import 'package:flutter/foundation.dart';

import '../../../features/products/domain/entities/product.dart';

/// Provides the product displayed on the details page.
class ProductDetailsProvider extends ChangeNotifier {

  /// Class constructor
  ProductDetailsProvider({required this._product});

  final Product _product;

  /// Returns the product being displayed.
  Product get product => _product;
}