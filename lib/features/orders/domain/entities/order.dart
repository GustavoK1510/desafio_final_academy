import '../enums/payment_option.dart';
import 'order_item.dart';

/// Represents an Order
class Order {

  /// Class constructor
  Order({
    this._id,
    required this._paymentOption,
    required this._installments,
    required this._price,
    required this._deliveryPrice,
    required this._deliveryDate,
    required this._deliveryServiceId,
    required this._clientId,
    required this._deliveryDistance,
    this._orderObs,
    required this._paymentObs,
    this._orderItems = const [],
  });

  final int? _id;
  final PaymentOption _paymentOption;
  final int _installments;
  final double _price;
  final double _deliveryPrice;
  final DateTime _deliveryDate;
  final int _deliveryServiceId;
  final int _clientId;
  final double _deliveryDistance;
  final String? _orderObs;
  final String _paymentObs;
  final List<OrderItem> _orderItems;

  /// Getter for id
  int? get id => _id;

  /// Getter for payment option
  PaymentOption get paymentOption => _paymentOption;

  /// Getter for installments
  int get installments => _installments;

  /// Getter for price
  double get price => _price;

  /// Getter for delivery price
  double get deliveryPrice => _deliveryPrice;

  /// Getter for delivery date
  DateTime get deliveryDate => _deliveryDate;

  /// Getter for the delivery service id
  int get deliveryServiceId => _deliveryServiceId;

  /// Getter for the client id
  int get clientId => _clientId;

  /// Getter for delivery distance
  double get deliveryDistance => _deliveryDistance;

  /// Getter for order observations
  String? get orderObs => _orderObs;

  /// Getter for payment observations
  String get paymentObs => _paymentObs;

  /// Getter for the order items
  List<OrderItem> get orderItems => _orderItems;
}