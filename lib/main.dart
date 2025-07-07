import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proofofconceptapp/ui/onboarding_screen.dart';
import 'ui/map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Buildings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnboardingWrapper(child: MapScreen()), // Wrap your MapScreen
      debugShowCheckedModeBanner: false,
    );
  }
}