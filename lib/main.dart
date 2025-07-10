// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:proofofconceptapp/ui/onboarding_screen.dart';
import 'ui/map_screen.dart';
import 'services/lg_service.dart';

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
        title: 'Open Buildings Visualizer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: OnboardingWrapper(child: MapScreen()),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}