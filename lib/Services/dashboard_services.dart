import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hero_application/Models/hero_model.dart';

class DashboardDatabaseService {
  CollectionReference heroes = FirebaseFirestore.instance.collection('Heroes');

  Stream<QuerySnapshot> getHero() {
    return heroes.snapshots();
  }
}
