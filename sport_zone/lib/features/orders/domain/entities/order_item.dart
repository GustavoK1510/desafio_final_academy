import 'order.dart';

/// Represents an item in the [Order]
class OrderItem {

  /// Class constructor
  OrderItem({
    this._id,
    required this._orderId,
    required this._productId,
    required this._quantity,
    required this._unitPrice,
  });

  final int? _id;
  final int _orderId;
  final int _productId;
  final int _quantity;
  final double _unitPrice;

  int? get id => _id;

  int get orderId => _orderId;

  int get productId => _productId;

  int get quantity => _quantity;

  double get unitPrice => _unitPrice;
}