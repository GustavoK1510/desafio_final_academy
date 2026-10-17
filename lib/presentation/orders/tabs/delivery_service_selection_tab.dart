import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            hintText: 'Enter a name or CNPJ',
            prefixIcon: IconButton(
              tooltip: 'Search',
              onPressed: () => provider.searchDeliveryServices,
              icon: const Icon(Icons.search),
            ),
            suffixIcon: provider.deliveryServiceSearchQuery.isNotEmpty
                ? IconButton(
              tooltip: 'Clear search',
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

        if (deliveryService != null) ...[

          const SizedBox(height: 24),

          Text(
            'Selected delivery service',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 16),

          ReadOnlyField(
            label: 'Name',
            value: deliveryService.name,
          ),

          const SizedBox(height: 12),

          ReadOnlyField(
            label: 'Company Name',
            value: deliveryService.companyName,
          ),

          const SizedBox(height: 12),

          ReadOnlyField(
            label: 'CNPJ',
            value: deliveryService.cnpj,
          ),

          const SizedBox(height: 12),

          ReadOnlyField(
            label: 'Cost per KM',
            value: deliveryService.kmCost.toString(),
          ),

          const SizedBox(height: 12),

          ReadOnlyField(
            label: 'Delivery distance',
            value: '${provider.deliveryDistance} km',
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
