import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../features/store/domain/entities/store.dart';
import '../../../ui/components/menu_card.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/home_page_provider.dart';

/// Home page for navigating through the application.
class HomePage extends StatelessWidget {
  /// Creates the home page.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageProvider(),
      child: const _HomePageContent(),
    );
  }
}

/// Displays the home page content.
class _HomePageContent extends StatelessWidget {
  /// Creates the home page content.
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;
    final store = settingsProvider.store;

    final logoFile = store != null &&
        store.logoPath.isNotEmpty &&
        File(store.logoPath).existsSync()
        ? File(store.logoPath)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(store?.name ?? 'SportZone'),
        centerTitle: true,
      ),
      drawer: _buildDrawer(
        context,
        store,
        logoFile,
        l10n,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store != null
                    ? l10n.welcomeStore(store.name)
                    : l10n.welcome,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.whatWouldYouLikeToManage,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 170,
                  children: [
                    menuCard(
                      context,
                      id: 'products',
                      icon: Icons.inventory_2_outlined,
                      title: l10n.seeProducts,
                      subtitle: l10n.manageProducts,
                      onTap: () => context.push('/products'),
                    ),
                    menuCard(
                      context,
                      id: 'clients',
                      icon: Icons.people_outline,
                      title: l10n.seeClients,
                      subtitle: l10n.manageClients,
                      onTap: () => context.push('/clients'),
                    ),
                    menuCard(
                      context,
                      id: 'delivery',
                      icon: Icons.local_shipping_outlined,
                      title: l10n.seeDeliveryServices,
                      subtitle: l10n.manageDeliveries,
                      onTap: () =>
                          context.push('/delivery-services'),
                    ),
                    menuCard(
                      context,
                      id: 'orders',
                      icon: Icons.receipt_long_outlined,
                      title: l10n.seeOrders,
                      subtitle: l10n.manageOrders,
                      onTap: () => context.push('/orders'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the application navigation drawer.
  Widget _buildDrawer(
      BuildContext context,
      Store? store,
      File? logoFile,
      AppLocalizations l10n,
      ) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: logoFile != null
                    ? FileImage(logoFile)
                    : null,
                child: logoFile == null
                    ? Icon(
                  Icons.store,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                )
                    : null,
              ),
              accountName: Text(
                store?.name ?? 'SportZone',
                style: const TextStyle(color: Colors.black),
              ),
              accountEmail: Text(
                store?.companyName ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(l10n.products),
              onTap: () => _navigateFromDrawer(
                context,
                '/products',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: Text(l10n.clients),
              onTap: () => _navigateFromDrawer(
                context,
                '/clients',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping_outlined),
              title: Text(l10n.deliveryServices),
              onTap: () => _navigateFromDrawer(
                context,
                '/delivery-services',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(l10n.orders),
              onTap: () => _navigateFromDrawer(
                context,
                '/orders',
              ),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.settings),
              onTap: () => _navigateFromDrawer(
                context,
                '/settings',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Closes the drawer before navigating to another page.
  void _navigateFromDrawer(
      BuildContext context,
      String route,
      ) {
    Navigator.of(context).pop();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.push(route);
      }
    });
  }
}