import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/services/brasil_api/brasil_api_service.dart';
import '../../../../core/utils/cnpj_validator.dart';
import '../../../../features/store/domain/entities/store.dart';
import '../../../../features/store/domain/usecases/store_use_case.dart';

/// Manages store settings and verification operations.
class SettingsProvider extends ChangeNotifier {
  
  /// Creates the settings provider.
  SettingsProvider({
    required this._storeUseCase,
    required this._brasilApiService,
  });

  final StoreUseCase _storeUseCase;
  final BrasilApiService _brasilApiService;

  Store? _store;
  File? _newLogo;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isEditing = true;
  bool _isVerifyingCep = false;
  String? _errorMessage;

  Store? get store => _store;
  File? get newLogo => _newLogo;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isEditing => _isEditing;
  bool get isVerifyingCep => _isVerifyingCep;
  String? get errorMessage => _errorMessage;
  bool get hasStore => _store != null;

  /// Loads the saved store.
  Future<void> loadStore() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _store = await _storeUseCase.getStore();
      _isEditing = _store == null;
    } catch (error, stackTrace) {
      debugPrint('ERROR LOADING STORE: $error');
      debugPrint('STACK TRACE: $stackTrace');
      _errorMessage = error.toString();
      _isEditing = _store == null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Enables editing of an existing store.
  void startEditing() {
    if (!hasStore || _isSaving) return;

    _isEditing = true;
    _errorMessage = null;
    notifyListeners();
  }

  /// Cancels editing without saving changes.
  void cancelEditing() {
    if (_isSaving || !hasStore) return;

    _newLogo = null;
    _isEditing = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Selects a new store logo.
  void selectLogo(File file) {
    if (!_isEditing || _isSaving) return;

    _newLogo = file;
    notifyListeners();
  }

  /// Checks whether a CNPJ has valid check digits.
  bool verifyCnpj(String cnpj) {
    return CnpjValidator.isValid(cnpj);
  }

  /// Looks up a CEP and returns its address details.
  Future<Map<String, String>?> verifyCep(String cep) async {
    if (_isVerifyingCep) return null;

    final digits = cep.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 8) {
      _errorMessage = 'Enter a valid 8-digit CEP.';
      notifyListeners();
      return null;
    }

    _isVerifyingCep = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final address = await _brasilApiService.getCep(digits);

      return {
        'street': address.street,
        'city': address.city,
        'state': address.state,
      };
    } catch (error, stackTrace) {
      debugPrint('ERROR VERIFYING CEP: $error');
      debugPrint('STACK TRACE: $stackTrace');
      _errorMessage = 'Could not verify the CEP. Check it and try again.';
      return null;
    } finally {
      _isVerifyingCep = false;
      notifyListeners();
    }
  }

  /// Creates or updates the store.
  Future<bool> saveStore({
    required String name,
    required String companyName,
    required String cnpj,
    required String street,
    required String number,
    required String city,
    required String state,
    required String zipCode,
  }) async {
    if (_isSaving) return false;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!CnpjValidator.isValid(cnpj)) {
        _errorMessage = 'Enter a valid CNPJ before saving.';
        return false;
      }

      if (_store == null) {
        if (_newLogo == null) {
          _errorMessage = 'Please select a store logo.';
          return false;
        }

        final store = Store(
          name: name.trim(),
          companyName: companyName.trim(),
          logoPath: '',
          cnpj: cnpj.trim(),
          street: street.trim(),
          number: number.trim(),
          city: city.trim(),
          state: state.trim(),
          zipCode: zipCode.trim(),
          latitude: 0,
          longitude: 0,
        );

        await _storeUseCase.insertStore(store, _newLogo!);
      } else {
        final store = Store(
          id: _store!.id,
          name: name.trim(),
          companyName: companyName.trim(),
          logoPath: _store!.logoPath,
          cnpj: cnpj.trim(),
          street: street.trim(),
          number: number.trim(),
          city: city.trim(),
          state: state.trim(),
          zipCode: zipCode.trim(),
          latitude: _store!.latitude,
          longitude: _store!.longitude,
        );

        await _storeUseCase.updateStore(store, _newLogo);
      }

      _store = await _storeUseCase.getStore();
      _newLogo = null;
      _isEditing = false;

      return true;
    } catch (error, stackTrace) {
      debugPrint('ERROR SAVING STORE: $error');
      debugPrint('STACK TRACE: $stackTrace');
      _errorMessage = error.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}