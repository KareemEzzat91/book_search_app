import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Switch
          Card(
            child: ListTile(
              leading: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: AppColors.primary,
              ),
              title: Text('theme'.tr()),
              subtitle: Text(
                Theme.of(context).brightness == Brightness.dark
                    ? 'darkTheme'.tr()
                    : 'lightTheme'.tr(),
              ),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  // TODO: Implement theme switching
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Language Selection
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: Text('language'.tr()),
                  subtitle: Text(
                    context.locale.languageCode == 'en' ? 'English' : 'العربية',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('English'),
                  trailing: context.locale.languageCode == 'en'
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    context.setLocale(const Locale('en'));
                  },
                ),
                ListTile(
                  title: const Text('العربية'),
                  trailing: context.locale.languageCode == 'ar'
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    context.setLocale(const Locale('ar'));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
