import '../../domain/entities/order_item.dart';

/// Data model for [OrderItem]
class OrderItemModel extends OrderItem {

  /// Class constructor
  OrderItemModel({
    super.id,
    required super.orderId,
    required super.productId,
    required super.quantity,
    required super.unitPrice,
  });

  /// Creates an OrderItemModel from a database Map
  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
    );
  }

  /// Converts an OrderItemModel into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }
}