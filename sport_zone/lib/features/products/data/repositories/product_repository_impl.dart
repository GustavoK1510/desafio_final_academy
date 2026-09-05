import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../../../../core/storage/image_storage.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_image_model.dart';
import '../models/product_model.dart';

/// The implementation for [ProductRepository]
class ProductRepositoryImpl implements ProductRepository {
  /// The [Database] instance
  final Database db;

  /// The [ImageStorage] instance
  final ImageStorage imageStorage;

  /// Class constructor
  ProductRepositoryImpl({required this.db, required this.imageStorage});

  @override
  Future<void> insertProduct(Product product, List<File> imageFiles) async {
    /// Copy physical image files directly to permanent local app storage
    final savedPaths = <String>[];

    if (imageFiles.isNotEmpty) {
      for (final rawImage in imageFiles) {
        savedPaths.add(await imageStorage.save(rawImage));
      }
    }

    /// Insert Product and ProductImages in a single atomic SQLite transaction
    final productModel = ProductModel(
      name: product.name,
      brand: product.brand,
      barcode: product.barcode,
      description: product.description,
      price: product.price,
    );

    await db.transaction((txn) async {
      final productId = await txn.insert('products', productModel.toMap());

      for (final path in savedPaths) {
        await txn.insert('product_images', {
          'path': path,
          'product_id': productId,
        });
      }
    });
  }

  @override
  Future<List<Product>> getProducts() async {
    /// Selects the 'products' table
    final productMaps = await db.query('products');

    /// Creates an empty list
    final products = <Product>[];

    for (final productMap in productMaps) {
      /// Retrieves each product's ID
      final productId = productMap['id'] as int;

      /// Gets all the images associated with the product's ID
      final imageMaps = await db.query(
        'product_images',
        where: 'product_id = ?',
        whereArgs: [productId],
        orderBy: 'id ASC',
      );

      final images = imageMaps.map(ProductImageModel.fromMap).toList();

      /// Creates the Product instance with the information
      final product = ProductModel.fromMap(productMap, images: images);

      /// Adds the product instance to the List
      products.add(product);
    }

    /// Returns the List of products
    return products;
  }

  @override
  Future<void> updateProduct(Product product, List<File> newImageFiles) async {
    if (product.id == null) {
      throw ArgumentError('Product id is required to update a product');
    }

    final productId = product.id!;

    /// Gets the images stored for this product
    final imageMaps = await db.query(
      'product_images',
      where: 'product_id = ?',
      whereArgs: [productId],
    );

    final existingImages = imageMaps.map(ProductImageModel.fromMap).toList();

    /// IDs of the existing images that the user wants to keep
    final keptImagesIds = product.images
        .where((image) => image.id != null)
        .map((image) => image.id!)
        .toSet();

    /// Images that exist in the database but are no longer in product.images
    final imagesToDelete = existingImages
        .where(
          (image) => image.id != null && !keptImagesIds.contains(image.id!),
        )
        .toList();

    /// Paths of newly saved physical files
    final savedPaths = <String>[];

    try {
      /// Save new images
      for (final image in newImageFiles) {
        final savedPath = await imageStorage.save(image);
        savedPaths.add(savedPath);
      }

      /// Update the database atomically
      await db.transaction((txn) async {
        /// Update product information
        await txn.update(
          'products',
          {
            'name': product.name,
            'brand': product.brand,
            'barcode': product.barcode,
            'description': product.description,
            'price': product.price,
          },
          where: 'id = ?',
          whereArgs: [productId],
        );

        /// Remove deleted image records
        for (final image in imagesToDelete) {
          await txn.delete(
            'product_images',
            where: 'id = ?',
            whereArgs: [image.id],
          );
        }

        /// Add new image records
        for (final path in savedPaths) {
          await txn.insert('product_images', {
            'path': path,
            'product_id': productId,
          });
        }
      });
    } catch (e) {
      /// If something fails, remove files that were already copied
      for (final path in savedPaths) {
        await imageStorage.delete(path);
      }

      rethrow;
    }

    /// Remove the physical files of images deleted from the product
    for (final image in imagesToDelete) {
      await imageStorage.delete(image.path);
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    /// Get the image paths before deleting the product
    final imageMaps = await db.query(
      'product_images',
      columns: ['path'],
      where: 'product_id = ?',
      whereArgs: [productId],
    );

    final imagePaths = imageMaps
        .map((map) => map['path'] as String)
        .toList();

    /// Delete the product from the database
    /// product_images records are deleted automatically because
    /// product_images.product_id uses ON DELETE CASCADE.
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );

    /// Delete the physical image files
    for (final path in imagePaths) {
      await imageStorage.delete(path);
    }
  }
}
