import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';
import '../providers/order_form_provider.dart';
import '../tabs/client_selection_tab.dart';
import '../tabs/product_selection_tab.dart';

/// Displays the multi-step order creation page.
class OrdersPage extends StatelessWidget {
  /// Creates the orders page.
  const OrdersPage({
    required this.clientUseCase,
    required this.productUseCase,
    super.key,
  });

  /// Use case for retrieving clients.
  final UseCaseClient clientUseCase;

  /// Use case for retrieving products.
  final ProductUseCase productUseCase;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderFormProvider(
        clientUseCase: clientUseCase,
        productUseCase: productUseCase,
      )
        ..loadClients()
        ..loadProducts(),
      child: const DefaultTabController(
        length: 4,
        child: _OrdersContent(),
      ),
    );
  }
}

/// Displays the order creation steps and navigation controls.
class _OrdersContent extends StatelessWidget {
  const _OrdersContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderFormProvider>();
    final controller = DefaultTabController.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create order'),
        centerTitle: true,
        bottom: TabBar(
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          onTap: (index) {
            if (index > provider.currentStep) {
              controller.animateTo(provider.currentStep);
            }
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.person_outline),
              text: 'Client',
            ),
            Tab(
              icon: Icon(Icons.inventory_2_outlined),
              text: 'Products',
            ),
            Tab(
              icon: Icon(Icons.local_shipping_outlined),
              text: 'Delivery',
            ),
            Tab(
              icon: Icon(Icons.receipt_long_outlined),
              text: 'Review',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ClientSelectionTab(),
                ProductSelectionTab(),
                const _LockedStep(
                  title: 'Delivery',
                  message: 'Delivery selection will be implemented next.',
                ),
                const _LockedStep(
                  title: 'Review',
                  message: 'Order review will be implemented next.',
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: provider.canContinue
                      ? () {
                    provider.continueToNextStep();
                    controller.animateTo(provider.currentStep);
                  }
                      : null,
                  child: Text(
                    provider.currentStep == 3
                        ? 'Finish order'
                        : 'Continue',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays a placeholder for a step that is not implemented yet.
class _LockedStep extends StatelessWidget {
  const _LockedStep({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}