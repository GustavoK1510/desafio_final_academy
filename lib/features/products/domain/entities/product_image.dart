/// Represents the product image
class ProductImage {

  /// Class constructor
  ProductImage({
    this._id,
    required this._path,
    required this._productId
  });

  final int? _id;
  final String _path;
  final int _productId;

  /// Getter for id
  int? get id => _id;

  /// Getter for the path
  String get path => _path;

  /// Getter for the product id
  int get productId => _productId;
}