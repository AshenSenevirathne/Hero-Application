/*
*   Dart core dependency imports
* */
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
* Package dependency import
* */
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:country_picker/country_picker.dart';

/*
* Custom dependency import
* */
import 'package:hero_application/Models/hero_model.dart';
import 'package:hero_application/Models/validation.dart';
import 'package:hero_application/Services/hero_database_services.dart';
import 'package:hero_application/Shared/alert_dialog.dart';
import 'package:hero_application/Shared/constants.dart';

/*
* Model popup for insert and update process if the hero
* */
class HeroModelPopup extends StatefulWidget {
  // Declare attributes
  final HeroModel heroModel;
  final String type;
  final String popUpHandler;

  // Initialization attributes
  HeroModelPopup(
      {required this.heroModel,
      required this.type,
      required this.popUpHandler});

  @override
  _HeroModelPopupState createState() => _HeroModelPopupState();
}

class _HeroModelPopupState extends State<HeroModelPopup> {

  // Declare state attributes
  int _index = 0;
  late String id;
  late String heroName;
  late dynamic bornDate;
  late String citizenship;
  late String domain;
  late String biography;
  late String imageUrl;
  late String addedUserId;
  late String type;
  late MaterialColor defaultColor;
  late String key;
  File? file;

  // Initialize state attributes
  @override
  void initState() {
    super.initState();
    id = widget.heroModel.id;
    heroName = widget.heroModel.heroName;
    bornDate = widget.type == "CREATE" ? "" : widget.heroModel.bornDate;
    citizenship = widget.heroModel.citizenship;
    domain = widget.heroModel.domain;
    biography = widget.heroModel.biography;
    imageUrl = widget.heroModel.imageUrl;
    addedUserId = widget.heroModel.addedUserId;
    type = widget.type;
    key = widget.popUpHandler;
    defaultColor = widget.type == "CREATE" ? primary_color : success_color;
  }

  @override
  Widget build(BuildContext context) {

    // Method to move next form step
    onStepCancel() {
      if (_index > 0) {
        setState(() {
          _index -= 1;
        });
      }
    }

    // Method to validate step content
    validate() {
      bool isValid = true;
      String response = "";
      if (_index == 0) {
        if (imageUrl == "" || !Uri.parse(imageUrl).isAbsolute) {
          response = "Please enter valid image url.";
          isValid = false;
        }
      } else if (_index == 1) {
        if (heroName == "") {
          response = "Please enter hero name.";
          isValid = false;
        } else if (domain == "") {
          response = "Please enter hero domain.";
          isValid = false;
        } else if (citizenship == "") {
          response = "Please enter hero country.";
          isValid = false;
        } else if (bornDate == "") {
          response = "Please enter hero born date.";
          isValid = false;
        }
      } else {
        if (biography == "") {
          response = "Please enter hero biography.";
          isValid = false;
        }
      }

      return new Validation(status: isValid, response: response);
    }

    // Call firebase file upload function
    Future fileUploadToFirebase(String path) async {
      return await new HeroDatabaseServices().uploadFile(File(path));
    }

    // Select file from device and upload file to firebase
    Future selectFile() async {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result == null) return;
      final path = result.files.single.path!;

      showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(fileUploadToFirebase(path),
            message: Text('Please wait. Image uploading...')),
      ).then((value) {
        if (value == "ERROR") {
          showAlertDialog(context, true, "Oops, Something went wrong!",
              "Error occurred while image uploading, Please Upload image again.");
        } else {
          setState(() {
            imageUrl = value;
          });
        }
      });
    }

    // Create or Update hero according to call type
    Future manipulateHero() async {
      await Future.delayed(Duration(seconds: 2));
      HeroModel newHero = new HeroModel(
          id: id,
          heroName: heroName,
          bornDate: bornDate,
          citizenship: citizenship,
          domain: domain,
          biography: biography,
          imageUrl: imageUrl,
          addedUserId: addedUserId);
      String state;
      if (type == "CREATE") {
        state = await new HeroDatabaseServices().addHero(newHero);
      } else {
        state = await new HeroDatabaseServices().updateHero(newHero);
      }
      return state;
    }

    // Move to to forward in the form and in the final stage call the respective hero management function accordingly
    onStepContinue() async{
      Validation validation = validate();
      if (validation.status) {
        if (_index < 2) {
          setState(() {
            _index += 1;
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => FutureProgressDialog(manipulateHero(),
                message: Text(
                    'Please wait. Hero ${type == "CREATE" ? "creating" : "updating"}...')),
          ).then((value) {
            if (value == "SUCCESS") {
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Done',
                  desc:"Hero ${type == "CREATE" ? "created" : "updated"} successfully.",
                  dismissOnTouchOutside: false,
                  btnOkOnPress: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/heroHome");
                  })..show();
            } else {
              showAlertDialog(context, true, "Oops, Something went wrong!",
                  "Error occurred while hero ${type == "CREATE" ? "creating" : "updating"}. Please ${type == "CREATE" ? "create" : "update"} hero again.");
            }
          });
        }
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Form Validation Error!',
            desc:validation.response,
            btnOkColor: danger_color,
            btnOkOnPress: () {
            })..show();
      }
    }

    // Return form content
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Hero(
          tag: key,
          child: Material(
            color: light_color,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: SingleChildScrollView(
              child: Theme(
                data: ThemeData(
                    accentColor: defaultColor, primarySwatch: defaultColor),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Row(children: [
                      Text(
                        type == "CREATE" ? "Create Hero" : "Update Hero",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: defaultColor,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: defaultColor,
                      ),
                    ]),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Stepper(
                      currentStep: _index,
                      onStepCancel: onStepCancel,
                      onStepContinue: onStepContinue,
                      controlsBuilder:
                          (context, {onStepCancel, onStepContinue}) => Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Row(
                          children: [
                            OutlinedButton(
                                onPressed: _index == 0 ? null : onStepCancel,
                                child: Text("Back")),
                            Spacer(),
                            ElevatedButton(
                              onPressed: onStepContinue,
                              child: _index == 2
                                  ? Text(type == "CREATE" ? "Create" : "Update")
                                  : Text("Next"),
                            ),
                          ],
                        ),
                      ),
                      steps: <Step>[
                        Step(
                          isActive: _index == 0 ? true : false,
                          state: StepState.indexed,
                          title: const Text(' Hero Image'),
                          content: Form(
                            child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 115,
                                      width: 115,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        fit: StackFit.expand,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                (imageUrl != "")
                                                    ? imageUrl
                                                    : "https://cdn1.vectorstock.com/i/1000x1000/51/05/male-profile-avatar-with-brown-hair-vector-12055105.jpg"),
                                          ),
                                          Positioned(
                                              bottom: 0,
                                              right: -25,
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  selectFile();
                                                },
                                                elevation: 2.0,
                                                fillColor: defaultColor,
                                                child: Icon(
                                                  Icons.cloud_upload_outlined,
                                                  color: light_color,
                                                ),
                                                shape: CircleBorder(),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      key: Key(imageUrl.toString()),
                                      initialValue: imageUrl,
                                      decoration:
                                          getTextInputDecorations(defaultColor)
                                              .copyWith(
                                                  hintText: 'Paste Image URL',
                                                  labelText: "Image URL"),
                                      style: TextStyle(color: defaultColor),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter Image URL'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => imageUrl = val);
                                      },
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Step(
                          isActive: _index == 1 ? true : false,
                          title: Text('Hero Details'),
                          content: Container(
                              child: Column(
                            children: [
                              SizedBox(height: 5),
                              TextFormField(
                                initialValue: heroName,
                                decoration:
                                    getTextInputDecorations(defaultColor)
                                        .copyWith(
                                  hintText: 'Hero Name',
                                  labelText: 'Hero Name',
                                ),
                                style: TextStyle(color: defaultColor),
                                validator: (val) => val!.isEmpty
                                    ? "Please Enter Hero Name"
                                    : null,
                                autofocus: false,
                                onChanged: (val) {
                                  setState(() => heroName = val);
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              DropdownButtonFormField<String>(
                                value: type == "CREATE" ? null : domain,
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: defaultColor,
                                ),
                                autofocus: false,
                                decoration:
                                    getTextInputDecorations(defaultColor)
                                        .copyWith(
                                  hintText: 'Hero Domain',
                                  labelText: 'Hero Domain',
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: defaultColor),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    domain = newValue!;
                                  });
                                },
                                items: domainType.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Citizenship",
                                  style: TextStyle(color: defaultColor),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: citizenship != ""
                                      ? Chip(
                                          avatar: CircleAvatar(
                                            child: Icon(Icons.public,
                                                color: light_color, size: 15),
                                          ),
                                          label: Text(
                                            citizenship,
                                            style:
                                                TextStyle(color: light_color),
                                          ),
                                          backgroundColor: defaultColor,
                                          deleteIcon: Icon(
                                            Icons.close_outlined,
                                            color: light_color,
                                            size: 12,
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              citizenship = "";
                                            });
                                          },
                                        )
                                      : null),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: citizenship == ""
                                      ? OutlinedButton.icon(
                                          onPressed: () {
                                            showCountryPicker(
                                              context: context,
                                              countryListTheme:
                                                  CountryListThemeData(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(20.0),
                                                  topRight:
                                                      Radius.circular(20.0),
                                                ),
                                              ),
                                              onSelect: (Country country) {
                                                setState(() {
                                                  citizenship =
                                                      country.displayName;
                                                });
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.public),
                                          label:
                                              Text("Select Hero Citizenship"),
                                        )
                                      : null),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Born Date",
                                  style: TextStyle(color: defaultColor),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: bornDate != ""
                                      ? Chip(
                                          avatar: CircleAvatar(
                                            child: Icon(Icons.date_range,
                                                color: light_color, size: 15),
                                          ),
                                          label: Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(bornDate)
                                                .toString(),
                                            style:
                                                TextStyle(color: light_color),
                                          ),
                                          backgroundColor: defaultColor,
                                          deleteIcon: Icon(
                                            Icons.close_outlined,
                                            color: light_color,
                                            size: 12,
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              bornDate = "";
                                            });
                                          },
                                        )
                                      : null),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: bornDate == ""
                                      ? OutlinedButton.icon(
                                          onPressed: () {
                                            showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    lastDate: DateTime.now(),
                                                    firstDate: DateTime(1900))
                                                .then((date) {
                                              setState(() {
                                                bornDate = date;
                                              });
                                            });
                                          },
                                          icon: Icon(Icons.date_range),
                                          label: Text("Select Hero Born Date"),
                                        )
                                      : null),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          )),
                        ),
                        Step(
                          isActive: _index == 2 ? true : false,
                          title: Text('Hero Biography'),
                          content: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                TextFormField(
                                  initialValue: biography,
                                  maxLines: 10,
                                  decoration:
                                      getTextInputDecorations(defaultColor)
                                          .copyWith(
                                    hintText: 'Hero Biography',
                                    labelText: 'Hero Biography',
                                  ),
                                  autofocus: false,
                                  style: TextStyle(color: defaultColor),
                                  validator: (val) => val!.isEmpty
                                      ? "Please Enter Hero Biography"
                                      : null,
                                  onChanged: (val) {
                                    setState(() => biography = val);
                                  },
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
