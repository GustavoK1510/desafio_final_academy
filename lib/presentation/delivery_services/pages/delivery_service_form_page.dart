import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';
import '../providers/delivery_service_form_provider.dart';

/// Displays the delivery service creation and editing form.
class DeliveryServiceFormPage extends StatelessWidget {

  /// Class constructor.
  const DeliveryServiceFormPage({
    required this.useCase,
    this.deliveryService,
    super.key,
  });

  /// DeliveryService use case.
  final DeliveryServiceUseCase useCase;

  /// DeliveryService being edited.
  final DeliveryService? deliveryService;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeliveryServiceFormProvider(
        useCase: useCase,
        deliveryService: deliveryService,
      ),
      child: const _DeliveryServiceFormContent(),
    );
  }
}

/// Displays the delivery service form.
class _DeliveryServiceFormContent extends StatelessWidget {

  /// Class constructor.
  const _DeliveryServiceFormContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<DeliveryServiceFormProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.isEditing
              ? l10n.editDeliveryService
              : l10n.addDeliveryService,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: provider.nameController,
                label: l10n.name,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.cnpjController,
                label: l10n.cnpj,
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.companyNameController,
                label: l10n.companyName,
                icon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.phoneController,
                label: l10n.phone,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.emailController,
                label: l10n.email,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.kmCostController,
                label: l10n.costPerKilometer,
                icon: Icons.attach_money_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.minimumPriceController,
                label: l10n.minimumPrice,
                icon: Icons.price_check_outlined,
                keyboardType: TextInputType.number,
              ),
              if (provider.error != null) ...[
                const SizedBox(height: 20),
                Text(
                  _errorMessage(
                    provider.error!,
                    l10n,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: provider.isSaving
                      ? null
                      : () => _save(context),
                  icon: provider.isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    provider.isEditing
                        ? l10n.saveChanges
                        : l10n.createDeliveryService,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  String _errorMessage(
      DeliveryServiceFormError error,
      AppLocalizations l10n,
      ) {
    switch (error) {
      case DeliveryServiceFormError.nameRequired:
        return l10n.pleaseEnterDeliveryServiceName;
      case DeliveryServiceFormError.cnpjRequired:
        return l10n.pleaseEnterCnpj;
      case DeliveryServiceFormError.invalidCnpj:
        return l10n.invalidCnpj;
      case DeliveryServiceFormError.companyNameRequired:
        return l10n.pleaseEnterCompanyName;
      case DeliveryServiceFormError.emailRequired:
        return l10n.pleaseEnterCompanyName;
      case DeliveryServiceFormError.kmCostRequired:
        return l10n.pleaseEnterKmCost;
      case DeliveryServiceFormError.minimumPriceRequired:
        return l10n.pleaseEnterMinimumPrice;
      case DeliveryServiceFormError.saveFailed:
        return l10n.deliveryServiceSaveFailed;
    }
  }

  Future<void> _save(BuildContext context) async {
    final provider = context.read<DeliveryServiceFormProvider>();

    final success = await provider.saveDeliveryService();

    if (!success || !context.mounted) {
      return;
    }

    context.pop(true);
  }
}