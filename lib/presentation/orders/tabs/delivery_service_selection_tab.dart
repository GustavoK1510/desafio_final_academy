import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../ui/components/delivery_route_map.dart';
import '../../../ui/components/delivery_service_search_results.dart';
import '../../../ui/components/error_message.dart';
import '../../../ui/components/read_only_field.dart';
import '../providers/order_form_provider.dart';

/// Displays the delivery service selection step
class DeliveryServiceSelectionTab extends StatelessWidget {

  /// Class constructor
  const DeliveryServiceSelectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderFormProvider>();
    final deliveryService = provider.selectedDeliveryService;
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [

        Text(
          'Select a delivery service',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 8),

        Text(
          'Search by delivery service name or CNPJ to continue.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),

        TextField(
          onChanged: provider.searchDeliveryServices,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Search delivery services',
            hintText: l10n.enterNameOrCNPJ,
            prefixIcon: IconButton(
              tooltip: l10n.search,
              onPressed: () => provider.searchDeliveryServices,
              icon: const Icon(Icons.search),
            ),
            suffixIcon: provider.deliveryServiceSearchQuery.isNotEmpty
                ? IconButton(
              tooltip: l10n.clearSearch,
              onPressed: () => provider.searchDeliveryServices(''),
              icon: const Icon(Icons.clear),
            )
                : null,
            border: const OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 12),

        if (provider.isLoadingDeliveryService)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )

        else if (provider.errorMessage != null)
          ErrorMessage(message: provider.errorMessage!)

        else DeliveryServiceSearchResults(
              deliveryServices: provider.filteredDeliveryServices,
              selectedDeliveryService: deliveryService,
            ),

        if (provider.store == null)
          const Center(
            child: Text('Verify your store address before continuing.'),
          )

        else if (deliveryService != null) ...[

          const SizedBox(height: 24),

          Text(
            'Selected delivery service',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 24),

          Text(
            'Delivery route',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 12),


          if (provider.isCalculatingRoute)
            const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (provider.deliveryRoute != null &&
              provider.store != null &&
              provider.selectedClient != null)
            DeliveryRouteMap(
              store: provider.store!,
              client: provider.selectedClient!,
              route: provider.deliveryRoute!,
            ),
            const SizedBox(height: 16),

            ReadOnlyField(
              label: l10n.name,
              value: deliveryService.name,
            ),

            const SizedBox(height: 12),

            ReadOnlyField(
              label: l10n.companyName,
              value: deliveryService.companyName,
            ),

            const SizedBox(height: 12),

            ReadOnlyField(
              label: l10n.cnpj,
              value: deliveryService.cnpj,
            ),

            const SizedBox(height: 12),

            ReadOnlyField(
              label: l10n.costPerKilometer,
              value: deliveryService.kmCost.toString(),
            ),

            const SizedBox(height: 12),

            ReadOnlyField(
              label: 'Estimated delivery date',
              value: '${provider.deliveryDate.day}/'
                '${provider.deliveryDate.month}/${provider.deliveryDate.year}',
            ),

            const SizedBox(height: 12),

            ReadOnlyField(
              label: 'Delivery distance',
              value: '${provider.deliveryDistance.roundToDouble()} km',
            ),

            const SizedBox(height: 12),

            ReadOnlyField(
              label: 'Total delivery price',
              value: 'R\$ ${provider.deliveryPrice}',
            ),
        ],
      ],
    );
  }
}
