import '../entities/delivery_service.dart';

/// Represents the contract for [DeliveryServiceRepository]
abstract class DeliveryServiceRepository {

  /// Inserts a [DeliveryService] into the database
  Future<void> insertDeliveryService(DeliveryService deliveryService);

  /// Retrieves all delivery services from the database
  Future<List<DeliveryService>> getDeliveryServices();

  /// Retrieves a specific Delivery Service using the ID
  Future<DeliveryService> getDeliveryService(int deliveryServiceId);

  /// Updates a [DeliveryService]
  Future<void> updateDeliveryService(DeliveryService deliveryService);

  /// Deletes a [DeliveryService] by its [id]
  Future<void> deleteDeliveryService(int deliveryServiceId);
}