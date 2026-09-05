import '../entities/store.dart';

/// Represents the contract for [StoreRepository]
abstract class StoreRepository {

  /// Insert a [Store] into the database
  Future<void> insertStore(Store store);

  /// Retrieve all Stores from the database
  Future<Store> getStores();

  /// Updates a [Store]
  Future<void> updateStore(Store store);

  /// Deletes a [Store] by its [id]
  Future<void> deleteStore(int storeId);
}