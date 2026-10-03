/// Represents the [Store]
class Store {

  /// Class constructor
  Store({
    this._id,
    required this._name,
    required this._companyName,
    required this._logoPath,
    required this._cnpj,
    required this._street,
    required this._number,
    required this._city,
    required this._state,
    required this._zipCode,
    required this._latitude,
    required this._longitude,
  });

  final int? _id;
  final String _name;
  final String _companyName;
  final String _logoPath;
  final String _cnpj;
  final String _street;
  final String _number;
  final String _city;
  final String _state;
  final String _zipCode;
  final double _latitude;
  final double _longitude;

  int? get id => _id;

  String get name => _name;

  String get zipCode => _zipCode;

  String get state => _state;

  String get city => _city;

  String get number => _number;

  String get street => _street;

  String get cnpj => _cnpj;

  String get logoPath => _logoPath;

  String get companyName => _companyName;

  double get latitude => _latitude;

  double get longitude => _longitude;
}