import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;


  static const List<LanguageOption> supportedLanguages = [
    LanguageOption(locale: Locale('en'), name: 'English', nativeName: 'English'),
    LanguageOption(locale: Locale('es'), name: 'Spanish', nativeName: 'Español'),
    LanguageOption(locale: Locale('fr'), name: 'French', nativeName: 'Français'),
    LanguageOption(locale: Locale('pt'), name: 'Portuguese', nativeName: 'Português'),
    LanguageOption(locale: Locale('hi'), name: 'Hindi', nativeName: 'हिन्दी'),
    LanguageOption(locale: Locale('sw'), name: 'Swahili', nativeName: 'Kiswahili'),
    LanguageOption(locale: Locale('ha'), name: 'Hausa', nativeName: 'Hausa'),
    LanguageOption(locale: Locale('bn'), name: 'Bengali', nativeName: 'বাংলা'),
    LanguageOption(locale: Locale('id'), name: 'Indonesian', nativeName: 'Bahasa Indonesia'),
    LanguageOption(locale: Locale('vi'), name: 'Vietnamese', nativeName: 'Tiếng Việt'),
  ];

  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Load saved language from preferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selected_language') ?? 'en';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  // Change language and save preference
  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;
    notifyListeners();

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', locale.languageCode);
  }

  // Get current language display name
  String getCurrentLanguageName() {
    return supportedLanguages
        .firstWhere((lang) => lang.locale == _currentLocale)
        .nativeName;
  }
}

class LanguageOption {
  final Locale locale;
  final String name;
  final String nativeName;

  const LanguageOption({
    required this.locale,
    required this.name,
    required this.nativeName,
  });
}