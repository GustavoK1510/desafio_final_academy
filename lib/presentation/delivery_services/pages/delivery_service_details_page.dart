import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../providers/delivery_service_details_provider.dart';

/// Displays all information about a delivery service.
class DeliveryServiceDetailsPage extends StatelessWidget {
  const DeliveryServiceDetailsPage({
    required this.deliveryService,
    super.key,
  });

  final DeliveryService deliveryService;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeliveryServiceDetailsProvider(
        deliveryService: deliveryService,
      ),
      child: const _DeliveryServiceDetailsContent(),
    );
  }
}

class _DeliveryServiceDetailsContent extends StatelessWidget {
  const _DeliveryServiceDetailsContent();

  @override
  Widget build(BuildContext context) {
    final service = context
        .watch<DeliveryServiceDetailsProvider>()
        .deliveryService;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Service Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 42,
                child: Text(
                  service.name.isEmpty
                      ? '?'
                      : service.name[0].toUpperCase(),
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                service.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              title: 'Business Information',
              children: [
                _DetailRow(label: 'ID', value: service.id?.toString()),
                _DetailRow(label: 'Name', value: service.name),
                _DetailRow(
                  label: 'Company Name',
                  value: service.companyName,
                ),
                _DetailRow(label: 'CNPJ', value: service.cnpj),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Contact Information',
              children: [
                _DetailRow(
                  label: 'Phone Number',
                  value: service.phoneNumber,
                ),
                _DetailRow(label: 'Email', value: service.email),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Pricing Information',
              children: [
                _DetailRow(
                  label: 'Cost per Kilometer',
                  value: 'R\$ ${service.kmCost.toStringAsFixed(2)}',
                ),
                _DetailRow(
                  label: 'Minimum Price',
                  value: service.minimumPrice == null
                      ? null
                      : 'R\$ ${service.minimumPrice!.toStringAsFixed(2)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required List<Widget> children,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

/// Displays a single delivery service information field.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : 'Not provided',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}