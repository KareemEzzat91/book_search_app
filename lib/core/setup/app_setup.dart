import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../language/language_provider.dart';
import '../theme/theme_provider.dart';
import '../../features/models/book_model.dart';

class AppSetup {
  static Future<Box<Book>> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(BookAdapter());
    final favoritesBox = await Hive.openBox<Book>('favorites');

    // Initialize Localization
    await EasyLocalization.ensureInitialized();

    return favoritesBox;
  }

  static List<ChangeNotifierProvider> getProviders(SharedPreferences prefs) {
    return [
      ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
      ChangeNotifierProvider(create: (_) => LanguageProvider(prefs)),
    ];
  }
}
