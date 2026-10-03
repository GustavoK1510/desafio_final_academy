import '../enums/business_type.dart';

/// Represents a [Client] instance
class Client {

  /// Class constructor
  Client({
    this._id,
    required this._name,
    required this._cnpj,
    required this._companyName,
    this._phoneNumber,
    required this._email,
    required this._street,
    required this._number,
    required this._city,
    required this._state,
    required this._zipCode,
    required this._latitude,
    required this._longitude,
    required this._businessType,
  });

  final int? _id;
  final String _name;
  final String _cnpj;
  final String _companyName;
  final String? _phoneNumber;
  final String _email;
  final String _street;
  final String _number;
  final String _city;
  final String _state;
  final String _zipCode;
  final double _latitude;
  final double _longitude;
  final BusinessType _businessType;

  /// Getter for id
  int? get id => _id;

  /// Getter for name
  String get name => _name;

  /// Getter for CNPJ
  String get cnpj => _cnpj;

  /// Getter for company name
  String get companyName => _companyName;

  /// Getter for phone number
  String? get phoneNumber => _phoneNumber;

  /// Getter for email
  String get email => _email;

  /// Getter for street
  String get street => _street;

  /// Getter for number
  String get number => _number;

  /// Getter for city
  String get city => _city;

  /// Getter for state
  String get state => _state;

  /// Getter for zip code
  String get zipCode => _zipCode;

  /// Getter for latitude
  double get latitude => _latitude;

  /// Getter for longitude
  double get longitude => _longitude;

  /// Getter for business type
  BusinessType get businessType => _businessType;
}