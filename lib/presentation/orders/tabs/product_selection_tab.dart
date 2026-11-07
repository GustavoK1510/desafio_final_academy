import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/order_form_provider.dart';

/// Displays product selection and the order cart.
class ProductSelectionTab extends StatelessWidget {
  /// Creates the product selection tab.
  const ProductSelectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderFormProvider>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: provider.searchProducts,
            decoration: InputDecoration(
              labelText: 'Search products',
              hintText: 'Enter a product name',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: provider.productSearchQuery.isNotEmpty
                  ? IconButton(
                onPressed: () => provider.searchProducts(''),
                icon: const Icon(Icons.clear),
              )
                  : null,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Registered products',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildProductList(context, provider),
          const Divider(height: 24),
          _buildCart(context, provider),
        ],
      ),
    );
  }

  Widget _buildProductList(
      BuildContext context,
      OrderFormProvider provider,
      ) {
    if (provider.isLoadingProducts) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.productErrorMessage != null) {
      return Center(
        child: Text(
          'Could not load products.\n'
              '${provider.productErrorMessage}',
          textAlign: TextAlign.center,
        ),
      );
    }

    final products = provider.filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Text(
          provider.productSearchQuery.isEmpty
              ? 'No products registered yet.'
              : 'No products found.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = products[index];
        final quantity = provider.selectedQuantity(product);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(product.brand),
                const SizedBox(height: 4),
                Text(
                  'Price: ${product.price.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Quantity'),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Decrease quantity',
                      onPressed: quantity > 1
                          ? () => provider.setSelectedQuantity(
                        product,
                        quantity - 1,
                      )
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$quantity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      tooltip: 'Increase quantity',
                      onPressed: () => provider.setSelectedQuantity(
                        product,
                        quantity + 1,
                      ),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => provider.addToCart(product),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCart(
      BuildContext context,
      OrderFormProvider provider,
      ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.shopping_cart_outlined),
            const SizedBox(width: 8),
            Text(
              'Cart (${provider.totalCartQuantity} items)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (provider.cart.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Add at least one product to continue.'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.cart.length,
            itemBuilder: (context, index) {
              final item = provider.cart[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.product.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove from cart',
                            onPressed: () {
                              provider.removeFromCart(item.product);
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                      Text(
                        '${item.quantity} × '
                            '${item.product.price.toStringAsFixed(2)}'
                            ' = ${item.subtotal.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Discount (%)'),
                          ),
                          SizedBox(
                            width: 110,
                            child: TextFormField(
                              key: ValueKey(
                                'discount-${item.product.barcode}',
                              ),
                              initialValue: item.discountPercentage == 0
                                  ? ''
                                  : item.discountPercentage.toStringAsFixed(2),
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d{0,3}[,.]?\d{0,2}'),
                                ),
                              ],
                              textAlign: TextAlign.end,
                              decoration: const InputDecoration(
                                hintText: '0–100',
                                suffixText: '%',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                final percentage = double.tryParse(
                                  value.replaceAll(',', '.'),
                                ) ?? 0;

                                provider.setProductDiscount(
                                  item.product,
                                  percentage,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount: '
                                '${item.discountAmount.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            item.discountedSubtotal.toStringAsFixed(2),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        if (provider.cart.isNotEmpty) ...[
          const Divider(height: 16),
          _buildTotalRow(
            'Subtotal',
            provider.cartSubtotal,
          ),
          _buildTotalRow(
            'Discounts',
            -provider.cartDiscountTotal,
          ),
          _buildTotalRow(
            'Total',
            provider.cartTotal,
            isTotal: true,
          ),
        ],
      ],
    );
  }

  Widget _buildTotalRow(
      String label,
      double value, {
        bool isTotal = false,
      }) {
    final style = isTotal
        ? const TextStyle(fontWeight: FontWeight.bold)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value.toStringAsFixed(2), style: style),
        ],
      ),
    );
  }
}