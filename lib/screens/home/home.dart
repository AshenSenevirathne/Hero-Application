import 'package:flutter/material.dart';
import 'package:hero_application/shared/constants.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: body_color,
      appBar: AppBar(
        backgroundColor: primary_color,
        elevation: 0.0,
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home"),
          ],
        ),
      ),
    );;
  }
}
