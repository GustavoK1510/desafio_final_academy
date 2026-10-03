import 'dart:io';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Provides product-related application operations
class ProductUseCase {

  /// Class constructor
  ProductUseCase({required this._repository});

  final ProductRepository _repository;

  /// Adds a new [Product] with its [imageFiles]
  Future<void> insertProduct(
    Product product,
    List<File> imageFiles
    ) {
     return _repository.insertProduct(product, imageFiles);
  }

  /// Retrieves all products
  Future<List<Product>> getProducts() {
    return _repository.getProducts();
  }

  /// Updates a [Product] and its [newImageFiles]
  Future<void> updateProduct(
    Product product,
    List<File> newImageFiles
    ) {
    return _repository.updateProduct(product, newImageFiles);
  }

  /// Deletes a product by its [productId]
  Future<void> deleteProducts(int productId) {
    return _repository.deleteProduct(productId);
  }
}