import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../features/clients/domain/entities/client.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../../../ui/components/client_card.dart';
import '../providers/clients_provider.dart';

/// Displays the client listing.
class ClientsPage extends StatelessWidget {
  /// Class constructor.
  const ClientsPage({
    required this.useCase,
    super.key,
  });

  /// Client use case.
  final UseCaseClient useCase;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientsProvider(
        useCase: useCase,
      )..loadClients(),
      child: const _ClientsContent(),
    );
  }
}

/// Displays the client list content.
class _ClientsContent extends StatelessWidget {
  /// Class constructor.
  const _ClientsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ClientsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.clients),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final saved = await context.push<bool>(
            '/clients/form',
          );

          if (saved == true && context.mounted) {
            await context.read<ClientsProvider>().loadClients();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addClient),
      ),
      body: RefreshIndicator(
        onRefresh: provider.loadClients,
        child: _buildBody(
          context,
          provider,
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      ClientsProvider provider,
      ) {
    final l10n = AppLocalizations.of(context)!;

    if (provider.isLoading && provider.clients.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null &&
        provider.clients.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            provider.errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (provider.clients.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Center(
              child: Text(
                l10n.noClientsRegistered,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        100,
      ),
      itemCount: provider.clients.length,
      separatorBuilder: (_, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final client = provider.clients[index];

        return ClientCard(
          client: client,
          onEdit: () async {
            final saved = await context.push<bool>(
              '/clients/form',
              extra: client,
            );

            if (saved == true && context.mounted) {
              await context
                  .read<ClientsProvider>()
                  .loadClients();
            }
          },
          onDelete: () {
            _confirmDelete(
              context,
              client,
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      Client client,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteClient),
          content: Text(
            l10n.deleteClientConfirmation,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final id = client.id;

    if (id == null) {
      return;
    }

    final success = await context
        .read<ClientsProvider>()
        .deleteClient(id);

    if (!success || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.clientDeleted),
      ),
    );
  }
}