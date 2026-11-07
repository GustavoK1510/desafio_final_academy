import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/order_card.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/order_receipt/order_receipt_pdf_service.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import '../../../features/orders/domain/usecases/order_use_case.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';
import '../../../features/store/domain/usecases/store_use_case.dart';
import '../providers/orders_provider.dart';

/// Displays the registered orders and their available actions.
class OrdersListingPage extends StatelessWidget {

  /// Class constructor
  const OrdersListingPage({
    super.key,
    required this.orderUseCase,
    required this.clientUseCase,
    required this.deliveryServiceUseCase,
    required this.productUseCase,
    required this.storeUseCase,
  });

  /// Order Use Case
  final OrderUseCase orderUseCase;

  /// Client Use Case
  final UseCaseClient clientUseCase;

  /// Delivery Service Use Case
  final DeliveryServiceUseCase deliveryServiceUseCase;

  /// Product Use Case
  final ProductUseCase productUseCase;

  /// Store Use Case
  final StoreUseCase storeUseCase;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersProvider(
        orderUseCase: orderUseCase,
        clientUseCase: clientUseCase,
        deliveryServiceUseCase: deliveryServiceUseCase,
        productUseCase: productUseCase,
        storeUseCase: storeUseCase,
        pdfService: OrderReceiptPdfService(),
      )..loadOrders(),
      child: const OrdersListingView(),
    );
  }
}

/// Builds the orders listing using the provider.
class OrdersListingView extends StatelessWidget {

  /// Class constructor
  const OrdersListingView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orders),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: provider.searchOrders,
              decoration: InputDecoration(
                hintText: 'Search orders by ID',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: provider.searchQuery.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    provider.searchOrders('');
                  },
                  icon: const Icon(Icons.clear),
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildBody(context, provider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await context.push<bool>('/orders/form');

          if (saved == true && context.mounted) {
            await provider.loadOrders();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      OrdersProvider provider,
      ) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.loadOrders,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.filteredOrders.isEmpty) {
      return Center(
        child: Text(
          provider.searchQuery.isNotEmpty
              ? 'No orders found.'
              : 'No orders registered yet.',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadOrders,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.filteredOrders.length,
        itemBuilder: (context, index) {
          final order = provider.filteredOrders[index];

          return OrderCard(
            order: order,
            clientName: provider.getClientName(order),
            deliveryServiceName:
            provider.getDeliveryServiceName(order),
            onDelete: () {
              _confirmDelete(context, provider, order.id!);
            },
            onGeneratePdf: () {
              _generatePdf(context, provider, order);
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      OrdersProvider provider,
      int orderId,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(context)!;

        return AlertDialog(
          title: const Text('Delete order'),
          content: const Text(
            'Are you sure you want to delete this order?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                l10n.delete,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      await provider.deleteOrder(orderId);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order deleted successfully.'),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete order: $error'),
        ),
      );
    }
  }

  Future<void> _generatePdf(
      BuildContext context,
      OrdersProvider provider,
      order,
      ) async {
    try {
      await provider.generateOrderPdf(order);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF receipt generated successfully.'),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate receipt: $error'),
        ),
      );
    }
  }
}