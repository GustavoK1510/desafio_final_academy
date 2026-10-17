// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get store => 'Store';

  @override
  String get address => 'Address';

  @override
  String get street => 'Street';

  @override
  String get number => 'Number';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get zipCode => 'ZIP Code';

  @override
  String get save => 'Save';

  @override
  String get changeLogo => 'Change logo';

  @override
  String get selectLogo => 'Tap to select a store logo';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get cancel => 'Cancel';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get addressUpdated => 'Address updated';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get storeName => 'Store name';

  @override
  String get companyName => 'Company name';

  @override
  String get cnpj => 'CNPJ';

  @override
  String get createStore => 'Create Store';

  @override
  String get storeCreatedSuccessfully => 'Store created successfully.';

  @override
  String get settingsSavedSuccessfully => 'Settings saved successfully.';

  @override
  String get errorOccurred => 'An error occurred.';

  @override
  String get products => 'Products';

  @override
  String get clients => 'Clients';

  @override
  String get deliveryServices => 'Delivery Services';

  @override
  String get orders => 'Orders';

  @override
  String get welcome => 'Welcome!';

  @override
  String welcomeStore(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get whatWouldYouLikeToManage => 'What would you like to manage?';

  @override
  String get seeProducts => 'See Products';

  @override
  String get seeClients => 'See Clients';

  @override
  String get seeDeliveryServices => 'See Delivery Services';

  @override
  String get seeOrders => 'See Orders';

  @override
  String get manageProducts => 'Manage your products';

  @override
  String get manageClients => 'Manage your clients';

  @override
  String get manageDeliveries => 'Manage deliveries';

  @override
  String get manageOrders => 'Manage your orders';

  @override
  String get addProduct => 'Add product';

  @override
  String get editProduct => 'Edit product';

  @override
  String get createProduct => 'Create product';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get deleteProduct => 'Delete product?';

  @override
  String get deleteProductConfirmation => 'This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get productDeleted => 'Product deleted.';

  @override
  String get noProductsRegistered => 'No products registered yet.';

  @override
  String get name => 'Name';

  @override
  String get brand => 'Brand';

  @override
  String get barcode => 'Barcode';

  @override
  String get price => 'Price';

  @override
  String get description => 'Description';

  @override
  String get productImages => 'Product images';

  @override
  String get addImages => 'Add images';

  @override
  String get addProductImages => 'Add product images';

  @override
  String get generateBarcode => 'Generate barcode';

  @override
  String get edit => 'Edit';

  @override
  String get pleaseEnterProductName => 'Please enter a product name.';

  @override
  String get pleaseEnterProductBrand => 'Please enter a product brand.';

  @override
  String get pleaseEnterBarcode => 'Please enter or generate a barcode.';

  @override
  String get pleaseEnterValidPrice => 'Please enter a valid price.';

  @override
  String get businessType => 'Business type';

  @override
  String get businessTypeSchool => 'School';

  @override
  String get businessTypeGym => 'Gym';

  @override
  String get businessTypeOther => 'Other';

  @override
  String get pleaseSelectBusinessType => 'Please select a business type.';

  @override
  String get addClient => 'Add client';

  @override
  String get editClient => 'Edit client';

  @override
  String get createClient => 'Create client';

  @override
  String get deleteClient => 'Delete client';

  @override
  String get deleteClientConfirmation => 'This action cannot be undone.';

  @override
  String get clientDeleted => 'Client deleted.';

  @override
  String get noClientsRegistered => 'No clients registered yet.';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get cep => 'ZIP Code';

  @override
  String get pleaseEnterClientName => 'Please enter a client name.';

  @override
  String get pleaseEnterCnpj => 'Please enter a CNPJ.';

  @override
  String get invalidCnpj => 'Please enter a valid CNPJ.';

  @override
  String get pleaseEnterCompanyName => 'Please enter a company name.';

  @override
  String get pleaseEnterCep => 'Please enter a ZIP code.';

  @override
  String get invalidCep => 'Please enter a valid ZIP code.';

  @override
  String get pleaseEnterAddress => 'Please enter an address.';

  @override
  String get pleaseEnterNumber => 'Please enter a number.';

  @override
  String get pleaseEnterCity => 'Please enter a city.';

  @override
  String get pleaseEnterState => 'Please enter a state.';

  @override
  String get clientSaveFailed => 'Failed to save the client.';

  @override
  String get costPerKilometer => 'Cost Per Kilometer';

  @override
  String get minimumPrice => 'Minimum Delivery Price';

  @override
  String get pleaseEnterDeliveryServiceName =>
      'Please enter a delivery service name.';

  @override
  String get pleaseEnterKmCost => 'Please enter a cost per kilometer.';

  @override
  String get pleaseEnterMinimumPrice =>
      'Please enter a minimum delivery price.';

  @override
  String get noDeliveryServicesRegistered =>
      'No delivery services registered yet.';

  @override
  String get deleteDeliveryService => 'Delete Delivery Service';

  @override
  String get deleteDeliveryServiceConfirmation =>
      'This action cannot be undone.';

  @override
  String get deliveryServiceDeleted => 'Delivery Service deleted.';

  @override
  String get addDeliveryService => 'Add delivery service';

  @override
  String get editDeliveryService => 'Edit delivery service';

  @override
  String get createDeliveryService => 'Create delivery service';

  @override
  String get deliveryService => 'Delivery Services';

  @override
  String get deliveryServiceSaveFailed =>
      'Failed to save the delivery service.';

  @override
  String get selectAClient => 'Select a client';

  @override
  String get searchByClientNameCNPJToContinue =>
      'Search by client name or CNPJ to continue.';

  @override
  String get searchClients => 'Search clients';

  @override
  String get enterNameOrCNPJ => 'Enter a name or CNPJ';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get selectedClient => 'Selected client';

  @override
  String get noMatchingClientsFound => 'No matching clients found.';

  @override
  String get searchProducts => 'Search products';

  @override
  String get enterAProductName => 'Enter a product name';

  @override
  String get registeredProducts => 'Registered products';

  @override
  String get couldNotLoadProducts => 'Could not load products.';

  @override
  String get noProductsRegisteredYet => 'No products registered yet.';

  @override
  String get noProductsFound => 'No products found.';

  @override
  String get quantity => 'Quantity';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String get increaseQuantity => 'Increase quantity';

  @override
  String get add => 'Add';

  @override
  String cartItems(Object quantity) {
    return 'Cart ($quantity items)';
  }

  @override
  String get addAtLeastOneProduct => 'Add at least one product to continue.';

  @override
  String get removeFromCart => 'Remove from cart';

  @override
  String get selectDeliveryService => 'Select a delivery service';

  @override
  String get searchByDSNameCNPJToContinue =>
      'Search by delivery service name or CNPJ to continue.';

  @override
  String get searchDeliveryServices => 'Search delivery services';

  @override
  String get search => 'Search';

  @override
  String get selectedDeliveryService => 'Selected delivery service';

  @override
  String get totalDeliveryPrice => 'Total delivery price';

  @override
  String get createOrder => 'Create order';

  @override
  String get review => 'Review';

  @override
  String get finishOrder => 'Finish order';

  @override
  String get next => 'Continue';

  @override
  String get noMatchingDeliveryServicesFound =>
      'No matching delivery services found.';
}
