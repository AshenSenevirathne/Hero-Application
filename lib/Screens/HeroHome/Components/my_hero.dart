import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Screens/HeroHome/HeroManagement/hero_model_popup.dart';
import 'package:hero_application/Screens/HeroHome/HeroManagement/hero_model_popup_route.dart';
import 'package:hero_application/Shared/constants.dart';


class MyHero extends StatefulWidget {
  final HeroModel heroModel;

  MyHero({required this.heroModel});

  @override
  _MyHeroState createState() => _MyHeroState();
}

class _MyHeroState extends State<MyHero> {
  late HeroModel heroModel;
  late String popUpHandler;

  @override
  void initState() {
    super.initState();
    heroModel = widget.heroModel;
    popUpHandler = widget.heroModel.id;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
      child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(heroModel.imageUrl),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          heroModel.heroName,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Spacer(),
                          Hero(
                            tag: popUpHandler,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      HeroModelPopupRoute(builder: (context) {
                                    return HeroModelPopup(
                                      heroModel: heroModel,
                                      type: "EDIT",
                                      popUpHandler: popUpHandler,
                                    );
                                  }));
                                },
                                icon: Icon(Icons.edit),
                                color: success_color,
                                iconSize: 30,
                              ),
                            ),
                          ),
                           Card(
                             elevation: 1,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(50),
                             ),
                             child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete),
                              color: danger_color,
                              iconSize: 30,
                          ),
                           ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
