import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/services/routing/routing_service.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import '../../../features/orders/domain/usecases/order_use_case.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';
import '../../../features/store/domain/usecases/store_use_case.dart';
import '../providers/order_form_provider.dart';
import '../tabs/client_selection_tab.dart';
import '../tabs/delivery_service_selection_tab.dart';
import '../tabs/order_review_tab.dart';
import '../tabs/product_selection_tab.dart';

/// Displays the multi-step order creation page.
class OrdersPage extends StatelessWidget {

  /// Creates the orders page.
  const OrdersPage({
    required this.clientUseCase,
    required this.productUseCase,
    required this.deliveryServiceUseCase,
    required this.storeUseCase,
    required this.orderUseCase,
    required this.routingService,
    super.key,
  });

  /// Use case for retrieving clients.
  final UseCaseClient clientUseCase;

  /// Use case for retrieving products.
  final ProductUseCase productUseCase;

  /// Use case for retrieving delivery services.
  final DeliveryServiceUseCase deliveryServiceUseCase;

  /// Use case for retrieving the store.
  final StoreUseCase storeUseCase;

  /// Use case for saving the order
  final OrderUseCase orderUseCase;

  /// Routing service.
  final RoutingService routingService;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderFormProvider(
        clientUseCase: clientUseCase,
        productUseCase: productUseCase,
        deliveryServiceUseCase: deliveryServiceUseCase,
        storeUseCase: storeUseCase,
        orderUseCase: orderUseCase,
        routingService: routingService,
      )
        ..loadClients()
        ..loadProducts()
        ..loadDeliveryServices(),
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
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<OrderFormProvider>();
    final controller = DefaultTabController.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createOrder),
        centerTitle: true,
        bottom: TabBar(
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          onTap: (index) {
            if (index > provider.currentStep) {
              return;
            }

            provider.goToStep(index);
          },
          tabs: [
            Tab(
              icon: const Icon(Icons.person_outline),
              text: l10n.clients,
            ),
            Tab(
              icon: const Icon(Icons.inventory_2_outlined),
              text: l10n.products,
            ),
            Tab(
              icon: const Icon(Icons.local_shipping_outlined),
              text: l10n.deliveryServices,
            ),
            Tab(
              icon: const Icon(Icons.receipt_long_outlined),
              text: l10n.review,
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
                DeliveryServiceSelectionTab(),
                const OrderReviewTab(),
              ],
            ),
          ),
          if (provider.currentStep < 3)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: context.watch<OrderFormProvider>().canContinue
                        ? () {
                      provider.continueToNextStep();
                      controller.animateTo(provider.currentStep);
                    }
                        : null,
                    child: Text(l10n.next),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}