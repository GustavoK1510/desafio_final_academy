import '../../domain/entities/product_image.dart';

/// Data model for [ProductImage]
class ProductImageModel extends ProductImage{
  ProductImageModel({
    super.id,
    required super.path,
    required super.productId,
  });

  /// Creates a ProductImageModel from a database Map
  factory ProductImageModel.fromMap(Map<String, dynamic> map) {
    return ProductImageModel(
      id: map['id'],
      path: map['path'],
      productId: map['product_id'],
    );
  }

  /// Converts the ProductImageModel instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'product_id': productId,
    };
  }
}