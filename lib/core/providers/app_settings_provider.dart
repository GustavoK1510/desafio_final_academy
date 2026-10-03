import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides application settings.
class AppSettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');
  bool _isDarkMode = false;

  Locale get locale => _locale;

  bool get isDarkMode => _isDarkMode;

  /// Loads saved application settings.
  Future<void> loadSettings() async {
    final preferences = await SharedPreferences.getInstance();

    final language = preferences.getString('language');
    final country = preferences.getString('country');

    if (language != null) {
      _locale = Locale(
        language,
        country,
      );
    }

    _isDarkMode = preferences.getBool('dark_mode') ?? false;

    notifyListeners();
  }

  /// Changes the application language.
  Future<void> changeLanguage(Locale locale) async {
    _locale = locale;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      'language',
      locale.languageCode,
    );

    await preferences.setString(
      'country',
      locale.countryCode ?? '',
    );

    notifyListeners();
  }

  /// Changes the dark mode state.
  Future<void> changeDarkMode(bool value) async {
    _isDarkMode = value;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      'dark_mode',
      value,
    );

    notifyListeners();
  }
}