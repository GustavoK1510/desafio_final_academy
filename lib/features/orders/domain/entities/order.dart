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

  int? get id => _id;

  PaymentOption get paymentOption => _paymentOption;

  int get installments => _installments;

  double get price => _price;

  double get deliveryPrice => _deliveryPrice;

  DateTime get deliveryDate => _deliveryDate;

  int get deliveryServiceId => _deliveryServiceId;

  int get clientId => _clientId;

  double get deliveryDistance => _deliveryDistance;

  String? get orderObs => _orderObs;

  String get paymentObs => _paymentObs;

  List<OrderItem> get orderItems => _orderItems;
}