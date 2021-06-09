import 'package:flutter/material.dart';

/*
*  Colors
* */
const primary_color = Colors.deepPurple;
const secondary_color = Color(0xff9d0191);
const light_color = Color(0xffffffff);
const dark_color = Color(0xff000000);
const danger_color = Color(0xffef5350);
const success_color = Color(0xff8bc34a);
const warning_color = Color(0xfffecd1a);
const sweet_color = Color(0xfffd3a69);
const body_color = Color(0xffeeeeee);

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