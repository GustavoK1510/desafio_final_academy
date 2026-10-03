import 'dart:async';

import 'package:flutter/material.dart';

import '../../../features/clients/domain/entities/client.dart';
import '../../../features/clients/domain/enums/business_type.dart';
import '../../../features/clients/domain/usecases/client_use_case.dart';

/// Represents validation errors in the client form.
enum ClientFormError {

  /// Error for name
  nameRequired,

  /// Error for CNPJ
  cnpjRequired,

  /// Error for invalid CNPJ
  invalidCnpj,

  /// Error for company name
  companyNameRequired,

  /// Error for CEP
  cepRequired,

  /// Error for invalid CEP
  invalidCep,

  /// Error for address
  addressRequired,

  /// Error for number
  numberRequired,

  /// Error for city
  cityRequired,

  /// Error for state
  stateRequired,

  /// Error for business type
  businessTypeRequired,

  /// Error while saving
  saveFailed,
}

/// Manages client creation and editing.
class ClientFormProvider extends ChangeNotifier {

  /// Creates a client form provider.
  ClientFormProvider({
    required this._useCase,
    this._client,
  }) {
    _initialize();
  }

  final UseCaseClient _useCase;
  final Client? _client;

  /// Name field controller
  final nameController = TextEditingController();

  /// CNPJ field controller
  final cnpjController = TextEditingController();

  /// Company name field controller
  final companyNameController = TextEditingController();

  /// Phone field controller
  final phoneController = TextEditingController();

  /// Email field controller
  final emailController = TextEditingController();

  /// CEP field controller
  final cepController = TextEditingController();

  /// Street field controller
  final streetController = TextEditingController();

  /// Number field controller
  final numberController = TextEditingController();

  /// City field controller
  final cityController = TextEditingController();

  /// State field controller
  final stateController = TextEditingController();

  Timer? _cepTimer;

  bool _isLoadingCep = false;
  bool _isSaving = false;
  bool _addressLoaded = false;
  ClientFormError? _error;
  BusinessType? _businessType;

  /// Whether the form is editing an existing client.
  bool get isEditing => _client != null;

  /// Whether a CEP request is currently running.
  bool get isLoadingCep => _isLoadingCep;

  /// Whether the client is being saved.
  bool get isSaving => _isSaving;

  /// Whether the address was loaded from the CEP.
  bool get addressLoaded => _addressLoaded;

  /// Current form error.
  ClientFormError? get error => _error;

  /// Business type
  BusinessType? get businessType => _businessType;

  void _initialize() {
    final client = _client;

    if (client == null) {
      return;
    }

    nameController.text = client.name;
    cnpjController.text = client.cnpj;
    companyNameController.text = client.companyName;
    phoneController.text = client.phoneNumber ?? '';
    emailController.text = client.email;
    cepController.text = client.zipCode;
    streetController.text = client.street;
    numberController.text = client.number;
    cityController.text = client.city;
    stateController.text = client.state;

    _addressLoaded = true;
  }

  /// Sets the business type
  void setBusinessType(BusinessType? value) {
    _businessType = value;
    _error = null;
    notifyListeners();
  }

  /// Handles changes to the CEP field.
  void onCepChanged(String value) {
    _error = null;

    _cepTimer?.cancel();

    final cep = value.replaceAll(RegExp(r'\D'), '');

    if (cep.length != 8) {
      _clearAddress();
      notifyListeners();
      return;
    }

    _cepTimer = Timer(
      const Duration(milliseconds: 500),
          () => _searchCep(cep),
    );

    notifyListeners();
  }

  Future<void> _searchCep(String cep) async {
    _isLoadingCep = true;
    _error = null;
    notifyListeners();

    try {
      final address = await _useCase.getAddressByCep(cep);


      streetController.text = address.street;
      cityController.text = address.city;
      stateController.text = address.state;

      _addressLoaded = true;
    } catch (error) {
      _clearAddress();
      _error = ClientFormError.invalidCep;
    } finally {
      _isLoadingCep = false;
      notifyListeners();
    }
  }

  void _clearAddress() {
    _addressLoaded = false;
    streetController.clear();
    cityController.clear();
    stateController.clear();
  }

  /// Validates a Brazilian CNPJ.
  bool isValidCnpj(String value) {
    final cnpj = value.replaceAll(RegExp(r'\D'), '');

    if (cnpj.length != 14) {
      return false;
    }

    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) {
      return false;
    }

    final firstWeights = [
      5,
      4,
      3,
      2,
      9,
      8,
      7,
      6,
      5,
      4,
      3,
      2,
    ];

    final secondWeights = [
      6,
      5,
      4,
      3,
      2,
      9,
      8,
      7,
      6,
      5,
      4,
      3,
      2,
    ];

    final firstDigit = _calculateDigit(
      cnpj.substring(0, 12),
      firstWeights,
    );

    if (firstDigit != int.parse(cnpj[12])) {
      return false;
    }

    final secondDigit = _calculateDigit(
      cnpj.substring(0, 13),
      secondWeights,
    );

    return secondDigit == int.parse(cnpj[13]);
  }

  int _calculateDigit(
      String value,
      List<int> weights,
      ) {
    var sum = 0;

    for (var i = 0; i < value.length; i++) {
      sum += int.parse(value[i]) * weights[i];
    }

    final remainder = sum % 11;

    return remainder < 2 ? 0 : 11 - remainder;
  }

  /// Saves the client.
  Future<bool> saveClient({
    required BusinessType businessType,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final name = nameController.text.trim();
      final cnpj = cnpjController.text
          .replaceAll(RegExp(r'\D'), '');
      final companyName = companyNameController.text.trim();
      final phone = phoneController.text.trim();
      final email = emailController.text.trim();
      final cep = cepController.text
          .replaceAll(RegExp(r'\D'), '');
      final street = streetController.text.trim();
      final number = numberController.text.trim();
      final city = cityController.text.trim();
      final state = stateController.text.trim();

      if (name.isEmpty) {
        _error = ClientFormError.nameRequired;
        return false;
      }

      if (cnpj.isEmpty) {
        _error = ClientFormError.cnpjRequired;
        return false;
      }

      if (!isValidCnpj(cnpj)) {
        _error = ClientFormError.invalidCnpj;
        return false;
      }

      if (companyName.isEmpty) {
        _error = ClientFormError.companyNameRequired;
        return false;
      }

      if (cep.length != 8) {
        _error = ClientFormError.cepRequired;
        return false;
      }

      if (!_addressLoaded) {
        _error = ClientFormError.invalidCep;
        return false;
      }

      if (street.isEmpty || city.isEmpty || state.isEmpty) {
        _error = ClientFormError.addressRequired;
        return false;
      }

      if (number.isEmpty) {
        _error = ClientFormError.numberRequired;
        return false;
      }

      if (_businessType == null) {
        _error = ClientFormError.businessTypeRequired;
        return false;
      }

      final client = Client(
        id: _client?.id,
        name: name,
        cnpj: cnpj,
        companyName: companyName,
        phoneNumber: phone.isEmpty ? null : phone,
        email: email.isEmpty ? '' : email,
        street: street,
        number: number,
        city: city,
        state: state,
        zipCode: cep,
        latitude: _client?.latitude ?? 0,
        longitude: _client?.longitude ?? 0,
        businessType: _businessType!,
      );

      if (_client == null) {
        await _useCase.insertClient(client);
      } else {
        await _useCase.updateClient(client);
      }

      return true;
    } catch (error) {
      debugPrint('ERROR SAVING CLIENT: $error');
      _error = ClientFormError.saveFailed;
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cepTimer?.cancel();

    nameController.dispose();
    cnpjController.dispose();
    companyNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cepController.dispose();
    streetController.dispose();
    numberController.dispose();
    cityController.dispose();
    stateController.dispose();

    super.dispose();
  }
}