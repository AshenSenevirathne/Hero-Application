import 'package:flutter/material.dart';

/*
*  Constants for colors
* */
const primary_color = Colors.deepPurple;
const secondary_color = Color(0xff9d0191);
const light_color = Color(0xffffffff);
const dark_color = Color(0xff000000);
const danger_color = Color(0xffef5350);
const success_color = Colors.green;
const warning_color = Color(0xfffecd1a);
const sweet_color = Color(0xfffd3a69);
const body_color = Color(0xffeeeeee);

/*
* Domain List
* */
final List<String> domainType = ['Education', 'Movie', 'Political', 'Sports'];

/*
* Keys
* */
const String heroModelPopupKey = 'add-todo-hero';

/*
* Widget Decorators
* */

getTextInputDecorations(defaultColor) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: defaultColor, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: defaultColor, width: 2.0),
    ),
  );
}

const double defaultPadding = 20.0;

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);
