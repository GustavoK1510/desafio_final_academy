import '../../domain/entities/store.dart';

///Data model for [Store]
class StoreModel extends Store {

  /// Class constructor
  StoreModel({
    super.id,
    required super.name,
    required super.companyName,
    required super.logoPath,
    required super.cnpj,
    required super.street,
    required super.number,
    required super.city,
    required super.state,
    required super.zipCode
  });

  /// Creates a StoreModel from a database Map
  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      id: map['id'],
      name: map['name'],
      companyName: map['company_name'],
      logoPath: map['logo_path'],
      cnpj: map['cnpj'],
      street: map['street'],
      number: map['number'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zip_code'],
    );
  }

  /// Converts a StoreModel instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'company_name': companyName,
      'logo_path': logoPath,
      'cnpj': cnpj,
      'street': street,
      'number': number,
      'city': city,
      'state': state,
      'zip_code': zipCode,
    };
  }

}