
import 'package:go_router/go_router.dart';

import '../../features/clients/domain/entities/client.dart';
import '../../features/clients/domain/usecases/client_use_case.dart';
import '../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/domain/usecases/product_use_case.dart';
import '../../features/store/domain/usecases/store_use_case.dart';
import '../../presentation/clients/pages/client_form_page.dart';
import '../../presentation/clients/pages/clients_page.dart';
import '../../presentation/delivery_services/pages/delivery_service_form_page.dart';
import '../../presentation/delivery_services/pages/delivery_services_page.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/orders/pages/orders_page.dart';
import '../../presentation/products/pages/product_form_page.dart';
import '../../presentation/products/pages/products_page.dart';
import '../../presentation/settings/pages/settings_page.dart';
import '../services/routing/routing_service.dart';

/// Provides the application's navigation configuration.
class AppRouter {

  /// Class constructor.
  AppRouter({
    required this.productUseCase,
    required this.clientUseCase,
    required this.deliveryServiceUseCase,
    required this.storeUseCase,
    required this.routingService,
  });

  /// Product use case.
  final ProductUseCase productUseCase;

  /// Client use case.
  final UseCaseClient clientUseCase;

  /// Delivery service use case.
  final DeliveryServiceUseCase deliveryServiceUseCase;

  /// Store use case
  final StoreUseCase storeUseCase;

  /// Routing service
  final RoutingService routingService;

  /// Router.
  late final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) {
          return ProductsPage(
            useCase: productUseCase,
          );
        },
        routes: [
          GoRoute(
            path: 'form',
            name: 'product-form',
            builder: (context, state) {
              final product = state.extra as Product?;

              return ProductFormPage(
                useCase: productUseCase,
                product: product,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/clients',
        name: 'clients',
        builder: (context, state) {
          return ClientsPage(
            useCase: clientUseCase,
          );
        },
        routes: [
          GoRoute(
            path: 'form',
            name: 'client-form',
            builder: (context, state) {
              final client = state.extra as Client?;

              return ClientFormPage(
                useCase: clientUseCase,
                client: client,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/delivery-services',
        name: 'delivery-services',
        builder: (context, state) {
          return DeliveryServicesPage(
            useCase: deliveryServiceUseCase,
          );
        },
        routes: [
          GoRoute(
            path: 'form',
            name: 'delivery-services-form',
            builder: (context, state) {
              final deliveryService =
              state.extra as DeliveryService?;

              return DeliveryServiceFormPage(
                useCase: deliveryServiceUseCase,
                deliveryService: deliveryService,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) {
          return OrdersPage(
            clientUseCase: clientUseCase,
            productUseCase: productUseCase,
            deliveryServiceUseCase: deliveryServiceUseCase,
            storeUseCase: storeUseCase,
            routingService: routingService,
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) {
          return const SettingsPage();
        },
      ),
    ],
  );
}
