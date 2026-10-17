import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../presentation/orders/providers/order_form_provider.dart';

/// Component for the delivery search results
class DeliveryServiceSearchResults extends StatelessWidget {

  /// Class constructor
  const DeliveryServiceSearchResults({
    super.key,
    required this.deliveryServices,
    required this.selectedDeliveryService,
  });

  /// List of delivery services
  final List<DeliveryService> deliveryServices;

  /// The selected delivery service
  final DeliveryService? selectedDeliveryService;

  @override
  Widget build(BuildContext context) {
    if (deliveryServices.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text('No matching delivery services found.'),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: deliveryServices.map((deliveryService) {
          final isSelected = selectedDeliveryService?.id == deliveryService.id;

          return ListTile(
            leading: CircleAvatar(
              child: Text(
                deliveryService.name.isEmpty
                    ? '?'
                    : deliveryService.name[0].toUpperCase(),
              ),
            ),
            title: Text(deliveryService.name),
            subtitle: Text(
              '${deliveryService.companyName}\n${deliveryService.cnpj}',
            ),
            isThreeLine: true,
            selected: isSelected,
            trailing: isSelected
                ? const Icon(Icons.check_circle)
                : null,
            onTap: () {
              context.read<OrderFormProvider>()
                  .selectDeliveryService(deliveryService);
            },
          );
        }).toList(),
      ),
    );
  }
}