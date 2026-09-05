import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/enums/payment_option.dart';

/// Data model for [Order]
class OrderModel extends Order {

  /// Class constructor
  OrderModel({
    super.id,
    required super.paymentOption,
    required super.installments,
    required super.price,
    required super.deliveryDate,
    required super.deliveryServiceId,
    required super.clientId,
    required super.deliveryDistance,
    super.orderObs,
    required super.paymentObs,
    super.orderItems,
  });

  /// Creates an OrderModel from a database Map
  factory OrderModel.fromMap(
    Map<String, dynamic> map,
    {List<OrderItem> orderItems = const []}
    ) {
    return OrderModel(
      id: map['id'],
      paymentOption: PaymentOption.values.byName(map['payment_option']),
      installments: map['installments'],
      price: (map['price'] as num).toDouble(),
      deliveryDate: DateTime.parse(map['delivery_date']),
      deliveryServiceId: map['delivery_service_id'],
      clientId: map['client_id'],
      deliveryDistance: (map['delivery_distance'] as num).toDouble(),
      orderObs: map['order_obs'],
      paymentObs: map['payment_obs'],
      orderItems: orderItems,
    );
  }

  /// Converts an OrderModel instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'payment_option': paymentOption.name,
      'installments': installments,
      'price': price,
      'delivery_date': deliveryDate.toString(),
      'delivery_service_id': deliveryServiceId,
      'client_id': clientId,
      'delivery_distance': deliveryDistance,
      'order_obs': orderObs,
      'payment_obs': paymentObs,
    };
  }
}