
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../features/orders/domain/enums/payment_option.dart';
import '../providers/order_form_provider.dart';

/// Displays the order summary and payment options.
class OrderReviewTab extends StatelessWidget {
  /// Creates the order review tab.
  const OrderReviewTab({super.key});

  String _paymentOptionLabel(PaymentOption option) {
    switch (option) {
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
    final provider = context.watch<OrderFormProvider>();

    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    final selectedClient = provider.selectedClient;
    final isCreditCard = provider.isCreditCard;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Order summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Client',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(selectedClient?.name ?? 'No client selected'),
                const Divider(height: 24),

                Text(
                  'Products',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                ...provider.cart.map((item) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.product.name}',
                            ),
                          ),
                          Text(
                            currencyFormat.format(item.subtotal),
                          ),
                        ],
                      ),
                      if (item.discountPercentage > 0) ...[
                        Text(
                          'Discount '
                              '(${item.discountPercentage
                              .toStringAsFixed(2)}%): '
                              '-${currencyFormat.format(item.discountAmount)}',
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'After discount: '
                                '${currencyFormat
                                .format(item.discountedSubtotal)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                    ],
                  );
                }),

                const Divider(height: 24),

                _PriceRow(
                  label: 'Product subtotal',
                  value: currencyFormat.format(provider.cartSubtotal),
                ),
                _PriceRow(
                  label: 'Product discounts',
                  value: '-${currencyFormat
                      .format(provider.cartDiscountTotal)}',
                ),
                _PriceRow(
                  label: 'Products after discounts',
                  value: currencyFormat.format(provider.cartTotal),
                ),

                const SizedBox(height: 8),

                _PriceRow(
                  label: 'Delivery',
                  value: currencyFormat.format(provider.deliveryPrice),
                ),

                if (isCreditCard) ...[
                  const SizedBox(height: 8),
                  _PriceRow(
                    label: 'Credit card surcharge (4%)',
                    value: currencyFormat.format(
                      provider.orderTotal * 0.04,
                    ),
                  ),
                ],

                const Divider(height: 24),

                _PriceRow(
                  label: 'Final total',
                  value: currencyFormat.format(
                    provider.finalOrderTotal,
                  ),
                  isTotal: true,
                ),

                if (isCreditCard) ...[
                  const SizedBox(height: 12),
                  _PriceRow(
                    label: '${provider.installments}x installments',
                    value: currencyFormat.format(
                      provider.installmentValue,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'Payment method',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<PaymentOption>(
          initialValue: provider.paymentOption,
          decoration: const InputDecoration(
            labelText: 'Select payment method',
            border: OutlineInputBorder(),
          ),
          items: PaymentOption.values.map((option) {
            return DropdownMenuItem<PaymentOption>(
              value: option,
              child: Text(_paymentOptionLabel(option)),
            );
          }).toList(),
          onChanged: (option) {
            if (option != null) {
              provider.selectPaymentOption(option);
            }
          },
        ),

        const SizedBox(height: 20),

        Text(
          'Installments',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<int>(
          initialValue: provider.installments,
          decoration: const InputDecoration(
            labelText: 'Number of installments',
            border: OutlineInputBorder(),
          ),
          items: provider.availableInstallments.map((installment) {
            return DropdownMenuItem<int>(
              value: installment,
              child: Text(
                '$installment x ${currencyFormat.format(
                  provider.isCreditCard
                      ? provider.creditCardTotal / installment
                      : provider.orderTotal,
                )}',
              ),
            );
          }).toList(),
          onChanged: provider.isCreditCard
              ? (installment) {
            if (installment != null) {
              provider.selectInstallments(installment);
            }
          }
              : null,
        ),

        if (!isCreditCard) ...[
          const SizedBox(height: 8),
          Text(
            'Installments are only available for credit card payments.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],

        const SizedBox(height: 24),

        Text(
          'Payment details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),

        /// Payment details field.
        TextFormField(
          initialValue: provider.paymentDetails,
          minLines: 4,
          maxLines: 4,
          maxLength: 90,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Payment details',
            hintText: 'Enter payment reference or other information',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          onChanged: provider.setPaymentDetails,
        ),

        const SizedBox(height: 20),

        Text(
          'Order details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),

        /// Order details field.
        TextFormField(
          initialValue: provider.orderDetails,
          minLines: 4,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Order details',
            hintText: 'Add notes or additional information about this order',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          onChanged: provider.setOrderDetails,
        ),

        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: !provider.canFinishOrder || provider.isSavingOrder
              ? null
              : () async {
            try {
              await provider.saveOrder();

              if (!context.mounted) return;

              // Return to the listing page and signal success.
              context.pop(true);
            } catch (error) {
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to save order: $error',
                  ),
                ),
              );
            }
          },
          child: provider.isSavingOrder
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : const Text('Finish Order'),
        ),
      ],
    );
  }
}

/// Displays a label and its corresponding price.
class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final textStyle = isTotal
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    )
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: textStyle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: textStyle,
        ),
      ],
    );
  }
}
