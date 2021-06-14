/*
*   Dart core dependency imports
* */
import 'dart:io';
import 'package:path/path.dart';

/*
*   Firebase dependency imports
* */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/*
* Custom dependency import
* */
import 'package:hero_application/Models/hero_model.dart';


/*
*   Manage hero database services
* */
class HeroDatabaseServices {

  // Heroes database reference
  CollectionReference heroes = FirebaseFirestore.instance.collection('Heroes');

  //Function to add hero
  Future<String> addHero(HeroModel heroModel) async {
    return await heroes.add({
      "HeroName": heroModel.heroName,
      "BornDate": heroModel.bornDate,
      "Citizenship": heroModel.citizenship,
      "Domain": heroModel.domain,
      "Biography": heroModel.biography,
      "ImageUrl": heroModel.imageUrl,
      "AddedUserId": heroModel.addedUserId,
    }).then((value) {
      return "SUCCESS";
    }).catchError((error) {
      return "ERROR";
    });
  }

  // Function to edit hero
  Future<String> updateHero(HeroModel heroModel) async {
    return await heroes.doc(heroModel.id).set({
      "HeroName": heroModel.heroName,
      "BornDate": heroModel.bornDate,
      "Citizenship": heroModel.citizenship,
      "Domain": heroModel.domain,
      "Biography": heroModel.biography,
      "ImageUrl": heroModel.imageUrl,
      "AddedUserId": heroModel.addedUserId,
    }).then((value) {
      return "SUCCESS";
    }).catchError((error) {
      return "ERROR";
    });
  }

  // Function to upload file to firebase
  Future<String> uploadFile(File file) async {

    // Create reference to image
    String ref = 'Heroes/${DateTime.now().millisecondsSinceEpoch.toString() + "_" + basename(file.path)}';

    try {
      await firebase_storage.FirebaseStorage.instance.ref(ref).putFile(file);
      return await firebase_storage.FirebaseStorage.instance
          .ref(ref)
          .getDownloadURL();
    } on FirebaseException catch (e) {
      return "ERROR";
    }
  }
}
