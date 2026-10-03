import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../features/clients/domain/entities/client.dart';
import '../../../features/clients/domain/enums/business_type.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';
import '../providers/client_form_provider.dart';

/// Displays the client creation and editing form.
class ClientFormPage extends StatelessWidget {

  /// Class constructor.
  const ClientFormPage({
    required this.useCase,
    this.client,
    super.key,
  });

  /// Client use case.
  final UseCaseClient useCase;

  /// Client being edited.
  final Client? client;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientFormProvider(
        useCase: useCase,
        client: client,
      ),
      child: const _ClientFormContent(),
    );
  }
}

/// Displays the client form.
class _ClientFormContent extends StatelessWidget {

  /// Class constructor.
  const _ClientFormContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ClientFormProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.isEditing
              ? l10n.editClient
              : l10n.addClient,
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
              _buildCepField(
                context,
                provider,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.streetController,
                label: l10n.street,
                icon: Icons.location_on_outlined,
                enabled: provider.addressLoaded,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.numberController,
                label: l10n.number,
                icon: Icons.numbers_outlined,
                enabled: provider.addressLoaded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.cityController,
                label: l10n.city,
                icon: Icons.location_city_outlined,
                enabled: provider.addressLoaded,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: provider.stateController,
                label: l10n.state,
                icon: Icons.map_outlined,
                enabled: provider.addressLoaded,
              ),
              const SizedBox(height: 16),
              _buildBusinessTypeField(
                context,
                provider,
              ),
              if (provider.isLoadingCep) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
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
                        : l10n.createClient,
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

  Widget _buildCepField(
      BuildContext context,
      ClientFormProvider provider,
      ) {
    final l10n = AppLocalizations.of(context)!;

    return TextField(
      controller: provider.cepController,
      keyboardType: TextInputType.number,
      maxLength: 8,
      decoration: InputDecoration(
        labelText: l10n.cep,
        prefixIcon: const Icon(
          Icons.local_post_office_outlined,
        ),
        border: const OutlineInputBorder(),
        counterText: '',
      ),
      onChanged: provider.onCepChanged,
    );
  }

  Widget _buildBusinessTypeField(
      BuildContext context,
      ClientFormProvider provider,
      ) {
    final l10n = AppLocalizations.of(context)!;

    return DropdownButtonFormField<BusinessType>(
      initialValue: provider.businessType,
      decoration: InputDecoration(
        labelText: l10n.businessType,
        prefixIcon: const Icon(
          Icons.category_outlined,
        ),
        border: const OutlineInputBorder(),
      ),
      items: BusinessType.values.map((type) {
        return DropdownMenuItem<BusinessType>(
          value: type,
          child: Text(
            _businessTypeName(
              type,
              l10n,
            ),
          ),
        );
      }).toList(),
      onChanged: provider.setBusinessType,
    );
  }

  String _businessTypeName(
      BusinessType type,
      AppLocalizations l10n,
      ) {
    switch (type) {
      case BusinessType.school:
        return l10n.businessTypeSchool;
      case BusinessType.gym:
        return l10n.businessTypeGym;
      case BusinessType.other:
        return l10n.businessTypeOther;
    }
  }

  String _errorMessage(
      ClientFormError error,
      AppLocalizations l10n,
      ) {
    switch (error) {
      case ClientFormError.nameRequired:
        return l10n.pleaseEnterClientName;
      case ClientFormError.cnpjRequired:
        return l10n.pleaseEnterCnpj;
      case ClientFormError.invalidCnpj:
        return l10n.invalidCnpj;
      case ClientFormError.companyNameRequired:
        return l10n.pleaseEnterCompanyName;
      case ClientFormError.cepRequired:
        return l10n.pleaseEnterCep;
      case ClientFormError.invalidCep:
        return l10n.invalidCep;
      case ClientFormError.addressRequired:
        return l10n.pleaseEnterAddress;
      case ClientFormError.numberRequired:
        return l10n.pleaseEnterNumber;
      case ClientFormError.cityRequired:
        return l10n.pleaseEnterCity;
      case ClientFormError.stateRequired:
        return l10n.pleaseEnterState;
      case ClientFormError.businessTypeRequired:
        return l10n.pleaseSelectBusinessType;
      case ClientFormError.saveFailed:
        return l10n.clientSaveFailed;
    }
  }

  Future<void> _save(BuildContext context) async {
    final provider = context.read<ClientFormProvider>();

    final businessType = provider.businessType;

    if (businessType == null) {
      return;
    }

    final success = await provider.saveClient(
      businessType: businessType,
    );

    if (!success || !context.mounted) {
      return;
    }

    context.pop(true);
  }
}