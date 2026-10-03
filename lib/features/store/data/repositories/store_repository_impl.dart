import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../../../../core/storage/image_storage.dart';
import '../../domain/entities/store.dart';
import '../../domain/repositories/store_repository.dart';
import '../models/store_model.dart';

/// The implementation for [StoreRepository]
class StoreRepositoryImpl implements StoreRepository {

  /// The [Database] instance
  final Database db;

  /// The [ImageStorage] instance
  final ImageStorage imageStorage;

  /// Class constructor
  StoreRepositoryImpl({required this.db, required this.imageStorage});

  @override
  Future<void> insertStore(Store store, File file) async {

    /// Saves the image in the app's storage
    final logoPath = await imageStorage.save(file);

    /// Creates the model
    final storeModel = StoreModel(
      name: store.name,
      companyName: store.companyName,
      logoPath: logoPath,
      cnpj: store.cnpj,
      street: store.street,
      number: store.number,
      city: store.city,
      state: store.state,
      zipCode: store.zipCode,
      latitude: store.latitude,
      longitude: store.longitude
    );

    /// Inserts the model into the database
    await db.insert('store', storeModel.toMap());
  }

  @override
  Future<Store?> getStore() async {
    final store = await db.query('store');

    if (store.isEmpty) {
      return null;
    }

    final storeModel = StoreModel.fromMap(store[0]);
    return storeModel;
  }

  @override
  Future<void> updateStore(Store store, File? file) async {

    /// Retrieves the Store already saved
    final storeSaved = await getStore();

    if(file != null) {

      /// Deletes the old logo from the storage
      await imageStorage.delete(storeSaved!.logoPath);

      /// Saves the image in the app's storage
      final logoPath = await imageStorage.save(file);

      /// Updates the database with the new logo
      await db.update(
          'store',
          {
            'name': store.name,
            'company_name': store.companyName,
            'logo_path': logoPath,
            'cnpj': store.cnpj,
            'street': store.street,
            'number': store.number,
            'city': store.city,
            'state': store.state,
            'zip_code': store.zipCode,
            'latitude': store.latitude,
            'longitude': store.longitude,
          },
          where: 'id = ?',
          whereArgs: [storeSaved.id]
      );

      return;
    }

    /// Updates the database
    await db.update(
        'store',
        {
          'name': store.name,
          'company_name': store.companyName,
          'cnpj': store.cnpj,
          'street': store.street,
          'number': store.number,
          'city': store.city,
          'state': store.state,
          'zip_code': store.zipCode,
          'latitude': store.latitude,
          'longitude': store.longitude,
        },
        where: 'id = ?',
        whereArgs: [storeSaved!.id]
    );

  }

  @override
  Future<void> deleteStore(int storeId) async {

    /// Retrieves the Store
    final storeSaved = await getStore();

    /// Deletes the Store from the database
    await db.delete(
      'store',
      where: 'id = ?',
      whereArgs: [storeId]
    );

    /// Deletes it's image from the app's storage
    await imageStorage.delete(storeSaved!.logoPath);
  }
}