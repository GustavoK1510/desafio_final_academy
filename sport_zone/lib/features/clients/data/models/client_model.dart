import '../../domain/entities/client.dart';
import '../../domain/enums/business_type.dart';

/// Data model for [Client]
class ClientModel extends Client {

  /// Class constructor
  ClientModel({
    super.id,
    required super.name,
    required super.cnpj,
    required super.companyName,
    super.phoneNumber,
    required super.email,
    required super.street,
    required super.number,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.latitude,
    required super.longitude,
    required super.businessType,
  });

  /// Creates a ClientModel from a database Map
  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      name: map['name'],
      cnpj: map['cnpj'],
      companyName: map['company_name'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      street: map['street'],
      number: map['number'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zip_code'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      businessType: BusinessType.values.byName(map['business_type'] as String),
    );
  }

  /// Converts a ClientModel instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cnpj': cnpj,
      'company_name': companyName,
      'phone_number': phoneNumber,
      'email': email,
      'street': street,
      'number': number,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'latitude': latitude,
      'longitude': longitude,
      'business_type': businessType.name
    };
  }
}