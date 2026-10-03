import 'dart:io';
import '../entities/product.dart';

/// Represents the contract for [ProductRepository]
abstract class ProductRepository {

  /// Inserts a [Product] and copies its physical image [imageFiles]
  /// into permanent app storage before saving metadata to the database
  Future<void> insertProduct(Product product, List<File> imageFiles);

  /// Retrieves all products from the database along with their
  /// associated images
  Future<List<Product>> getProducts();

  /// Retrieves a specific Product using the ID
  Future<Product> getProduct(int productId);

  /// Updates an existing [Product], handling any newly added or removed
  /// image files
  Future<void> updateProduct(Product product, List<File> newImageFiles);

  /// Deletes a [Product] by its [id], removing both database records
  /// and physical image files from local disk storage
  Future<void> deleteProduct(int productId);
}