import 'package:flutter/material.dart';
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

    return Column(
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
        Expanded(
          child: _buildProductList(context, provider),
        ),
        const Divider(height: 24),
        _buildCart(context, provider),
      ],
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
                  style: Theme.of(context).textTheme.bodyMedium,
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
            const Spacer(),
            Text(
              'Total: ${provider.cartTotal.toStringAsFixed(2)}',
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.cart.length,
              itemBuilder: (context, index) {
                final item = provider.cart[index];

                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.product.name),
                  subtitle: Text(
                    '${item.quantity} × '
                        '${item.product.price.toStringAsFixed(2)}'
                        ' = ${item.subtotal.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    tooltip: 'Remove from cart',
                    onPressed: () {
                      provider.removeFromCart(item.product);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}