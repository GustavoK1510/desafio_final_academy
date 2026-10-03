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

  /// Getter for id
  int? get id => _id;

  /// Getter for the order id
  int get orderId => _orderId;

  /// Getter for the product id
  int get productId => _productId;

  /// Getter for quantity
  int get quantity => _quantity;

  /// Getter for unit price
  double get unitPrice => _unitPrice;
}