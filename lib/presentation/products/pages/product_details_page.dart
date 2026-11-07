import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/products/domain/entities/product.dart';
import '../../../features/products/domain/entities/product_image.dart';
import '../providers/product_details_provider.dart';

/// Displays all information about a product.
class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductDetailsProvider(product: product),
      child: const _ProductDetailsContent(),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  const _ProductDetailsContent();

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductDetailsProvider>().product;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImages(context, product.images),
            const SizedBox(height: 24),

            Text(
              product.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              title: 'Product Information',
              children: [
                _DetailRow(label: 'ID', value: product.id?.toString()),
                _DetailRow(label: 'Name', value: product.name),
                _DetailRow(label: 'Brand', value: product.brand),
                _DetailRow(label: 'Barcode', value: product.barcode),
                _DetailRow(
                  label: 'Description',
                  value: product.description,
                ),
                _DetailRow(
                  label: 'Price',
                  value: 'R\$ ${product.price.toStringAsFixed(2)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImages(BuildContext context, List<ProductImage> images) {
    final colorScheme = Theme.of(context).colorScheme;

    if (images.isEmpty) {
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.inventory_2_outlined,
          size: 64,
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final image = images[index];
          final file = File(image.path);

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 260,
              color: colorScheme.surfaceContainerHighest,
              child: file.existsSync()
                  ? Image.file(
                file,
                fit: BoxFit.cover,
              )
                  : const Icon(
                Icons.broken_image_outlined,
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required List<Widget> children,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

/// Displays a single product information field.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : 'Not provided',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}