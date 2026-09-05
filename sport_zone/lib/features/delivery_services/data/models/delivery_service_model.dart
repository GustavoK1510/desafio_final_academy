import '../../domain/entities/delivery_service.dart';

/// Data model for [DeliveryServiceModel]
class DeliveryServiceModel extends DeliveryService {

  /// Class constructor
  DeliveryServiceModel({
    super.id,
    required super.name,
    required super.companyName,
    required super.cnpj,
    super.phoneNumber,
    required super.email,
    required super.kmCost,
    super.minimumPrice,
  });

  /// Creates a DeliveryServiceModel from a database map
  factory DeliveryServiceModel.fromMap(Map<String, dynamic> map) {
    return DeliveryServiceModel(
      id: map['id'],
      name: map['name'],
      companyName: map['company_name'],
      cnpj: map['cnpj'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      kmCost: (map['km_cost'] as num).toDouble(),
      minimumPrice: (map['minimum_price'] as num).toDouble(),
    );
  }

  /// Converts a DeliveryServiceModel into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'company_name': companyName,
      'cnpj': cnpj,
      'phone_number': phoneNumber,
      'email': email,
      'km_cost': kmCost,
      'minimum_price': minimumPrice,
    };
  }

}