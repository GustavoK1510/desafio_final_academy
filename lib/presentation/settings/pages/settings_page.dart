import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../providers/settings_provider.dart';

/// Displays and manages store settings.
class SettingsPage extends StatefulWidget {

  /// Creates the settings page.
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  final _imagePicker = ImagePicker();

  bool _controllersInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _companyNameController.dispose();
    _cnpjController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  /// Loads saved store values into the form.
  void _initializeControllers(SettingsProvider provider) {
    if (_controllersInitialized || provider.isLoading) return;

    final store = provider.store;

    if (store != null) {
      _nameController.text = store.name;
      _companyNameController.text = store.companyName;
      _cnpjController.text = store.cnpj;
      _streetController.text = store.street;
      _numberController.text = store.number;
      _cityController.text = store.city;
      _stateController.text = store.state;
      _zipCodeController.text = store.zipCode;
    }

    _controllersInitialized = true;
  }

  Future<void> _selectLogo() async {
    final provider = context.read<SettingsProvider>();

    if (!provider.isEditing || provider.isSaving) return;

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (!mounted || image == null) return;

    provider.selectLogo(File(image.path));
  }

  Future<void> _verifyCnpj() async {
    final provider = context.read<SettingsProvider>();
    final isValid = provider.verifyCnpj(_cnpjController.text.trim());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isValid
              ? 'CNPJ is valid.'
              : 'Invalid CNPJ. Check the number and try again.',
        ),
      ),
    );
  }

  Future<void> _verifyCep() async {
    final provider = context.read<SettingsProvider>();

    final result = await provider.verifyCep(
      _zipCodeController.text.trim(),
    );

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Could not verify the CEP.',
          ),
        ),
      );
      return;
    }

    _streetController.text = result['street'] ?? '';
    _cityController.text = result['city'] ?? '';
    _stateController.text = result['state'] ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CEP verified successfully.'),
      ),
    );
  }

  Future<void> _save() async {
    final provider = context.read<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (!provider.verifyCnpj(_cnpjController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid CNPJ. Check the number and try again.'),
        ),
      );
      return;
    }

    final success = await provider.saveStore(
      name: _nameController.text,
      companyName: _companyNameController.text,
      cnpj: _cnpjController.text,
      street: _streetController.text,
      number: _numberController.text,
      city: _cityController.text,
      state: _stateController.text,
      zipCode: _zipCodeController.text,
    );

    if (!mounted) return;

    final message = success
        ? provider.hasStore
        ? l10n.settingsSavedSuccessfully
        : l10n.storeCreatedSuccessfully
        : provider.errorMessage ?? l10n.errorOccurred;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _cancelEditing() {
    final provider = context.read<SettingsProvider>();
    provider.cancelEditing();

    final store = provider.store;

    if (store == null) return;

    _nameController.text = store.name;
    _companyNameController.text = store.companyName;
    _cnpjController.text = store.cnpj;
    _streetController.text = store.street;
    _numberController.text = store.number;
    _cityController.text = store.city;
    _stateController.text = store.state;
    _zipCodeController.text = store.zipCode;
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLogoSection(
      SettingsProvider provider,
      bool canEdit,
      AppLocalizations l10n,
      ) {
    final store = provider.store;
    final selectedLogo = provider.newLogo;

    ImageProvider? imageProvider;

    if (selectedLogo != null) {
      imageProvider = FileImage(selectedLogo);
    } else if (store != null && store.logoPath.isNotEmpty) {
      imageProvider = FileImage(File(store.logoPath));
    }

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: canEdit ? _selectLogo : null,
            child: CircleAvatar(
              radius: 48,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? const Icon(Icons.store, size: 42)
                  : null,
            ),
          ),
          if (canEdit)
            TextButton.icon(
              onPressed: provider.isSaving ? null : _selectLogo,
              icon: const Icon(Icons.image_outlined),
              label: Text(l10n.changeLogo),
            ),
        ],
      ),
    );
  }

  Widget _buildCnpjField(
      SettingsProvider provider,
      bool canEdit,
      AppLocalizations l10n,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          label: l10n.cnpj,
          controller: _cnpjController,
          enabled: canEdit && !provider.isSaving,
          keyboardType: TextInputType.number,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: canEdit && !provider.isSaving
                ? _verifyCnpj
                : null,
            icon: const Icon(Icons.verified_outlined),
            label: const Text('Verify CNPJ'),
          ),
        ),
      ],
    );
  }

  Widget _buildCepField(
      SettingsProvider provider,
      bool canEdit,
      AppLocalizations l10n,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          label: l10n.zipCode,
          controller: _zipCodeController,
          enabled: canEdit &&
              !provider.isSaving &&
              !provider.isVerifyingCep,
          keyboardType: TextInputType.number,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: canEdit &&
                !provider.isSaving &&
                !provider.isVerifyingCep
                ? _verifyCep
                : null,
            icon: provider.isVerifyingCep
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.location_searching),
            label: Text(
              provider.isVerifyingCep ? 'Verifying...' : 'Verify CEP',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreSection(
      SettingsProvider provider,
      AppLocalizations l10n,
      ) {
    final canEdit = !provider.hasStore || provider.isEditing;
    final fieldsEnabled = canEdit && !provider.isSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLogoSection(provider, canEdit, l10n),
        const SizedBox(height: 24),
        _buildField(
          label: l10n.storeName,
          controller: _nameController,
          enabled: fieldsEnabled,
        ),
        const SizedBox(height: 16),
        _buildField(
          label: l10n.companyName,
          controller: _companyNameController,
          enabled: fieldsEnabled,
        ),
        const SizedBox(height: 16),
        _buildCnpjField(provider, canEdit, l10n),
        _buildField(
          label: l10n.street,
          controller: _streetController,
          enabled: fieldsEnabled,
        ),
        const SizedBox(height: 16),
        _buildField(
          label: l10n.number,
          controller: _numberController,
          enabled: fieldsEnabled,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildField(
          label: l10n.city,
          controller: _cityController,
          enabled: fieldsEnabled,
        ),
        const SizedBox(height: 16),
        _buildField(
          label: l10n.state,
          controller: _stateController,
          enabled: fieldsEnabled,
        ),
        const SizedBox(height: 16),
        _buildCepField(provider, canEdit, l10n),
      ],
    );
  }

  Widget _buildActionButtons(
      SettingsProvider provider,
      AppLocalizations l10n,
      ) {
    if (provider.hasStore && !provider.isEditing) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: provider.isSaving ? null : provider.startEditing,
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: provider.isSaving ? null : _save,
          child: provider.isSaving
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(
            provider.hasStore ? l10n.save : l10n.createStore,
          ),
        ),
        if (provider.hasStore) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: provider.isSaving ? null : _cancelEditing,
            child: const Text('Cancel'),
          ),
        ],
      ],
    );
  }

  Future<void> _showLanguageDialog(
      BuildContext context,
      AppSettingsProvider settings,
      AppLocalizations l10n,
      ) async {
    final selectedLocale = await showDialog<Locale>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(l10n.changeLanguage),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, const Locale('en', 'US'));
              },
              child: Text(l10n.english),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, const Locale('pt', 'BR'));
              },
              child: Text(l10n.portuguese),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, const Locale('es', 'ES'));
              },
              child: Text(l10n.spanish),
            ),
          ],
        );
      },
    );

    if (selectedLocale != null) {
      await settings.changeLanguage(selectedLocale);
    }
  }

  Widget _buildPreferencesSection(
      AppSettingsProvider settings,
      AppLocalizations l10n,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.language),
          trailing: const Icon(Icons.language),
          onTap: () => _showLanguageDialog(
            context,
            settings,
            l10n,
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.darkMode),
          value: settings.isDarkMode,
          onChanged: (value) {
            settings.changeDarkMode(value: value);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final settings = context.watch<AppSettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    _initializeControllers(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStoreSection(provider, l10n),
            const SizedBox(height: 24),
            _buildActionButtons(provider, l10n),
            const SizedBox(height: 32),
            const Divider(),
            _buildPreferencesSection(settings, l10n),
          ],
        ),
      ),
    );
  }
}