import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:hero_application/Screens/AuthWrapper.dart';
import 'dart:async';
import 'package:hero_application/shared/constants.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticationWrapper()))
    );
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
                          fontFamily: "LobsterTwo-Regular"
                      ),
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
