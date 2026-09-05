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

  int? get id => _id;

  String get name => _name;

  String get brand => _brand;

  String get barcode => _barcode;

  String? get description => _description;

  double get price => _price;

  List<ProductImage> get images => _images;
}