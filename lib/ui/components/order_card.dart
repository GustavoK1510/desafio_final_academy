import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/localization/app_localizations.dart';
import '../../features/orders/domain/entities/order.dart';
import '../../features/orders/domain/enums/payment_option.dart';

/// Displays order information and its available actions.
class OrderCard extends StatelessWidget {

  /// Class constructor
  const OrderCard({
    super.key,
    required this.order,
    required this.clientName,
    required this.deliveryServiceName,
    required this.onDelete,
    required this.onGeneratePdf,
  });

  /// Order
  final Order order;

  /// Client name
  final String clientName;

  /// Delivery service name
  final String deliveryServiceName;

  /// onDelete function
  final VoidCallback onDelete;

  /// Generates the PDF
  final VoidCallback onGeneratePdf;

  /// Getter for total units
  int get totalUnits {
    return order.orderItems.fold<int>(
      0, (total, item) => total + item.quantity,
    );
  }

  /// Getter for formatted date
  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(order.deliveryDate);
  }

  /// Getter for formatted price
  String get formattedPrice {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    ).format(order.price);
  }

  /// Getter for payment label
  String get paymentLabel {
    switch (order.paymentOption) {
      case PaymentOption.creditCard:
        return 'Credit card';
      case PaymentOption.cash:
        return 'Cash';
      case PaymentOption.bankTransferTed:
        return 'Bank transfer (TED)';
      case PaymentOption.bankTransferDoc:
        return 'Bank transfer (DOC)';
      case PaymentOption.pix:
        return 'PIX';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order #${order.id}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    formattedPrice,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _infoRow(
                icon: Icons.person_outline,
                label: clientName,
              ),
              const SizedBox(height: 6),
              _infoRow(
                icon: Icons.local_shipping_outlined,
                label: deliveryServiceName,
              ),
              const SizedBox(height: 6),
              _infoRow(
                icon: Icons.calendar_today_outlined,
                label: formattedDate,
              ),
              const SizedBox(height: 6),
              _infoRow(
                icon: Icons.payment_outlined,
                label: paymentLabel,
              ),
              const SizedBox(height: 6),
              _infoRow(
                icon: Icons.shopping_bag_outlined,
                label: '$totalUnits product units',
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Generate PDF receipt',
                    onPressed: onGeneratePdf,
                    icon: const Icon(
                      Icons.picture_as_pdf_outlined,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete order',
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}