import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCode;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @changeLogo.
  ///
  /// In en, this message translates to:
  /// **'Change logo'**
  String get changeLogo;

  /// No description provided for @selectLogo.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a store logo'**
  String get selectLogo;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @addressUpdated.
  ///
  /// In en, this message translates to:
  /// **'Address updated'**
  String get addressUpdated;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get storeName;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get companyName;

  /// No description provided for @cnpj.
  ///
  /// In en, this message translates to:
  /// **'CNPJ'**
  String get cnpj;

  /// No description provided for @createStore.
  ///
  /// In en, this message translates to:
  /// **'Create Store'**
  String get createStore;

  /// No description provided for @storeCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Store created successfully.'**
  String get storeCreatedSuccessfully;

  /// No description provided for @settingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully.'**
  String get settingsSavedSuccessfully;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred.'**
  String get errorOccurred;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @deliveryServices.
  ///
  /// In en, this message translates to:
  /// **'Delivery Services'**
  String get deliveryServices;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @welcomeStore.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeStore(Object name);

  /// No description provided for @whatWouldYouLikeToManage.
  ///
  /// In en, this message translates to:
  /// **'What would you like to manage?'**
  String get whatWouldYouLikeToManage;

  /// No description provided for @seeProducts.
  ///
  /// In en, this message translates to:
  /// **'See Products'**
  String get seeProducts;

  /// No description provided for @seeClients.
  ///
  /// In en, this message translates to:
  /// **'See Clients'**
  String get seeClients;

  /// No description provided for @seeDeliveryServices.
  ///
  /// In en, this message translates to:
  /// **'See Delivery Services'**
  String get seeDeliveryServices;

  /// No description provided for @seeOrders.
  ///
  /// In en, this message translates to:
  /// **'See Orders'**
  String get seeOrders;

  /// No description provided for @manageProducts.
  ///
  /// In en, this message translates to:
  /// **'Manage your products'**
  String get manageProducts;

  /// No description provided for @manageClients.
  ///
  /// In en, this message translates to:
  /// **'Manage your clients'**
  String get manageClients;

  /// No description provided for @manageDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Manage deliveries'**
  String get manageDeliveries;

  /// No description provided for @manageOrders.
  ///
  /// In en, this message translates to:
  /// **'Manage your orders'**
  String get manageOrders;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProduct;

  /// No description provided for @createProduct.
  ///
  /// In en, this message translates to:
  /// **'Create product'**
  String get createProduct;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete product?'**
  String get deleteProduct;

  /// No description provided for @deleteProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteProductConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product deleted.'**
  String get productDeleted;

  /// No description provided for @noProductsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No products registered yet.'**
  String get noProductsRegistered;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @productImages.
  ///
  /// In en, this message translates to:
  /// **'Product images'**
  String get productImages;

  /// No description provided for @addImages.
  ///
  /// In en, this message translates to:
  /// **'Add images'**
  String get addImages;

  /// No description provided for @addProductImages.
  ///
  /// In en, this message translates to:
  /// **'Add product images'**
  String get addProductImages;

  /// No description provided for @generateBarcode.
  ///
  /// In en, this message translates to:
  /// **'Generate barcode'**
  String get generateBarcode;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @pleaseEnterProductName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a product name.'**
  String get pleaseEnterProductName;

  /// No description provided for @pleaseEnterProductBrand.
  ///
  /// In en, this message translates to:
  /// **'Please enter a product brand.'**
  String get pleaseEnterProductBrand;

  /// No description provided for @pleaseEnterBarcode.
  ///
  /// In en, this message translates to:
  /// **'Please enter or generate a barcode.'**
  String get pleaseEnterBarcode;

  /// No description provided for @pleaseEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price.'**
  String get pleaseEnterValidPrice;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'Business type'**
  String get businessType;

  /// No description provided for @businessTypeSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get businessTypeSchool;

  /// No description provided for @businessTypeGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get businessTypeGym;

  /// No description provided for @businessTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get businessTypeOther;

  /// No description provided for @pleaseSelectBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Please select a business type.'**
  String get pleaseSelectBusinessType;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add client'**
  String get addClient;

  /// No description provided for @editClient.
  ///
  /// In en, this message translates to:
  /// **'Edit client'**
  String get editClient;

  /// No description provided for @createClient.
  ///
  /// In en, this message translates to:
  /// **'Create client'**
  String get createClient;

  /// No description provided for @deleteClient.
  ///
  /// In en, this message translates to:
  /// **'Delete client'**
  String get deleteClient;

  /// No description provided for @deleteClientConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteClientConfirmation;

  /// No description provided for @clientDeleted.
  ///
  /// In en, this message translates to:
  /// **'Client deleted.'**
  String get clientDeleted;

  /// No description provided for @noClientsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No clients registered yet.'**
  String get noClientsRegistered;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @cep.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get cep;

  /// No description provided for @pleaseEnterClientName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a client name.'**
  String get pleaseEnterClientName;

  /// No description provided for @pleaseEnterCnpj.
  ///
  /// In en, this message translates to:
  /// **'Please enter a CNPJ.'**
  String get pleaseEnterCnpj;

  /// No description provided for @invalidCnpj.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid CNPJ.'**
  String get invalidCnpj;

  /// No description provided for @pleaseEnterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a company name.'**
  String get pleaseEnterCompanyName;

  /// No description provided for @pleaseEnterCep.
  ///
  /// In en, this message translates to:
  /// **'Please enter a ZIP code.'**
  String get pleaseEnterCep;

  /// No description provided for @invalidCep.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid ZIP code.'**
  String get invalidCep;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter an address.'**
  String get pleaseEnterAddress;

  /// No description provided for @pleaseEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a number.'**
  String get pleaseEnterNumber;

  /// No description provided for @pleaseEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter a city.'**
  String get pleaseEnterCity;

  /// No description provided for @pleaseEnterState.
  ///
  /// In en, this message translates to:
  /// **'Please enter a state.'**
  String get pleaseEnterState;

  /// No description provided for @clientSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save the client.'**
  String get clientSaveFailed;

  /// No description provided for @costPerKilometer.
  ///
  /// In en, this message translates to:
  /// **'Cost Per Kilometer'**
  String get costPerKilometer;

  /// No description provided for @minimumPrice.
  ///
  /// In en, this message translates to:
  /// **'Minimum Delivery Price'**
  String get minimumPrice;

  /// No description provided for @pleaseEnterDeliveryServiceName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a delivery service name.'**
  String get pleaseEnterDeliveryServiceName;

  /// No description provided for @pleaseEnterKmCost.
  ///
  /// In en, this message translates to:
  /// **'Please enter a cost per kilometer.'**
  String get pleaseEnterKmCost;

  /// No description provided for @pleaseEnterMinimumPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a minimum delivery price.'**
  String get pleaseEnterMinimumPrice;

  /// No description provided for @noDeliveryServicesRegistered.
  ///
  /// In en, this message translates to:
  /// **'No delivery services registered yet.'**
  String get noDeliveryServicesRegistered;

  /// No description provided for @deleteDeliveryService.
  ///
  /// In en, this message translates to:
  /// **'Delete Delivery Service'**
  String get deleteDeliveryService;

  /// No description provided for @deleteDeliveryServiceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteDeliveryServiceConfirmation;

  /// No description provided for @deliveryServiceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Delivery Service deleted.'**
  String get deliveryServiceDeleted;

  /// No description provided for @addDeliveryService.
  ///
  /// In en, this message translates to:
  /// **'Add delivery service'**
  String get addDeliveryService;

  /// No description provided for @editDeliveryService.
  ///
  /// In en, this message translates to:
  /// **'Edit delivery service'**
  String get editDeliveryService;

  /// No description provided for @createDeliveryService.
  ///
  /// In en, this message translates to:
  /// **'Create delivery service'**
  String get createDeliveryService;

  /// No description provided for @deliveryService.
  ///
  /// In en, this message translates to:
  /// **'Delivery Services'**
  String get deliveryService;

  /// No description provided for @deliveryServiceSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save the delivery service.'**
  String get deliveryServiceSaveFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
