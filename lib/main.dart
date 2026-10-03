import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/database/database_helper.dart';
import 'core/localization/app_localizations.dart';
import 'core/providers/app_settings_provider.dart';
import 'core/routes/app_router.dart';
import 'core/services/brasil_api/brasil_api_service.dart';
import 'core/services/geocoding/geocoding_service.dart';
import 'core/storage/image_storage.dart';
import 'features/clients/data/repositories/client_repository_impl.dart';
import 'features/clients/domain/usecases/client_use_case.dart';
import 'features/delivery_services/data/repositories/delivery_service_repository_impl.dart';
import 'features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/usecases/product_use_case.dart';
import 'features/store/data/repositories/store_repository_impl.dart';
import 'features/store/domain/usecases/store_use_case.dart';
import 'presentation/products/providers/products_provider.dart';
import 'presentation/settings/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await DatabaseHelper.initializeDatabase();

  final imageStorage = ImageStorage();

  final geocodingService = GeocodingService();

  final storeRepository = StoreRepositoryImpl(
    db: database,
    imageStorage: imageStorage,
  );

  final storeUseCase = StoreUseCase(
    repository: storeRepository,
    geocodingService: geocodingService,
  );

  final productRepository = ProductRepositoryImpl(
    db: database,
    imageStorage: imageStorage,
  );

  final productUseCase = ProductUseCase(
    repository: productRepository,
  );

  final clientRepository = ClientRepositoryImpl(db: database);

  final brasilApiService = BrasilApiService();

  final clientUseCase = UseCaseClient(
      repository: clientRepository,
      brasilApiService: brasilApiService,
      geocodingService: geocodingService,
  );

  final deliveryServiceRepository = DeliveryServiceRepositoryImpl(db: database);

  final deliveryServiceUseCase = DeliveryServiceUseCase(
      repository: deliveryServiceRepository,
  );

  final appRouter = AppRouter(
    productUseCase: productUseCase,
    clientUseCase: clientUseCase,
    deliveryServiceUseCase: deliveryServiceUseCase,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppSettingsProvider()..loadSettings(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            storeUseCase: storeUseCase,
          )..loadStore(),
        ),
        ChangeNotifierProvider(
            create: (_) => ProductsProvider(
              useCase: productUseCase
            )..loadProducts(),
        ),
      ],
      child: MyApp(
        router: appRouter.router,
      ),
    ),
  );
}

/// The App
class MyApp extends StatelessWidget {
  /// Class constructor
  const MyApp({
    required this.router,
    super.key,
  });

  /// Router instance
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      localizationsDelegates:
      AppLocalizations.localizationsDelegates,
      supportedLocales:
      AppLocalizations.supportedLocales,
      themeMode: settings.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}