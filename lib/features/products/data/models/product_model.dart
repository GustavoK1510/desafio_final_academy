import '../../domain/entities/product.dart';
import '../../domain/entities/product_image.dart';

/// Data model for [Product]
class ProductModel extends Product{

  /// Class constructor
  ProductModel({
    super.id,
    required super.name,
    required super.brand,
    required super.barcode,
    super.description,
    required super.price,
    super.images =  const [],
  });

  /// Creates a ProductModel from a database Map
  factory ProductModel.fromMap(
      Map<String, dynamic> map,
      {List<ProductImage> images = const []}
      ) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      brand: map['brand'],
      barcode: map['barcode'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      images: images,
    );
  }

  /// Converts the ProductModel instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'barcode': barcode,
      'description': description,
      'price': price,
    };
  }
}