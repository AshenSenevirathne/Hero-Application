import 'package:flutter/material.dart';
import 'package:hero_application/Shared/constants.dart';

showAlertDialog(context, error, title, body) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: error ? danger_color : primary_color),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                body,
                style: TextStyle(color: primary_color),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
