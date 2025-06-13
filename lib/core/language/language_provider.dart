import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  final SharedPreferences _prefs;
  late Locale _locale;

  LanguageProvider(this._prefs) {
    _loadLanguage();
  }

  Locale get locale => _locale;

  void _loadLanguage() {
    final savedLanguage = _prefs.getString(_languageKey);
    _locale =
        savedLanguage != null ? Locale(savedLanguage) : const Locale('en');
    notifyListeners();
  }

  Future<void> setLanguage(Locale locale) async {
    _locale = locale;
    await _prefs.setString(_languageKey, locale.languageCode);
    notifyListeners();
  }
}
