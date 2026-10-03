import 'package:flutter/material.dart';

import '../../features/delivery_services/domain/entities/delivery_service.dart';

/// Displays a client in the client list.
class DeliveryServiceCard extends StatelessWidget {

  /// Class constructor.
  const DeliveryServiceCard({
    required this.deliveryService,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  /// DeliveryService displayed by the card.
  final DeliveryService deliveryService;

  /// Called when the edit button is pressed.
  final VoidCallback onEdit;

  /// Called when the delete button is pressed.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Text(
                deliveryService.name.isEmpty
                    ? '?'
                    : deliveryService.name[0].toUpperCase(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deliveryService.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(deliveryService.companyName),
                  const SizedBox(height: 4),
                  Text(deliveryService.cnpj),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}