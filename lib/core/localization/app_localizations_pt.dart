// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get settings => 'Configurações';

  @override
  String get store => 'Loja';

  @override
  String get address => 'Endereço';

  @override
  String get street => 'Rua';

  @override
  String get number => 'Número';

  @override
  String get city => 'Cidade';

  @override
  String get state => 'Estado';

  @override
  String get zipCode => 'CEP';

  @override
  String get save => 'Salvar';

  @override
  String get changeLogo => 'Alterar logo';

  @override
  String get selectLogo => 'Toque para selecionar o logo da loja';

  @override
  String get language => 'Idioma';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get cancel => 'Cancelar';

  @override
  String get portuguese => 'Português';

  @override
  String get english => 'Inglês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get changeLanguage => 'Alterar idioma';

  @override
  String get addressUpdated => 'Endereço atualizado';

  @override
  String get settingsSaved => 'Configurações salvas';

  @override
  String get storeName => 'Nome da loja';

  @override
  String get companyName => 'Razão social';

  @override
  String get cnpj => 'CNPJ';

  @override
  String get createStore => 'Criar loja';

  @override
  String get storeCreatedSuccessfully => 'Loja criada com sucesso.';

  @override
  String get settingsSavedSuccessfully => 'Configurações salvas com sucesso.';

  @override
  String get errorOccurred => 'Ocorreu um erro.';

  @override
  String get products => 'Produtos';

  @override
  String get clients => 'Clientes';

  @override
  String get deliveryServices => 'Serviços de entrega';

  @override
  String get orders => 'Pedidos';

  @override
  String get welcome => 'Bem-vindo!';

  @override
  String welcomeStore(Object name) {
    return 'Bem-vindo, $name!';
  }

  @override
  String get whatWouldYouLikeToManage => 'O que você gostaria de gerenciar?';

  @override
  String get seeProducts => 'Ver produtos';

  @override
  String get seeClients => 'Ver clientes';

  @override
  String get seeDeliveryServices => 'Ver serviços de entrega';

  @override
  String get seeOrders => 'Ver pedidos';

  @override
  String get manageProducts => 'Gerencie seus produtos';

  @override
  String get manageClients => 'Gerencie seus clientes';

  @override
  String get manageDeliveries => 'Gerencie suas entregas';

  @override
  String get manageOrders => 'Gerencie seus pedidos';

  @override
  String get addProduct => 'Adicionar produto';

  @override
  String get editProduct => 'Editar produto';

  @override
  String get createProduct => 'Criar produto';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get deleteProduct => 'Excluir produto?';

  @override
  String get deleteProductConfirmation => 'Esta ação não pode ser desfeita.';

  @override
  String get delete => 'Excluir';

  @override
  String get productDeleted => 'Produto excluído.';

  @override
  String get noProductsRegistered => 'Nenhum produto cadastrado.';

  @override
  String get name => 'Nome';

  @override
  String get brand => 'Marca';

  @override
  String get barcode => 'Código de barras';

  @override
  String get price => 'Preço';

  @override
  String get description => 'Descrição';

  @override
  String get productImages => 'Imagens do produto';

  @override
  String get addImages => 'Adicionar imagens';

  @override
  String get addProductImages => 'Adicionar imagens do produto';

  @override
  String get generateBarcode => 'Gerar código de barras';

  @override
  String get edit => 'Editar';

  @override
  String get pleaseEnterProductName => 'Digite o nome do produto.';

  @override
  String get pleaseEnterProductBrand => 'Digite a marca do produto.';

  @override
  String get pleaseEnterBarcode => 'Digite ou gere um código de barras.';

  @override
  String get pleaseEnterValidPrice => 'Digite um preço válido.';

  @override
  String get businessType => 'Tipo de negócio';

  @override
  String get businessTypeSchool => 'Escola';

  @override
  String get businessTypeGym => 'Academia';

  @override
  String get businessTypeOther => 'Outro';

  @override
  String get pleaseSelectBusinessType => 'Selecione um tipo de negócio.';

  @override
  String get addClient => 'Adicionar cliente';

  @override
  String get editClient => 'Editar cliente';

  @override
  String get createClient => 'Criar cliente';

  @override
  String get deleteClient => 'Excluir cliente';

  @override
  String get deleteClientConfirmation => 'Esta ação não pode ser desfeita.';

  @override
  String get clientDeleted => 'Cliente excluído.';

  @override
  String get noClientsRegistered => 'Nenhum cliente cadastrado ainda.';

  @override
  String get phone => 'Telefone';

  @override
  String get email => 'E-mail';

  @override
  String get cep => 'CEP';

  @override
  String get pleaseEnterClientName => 'Digite o nome do cliente.';

  @override
  String get pleaseEnterCnpj => 'Digite um CNPJ.';

  @override
  String get invalidCnpj => 'Digite um CNPJ válido.';

  @override
  String get pleaseEnterCompanyName => 'Digite o nome da empresa.';

  @override
  String get pleaseEnterCep => 'Digite um CEP.';

  @override
  String get invalidCep => 'Digite um CEP válido.';

  @override
  String get pleaseEnterAddress => 'Digite um endereço.';

  @override
  String get pleaseEnterNumber => 'Digite um número.';

  @override
  String get pleaseEnterCity => 'Digite uma cidade.';

  @override
  String get pleaseEnterState => 'Digite um estado.';

  @override
  String get clientSaveFailed => 'Não foi possível salvar o cliente.';

  @override
  String get costPerKilometer => 'Custo Por Quilômetro';

  @override
  String get minimumPrice => 'Frete Mínimo';

  @override
  String get pleaseEnterDeliveryServiceName =>
      'Digite um nome para o serviço de entrega.';

  @override
  String get pleaseEnterKmCost => 'Digite um custo por quilômetro.';

  @override
  String get pleaseEnterMinimumPrice => 'Digite um frete mínimo.';

  @override
  String get noDeliveryServicesRegistered =>
      'Nenhum serviço de entrega cadastrado ainda.';

  @override
  String get deleteDeliveryService => 'Excluir serviço de entrega';

  @override
  String get deleteDeliveryServiceConfirmation =>
      'Esta ação não pode ser desfeita.';

  @override
  String get deliveryServiceDeleted => 'Serviço de entrega excluído.';

  @override
  String get addDeliveryService => 'Adicionar serviço de entrega';

  @override
  String get editDeliveryService => 'Editar serviço de entrega';

  @override
  String get createDeliveryService => 'Criar serviço de entrega';

  @override
  String get deliveryService => 'Serviços De Entrega';

  @override
  String get deliveryServiceSaveFailed =>
      'Não foi possível salvar o serviço de entrega.';
}
