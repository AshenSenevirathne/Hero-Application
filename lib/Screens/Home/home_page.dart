import 'package:flutter/material.dart';
import '../../Services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hero_application/shared/constants.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    bool isAnon = true;

    if (firebaseUser!.isAnonymous == false) {
      isAnon = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        elevation: 0.0,
        title: Text('Home'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.exit_to_app),
            label: Text('Sign Out'),
            onPressed: () => context.read<AuthenticationService>().signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isAnon? Text("Anonymous"):Text("User : " + firebaseUser.email.toString()),
          ],
        ),
      ),
    );
  }
}
