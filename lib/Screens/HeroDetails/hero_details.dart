import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Shared/styleguide.dart';
import 'package:hero_application/Screens/HeroDetails/action_widget.dart';
import 'package:hero_application/Screens/HeroDetails/hero_more_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hero_application/Services/hero_database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class HeroDetailScreen extends StatefulWidget {
  final HeroModel hero;
  final double _expandedBottomSheetBottom = 0;
  final double _collapsedBottomSheetBottom = -80;
  final double _completeCollapsedBottomSheetBottom = -330;
  final List<Color> colors;

  const HeroDetailScreen({Key? key, required this.hero, required this.colors})
      : super(key: key);

  @override
  _HeroDetailScreenState createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen>
    with AfterLayoutMixin<HeroDetailScreen> {
  double _bottomSheetBottom = -330;
  bool isCollapsed = false;
  bool isEnableDelete = false;

  late String id;
  late String heroName;
  late dynamic bornDate;
  late String citizenship;
  late String domain;
  late String biography;
  late String imageUrl;
  late String addedUserId;

  @override
  void initState() {
    super.initState();
    id = widget.hero.id;
    heroName = widget.hero.heroName;
    bornDate = widget.hero.bornDate;
    citizenship = widget.hero.citizenship;
    domain = widget.hero.domain;
    biography = widget.hero.biography;
    imageUrl = widget.hero.imageUrl;
    addedUserId = widget.hero.addedUserId;
  }

  @override
  Widget build(BuildContext context) {
    isEnableDelete = addedUserId == context.watch<User?>()!.uid ? true : false;
    final screenHeight = MediaQuery.of(context).size.height;

    final Stream<QuerySnapshot> _selectedHeroStream =
        new HeroDatabaseServices().getHeroByName(heroName.toString());

    // final Stream<QuerySnapshot> _selectedHeroStream = FirebaseFirestore.instance
    //     .collection('Heroes')
    //     .where("HeroName", isEqualTo: widget.hero.heroName.toString())
    //     .snapshots();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: "background-${widget.hero.heroName}",
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.colors,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16),
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.close),
                    color: Colors.white.withOpacity(0.9),
                    onPressed: () {
                      setState(() {
                        _bottomSheetBottom =
                            widget._completeCollapsedBottomSheetBottom;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Hero(
                      tag: "image-${widget.hero.heroName}",
                      child:
                          Image.network(imageUrl, height: screenHeight * 0.45)),

                  // child: Image.asset(widget.hero.imageUrl,
                  //     height: screenHeight * 0.45)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                  child: Hero(
                      tag: "name-${widget.hero.heroName}",
                      child: Material(
                          color: Colors.transparent,
                          child: Container(
                              child: Text(heroName, style: AppTheme.heading)))),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _selectedHeroStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          'Something went wrong',
                          style: TextStyle(color: Colors.red, fontSize: 45),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
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
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;

                      biography = documents[0]['Biography'];
                      citizenship = documents[0]['Citizenship'];
                      domain = documents[0]['Domain'];

                      return HeroMoreDetailsWidget(
                          hero: new HeroModel(
                              id: documents[0].id,
                              heroName: documents[0]['HeroName'],
                              bornDate: DateTime.parse(
                                  documents[0]['BornDate'].toDate().toString()),
                              citizenship: documents[0]['Citizenship'],
                              domain: documents[0]['Domain'],
                              biography: documents[0]['Biography'],
                              imageUrl: documents[0]['ImageUrl'],
                              addedUserId: documents[0]['AddedUserId']));
                    }),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.decelerate,
            bottom: _bottomSheetBottom,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: _onTap,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      child: Text(
                        "  Action",
                        style:
                            AppTheme.subHeading.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    child: ActionWidget(
                        hero: new HeroModel(
                            id: id,
                            heroName: heroName,
                            bornDate: bornDate,
                            citizenship: citizenship,
                            domain: domain,
                            biography: biography,
                            imageUrl: imageUrl,
                            addedUserId: addedUserId),
                        isEnableDelete: isEnableDelete),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _onTap() {
    setState(() {
      _bottomSheetBottom = isCollapsed
          ? widget._expandedBottomSheetBottom
          : widget._collapsedBottomSheetBottom;

      isCollapsed = !isCollapsed;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isCollapsed = true;
        _bottomSheetBottom = widget._collapsedBottomSheetBottom;
      });
    });
  }
}
