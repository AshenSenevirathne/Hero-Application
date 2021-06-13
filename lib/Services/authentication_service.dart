import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hero_application/Models/User.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  AuthenticationService();

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
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
    return users.doc(id).set({
      'UserEmail': userData.userEmail,
      'UserName': userData.userName,
      'UserMobile': userData.userMobile,
      'Country': userData.country
    }).then((value) => "Added")
        .catchError((error) => "Error");
  }



  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
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