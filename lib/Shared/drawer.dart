import 'package:flutter/material.dart';
import 'package:hero_application/Shared/constants.dart';
import '../../Services/authentication_service.dart';
import 'package:provider/provider.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: primary_color,
                image: DecorationImage(
                    image: AssetImage("assets/images/hero2.jpg"),
                    fit:BoxFit.cover
                )
            ),
            child: Container(),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 20.0),
                Text('All Heroes')
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/home");
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 20.0),
                Text('My Heroes')
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/heroHome");
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: 20.0),
                Text('Sign Out')
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthenticationService>().signOut();
              Navigator.pushReplacementNamed(context, "/signIn");
            },
          ),
        ],
      ),
    );
  }
}
