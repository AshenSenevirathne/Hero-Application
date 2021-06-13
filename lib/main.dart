import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hero_application/Screens/Home/home_page.dart';
import 'package:hero_application/screens/splash/splash.dart';
import 'package:hero_application/Screens/Authentication/SignIn.dart';
import 'package:hero_application/Screens/Authentication/SignUp.dart';
import 'Services/authentication_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Hero App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          "/register": (context) => Register(),
          "/signIn": (context) => SignIn(),
          "/home": (context) => Home(),
        },
        home: SplashScreen(),
      ),
    );
  }
}

