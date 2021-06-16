import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardDatabaseService {
  CollectionReference heroes = FirebaseFirestore.instance.collection('Heroes');

  Stream<QuerySnapshot> getHero() {
    return heroes.snapshots();
  }
}
