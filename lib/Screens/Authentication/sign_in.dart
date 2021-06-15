import 'package:hero_application/Services/authentication_service.dart';
import 'package:hero_application/Shared/constants.dart';
import 'package:hero_application/Shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // Text field state
  String UserEmail = '';
  String UserPassword = '';

  //Show error dialog
  void _showErrorDialog(String msg){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Please try again ',
      desc: 'Could not sign in with provided credentials!',
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(


      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0.0,
        title:  AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Sign In to HeroApp!',
              textStyle: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 600),
            ),
          ],

          totalRepeatCount: 4,
          pause: const Duration(milliseconds: 400),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () => Navigator.pushReplacementNamed(context, "/register"),
          ),
        ],
      ),


//Gradient the background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: TileMode.mirror,
            begin: Alignment(-0.8, -1.0),
            end: Alignment.bottomRight,
            colors: [
              Color(0xc1f436f2),
              Color((0xff4f21f3)),
            ],
            stops: [
              0,
              1,
            ],
          ),
          backgroundBlendMode: BlendMode.srcOver,
        ),
        padding: EdgeInsets.symmetric(vertical: 63.0, horizontal: 30.0),
//Form to validate the inputs
        child: Form(

          key: _formKey,
          child:ClipRect(
            child:SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  ClipRRect(

                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network('https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400px.gif'),

                  ),

                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => UserEmail = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                    onChanged: (val) {
                      setState(() => UserPassword = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.purple[800],

                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.signIn(UserEmail:UserEmail, UserPassword:UserPassword);
                          if(result == null) {
                            setState(() {
                              loading = false;
                              var errorMsg = 'Could not sign in with those credentials';
                              _showErrorDialog(errorMsg);
                            });
                          }
                          else{
                            setState(() {
                              loading = false;
                            });
                            Navigator.pushReplacementNamed(context, "/home");
                          }
                        }
                      }
                  ),
                  SizedBox(height: 12.0),
                  RaisedButton(
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.pink[400],
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() => loading = true);
                        dynamic result = await _auth.signInAnon();
                        if(result == null) {
                          setState(() {
                            loading = false;
                            error = 'Something went wrong!';
                          });
                        }else{
                          setState(() {
                            loading = false;
                          });
                          Navigator.pushReplacementNamed(context, "/home");
                        }
                      }

                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 15.0),
                  ),


                ],
              ),
            ),

          ),


        ),


      ),
    );
  }
}