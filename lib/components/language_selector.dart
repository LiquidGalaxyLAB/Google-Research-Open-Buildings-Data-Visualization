// lib/components/language_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/colors.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return ListTile(
          leading: Icon(Icons.language, color: AppColors.onSurfaceVariant),
          title: Text(
            'Language', // You can localize this later
            style: TextStyle(color: AppColors.onSurface),
          ),
          subtitle: Text(
            languageProvider.getCurrentLanguageName(),
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
          trailing: Icon(Icons.chevron_right, color: AppColors.outline),
          onTap: () => _showLanguageBottomSheet(context, languageProvider),
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context, LanguageProvider languageProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.language, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Language options with better styling
              ...LanguageProvider.supportedLanguages.map((langOption) {
                final isSelected = languageProvider.currentLocale == langOption.locale;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                      ),
                      child: Center(
                        child: Text(
                          langOption.locale.languageCode.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      langOption.nativeName,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: AppColors.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      langOption.name,
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () async {
                      await languageProvider.changeLanguage(langOption.locale);
                      if (context.mounted) {
                        Navigator.pop(context);

                        // Show language changed confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Language changed to ${langOption.nativeName}',
                              style: TextStyle(color: AppColors.onPrimary),
                            ),
                            backgroundColor: AppColors.primary,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              }).toList(),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}