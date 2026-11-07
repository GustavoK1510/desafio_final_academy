
import 'package:flutter/material.dart';

import '../../../core/services/routing/models/route_result.dart';
import '../../../core/services/routing/routing_service.dart';
import '../../../features/clients/domain/entities/client.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import '../../../features/orders/domain/entities/order.dart';
import '../../../features/orders/domain/entities/order_item.dart';
import '../../../features/orders/domain/enums/payment_option.dart';
import '../../../features/orders/domain/usecases/order_use_case.dart';
import '../../../features/products/domain/entities/product.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';
import '../../../features/store/domain/entities/store.dart';
import '../../../features/store/domain/usecases/store_use_case.dart';

/// Represents a product and its quantity in the order cart.
class OrderCartItem {
  /// Class constructor.
  const OrderCartItem({
    required this.product,
    required this.quantity,
    this.discountPercentage = 0,
  });

  /// Product
  final Product product;

  /// Quantity
  final int quantity;

  /// Discount percentage
  final double discountPercentage;

  /// Subtotal before discount.
  double get subtotal => product.price * quantity;

  /// Discount amount in currency.
  double get discountAmount => subtotal * discountPercentage / 100;

  /// Subtotal after discount.
  double get discountedSubtotal => subtotal - discountAmount;
}

/// Manages client selection, products, cart, and order steps.
class OrderFormProvider extends ChangeNotifier {
  /// Creates the order form provider.
  OrderFormProvider({
    required this._clientUseCase,
    required this._productUseCase,
    required this._deliveryServiceUseCase,
    required this._storeUseCase,
    required this._orderUseCase,
    required this._routingService,
  });

  final UseCaseClient _clientUseCase;
  final ProductUseCase _productUseCase;
  final DeliveryServiceUseCase _deliveryServiceUseCase;
  final StoreUseCase _storeUseCase;
  final OrderUseCase _orderUseCase;
  final RoutingService _routingService;

  List<Client> _clients = [];
  Client? _selectedClient;
  String _clientSearchQuery = '';
  int _currentStep = 0;
  bool _isLoadingClients = false;
  String? _errorMessage;

  List<Product> _products = [];
  String _productSearchQuery = '';
  bool _isValidDiscount = true;
  bool _isLoadingProducts = false;
  String? _productErrorMessage;

  List<DeliveryService> _deliveryServices = [];
  DeliveryService? _selectedDeliveryService;
  String _deliveryServiceSearchQuery = '';
  bool _isLoadingDeliveryService = false;
  String? _deliveryServiceErrorMessage;
  double _deliveryPrice = 0;
  double _deliveryDistance = 0;
  DateTime _deliveryDate = DateTime.now();

  PaymentOption? _paymentOption;
  int _installments = 1;
  String _paymentDetails = '';
  String _orderDetails = '';

  Store? _store;

  RouteResult? _deliveryRoute;
  bool _isCalculatingRoute = false;
  bool _isSavingOrder = false;

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

  /// Returns whether the discount is valid
  bool get isValidDiscount => _isValidDiscount;

  /// Indicates whether products are loading.
  bool get isLoadingProducts => _isLoadingProducts;

  /// Returns the product loading error.
  String? get productErrorMessage => _productErrorMessage;

  /// Returns the items currently in the cart.
  List<OrderCartItem> get cart => List.unmodifiable(_cart);

  /// Returns the number of individual units in the cart.
  int get totalCartQuantity =>
      _cart.fold(0, (total, item) => total + item.quantity);

  /// Returns whether the cart contains at least one item.
  bool get hasProducts => _cart.isNotEmpty;

  /// Returns the registered delivery services.
  List<DeliveryService> get deliveryServices =>
      List.unmodifiable(_deliveryServices);

  /// Returns the selected delivery service.
  DeliveryService? get selectedDeliveryService => _selectedDeliveryService;

  /// Returns the delivery service search query.
  String get deliveryServiceSearchQuery => _deliveryServiceSearchQuery;

  /// Returns whether delivery services are loading.
  bool get isLoadingDeliveryService => _isLoadingDeliveryService;

  /// Returns the delivery service loading error.
  String? get deliveryServiceErrorMessage =>
      _deliveryServiceErrorMessage;

  /// Returns the total delivery price.
  double get deliveryPrice => _deliveryPrice;

  /// Returns the estimated delivery date
  DateTime get deliveryDate => _deliveryDate;

  /// Returns the distance between client and store.
  double get deliveryDistance => _deliveryDistance;

  /// Returns the store.
  Store? get store => _store;

  /// Returns the delivery route.
  RouteResult? get deliveryRoute => _deliveryRoute;

  /// Returns whether the delivery route is being calculated.
  bool get isCalculatingRoute => _isCalculatingRoute;

  /// Returns whether an order is being saved.
  bool get isSavingOrder => _isSavingOrder;

  /// Returns the selected payment option.
  PaymentOption? get paymentOption => _paymentOption;

  /// Returns the selected number of installments.
  int get installments => _installments;

  /// Indicates whether credit card was selected.
  bool get isCreditCard =>
      _paymentOption == PaymentOption.creditCard;

  /// Returns the product subtotal plus delivery fee.
  double get orderTotal => cartTotal + deliveryPrice;

  /// Returns the order total with the 4% credit card surcharge.
  double get creditCardTotal => orderTotal * 1.04;

  /// Returns the final total according to the payment option.
  double get finalOrderTotal =>
      isCreditCard ? creditCardTotal : orderTotal;

  /// Returns the maximum allowed installments.
  int get maxInstallments {
    if (!isCreditCard) return 1;
    if (cartTotal > 5000) return 18;
    if (cartTotal >= 1000) return 10;

    return 1;
  }

  /// Returns the available installment options.
  List<int> get availableInstallments =>
      List.generate(maxInstallments, (index) => index + 1);

  /// Returns the value of each installment.
  double get installmentValue {
    if (_installments <= 0) return 0;

    return creditCardTotal / _installments;
  }

  /// Returns the payment details.
  String get paymentDetails => _paymentDetails;

  /// Returns the order details.
  String get orderDetails => _orderDetails;

  /// Cart subtotal before discounts.
  double get cartSubtotal =>
      _cart.fold(0, (total, item) => total + item.subtotal);

  /// Total discount applied to cart items.
  double get cartDiscountTotal =>
      _cart.fold(0, (total, item) => total + item.discountAmount);

  /// Cart total after discounts.
  double get cartTotal =>
      _cart.fold(0, (total, item) => total + item.discountedSubtotal);

  /// Returns clients matching the current query.
  List<Client> get filteredClients {
    final query = _clientSearchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _clients;
    }

    final digits = query.replaceAll(RegExp(r'\D'), '');
    final isCnpjSearch =
        RegExp(r'^[\d./\-\s]+$').hasMatch(query) && digits.isNotEmpty;

    if (isCnpjSearch && digits.length == 14) {
      return _clients.where((client) {
        return client.cnpj.replaceAll(RegExp(r'\D'), '') == digits;
      }).toList();
    }

    if (isCnpjSearch) {
      return _clients.where((client) {
        final cnpj = client.cnpj.replaceAll(RegExp(r'\D'), '');
        return cnpj.contains(digits);
      }).toList();
    }

    return _clients.where((client) {
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

  /// Returns delivery services matching the current search query.
  List<DeliveryService> get filteredDeliveryServices {
    final query = _deliveryServiceSearchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
    }

    final digits = query.replaceAll(RegExp(r'\D'), '');
    final isCnpjSearch =
        RegExp(r'^[\d./\-\s]+$').hasMatch(query) && digits.isNotEmpty;

    if (isCnpjSearch && digits.length == 14) {
      return _deliveryServices.where((deliveryService) {
        return deliveryService.cnpj.replaceAll(RegExp(r'\D'), '') == digits;
      }).toList();
    }

    if (isCnpjSearch) {
      return _deliveryServices.where((deliveryService) {
        final cnpj = deliveryService.cnpj.replaceAll(RegExp(r'\D'), '');
        return cnpj.contains(digits);
      }).toList();
    }

    return _deliveryServices.where((deliveryService) {
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

  /// Loads registered delivery services.
  Future<void> loadDeliveryServices() async {
    _isLoadingDeliveryService = true;
    _deliveryServiceErrorMessage = null;
    notifyListeners();

    try {
      _deliveryServices =
      await _deliveryServiceUseCase.getDeliveryServices();
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
    if (quantity < 1) return;

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
        discountPercentage: existingItem.discountPercentage,
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

    if (index == -1) return;

    final item = _cart[index];

    _cart[index] = OrderCartItem(
      product: item.product,
      quantity: quantity,
      discountPercentage: item.discountPercentage,
    );

    notifyListeners();
  }

  /// Updates the percentage discount for a cart item.
  void setProductDiscount(Product product, double percentage) {
    final index = _cart.indexWhere(
          (item) => item.product.barcode == product.barcode,
    );

    if (index == -1) return;

    if (percentage > 100 || percentage < 0) {
      _isValidDiscount = false;
      _errorMessage = 'The discount should be between 0 and 100%';
      notifyListeners();
    }

    final normalizedPercentage =
    percentage.clamp(0.0, 100.0).toDouble();

    final item = _cart[index];

    _cart[index] = OrderCartItem(
      product: item.product,
      quantity: item.quantity,
      discountPercentage: normalizedPercentage,
    );

    notifyListeners();
  }

  /// Updates the delivery service search query.
  void searchDeliveryServices(String query) {
    _deliveryServiceSearchQuery = query;
    _selectedDeliveryService = null;
    notifyListeners();
  }

  /// Selects a delivery service and calculates the delivery route.
  Future<void> selectDeliveryService(
      DeliveryService deliveryService,
      ) async {
    if (_isCalculatingRoute) return;

    _selectedDeliveryService = deliveryService;
    _deliveryRoute = null;
    _deliveryDistance = 0;
    _deliveryPrice = 0;
    _deliveryDate = DateTime.now().add(Duration(days: 20));
    _deliveryServiceErrorMessage = null;
    _isCalculatingRoute = true;
    notifyListeners();

    try {
      final client = _selectedClient;

      if (client == null) {
        throw StateError('Select a client before choosing delivery.');
      }

      _store = await _storeUseCase.getStore();

      final store = _store;

      if (store == null) {
        throw StateError('Store information could not be found.');
      }

      final route = await _routingService.getRoute(
        startLatitude: store.latitude,
        startLongitude: store.longitude,
        endLatitude: client.latitude,
        endLongitude: client.longitude,
      );

      _deliveryRoute = route;
      _deliveryDistance = route.distance;

      _deliveryPrice = double.parse(
        (_deliveryDistance * deliveryService.kmCost).toStringAsFixed(2),
      );

      if (deliveryService.minimumPrice != null &&
          _deliveryPrice < deliveryService.minimumPrice!) {
        _deliveryPrice = deliveryService.minimumPrice!;
      }
    } catch (error) {
      _deliveryServiceErrorMessage =
      'Could not calculate the delivery route. Please try again.';
      debugPrint('Error calculating delivery route: $error');
    } finally {
      _isCalculatingRoute = false;
      notifyListeners();
    }
  }

  /// Indicates whether the current step can be completed.
  bool get canContinue {
    switch (_currentStep) {
      case 0:
        return _selectedClient != null;
      case 1:
        return hasProducts && isValidDiscount;
      case 2:
        return _selectedDeliveryService != null &&
            _deliveryRoute != null &&
            !_isCalculatingRoute;
      default:
        return false;
    }
  }

  /// Advances to the next step when the current step is valid.
  void continueToNextStep() {
    if (!canContinue || _currentStep >= 3) return;

    _currentStep++;
    notifyListeners();
  }

  /// Navigates to a previously reached step.
  void goToStep(int step) {
    if (step < 0 || step > _currentStep) return;

    _currentStep = step;
    notifyListeners();
  }

  /// Selects the payment option and resets installments.
  void selectPaymentOption(PaymentOption option) {
    _paymentOption = option;
    _installments = 1;
    notifyListeners();
  }

  /// Selects an installment option if it is valid.
  void selectInstallments(int installments) {
    if (!availableInstallments.contains(installments)) return;

    _installments = installments;
    notifyListeners();
  }

  /// Indicates whether the order review is complete.
  bool get canFinishOrder {
    return _currentStep == 3 &&
        _selectedClient != null &&
        _cart.isNotEmpty &&
        _selectedDeliveryService != null &&
        _deliveryRoute != null &&
        !_isCalculatingRoute &&
        _paymentOption != null &&
        availableInstallments.contains(_installments) &&
        !_isSavingOrder;
  }

  /// Updates payment details with a 90-character limit.
  void setPaymentDetails(String value) {
    _paymentDetails = value.length > 90 ? value.substring(0, 90) : value;
    notifyListeners();
  }

  /// Updates order details without a character limit.
  void setOrderDetails(String value) {
    _orderDetails = value;
    notifyListeners();
  }

  /// Saves the current order.
  Future<void> saveOrder() async {
    if (!canFinishOrder || _isSavingOrder) return;

    _isSavingOrder = true;
    notifyListeners();

    try {
      final orderItems = _cart.map((item) {
        return OrderItem(
          orderId: 0,
          productId: item.product.id!,
          discount: item.discountPercentage,
          quantity: item.quantity,
          unitPrice: item.product.price,
        );
      }).toList();

      final order = Order(
        paymentOption: _paymentOption!,
        installments: _installments,
        price: finalOrderTotal,
        deliveryPrice: _deliveryPrice,
        deliveryDate: _deliveryDate,
        deliveryServiceId: _selectedDeliveryService!.id!,
        clientId: _selectedClient!.id!,
        deliveryDistance: _deliveryDistance,
        paymentObs: _paymentDetails,
        orderObs: _orderDetails,
        orderItems: orderItems,
      );

      await _orderUseCase.insertOrder(order);

      _resetOrderForm();
    } catch (error) {
      debugPrint('Error saving order: $error');
      rethrow;
    } finally {
      _isSavingOrder = false;
      notifyListeners();
    }
  }

  /// Resets the order form after a successful save.
  void _resetOrderForm() {
    _selectedClient = null;
    _clientSearchQuery = '';

    _cart.clear();
    _selectedQuantities.clear();
    _productSearchQuery = '';

    _selectedDeliveryService = null;
    _deliveryServiceSearchQuery = '';
    _deliveryRoute = null;
    _deliveryDistance = 0;
    _deliveryPrice = 0;

    _paymentOption = null;
    _installments = 1;
    _paymentDetails = '';
    _orderDetails = '';

    _currentStep = 0;

    _deliveryServiceErrorMessage = null;
  }
}
