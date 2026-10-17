import 'package:flutter/material.dart';

import '../../../core/services/routing/routing_service.dart';
import '../../../features/clients/domain/entities/client.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import '../../../features/products/domain/entities/product.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';
import '../../../features/store/domain/entities/store.dart';
import '../../../features/store/domain/usecases/store_use_case.dart';

/// Represents a product and its quantity in the order cart.
class OrderCartItem {

  /// Creates a cart item.
  const OrderCartItem({
    required this.product,
    required this.quantity,
  });

  /// The selected product.
  final Product product;

  /// The quantity added to the cart.
  final int quantity;

  /// The total price for this cart item.
  double get subtotal => product.price * quantity;
}

/// Manages client selection, products, cart, and order steps.
class OrderFormProvider extends ChangeNotifier {
  /// Creates the order form provider.
  OrderFormProvider({
    required this._clientUseCase,
    required this._productUseCase,
    required this._deliveryServiceUseCase,
    required this._storeUseCase,
    required this._routingService,
  });

  final UseCaseClient _clientUseCase;
  final ProductUseCase _productUseCase;
  final DeliveryServiceUseCase _deliveryServiceUseCase;
  final StoreUseCase _storeUseCase;
  final RoutingService _routingService;

  List<Client> _clients = [];
  Client? _selectedClient;
  String _clientSearchQuery = '';
  int _currentStep = 0;
  bool _isLoadingClients = false;
  String? _errorMessage;

  List<Product> _products = [];
  String _productSearchQuery = '';
  bool _isLoadingProducts = false;
  String? _productErrorMessage;

  List<DeliveryService> _deliveryServices = [];
  DeliveryService? _selectedDeliveryService;
  String _deliveryServiceSearchQuery = '';
  bool _isLoadingDeliveryService = false;
  String? _deliveryServiceErrorMessage;
  double _deliveryPrice = 0;
  double _deliveryDistance = 0;

  Store? _store;

  final Map<String, int> _selectedQuantities = {};
  final List<OrderCartItem> _cart = [];

  /// Returns the registered clients.
  List<Client> get clients => List.unmodifiable(_clients);

  /// Returns the selected client.
  Client? get selectedClient => _selectedClient;

  /// Returns the client search query.
  String get clientSearchQuery => _clientSearchQuery;

  /// Returns the active order step.
  int get currentStep => _currentStep;

  /// Indicates whether clients are loading.
  bool get isLoadingClients => _isLoadingClients;

  /// Returns the client loading error.
  String? get errorMessage => _errorMessage;

  /// Returns registered products.
  List<Product> get products => List.unmodifiable(_products);

  /// Returns the product search query.
  String get productSearchQuery => _productSearchQuery;

  /// Indicates whether products are loading.
  bool get isLoadingProducts => _isLoadingProducts;

  /// Returns the product loading error.
  String? get productErrorMessage => _productErrorMessage;

  /// Returns the items currently in the cart.
  List<OrderCartItem> get cart => List.unmodifiable(_cart);

  /// Returns the number of individual units in the cart.
  int get totalCartQuantity =>
      _cart.fold(0, (total, item) => total + item.quantity);

  /// Returns the total price of the cart.
  double get cartTotal =>
      _cart.fold(0, (total, item) => total + item.subtotal);

  /// Returns whether the cart contains at least one item.
  bool get hasProducts => _cart.isNotEmpty;

  /// Returns the registered delivery services
  List<DeliveryService> get deliveryServices =>
      List.unmodifiable(_deliveryServices);

  /// Returns the selected delivery service
  DeliveryService? get selectedDeliveryService => _selectedDeliveryService;

  /// Returns the delivery service search query
  String get deliveryServiceSearchQuery => _deliveryServiceSearchQuery;

  /// Returns whether delivery services are loading
  bool get isLoadingDeliveryService => _isLoadingDeliveryService;

  /// Returns the delivery service loading error
  String? get deliveryServiceErrorMessage => _deliveryServiceErrorMessage;

  /// Return the total delivery price
  double get deliveryPrice => _deliveryPrice;

  /// Returns the distance between client and the store
  double get deliveryDistance => _deliveryDistance;

  /// Returns the store
  Store? get store => _store;

  /// Returns clients matching the current query.
  List<Client> get filteredClients {
    final query = _clientSearchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      loadClients();
      return _clients;
    }

    final digits = query.replaceAll(RegExp(r'\D'), '');
    final isCnpjSearch =
        RegExp(r'^[\d./\-\s]+$').hasMatch(query) &&
            digits.isNotEmpty;

    if (isCnpjSearch && digits.length == 14) {
      return _clients.where((client) {
        return client.cnpj.replaceAll(RegExp(r'\D'), '') == digits;
      }).toList();
    }

    return _clients.where((client) {
      if (isCnpjSearch) {
        final cnpj = client.cnpj.replaceAll(RegExp(r'\D'), '');
        return cnpj.contains(digits);
      }

      return client.name.toLowerCase().contains(query);
    }).toList();
  }

  /// Returns products matching the current search query.
  List<Product> get filteredProducts {
    final query = _productSearchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _products;
    }

    return _products.where((product) {
      return product.name.toLowerCase().contains(query);
    }).toList();
  }

  /// Returns delivery services matching the current search query
  List<DeliveryService> get filteredDeliveryServices {
    final query = _deliveryServiceSearchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
    }

    final digits = query.replaceAll(RegExp(r'\D'), '');
    final isCnpjSearch =
        RegExp(r'^[\d./\-\s]+$').hasMatch(query) &&
            digits.isNotEmpty;

    if (isCnpjSearch && digits.length == 14) {
      return _deliveryServices.where((deliveryService) {
        return deliveryService.cnpj.replaceAll(RegExp(r'\D'), '') == digits;
      }).toList();
    }

    return _deliveryServices.where((deliveryService) {
      if (isCnpjSearch) {
        final cnpj = deliveryService.cnpj.replaceAll(RegExp(r'\D'), '');
        return cnpj.contains(digits);
      }

      return deliveryService.name.toLowerCase().contains(query);
    }).toList();
  }

  /// Loads registered clients.
  Future<void> loadClients() async {
    _isLoadingClients = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _clients = await _clientUseCase.getClients();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoadingClients = false;
      notifyListeners();
    }
  }

  /// Loads registered products.
  Future<void> loadProducts() async {
    _isLoadingProducts = true;
    _productErrorMessage = null;
    notifyListeners();

    try {
      _products = await _productUseCase.getProducts();
    } catch (error) {
      _productErrorMessage = error.toString();
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  /// Loads registered delivery services
  Future<void> loadDeliveryServices() async {
    _isLoadingDeliveryService = true;
    _productErrorMessage = null;
    notifyListeners();

    try {
      _deliveryServices = await _deliveryServiceUseCase.getDeliveryServices();
    } catch (error) {
      _deliveryServiceErrorMessage = error.toString();
    } finally {
      _isLoadingDeliveryService = false;
      notifyListeners();
    }
  }

  /// Updates the client search query and clears the selection.
  void searchClients(String query) {
    _clientSearchQuery = query;
    _selectedClient = null;
    notifyListeners();
  }

  /// Selects a client for the order.
  void selectClient(Client client) {
    _selectedClient = client;
    notifyListeners();
  }

  /// Updates the product search query.
  void searchProducts(String query) {
    _productSearchQuery = query;
    notifyListeners();
  }

  /// Returns the currently selected quantity for a product.
  int selectedQuantity(Product product) {
    return _selectedQuantities[product.barcode] ?? 1;
  }

  /// Updates the quantity selected for a product.
  void setSelectedQuantity(Product product, int quantity) {
    if (quantity < 1) {
      return;
    }

    _selectedQuantities[product.barcode] = quantity;
    notifyListeners();
  }

  /// Adds the selected quantity of a product to the cart.
  void addToCart(Product product) {
    final quantity = selectedQuantity(product);
    final index = _cart.indexWhere(
          (item) => item.product.barcode == product.barcode,
    );

    if (index == -1) {
      _cart.add(
        OrderCartItem(
          product: product,
          quantity: quantity,
        ),
      );
    } else {
      final existingItem = _cart[index];

      _cart[index] = OrderCartItem(
        product: existingItem.product,
        quantity: existingItem.quantity + quantity,
      );
    }

    notifyListeners();
  }

  /// Removes a product from the cart.
  void removeFromCart(Product product) {
    _cart.removeWhere(
          (item) => item.product.barcode == product.barcode,
    );

    notifyListeners();
  }

  /// Changes the quantity of an item already in the cart.
  void setCartQuantity(Product product, int quantity) {
    if (quantity < 1) {
      removeFromCart(product);
      return;
    }

    final index = _cart.indexWhere(
          (item) => item.product.barcode == product.barcode,
    );

    if (index == -1) {
      return;
    }

    _cart[index] = OrderCartItem(
      product: _cart[index].product,
      quantity: quantity,
    );

    notifyListeners();
  }

  /// Updates the delivery service search query
  void searchDeliveryServices(String query) {
    _deliveryServiceSearchQuery = query;
    _selectedDeliveryService = null;
    notifyListeners();
  }

  /// Selects a delivery service for the order
  Future<void> selectDeliveryService(DeliveryService deliveryService) async {
    _selectedDeliveryService = deliveryService;

    _store = await _storeUseCase.getStore();

    final route = await _routingService.getRoute(
      startLatitude: store!.latitude,
      startLongitude: store!.longitude,
      endLatitude: _selectedClient!.latitude,
      endLongitude: _selectedClient!.longitude,
    );

    _deliveryDistance = route.distance.roundToDouble();

    _deliveryPrice =
        (_deliveryDistance * _selectedDeliveryService!.kmCost).roundToDouble();

    notifyListeners();
  }


  /// Indicates whether the current step can be completed.
  bool get canContinue {
    switch (_currentStep) {
      case 0:
        return _selectedClient != null;
      case 1:
        return hasProducts;
      case 2:
        return _selectedDeliveryService!= null;
      default:
        return false;
    }
  }

  /// Advances to the next step when the current step is valid.
  void continueToNextStep() {
    if (!canContinue || _currentStep >= 3) {
      return;
    }

    _currentStep++;
    notifyListeners();
  }
}