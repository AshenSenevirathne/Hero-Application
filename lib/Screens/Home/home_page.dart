import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Screens/Home/search_modal.dart';
import 'package:hero_application/Services/authentication_service.dart';
import 'package:hero_application/Services/dashboard_services.dart';
import 'package:hero_application/Shared/drawer.dart';
import 'package:hero_application/Shared/styleguide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'character_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _pageController;
  int currentPage = 0;
  Random random = new Random();

  List listColours = [
    [Colors.teal.shade200, Colors.teal.shade400],
    [Colors.purple.shade200, Colors.deepPurple.shade400],
    [Colors.green.shade200, Colors.greenAccent.shade400],
    [Colors.blue.shade200, Colors.blueAccent.shade400],
    [Colors.orange.shade200, Colors.deepOrange.shade400]
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        viewportFraction: 1.0, initialPage: currentPage, keepPage: false);
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    bool isAnon = true;

    if (firebaseUser!.isAnonymous == false) {
      isAnon = false;
    }

    final Stream<QuerySnapshot> _heroStream =
        new DashboardDatabaseService().getHero();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: isAnon ? null : CommonDrawer(),
        body: StreamBuilder<QuerySnapshot>(
            stream: _heroStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Error !',
                  desc: 'Something went wrong. Please try again!',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {},
                )..show();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              List<HeroModel> heroList = [];

              for (var i = 0; i < documents.length; i++) {
                heroList.add(HeroModel(
                    id: documents[i].id,
                    heroName: documents[i]['HeroName'],
                    bornDate: DateTime.now(),
                    citizenship: '',
                    domain: '',
                    biography: '',
                    imageUrl: documents[i]['ImageUrl'],
                    addedUserId: documents[i]['AddedUserId']));
              }

              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.0, top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          isAnon
                              ? IconButton(
                                  onPressed: () {
                                    context
                                        .read<AuthenticationService>()
                                        .signOut();
                                    Navigator.pushReplacementNamed(
                                        context, "/signIn");
                                  },
                                  icon: Icon(Icons.exit_to_app),
                                  iconSize: 35.0,
                                )
                              : IconButton(
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: Icon(Icons.menu),
                                  iconSize: 35.0,
                                ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Moden Day Heros',
                                style: AppTheme.display1),
                            TextSpan(text: '\n'),
                            TextSpan(
                                text: 'Read more about heros',
                                style: AppTheme.display2)
                          ])),
                          IconButton(
                            onPressed: () {
                              _onTapSearch(context, heroList);
                            },
                            icon: Icon(Icons.search_rounded),
                            iconSize: 35.0,
                          )
                        ],
                      ),
                      Expanded(
                          child: PageView(
                        controller: _pageController,
                        children: [
                          for (var i = 0; i < documents.length; i++)
                            CharacterWidget(
                                character: heroList[i],
                                pageController: _pageController,
                                currentPage: i,
                                colors: listColours[random.nextInt(4)])
                        ],
                      ))
                    ],
                  ),
                ),
              );
            }));
  }
}

_onTapSearch(BuildContext context, List<HeroModel> heroList) {
  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: context,
    elevation: 0,
    builder: (BuildContext context) {
      return SearchModal(heroList: heroList);
    },
  );
}
