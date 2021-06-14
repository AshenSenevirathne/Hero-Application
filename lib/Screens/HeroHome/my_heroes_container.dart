import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Screens/HeroHome/Components/top_bar.dart';
import 'package:hero_application/Screens/HeroHome/HeroManagement/hero_model_popup.dart';
import 'package:hero_application/Screens/HeroHome/HeroManagement/hero_model_popup_route.dart';
import 'package:hero_application/Shared/constants.dart';
import 'package:hero_application/Shared/drawer.dart';

import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:flutter/widgets.dart';

import 'Components/my_heroes.dart';

class MyAllHeroes extends StatefulWidget {
  @override
  _MyAllHeroesState createState() => _MyAllHeroesState();
}

class _MyAllHeroesState extends State<MyAllHeroes> {
  String popUpHandler = heroModelPopupKey;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary_color,
        elevation: 0.0,
      ),
      drawer: CommonDrawer(),
      floatingActionButton: GestureDetector(
        onTap: () {
          String keyForPopup = DateTime.now().millisecondsSinceEpoch.toString();
          setState(() {
            popUpHandler = keyForPopup;
          });
          Navigator.of(context).push(HeroModelPopupRoute(builder: (context) {
            return HeroModelPopup(
                heroModel: new HeroModel(
                    id: "",
                    heroName: "",
                    bornDate: DateTime.now(),
                    citizenship: "",
                    domain: "",
                    biography: "",
                    imageUrl: "",
                    addedUserId: context.watch<User?>()!.uid),
                type: "CREATE",
                popUpHandler: keyForPopup);
          }));
        },
        child: Hero(
            tag: popUpHandler,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: primary_color,
              child: Icon(
                Icons.add,
                color: light_color,
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(size: size),
            MyHeroes(),
          ],
        ),
      ),
    );
  }
}
