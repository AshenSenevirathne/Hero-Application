/*
*   Dart core dependency imports
* */
import 'package:flutter/material.dart';

/*
* Custom dependency import
* */
import 'package:hero_application/Shared/constants.dart';

class TopBar extends StatelessWidget {
  final Size size;

  const TopBar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25.0),
      height: size.height * 0.2,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              right: defaultPadding,
              bottom: 35 + defaultPadding,
              left: defaultPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
              color: primary_color,
            ),
            height: size.height * 0.2 - 20,
            child: Row(
              children: <Widget>[
                Text(
                  'My Heroes',
                  style: TextStyle(
                      color: light_color,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      fontFamily: "LobsterTwo-Regular"),
                ),
                Spacer(),
                Image.asset(
                  "assets/images/hero1.png",
                  width: 100.0,
                  height: 30.0,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: defaultPadding),
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              height: 45,
              decoration: BoxDecoration(
                color: light_color,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: primary_color.withOpacity(0.25),
                    blurRadius: 10,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: primary_color.withOpacity(0.4),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
