import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hero_application/Models/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  AuthenticationService();

  ///This updated the dependency
  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


  Future<String?> signIn({required String UserEmail, required String UserPassword}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: UserEmail, password: UserPassword);
      return "Signed in";
    }catch (e) {
      print(e);
      return null;
    }
  }


  Future<String?> signInAnon() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      print(userCredential);
      return "Signed in Anonymous";
    } on FirebaseAuthException catch (e) {
       print(e.message);
       return null;
    }
  }

  Future<String?> addUser({required UserData userData, required String id}) {
    // Call the user's CollectionReference to add a new user
    print(userData.country);
    print(userData.userEmail);
    print(userData.userMobile);
    return users.doc(id).set({
      'UserEmail': userData.userEmail,
      'UserName': userData.userName,
      'UserMobile': userData.userMobile,
      'Country': userData.country
    }).then((value) => "Added")
        .catchError((error) => "Error");
  }



  ///own custom classes can be taken for return better and exception


  Future<String?> signUp({required UserData userData}) async {
    try {
      UserCredential userCredential =  await _firebaseAuth.createUserWithEmailAndPassword(email: userData.userEmail, password: userData.userPassword);
      print(userCredential);
      dynamic result =  await addUser(userData : userData, id : userCredential.user!.uid);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }
}