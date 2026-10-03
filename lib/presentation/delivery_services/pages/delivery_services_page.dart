import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import '../../../ui/components/delivery_service_card.dart';
import '../providers/delivery_services_provider.dart';

/// Displays the delivery service listing.
class DeliveryServicesPage extends StatelessWidget {

  /// Class constructor.
  const DeliveryServicesPage({
    required this.useCase,
    super.key,
  });

  /// Delivery Service use case.
  final DeliveryServiceUseCase useCase;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeliveryServicesProvider(
        useCase: useCase,
      )..loadDeliveryServices(),
      child: const _DeliveryServicesContent(),
    );
  }
}

/// Displays the delivery service list content.
class _DeliveryServicesContent extends StatelessWidget {

  /// Class constructor.
  const _DeliveryServicesContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<DeliveryServicesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deliveryService),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final saved = await context.push<bool>(
            '/delivery-services/form',
          );

          if (saved == true && context.mounted) {
            await context.read<DeliveryServicesProvider>().loadDeliveryServices();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addDeliveryService),
      ),
      body: RefreshIndicator(
        onRefresh: provider.loadDeliveryServices,
        child: _buildBody(
          context,
          provider,
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      DeliveryServicesProvider provider,
      ) {
    final l10n = AppLocalizations.of(context)!;

    if (provider.isLoading && provider.deliveryServices.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null &&
        provider.deliveryServices.isEmpty) {
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

    if (provider.deliveryServices.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Center(
              child: Text(
                l10n.noDeliveryServicesRegistered,
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
      itemCount: provider.deliveryServices.length,
      separatorBuilder: (_, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final deliveryService = provider.deliveryServices[index];

        return DeliveryServiceCard(
          deliveryService: deliveryService,
          onEdit: () async {
            final saved = await context.push<bool>(
              '/delivery-services/form',
              extra: deliveryService,
            );

            if (saved == true && context.mounted) {
              await context
                  .read<DeliveryServicesProvider>()
                  .loadDeliveryServices();
            }
          },
          onDelete: () {
            _confirmDelete(
              context,
              deliveryService,
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      DeliveryService deliveryService,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteDeliveryService),
          content: Text(
            l10n.deleteDeliveryServiceConfirmation,
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

    final id = deliveryService.id;

    if (id == null) {
      return;
    }

    final success = await context
        .read<DeliveryServicesProvider>()
        .deleteDeliveryService(id);

    if (!success || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.deliveryServiceDeleted),
      ),
    );
  }
}