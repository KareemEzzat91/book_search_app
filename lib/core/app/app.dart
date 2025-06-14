import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../routes/app_router.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../language/language_provider.dart';
import '../../features/books/data/repositories/book_repository_impl.dart';
import '../../features/books/presentation/bloc/book_bloc.dart';
import '../../features/models/book_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesBox = context.read<Box<Book>>();

    return BlocProvider(
      create: (context) => BookBloc(
        BookRepositoryImpl(),
        favoritesBox,
      ),
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'BookSearch'.tr(),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: languageProvider.locale,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
