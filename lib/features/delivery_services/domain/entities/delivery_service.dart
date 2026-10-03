///Represents a Delivery Service
class DeliveryService {

  /// Class constructor
  DeliveryService({
    this._id,
    required this._name,
    required this._companyName,
    required this._cnpj,
    this._phoneNumber,
    required this._email,
    required this._kmCost,
    this._minimumPrice,
  });

  final int? _id;
  final String _name;
  final String _companyName;
  final String _cnpj;
  final String? _phoneNumber;
  final String _email;
  final double _kmCost;
  final double? _minimumPrice;

  int? get id => _id;

  String get name => _name;

  double? get minimumPrice => _minimumPrice;

  double get kmCost => _kmCost;

  String get email => _email;

  String? get phoneNumber => _phoneNumber;

  String get cnpj => _cnpj;

  String get companyName => _companyName;
}