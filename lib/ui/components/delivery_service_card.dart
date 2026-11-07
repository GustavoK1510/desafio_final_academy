import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../features/delivery_services/domain/entities/delivery_service.dart';

/// Displays a delivery service in the delivery service list.
class DeliveryServiceCard extends StatelessWidget {
  /// Class constructor.
  const DeliveryServiceCard({
    required this.deliveryService,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    super.key,
  });

  /// Delivery service displayed by the card.
  final DeliveryService deliveryService;

  /// Called when the edit button is pressed.
  final VoidCallback onEdit;

  /// Called when the delete button is pressed.
  final VoidCallback onDelete;

  /// Called when opening the delivery service details.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: InkWell(
        onTap: onTap,
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
                  return [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(l10n.edit),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(l10n.delete),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}