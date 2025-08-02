// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proofofconceptapp/ui/splash.dart';
import 'package:provider/provider.dart';
import 'package:proofofconceptapp/ui/onboarding_screen.dart';
import 'l10n/app_localizations.dart';
import 'ui/map_screen.dart';
import 'services/lg_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize LG Service
  final lgService = LGService();
  await lgService.initialize();

  runApp(MyApp(lgService: lgService));
}

class MyApp extends StatelessWidget {
  final LGService lgService;

  const MyApp({Key? key, required this.lgService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UPDATED: Added ThemeProvider to MultiProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LGService>.value(value: lgService),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ADD THIS
      ],
      // UPDATED: Wrap with both Consumers to respond to language and theme changes
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          // Update AppColors state when theme changes
          AppColors.updateThemeState(themeProvider.isDarkMode);

          return MaterialApp(
            // CHANGED: Add AppLocalizations.delegate (this was missing!)
            localizationsDelegates: const [
              AppLocalizations.delegate,  // ADD THIS LINE
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // CHANGED: Make locale dynamic based on user selection
            locale: languageProvider.currentLocale,  // ADD THIS LINE

            supportedLocales: const [
              Locale('en'), // English
              Locale('es'), // Spanish
              Locale('fr'), // French
              Locale('pt'), // Portuguese
              Locale('hi'), // Hindi
              Locale('sw'), // Swahili
              Locale('ha'), // Hausa
              Locale('bn'), // Bengali
              Locale('id'), // Indonesian
              Locale('vi'), // Vietnamese
            ],

            title: 'Open Buildings Visualizer',

            // UPDATED: Theme now responds to dark/light mode
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: AppColors.currentPrimary,
              scaffoldBackgroundColor: AppColors.currentBackground,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.currentPrimary,
                foregroundColor: AppColors.currentOnPrimary,
                elevation: 0,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.currentPrimary,
                  foregroundColor: AppColors.currentOnPrimary,
                ),
              ),
              cardTheme: CardThemeData(
                color: AppColors.currentSurface,
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: AppColors.currentSurface,
              ),
              brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),

            home: SplashScreen(
              nextScreen: OnboardingWrapper(child: MapScreen()),
              duration: 5,
            ),
            debugShowCheckedModeBanner: false,

            // ADD THIS: Handle locale fallback gracefully
            localeResolutionCallback: (locale, supportedLocales) {
              // If device locale is supported, use it
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              // Fallback to English
              return const Locale('en');
            },
          );
        },
      ),
    );
  }
}