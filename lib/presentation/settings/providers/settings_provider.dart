import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../features/store/domain/entities/store.dart';
import '../../../../features/store/domain/usecases/store_use_case.dart';

/// Manages the state and actions of the settings page.
class SettingsProvider extends ChangeNotifier {
  /// Class constructor.
  SettingsProvider({
    required this._storeUseCase,
  });

  final StoreUseCase _storeUseCase;

  Store? _store;
  File? _newLogo;

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  /// The currently saved store.
  Store? get store => _store;

  /// The new logo selected by the user.
  File? get newLogo => _newLogo;

  /// Whether the store is currently being loaded.
  bool get isLoading => _isLoading;

  /// Whether the store is currently being saved.
  bool get isSaving => _isSaving;

  /// The current error message.
  String? get errorMessage => _errorMessage;

  /// Whether a store has already been registered.
  bool get hasStore => _store != null;

  /// Loads the store from the database.
  Future<void> loadStore() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _store = await _storeUseCase.getStore();
    } catch (error, stackTrace) {
      debugPrint('ERROR LOADING STORE: $error');
      debugPrint('STACK TRACE: $stackTrace');

      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Selects a new logo.
  void selectLogo(File file) {
    _newLogo = file;
    notifyListeners();
  }

  /// Saves the store information.
  ///
  /// Creates the store when one does not exist and updates it when
  /// a store has already been registered.
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
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
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

        await _storeUseCase.insertStore(
          store,
          _newLogo!,
        );
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

        await _storeUseCase.updateStore(
          store,
          _newLogo,
        );
      }

      _store = await _storeUseCase.getStore();
      _newLogo = null;

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