import 'dart:io';

import 'package:flutter/material.dart';

import '../../features/products/domain/entities/product.dart';

/// Displays a product in the product listing.
class ProductCard extends StatelessWidget {

  /// Class constructor.
  const ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  /// Product displayed by the card.
  final Product product;

  /// Called when editing the product.
  final VoidCallback onEdit;

  /// Called when deleting the product.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final imagePath = product.images.isNotEmpty
        ? product.images.first.path
        : null;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildImage(context, imagePath),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(
      BuildContext context,
      String? imagePath,
      ) {
    if (imagePath == null || !File(imagePath).existsSync()) {
      return Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.inventory_2_outlined,
          size: 36,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.file(
        File(imagePath),
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      ),
    );
  }
}