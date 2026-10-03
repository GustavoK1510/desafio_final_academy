import 'package:sqflite/sqflite.dart';

import '../../domain/entities/delivery_service.dart';
import '../../domain/repositories/delivery_service_repository.dart';
import '../models/delivery_service_model.dart';

/// The implementation for [DeliveryServiceRepository]
class DeliveryServiceRepositoryImpl implements DeliveryServiceRepository {

  /// A [Database] instance
  final Database db;

  /// Class constructor
  DeliveryServiceRepositoryImpl({required this.db});

  @override
  Future<void> insertDeliveryService(DeliveryService deliveryService) async {

    /// Creates a DeliveryServiceModel
    final deliveryServiceModel = DeliveryServiceModel(
      name: deliveryService.name,
      companyName: deliveryService.companyName,
      cnpj: deliveryService.cnpj,
      phoneNumber: deliveryService.phoneNumber,
      email: deliveryService.email,
      kmCost: deliveryService.kmCost,
      minimumPrice: deliveryService.minimumPrice,
    );

    /// Inserts the model into the database
    await db.insert(
      'delivery_services',
      deliveryServiceModel.toMap()
    );
  }

  @override
  Future<List<DeliveryService>> getDeliveryServices() async {

    /// Gets all the delivery services
    final deliveryServiceMaps = await db.query('delivery_services');

    /// Creates an empty List
    final deliveryServices = <DeliveryService>[];

    /// Converts each delivery service into a DeliveryServiceModel instance
    /// and adds it to the List
    for (final deliveryServiceMap in deliveryServiceMaps) {
      final deliveryService = DeliveryServiceModel.fromMap(deliveryServiceMap);
      deliveryServices.add(deliveryService);
    }

    /// Returns the List
    return deliveryServices;
  }

  @override
  Future<DeliveryService> getDeliveryService(int deliveryServiceId) async {

    /// Selects the DeliveryService using it's ID
    final deliveryServiceMap = await db.query(
      'delivery_services',
      where: 'id = ?',
      whereArgs: [deliveryServiceId]
    );

    /// Converts it into a DeliveryService instance
    final deliveryService = DeliveryServiceModel.fromMap(deliveryServiceMap[0]);

    /// Return the DeliveryService
    return deliveryService;
  }

  @override
  Future<void> updateDeliveryService(DeliveryService deliveryService) async {

    /// Checks if the delivery service has an ID
    if(deliveryService.id == null) {
      throw ArgumentError('Client ID is required to update a client');
    }

    /// Updates the delivery service
    await db.update(
      'delivery_services',
      {
        'name': deliveryService.name,
        'company_name': deliveryService.companyName,
        'cnpj': deliveryService.cnpj,
        'phone_number': deliveryService.phoneNumber,
        'email': deliveryService.email,
        'km_cost': deliveryService.kmCost,
        'minimum_price': deliveryService.minimumPrice,
      },
      where: 'id = ?',
      whereArgs: [deliveryService.id!],
    );
  }

  @override
  Future<void> deleteDeliveryService(int deliveryServiceId) async {

    /// Deletes the delivery service
    await db.delete(
      'delivery_services',
      where: 'id = ?',
      whereArgs: [deliveryServiceId],
    );
  }

}