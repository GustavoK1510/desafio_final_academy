import 'dart:io';

import '../entities/store.dart';

/// Represents the contract for [StoreRepository]
abstract class StoreRepository {

  /// Insert a [Store] into the database
  Future<void> insertStore(Store store, File file);

  /// Retrieve all Stores from the database
  Future<Store?> getStore();

  /// Updates a [Store]
  Future<void> updateStore(Store store, File? file);

  /// Deletes a [Store] by its [id]
  Future<void> deleteStore(int storeId);
}