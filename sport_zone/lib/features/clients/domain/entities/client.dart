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

  int? get id => _id;

  String get name => _name;

  String get cnpj => _cnpj;

  String get companyName => _companyName;

  String? get phoneNumber => _phoneNumber;

  String get email => _email;

  String get street => _street;

  String get number => _number;

  String get city => _city;

  String get state => _state;

  String get zipCode => _zipCode;

  double get latitude => _latitude;

  double get longitude => _longitude;

  BusinessType get businessType => _businessType;
}