import 'dart:io';

import '../../../../core/services/geocoding/geocoding_service.dart';
import '../entities/store.dart';
import '../repositories/store_repository.dart';

/// Provides store-related application operations
class StoreUseCase {

  /// Class constructor
  StoreUseCase ({
    required this._repository,
    required this._geocodingService,
  });

  final StoreRepository _repository;

  final GeocodingService _geocodingService;

  /// Adds a new [Store]
  Future<void> insertStore(Store store, File file) async {

    /// Retrieves the address coordinates
    final location = await _geocodingService.getCoordinates(
        street: store.street,
        number: store.number,
        city: store.city,
        state: store.state
    );

    /// Creates a Store instance with the coordinates
    final storeWithCoordinates = Store(
      name: store.name,
      companyName: store.companyName,
      logoPath: store.logoPath,
      cnpj: store.cnpj,
      street: store.street,
      number: store.number,
      city: store.city,
      state: store.state,
      zipCode: store.zipCode,
      latitude: location.latitude,
      longitude: location.longitude,
    );

    /// Sends it to the repository
    await _repository.insertStore(storeWithCoordinates, file);
  }

  /// Retrieves the [Store]
  Future<Store?> getStore() async {
    final store = await _repository.getStore();

    return store;
  }

  /// Updates the [Store]
  Future<void> updateStore(Store store, File? file) async {

    /// Retrieves the address coordinates
    final location = await _geocodingService.getCoordinates(
        street: store.street,
        number: store.number,
        city: store.city,
        state: store.state
    );

    /// Creates a Store instance with the coordinates
    final storeWithCoordinates = Store(
      id: store.id,
      name: store.name,
      companyName: store.companyName,
      logoPath: store.logoPath,
      cnpj: store.cnpj,
      street: store.street,
      number: store.number,
      city: store.city,
      state: store.state,
      zipCode: store.zipCode,
      latitude: location.latitude,
      longitude: location.longitude,
    );

    /// Sends it to the repository
    await _repository.updateStore(storeWithCoordinates, file);
  }

  /// Deletes the [Store]
  Future<void> deleteStore(int storeId) async {
    await _repository.deleteStore(storeId);
  }

}