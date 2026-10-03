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

  /// Getter for id
  int? get id => _id;

  /// Getter for name
  String get name => _name;

  /// Getter for zip code
  String get zipCode => _zipCode;

  /// Getter for state
  String get state => _state;

  /// Getter for city
  String get city => _city;

  /// Getter for number
  String get number => _number;

  /// Getter for street
  String get street => _street;

  /// Getter for CNPJ
  String get cnpj => _cnpj;

  /// Getter for the logo path
  String get logoPath => _logoPath;

  /// Getter for company name
  String get companyName => _companyName;

  /// Getter for latitude
  double get latitude => _latitude;

  /// Getter for longitude
  double get longitude => _longitude;
}