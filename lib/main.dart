// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proofofconceptapp/ui/splash.dart';
import 'package:provider/provider.dart';
import 'package:proofofconceptapp/ui/onboarding_screen.dart';
import 'ui/map_screen.dart';
import 'services/lg_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



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
    return ChangeNotifierProvider<LGService>.value(
      value: lgService,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('es'), // Spanish
          Locale('fr'), // French
          Locale('pt'), // Portugese
          Locale('hi'), // Hindi
          Locale('sw'), // Swahili
          Locale('ha'), // Hausa
          Locale('bn'), // Bengali
          Locale('id'), // Indonesian
          Locale('vi'), // Vietnamese

        ],
        title: 'Open Buildings Visualizer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(
          nextScreen: OnboardingWrapper(child: MapScreen()),
          duration: 5,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}