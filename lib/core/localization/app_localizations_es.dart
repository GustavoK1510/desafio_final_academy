// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Configuración';

  @override
  String get store => 'Tienda';

  @override
  String get address => 'Dirección';

  @override
  String get street => 'Calle';

  @override
  String get number => 'Número';

  @override
  String get city => 'Ciudad';

  @override
  String get state => 'Estado';

  @override
  String get zipCode => 'Código postal';

  @override
  String get save => 'Guardar';

  @override
  String get changeLogo => 'Cambiar logo';

  @override
  String get selectLogo => 'Toca para seleccionar el logo de la tienda';

  @override
  String get language => 'Idioma';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get cancel => 'Cancelar';

  @override
  String get portuguese => 'Portugués';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String get addressUpdated => 'Dirección actualizada';

  @override
  String get settingsSaved => 'Configuración guardada';

  @override
  String get storeName => 'Nombre de la tienda';

  @override
  String get companyName => 'Razón social';

  @override
  String get cnpj => 'CNPJ';

  @override
  String get createStore => 'Crear tienda';

  @override
  String get storeCreatedSuccessfully => 'Tienda creada correctamente.';

  @override
  String get settingsSavedSuccessfully =>
      'Configuración guardada correctamente.';

  @override
  String get errorOccurred => 'Ocurrió un error.';

  @override
  String get products => 'Productos';

  @override
  String get clients => 'Clientes';

  @override
  String get deliveryServices => 'Servicios de entrega';

  @override
  String get orders => 'Pedidos';

  @override
  String get welcome => '¡Bienvenido!';

  @override
  String welcomeStore(Object name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String get whatWouldYouLikeToManage => '¿Qué te gustaría administrar?';

  @override
  String get seeProducts => 'Ver productos';

  @override
  String get seeClients => 'Ver clientes';

  @override
  String get seeDeliveryServices => 'Ver servicios de entrega';

  @override
  String get seeOrders => 'Ver pedidos';

  @override
  String get manageProducts => 'Administra tus productos';

  @override
  String get manageClients => 'Administra tus clientes';

  @override
  String get manageDeliveries => 'Administra tus entregas';

  @override
  String get manageOrders => 'Administra tus pedidos';

  @override
  String get addProduct => 'Añadir producto';

  @override
  String get editProduct => 'Editar producto';

  @override
  String get createProduct => 'Crear producto';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get deleteProduct => '¿Eliminar producto?';

  @override
  String get deleteProductConfirmation => 'Esta acción no se puede deshacer.';

  @override
  String get delete => 'Eliminar';

  @override
  String get productDeleted => 'Producto eliminado.';

  @override
  String get noProductsRegistered => 'Aún no hay productos registrados.';

  @override
  String get name => 'Nombre';

  @override
  String get brand => 'Marca';

  @override
  String get barcode => 'Código de barras';

  @override
  String get price => 'Precio';

  @override
  String get description => 'Descripción';

  @override
  String get productImages => 'Imágenes del producto';

  @override
  String get addImages => 'Añadir imágenes';

  @override
  String get addProductImages => 'Añadir imágenes del producto';

  @override
  String get generateBarcode => 'Generar código de barras';

  @override
  String get edit => 'Editar';

  @override
  String get pleaseEnterProductName => 'Introduce el nombre del producto.';

  @override
  String get pleaseEnterProductBrand => 'Introduce la marca del producto.';

  @override
  String get pleaseEnterBarcode => 'Introduce o genera un código de barras.';

  @override
  String get pleaseEnterValidPrice => 'Introduce un precio válido.';

  @override
  String get businessType => 'Tipo de negocio';

  @override
  String get businessTypeSchool => 'Escuela';

  @override
  String get businessTypeGym => 'Gimnasio';

  @override
  String get businessTypeOther => 'Otro';

  @override
  String get pleaseSelectBusinessType => 'Selecciona un tipo de negocio.';

  @override
  String get addClient => 'Agregar cliente';

  @override
  String get editClient => 'Editar cliente';

  @override
  String get createClient => 'Crear cliente';

  @override
  String get deleteClient => 'Eliminar cliente';

  @override
  String get deleteClientConfirmation => 'Esta acción no se puede deshacer.';

  @override
  String get clientDeleted => 'Cliente eliminado.';

  @override
  String get noClientsRegistered => 'No hay clientes registrados todavía.';

  @override
  String get phone => 'Teléfono';

  @override
  String get email => 'E-mail';

  @override
  String get cep => 'Código postal';

  @override
  String get pleaseEnterClientName => 'Introduce el nombre del cliente.';

  @override
  String get pleaseEnterCnpj => 'Introduce un CNPJ.';

  @override
  String get invalidCnpj => 'Introduce un CNPJ válido.';

  @override
  String get pleaseEnterCompanyName => 'Introduce el nombre de la empresa.';

  @override
  String get pleaseEnterCep => 'Introduce un código postal.';

  @override
  String get invalidCep => 'Introduce un código postal válido.';

  @override
  String get pleaseEnterAddress => 'Introduce una dirección.';

  @override
  String get pleaseEnterNumber => 'Introduce un número.';

  @override
  String get pleaseEnterCity => 'Introduce una ciudad.';

  @override
  String get pleaseEnterState => 'Introduce un estado.';

  @override
  String get clientSaveFailed => 'No se pudo guardar el cliente.';

  @override
  String get costPerKilometer => 'Costo Por Kilómetro';

  @override
  String get minimumPrice => 'Precio Mínimo De Entrega';

  @override
  String get pleaseEnterDeliveryServiceName =>
      'Introduce el nombre del servicio de entriega';

  @override
  String get pleaseEnterKmCost => 'Introduce un costo por kilómetro.';

  @override
  String get pleaseEnterMinimumPrice =>
      'Introduce un precio mínimo de entrega.';

  @override
  String get noDeliveryServicesRegistered =>
      'No hay servicios de entriega registrados todavía.';

  @override
  String get deleteDeliveryService => 'Eliminar servicio de entriega';

  @override
  String get deleteDeliveryServiceConfirmation =>
      'Esta acción no se puede deshacer.';

  @override
  String get deliveryServiceDeleted => 'Servicio de entriega eliminado.';

  @override
  String get addDeliveryService => 'Agregar servicio de entriega';

  @override
  String get editDeliveryService => 'Editar servicio de entriega';

  @override
  String get createDeliveryService => 'Crear servicio de entriega';

  @override
  String get deliveryService => 'Servicios De Entriega';

  @override
  String get deliveryServiceSaveFailed =>
      'No se pudo guardar el servicio de entriega';
}
