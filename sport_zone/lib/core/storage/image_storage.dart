import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Responsible for saving and deleting image files from the app's storage
class ImageStorage {
  /// Saves an image to the application's permanent storage
  /// and returns the saved file path
  Future<String> save(File image) async {

    /// Gets the application's documents directory
    final appDocDir = await getApplicationDocumentsDirectory();

    final imagesDir = Directory(
      p.join(appDocDir.path, 'product_images'),
    );

    /// Creates the directory for the images if it doesn't exists
    if(!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    /// Creates the file name
    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}'
        '${p.extension(image.path)}';

    /// Creates the permanent path
    final permanentPath = p.join(
      imagesDir.path,
      fileName,
    );

    final savedFile = await image.copy(permanentPath);

    return savedFile.path;
  }

  /// Deletes an image from the application's storage
  Future<void> delete(String imagePath) async {
    final file = File(imagePath);

    if (await file.exists()) {
      file.delete;
    }
  }

}