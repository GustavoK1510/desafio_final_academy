import 'package:flutter/material.dart';

import '../../features/clients/domain/entities/client.dart';

/// Displays a client in the client list.
class ClientCard extends StatelessWidget {
  /// Class constructor.
  const ClientCard({
    required this.client,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  /// Client displayed by the card.
  final Client client;

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
                client.name.isEmpty
                    ? '?'
                    : client.name[0].toUpperCase(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(client.companyName),
                  const SizedBox(height: 4),
                  Text(client.cnpj),
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