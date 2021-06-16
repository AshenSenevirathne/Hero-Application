/*
*   Dart core dependency imports
* */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/*
* Package dependency import
* */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

/*
* Custom dependency import
* */
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Shared/constants.dart';
import 'package:hero_application/Screens/HeroHome/Components/my_hero.dart';

class MyHeroes extends StatefulWidget {
  @override
  _MyHeroesState createState() => _MyHeroesState();
}

class _MyHeroesState extends State<MyHeroes> {
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {

    /*
    * Create stream for firebase and get heroes by user
    * */
    final Stream<QuerySnapshot> _myHeroStream = FirebaseFirestore.instance
        .collection('Heroes')
        .where("AddedUserId", isEqualTo: context.watch<User?>()!.uid)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _myHeroStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Show Error
        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
            child: Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [Text("Something went wrong...")],
                  ),
                ),
              ),
            ),
          );
        }

        // Show loading screen until data loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
            child: Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircularProgressIndicator(),
                          Text(
                            "Loading hero details...",
                            style:
                                TextStyle(fontSize: 18, color: primary_color),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Show Empty list if there is no hero
        if (snapshot.data!.size <= 0) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
            child: Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.list,
                            color: primary_color,
                            size: 60,
                          ),
                          Text(
                            "Your hero list is empty.",
                            style:
                                TextStyle(fontSize: 18, color: primary_color),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Show heroes created by the user
        return Column(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              controller: _controller,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return MyHero(
                    heroModel: new HeroModel(
                        id: document.id,
                        heroName: data['HeroName'],
                        bornDate: DateTime.parse(data['BornDate'].toDate().toString()),
                        citizenship: data['Citizenship'],
                        domain: data['Domain'],
                        biography: data['Biography'],
                        imageUrl: data['ImageUrl'],
                        addedUserId: data['AddedUserId']));
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
