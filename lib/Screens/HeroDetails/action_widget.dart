import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Services/hero_database_services.dart';
import 'package:hero_application/Shared/alert_dialog.dart';
import 'package:hero_application/Screens/HeroHome/HeroManagement/hero_model_popup.dart';
import 'package:hero_application/Screens/HeroHome/HeroManagement/hero_model_popup_route.dart';

class ActionWidget extends StatefulWidget {
  const ActionWidget(
      {Key? key, required this.hero, required this.isEnableDelete})
      : super(key: key);

  final HeroModel hero;
  final bool isEnableDelete;

  @override
  _ActionWidget createState() => _ActionWidget();
}

class _ActionWidget extends State<ActionWidget> {
  Future manipulateHero(String id) async {
    await Future.delayed(Duration(seconds: 2));
    String state;
    state = await new HeroDatabaseServices().deleteHero(id);
    return state;
  }

  void _fnDeleteHero(HeroModel hero) {
    showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(manipulateHero(hero.id),
          message: Text('Please wait. Hero deleting...')),
    ).then((value) {
      if (value == "SUCCESS") {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Done',
            desc: "Hero deleted successfully.",
            dismissOnTouchOutside: false,
            btnOkOnPress: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/home");
            })
          ..show();
      } else {
        showAlertDialog(context, true, "Oops, Something went wrong!",
            "Error occurred while hero deleting. Please Delete hero again.");
      }
    });
  }

  void _fnEditHero(HeroModel hero) {
    Navigator.of(context).push(HeroModelPopupRoute(builder: (context) {
      return HeroModelPopup(
        heroModel: hero,
        type: "EDIT",
        popUpHandler: "",
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(
        horizontal: 50,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => _fnEditHero(widget.hero),
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 24.0,
                ),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  onPrimary: Colors.white,
                  primary: Colors.green[700],
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: widget.isEnableDelete
                    ? () => _fnDeleteHero(widget.hero)
                    : null,
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 24.0,
                ),
                label: Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  onPrimary: Colors.white,
                  primary: Colors.red[700],
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
