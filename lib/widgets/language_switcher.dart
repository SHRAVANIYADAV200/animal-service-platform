import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        return PopupMenuButton<Locale>(
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.translate, size: 18, color: AppTheme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  langProvider.currentLanguageName,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          onSelected: (locale) {
            langProvider.setLocale(locale);
          },
          itemBuilder: (context) => LanguageProvider.supportedLanguages.map((lang) {
            final isSelected = langProvider.locale == lang['locale'];
            return PopupMenuItem<Locale>(
              value: lang['locale'] as Locale,
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    size: 18,
                    color: isSelected ? AppTheme.primaryColor : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    lang['nativeName'] as String,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.primaryColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "(${lang['name']})",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
