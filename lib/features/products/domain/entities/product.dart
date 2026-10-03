import 'product_image.dart';

/// Represents the product entity
class Product {

  /// Class constructor
  Product({
    this._id,
    required this._name,
    required this._brand,
    required this._barcode,
    this._description,
    required this._price,
    this._images = const []
  });

  final int? _id;
  final String _name;
  final String _brand;
  final String _barcode;
  final String? _description;
  final double _price;
  final List<ProductImage> _images;

  /// Getter for id
  int? get id => _id;

  /// Getter for name
  String get name => _name;

  /// Getter for brand
  String get brand => _brand;

  /// Getter for barcode
  String get barcode => _barcode;

  /// Getter for description
  String? get description => _description;

  /// Getter for price
  double get price => _price;

  /// Getter for the images
  List<ProductImage> get images => _images;
}