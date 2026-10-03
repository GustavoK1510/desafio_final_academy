import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../providers/settings_provider.dart';

/// Page for managing application and store settings.
class SettingsPage extends StatefulWidget {
  /// Class constructor.
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// Manages the state of the settings page.
class _SettingsPageState extends State<SettingsPage> {
  /// Controller for the store name field.
  final _nameController = TextEditingController();

  /// Controller for the company name field.
  final _companyNameController = TextEditingController();

  /// Controller for the CNPJ field.
  final _cnpjController = TextEditingController();

  /// Controller for the street field.
  final _streetController = TextEditingController();

  /// Controller for the number field.
  final _numberController = TextEditingController();

  /// Controller for the city field.
  final _cityController = TextEditingController();

  /// Controller for the state field.
  final _stateController = TextEditingController();

  /// Controller for the ZIP code field.
  final _zipCodeController = TextEditingController();

  /// Prevents the controllers from being initialized multiple times.
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();

    /// Loads the store after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadStore();
    });
  }

  @override
  void dispose() {
    /// Releases all text controllers.
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

  /// Loads saved store data into the text controllers.
  void _initializeControllers(SettingsProvider provider) {
    if (_controllersInitialized || provider.store == null) {
      return;
    }

    final store = provider.store!;

    _nameController.text = store.name;
    _companyNameController.text = store.companyName;
    _cnpjController.text = store.cnpj;
    _streetController.text = store.street;
    _numberController.text = store.number;
    _cityController.text = store.city;
    _stateController.text = store.state;
    _zipCodeController.text = store.zipCode;

    _controllersInitialized = true;
  }

  /// Opens the gallery to select a store logo.
  Future<void> _selectLogo() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null || !mounted) {
      return;
    }

    context.read<SettingsProvider>().selectLogo(
      File(image.path),
    );
  }

  /// Saves the store information.
  Future<void> _save() async {
    final provider = context.read<SettingsProvider>();

    /// Stores whether this operation creates a new store.
    final wasCreating = !provider.hasStore;

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

    if (!mounted) {
      return;
    }

    final message = success
        ? wasCreating
        ? AppLocalizations.of(context)!
        .storeCreatedSuccessfully
        : AppLocalizations.of(context)!
        .settingsSavedSuccessfully
        : provider.errorMessage ??
        AppLocalizations.of(context)!.errorOccurred;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final appSettings = context.watch<AppSettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    /// Initializes fields when saved store data is available.
    _initializeControllers(provider);

    /// Displays a loading indicator while loading the store.
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    /// Uses the selected logo or the saved store logo.
    final logoFile = provider.newLogo ??
        (provider.store != null
            ? File(provider.store!.logoPath)
            : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Store information section.
              _buildStoreSection(
                context,
                logoFile,
                provider.isSaving,
                provider.hasStore,
                l10n,
              ),

              const SizedBox(height: 16),

              /// Language selection section.
              _buildLanguageSection(
                context,
                appSettings,
                l10n,
              ),

              const SizedBox(height: 16),

              /// Appearance settings section.
              _buildAppearanceSection(
                context,
                appSettings,
                l10n,
              ),

              const SizedBox(height: 24),

              /// Button for creating or updating the store.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.isSaving ? null : _save,
                  child: provider.isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                      : Text(
                    provider.hasStore
                        ? l10n.save
                        : l10n.createStore,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the store information section.
  Widget _buildStoreSection(
      BuildContext context,
      File? logoFile,
      bool isSaving,
      bool hasStore,
      AppLocalizations l10n,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Displays the selected or saved store logo.
            GestureDetector(
              onTap: isSaving ? null : _selectLogo,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: logoFile != null
                    ? FileImage(logoFile)
                    : null,
                child: logoFile == null
                    ? const Icon(
                  Icons.store,
                  size: 40,
                )
                    : null,
              ),
            ),

            const SizedBox(height: 8),

            /// Shows instructions for selecting or changing the logo.
            Text(
              hasStore
                  ? l10n.changeLogo
                  : l10n.selectLogo,
            ),

            const SizedBox(height: 16),

            /// Field for the store name.
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.storeName,
              ),
            ),

            /// Field for the company name.
            TextField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: l10n.companyName,
              ),
            ),

            /// Field for the CNPJ.
            TextField(
              controller: _cnpjController,
              decoration: InputDecoration(
                labelText: l10n.cnpj,
              ),
            ),

            /// Field for the street.
            TextField(
              controller: _streetController,
              decoration: InputDecoration(
                labelText: l10n.street,
              ),
            ),

            /// Field for the address number.
            TextField(
              controller: _numberController,
              decoration: InputDecoration(
                labelText: l10n.number,
              ),
            ),

            /// Field for the city.
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: l10n.city,
              ),
            ),

            /// Field for the state.
            TextField(
              controller: _stateController,
              decoration: InputDecoration(
                labelText: l10n.state,
              ),
            ),

            /// Field for the ZIP code.
            TextField(
              controller: _zipCodeController,
              decoration: InputDecoration(
                labelText: l10n.zipCode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the language settings section.
  Widget _buildLanguageSection(
      BuildContext context,
      AppSettingsProvider provider,
      AppLocalizations l10n,
      ) {
    return Card(
      child: ListTile(
        title: Text(l10n.language),
        subtitle: Text(
          provider.locale.languageCode.toUpperCase(),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showLanguageDialog(
          context,
          provider,
          l10n,
        ),
      ),
    );
  }

  /// Builds the appearance settings section.
  Widget _buildAppearanceSection(
      BuildContext context,
      AppSettingsProvider provider,
      AppLocalizations l10n,
      ) {
    return Card(
      child: SwitchListTile(
        title: Text(l10n.darkMode),
        value: provider.isDarkMode,
        onChanged: provider.changeDarkMode,
      ),
    );
  }

  /// Displays the language selection dialog.
  Future<void> _showLanguageDialog(
      BuildContext context,
      AppSettingsProvider provider,
      AppLocalizations l10n,
      ) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(l10n.changeLanguage),
          children: [
            /// Changes the application language to English.
            SimpleDialogOption(
              onPressed: () {
                provider.changeLanguage(
                  const Locale('en'),
                );
                Navigator.pop(context);
              },
              child: Text(
                '🇺🇸 ${l10n.english}',
              ),
            ),

            /// Changes the application language to Portuguese.
            SimpleDialogOption(
              onPressed: () {
                provider.changeLanguage(
                  const Locale('pt'),
                );
                Navigator.pop(context);
              },
              child: Text(
                '🇧🇷 ${l10n.portuguese}',
              ),
            ),

            /// Changes the application language to Spanish.
            SimpleDialogOption(
              onPressed: () {
                provider.changeLanguage(
                  const Locale('es'),
                );
                Navigator.pop(context);
              },
              child: Text(
                '🇪🇸 ${l10n.spanish}',
              ),
            ),
          ],
        );
      },
    );
  }
}