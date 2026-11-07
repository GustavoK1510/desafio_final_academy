import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/clients/domain/entities/client.dart';
import '../providers/client_details_provider.dart';

/// Displays all information about a client.
class ClientDetailsPage extends StatelessWidget {
  const ClientDetailsPage({
    required this.client,
    super.key,
  });

  final Client client;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientDetailsProvider(client: client),
      child: const _ClientDetailsContent(),
    );
  }
}

class _ClientDetailsContent extends StatelessWidget {
  const _ClientDetailsContent();

  @override
  Widget build(BuildContext context) {
    final client = context.watch<ClientDetailsProvider>().client;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
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
                  client.name.isEmpty
                      ? '?'
                      : client.name[0].toUpperCase(),
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                client.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              title: 'Personal and Business Information',
              children: [
                _DetailRow(label: 'ID', value: client.id?.toString()),
                _DetailRow(label: 'Name', value: client.name),
                _DetailRow(
                  label: 'Company Name',
                  value: client.companyName,
                ),
                _DetailRow(label: 'CNPJ', value: client.cnpj),
                _DetailRow(
                  label: 'Business Type',
                  value: client.businessType.name,
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Contact Information',
              children: [
                _DetailRow(
                  label: 'Phone Number',
                  value: client.phoneNumber,
                ),
                _DetailRow(label: 'Email', value: client.email),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Address',
              children: [
                _DetailRow(label: 'Street', value: client.street),
                _DetailRow(label: 'Number', value: client.number),
                _DetailRow(label: 'City', value: client.city),
                _DetailRow(label: 'State', value: client.state),
                _DetailRow(label: 'ZIP Code', value: client.zipCode),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Location Coordinates',
              children: [
                _DetailRow(
                  label: 'Latitude',
                  value: client.latitude.toString(),
                ),
                _DetailRow(
                  label: 'Longitude',
                  value: client.longitude.toString(),
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

/// Displays a single client information field.
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
            width: 120,
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