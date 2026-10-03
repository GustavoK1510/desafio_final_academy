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

  /// Getter for id
  int? get id => _id;

  /// Getter for name
  String get name => _name;

  /// Getter for minimum price
  double? get minimumPrice => _minimumPrice;

  /// Getter for cost per kilometer
  double get kmCost => _kmCost;

  /// Getter for email
  String get email => _email;

  /// Getter for phone number
  String? get phoneNumber => _phoneNumber;

  /// Getter for CNPJ
  String get cnpj => _cnpj;

  /// Getter for company name
  String get companyName => _companyName;
}