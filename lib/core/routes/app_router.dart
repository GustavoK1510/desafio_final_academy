import 'package:go_router/go_router.dart';

import '../../features/clients/domain/entities/client.dart';
import '../../features/clients/domain/usecases/client_use_case.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/domain/usecases/product_use_case.dart';
import '../../presentation/clients/pages/client_form_page.dart';
import '../../presentation/clients/pages/clients_page.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/products/pages/product_form_page.dart';
import '../../presentation/products/pages/products_page.dart';
import '../../presentation/settings/pages/settings_page.dart';

/// Provides the application's navigation configuration.
class AppRouter {
  /// Class constructor.
  AppRouter({
    required this.productUseCase,
    required this.clientUseCase,
  });

  /// Product use case.
  final ProductUseCase productUseCase;

  /// Client use case
  final UseCaseClient clientUseCase;

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
      ),
      GoRoute(
        path: '/products/form',
        name: 'product-form',
        builder: (context, state) {
          final product = state.extra as Product?;

          return ProductFormPage(
            useCase: productUseCase,
            product: product,
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
      GoRoute(
        path: '/clients',
        name: 'clients',
        builder: (context, state) {
          return ClientsPage(
            useCase: clientUseCase,
          );
        },
      ),
      GoRoute(
        path: '/clients/form',
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
  );

}