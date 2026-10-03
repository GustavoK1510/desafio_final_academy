import 'dart:async';

import 'package:flutter/material.dart';

import '../../../features/delivery_services/domain/entities/delivery_service.dart';
import '../../../features/delivery_services/domain/usecases/delivery_service_use_case.dart';

/// Represents validation errors in the delivery service form.
enum DeliveryServiceFormError {

  /// Error for name
  nameRequired,

  /// Error for CNPJ
  cnpjRequired,

  /// Error for invalid CNPJ
  invalidCnpj,

  /// Error for company name
  companyNameRequired,

  /// Error for email
  emailRequired,

  /// Error for Cost per kilometer
  kmCostRequired,

  /// Error for minimum price
  minimumPriceRequired,

  /// Error while saving
  saveFailed,
}

/// Manages delivery service creation and editing.
class DeliveryServiceFormProvider extends ChangeNotifier {

  /// Creates a delivery service form provider.
  DeliveryServiceFormProvider({
    required this._useCase,
    this._deliveryService,
  }) {
    _initialize();
  }

  final DeliveryServiceUseCase _useCase;
  final DeliveryService? _deliveryService;

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

  /// Cost per kilometer field controller
  final kmCostController = TextEditingController();

  /// Minimum price field controller
  final minimumPriceController = TextEditingController();

  bool _isSaving = false;
  DeliveryServiceFormError? _error;

  /// Whether the form is editing an existing delivery service.
  bool get isEditing => _deliveryService != null;

  /// Whether the delivery service is being saved.
  bool get isSaving => _isSaving;

  /// Current form error.
  DeliveryServiceFormError? get error => _error;

  /// Initializes the form with the fields from the delivery service
  void _initialize() {
    final deliveryService = _deliveryService;

    /// Returns if there is no delivery service
    if (deliveryService == null) {
      return;
    }

    nameController.text = deliveryService.name;
    cnpjController.text = deliveryService.cnpj;
    companyNameController.text = deliveryService.companyName;
    phoneController.text = deliveryService.phoneNumber ?? '';
    emailController.text = deliveryService.email;
    kmCostController.text = deliveryService.kmCost.toString();
    minimumPriceController.text = deliveryService.minimumPrice.toString();
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

  /// Saves the deliveryService.
  Future<bool> saveDeliveryService() async {
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
      final kmCost = double.parse(kmCostController.text.trim());
      final minimumPrice = double.parse(minimumPriceController.text.trim());

      if (name.isEmpty) {
        _error = DeliveryServiceFormError.nameRequired;
        return false;
      }

      if (cnpj.isEmpty) {
        _error = DeliveryServiceFormError.cnpjRequired;
        return false;
      }

      if (!isValidCnpj(cnpj)) {
        _error = DeliveryServiceFormError.invalidCnpj;
        return false;
      }

      if (companyName.isEmpty) {
        _error = DeliveryServiceFormError.companyNameRequired;
        return false;
      }

      if (kmCost.isNaN || kmCost.isNegative) {
        _error = DeliveryServiceFormError.kmCostRequired;
        return false;
      }

      if (minimumPrice.isNaN || minimumPrice.isNegative) {
        _error = DeliveryServiceFormError.minimumPriceRequired;
        return false;
      }

      final deliveryService = DeliveryService(
        id: _deliveryService?.id,
        name: name,
        cnpj: cnpj,
        companyName: companyName,
        phoneNumber: phone.isEmpty ? null : phone,
        email: email.isEmpty ? '' : email,
        kmCost: kmCost,
        minimumPrice: minimumPrice,
      );

      if (_deliveryService == null) {
        await _useCase.insertDeliveryService(deliveryService);
      } else {
        await _useCase.updateDeliveryService(deliveryService);
      }

      return true;
    } catch (error) {
      debugPrint('ERROR SAVING DELIVERY SERVICE: $error');
      _error = DeliveryServiceFormError.saveFailed;
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cnpjController.dispose();
    companyNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    kmCostController.dispose();
    minimumPriceController.dispose();

    super.dispose();
  }
}