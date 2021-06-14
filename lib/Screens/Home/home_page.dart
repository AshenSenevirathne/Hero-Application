import 'package:flutter/material.dart';
import 'package:hero_application/Shared/drawer.dart';
import '../../Services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    bool isAnon = true;

    if (firebaseUser!.isAnonymous == false) {
      isAnon = false;
    }

    return Scaffold(
      drawer: isAnon ? null : CommonDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isAnon
                ? IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();
                      Navigator.pushReplacementNamed(context, "/signIn");
                    })
                : Builder(
                    builder: (context) => // Ensure Scaffold is in context
                        IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer()),
                  )
          ],
        ),
      ),
    );
  }
}
