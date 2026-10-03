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

  int? get id => _id;
  String get path => _path;
  int get productId => _productId;
}