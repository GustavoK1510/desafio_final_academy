import 'package:flutter/material.dart';

import '../../../features/products/domain/entities/product.dart';
import '../../../features/products/domain/usecases/product_use_case.dart';

/// Manages the product listing.
class ProductsProvider extends ChangeNotifier {
  /// Class constructor.
  ProductsProvider({
    required this._useCase,
  });

  final ProductUseCase _useCase;

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  /// Getter for the filtered orders list
  List<Product> get product => filteredProducts;

  /// Products currently available.
  List<Product> get products => List.unmodifiable(_products);

  /// Whether products are being loaded.
  bool get isLoading => _isLoading;

  /// Current error message.
  String? get errorMessage => _errorMessage;

  /// Returns the search query
  String get searchQuery => _searchQuery;

  /// Returns orders filtered by the search query.
  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }

    return _products.where((order) {
      final orderId = order.id?.toString() ?? '';

      return orderId.contains(_searchQuery);
    }).toList();
  }

  /// Updates the order search query.
  void searchProducts(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  /// Loads all products.
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _useCase.getProducts();
    } catch (error, stackTrace) {
      debugPrint('ERROR LOADING PRODUCTS: $error');
      debugPrint('STACK TRACE: $stackTrace');

      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes a product.
  Future<bool> deleteProduct(int id) async {
    try {
      await _useCase.deleteProducts(id);

      _products.removeWhere((product) => product.id == id);

      notifyListeners();

      return true;
    } catch (error, stackTrace) {
      debugPrint('ERROR DELETING PRODUCT: $error');
      debugPrint('STACK TRACE: $stackTrace');

      _errorMessage = error.toString();
      notifyListeners();

      return false;
    }
  }
}