import '../entities/delivery_service.dart';
import '../repositories/delivery_service_repository.dart';

/// Provides delivery-service-related application operations
class DeliveryServiceUseCase {

  /// Class constructor
  DeliveryServiceUseCase({required this._repository});

  final DeliveryServiceRepository _repository;

  /// Adds a new [DeliveryService]
  Future<void> insertDeliveryService(DeliveryService deliveryService) async {
    await _repository.insertDeliveryService(deliveryService);
  }

  /// Retrieves all delivery services
  Future<List<DeliveryService>> getDeliveryServices() async {
    return await _repository.getDeliveryServices();
  }

  /// Updates an existing [DeliveryService]
  Future<void> updateDeliveryService(DeliveryService deliveryService) async {
    await _repository.updateDeliveryService(deliveryService);
  }

  /// Deletes a [DeliveryService] by its [id]
  Future<void> deleteDeliveryService(int deliveryServiceId) async {
    await _repository.deleteDeliveryService(deliveryServiceId);
  }
}