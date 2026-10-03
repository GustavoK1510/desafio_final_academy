import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';
import '../../../ui/components/product_card.dart';
import '../providers/products_provider.dart';

/// Displays the product listing.
class ProductsPage extends StatelessWidget {

  /// Class constructor.
  const ProductsPage({
    super.key,
    required this.useCase,
  });

  /// UseCase for Products
  final ProductUseCase useCase;



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final provider = context.watch<ProductsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.products),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final saved = await context.push<bool>(
            '/products/form',
          );

          if (saved == true && context.mounted) {
            await context.read<ProductsProvider>().loadProducts();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addProduct),
      ),
      body: RefreshIndicator(
        onRefresh: provider.loadProducts,
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      ProductsProvider provider,
      ) {

    final l10n = AppLocalizations.of(context)!;

    if (provider.isLoading && provider.products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null &&
        provider.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            provider.errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (provider.products.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Center(
              child: Text(l10n.noProductsRegistered),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),

      itemCount: provider.products.length,
      separatorBuilder: (_, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final product = provider.products[index];

        return ProductCard(
          product: product,
          onEdit: () async {
          final saved = await context.push<bool>(
            '/products/form',
            extra: product,
          );

          if (saved == true && context.mounted) {
            await context.read<ProductsProvider>().loadProducts();
          }
        },
          onDelete: () {
            _confirmDelete(context, product.id!);
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      int productId,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteProduct),
          content: Text(l10n.deleteProductConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final success = await context
        .read<ProductsProvider>()
        .deleteProduct(productId);

    if (!success || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.productDeleted),
      ),
    );
  }
}