/*
*   Dart core dependency imports
* */
import 'dart:async';
import 'package:flutter/material.dart';

/*
* Animated text dependency import
* */
import 'package:animated_text_kit/animated_text_kit.dart';

/*
* Custom dependency import
* */
import 'package:hero_application/Screens/auth_wrapper.dart';
import 'package:hero_application/Shared/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 5 seconds
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AuthenticationWrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                primary_color,
                secondary_color,
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image(
                  image: AssetImage("assets/images/superhero.gif"),
                  height: 230.0,
                  width: 230.0,
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      'Hero App',
                      textStyle: const TextStyle(
                          color: light_color,
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0,
                          fontFamily: "LobsterTwo-Regular"),
                    ),
                  ],
                  isRepeatingAnimation: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
