
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../features/clients/domain/entities/client.dart';
import '../providers/order_form_provider.dart';

/// Displays the client selection step.
class ClientSelectionTab extends StatelessWidget {
  /// Creates the client selection tab.
  const ClientSelectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderFormProvider>();
    final client = provider.selectedClient;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [

        Text(
          'Select a client',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 8),

        Text(
          'Search by client name or CNPJ to continue.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),

        TextField(
          onChanged: provider.searchClients,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Search clients',
            hintText: 'Enter a name or CNPJ',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: provider.searchQuery.isNotEmpty
                ? IconButton(
              tooltip: 'Clear search',
              onPressed: () => provider.searchClients(''),
              icon: const Icon(Icons.clear),
            )
                : null,
            border: const OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 12),

        if (provider.isLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )

        else if (provider.errorMessage != null)
          _ErrorMessage(message: provider.errorMessage!)

        else if (provider.searchQuery.trim().isNotEmpty)
            _ClientSearchResults(
              clients: provider.filteredClients,
              selectedClient: client,
            ),

        if (client != null) ...[

          const SizedBox(height: 24),

          Text(
            'Selected client',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 16),

          _ReadOnlyField(
            label: 'Name',
            value: client.name,
          ),

          const SizedBox(height: 12),

          _ReadOnlyField(
            label: 'Company Name',
            value: client.companyName,
          ),

          const SizedBox(height: 12),

          _ReadOnlyField(
            label: 'CNPJ',
            value: client.cnpj,
          ),

          const SizedBox(height: 12),

          _ReadOnlyField(
            label: 'ZIP Code',
            value: client.zipCode,
          ),
        ],
      ],
    );
  }
}

class _ClientSearchResults extends StatelessWidget {
  const _ClientSearchResults({
    required this.clients,
    required this.selectedClient,
  });

  final List<Client> clients;
  final Client? selectedClient;

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text('No matching clients found.'),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: clients.map((client) {
          final isSelected = selectedClient?.id == client.id;

          return ListTile(
            leading: CircleAvatar(
              child: Text(
                client.name.isEmpty
                    ? '?'
                    : client.name[0].toUpperCase(),
              ),
            ),
            title: Text(client.name),
            subtitle: Text(
              '${client.companyName}\n${client.cnpj}',
            ),
            isThreeLine: true,
            selected: isSelected,
            trailing: isSelected
                ? const Icon(Icons.check_circle)
                : null,
            onTap: () {
              context.read<OrderFormProvider>().selectClient(client);
            },
          );
        }).toList(),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-$value'),
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
