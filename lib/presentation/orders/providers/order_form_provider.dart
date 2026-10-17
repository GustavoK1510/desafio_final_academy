import 'package:flutter/material.dart';

import '../../../features/clients/domain/entities/client.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../../../features/products/domain/entities/product.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';

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
  });

  final UseCaseClient _clientUseCase;
  final ProductUseCase _productUseCase;

  List<Client> _clients = [];
  Client? _selectedClient;
  String _searchQuery = '';
  int _currentStep = 0;
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> _products = [];
  String _productSearchQuery = '';
  bool _isLoadingProducts = false;
  String? _productErrorMessage;

  final Map<String, int> _selectedQuantities = {};
  final List<OrderCartItem> _cart = [];

  /// Returns the registered clients.
  List<Client> get clients => List.unmodifiable(_clients);

  /// Returns the selected client.
  Client? get selectedClient => _selectedClient;

  /// Returns the client search query.
  String get searchQuery => _searchQuery;

  /// Returns the active order step.
  int get currentStep => _currentStep;

  /// Indicates whether clients are loading.
  bool get isLoading => _isLoading;

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

  /// Returns clients matching the current query.
  List<Client> get filteredClients {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
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

  /// Loads registered clients.
  Future<void> loadClients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _clients = await _clientUseCase.getClients();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
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

  /// Updates the client search query and clears the selection.
  void searchClients(String query) {
    _searchQuery = query;
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

  /// Indicates whether the current step can be completed.
  bool get canContinue {
    switch (_currentStep) {
      case 0:
        return _selectedClient != null;
      case 1:
        return hasProducts;
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