import 'dart:io';

import 'package:flutter/material.dart';

/// Displays and manages product images.
class ProductImagePicker extends StatelessWidget {
  /// Class constructor.
  const ProductImagePicker({
    required this.existingImages,
    required this.newImages,
    required this.onAdd,
    required this.onRemoveExisting,
    required this.onRemoveNew,
    super.key,
  });

  /// Existing product images.
  final List<File> existingImages;

  /// Newly selected images.
  final List<File> newImages;

  /// Callback for adding images.
  final VoidCallback onAdd;

  /// Callback for removing an existing image.
  final ValueChanged<File> onRemoveExisting;

  /// Callback for removing a new image.
  final ValueChanged<File> onRemoveNew;

  @override
  Widget build(BuildContext context) {
    final images = [
      ...existingImages,
      ...newImages,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Product images',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              tooltip: 'Add images',
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (images.isEmpty)
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text('Add product images'),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final image = images[index];
              final isExisting = index < existingImages.length;

              return Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () {
                          if (isExisting) {
                            onRemoveExisting(image);
                          } else {
                            onRemoveNew(image);
                          }
                        },
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}