import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hero_application/screens/splash/splash.dart';
import 'package:hero_application/shared/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hero App',
      theme: ThemeData(
        primarySwatch: primary_color,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

