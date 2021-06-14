import 'package:hero_application/Models/user.dart';
import 'package:hero_application/Services/authentication_service.dart';
import 'package:hero_application/Shared/constants.dart';
import 'package:hero_application/Shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
//import 'package:country_picker/country_picker.dart';



class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String UserEmail = '';
  String UserPassword = '';
  String UserName='';
  String Country='';
  String UserMobile='';
  String citizenship='';


  //Show error message dialog
  void _showErrorDialog(String msg){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Please try again ',
      desc: 'User already exists!',
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
        title: Text('Sign up to Hero App'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person_add),
            label: Text('Sign In'),
            onPressed: () => Navigator.pushReplacementNamed(context, "/signIn"),
          ),
        ],
      ),


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
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
        child: Form(
          key: _formKey,


          child: Column(
            children: <Widget>[


              SizedBox(height: 15.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email!' : null,
                onChanged: (val) {
                  setState(() => UserEmail = val);
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password with six characters!' : null,
                onChanged: (val) {
                  setState(() => UserPassword = val);
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Name'),

                  validator: (val){
                    if(val!.isEmpty){
                      return 'Please enter your name!';
                    }
                    return null;
                  },
                  onSaved: (value){

                  }
              ),

              SizedBox(height: 15.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Mobile Number'),

                  validator: (val){
                    if(val!.isEmpty||val.length>10||val.length<10){
                      return 'Please enter a valid number!';
                    }
                    return null;
                  },
                  onSaved: (val){

                  }
              ),

              SizedBox(height: 15.0),
              TextFormField(

                  decoration: textInputDecoration.copyWith(hintText: 'Country'),

                  validator: (val){
                    if(val!.isEmpty){
                      return 'Please enter a Country!';
                    }
                    return null;
                  },
                  onSaved: (val){

                  }
              ),

              SizedBox(height: 15.0),
              RaisedButton(
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.pink[400],
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() => loading = true);
                      UserData userData = new UserData(id: "", userEmail: UserEmail, userPassword: UserPassword, userName: UserName, userMobile: UserMobile, country: Country);
                      dynamic result = await _auth.signUp(userData : userData);
                      if(result == null || result == "Error") {
                        setState(() {
                          loading = false;
                          error = 'Please provide a valid email';
                          _showErrorDialog(error);
                        });
                      }else{
                        setState(() {
                          loading=false;
                        });
                      }
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  }
              ),
            /*  OutlinedButton.icon(
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    countryListTheme:
                    CountryListThemeData(
                      borderRadius:
                      BorderRadius.only(
                        topLeft:
                        Radius.circular(20.0),
                        topRight:
                        Radius.circular(20.0),
                      ),
                    ),
                   *//* onSelect: (Country country) {
                      setState(() {
                        citizenship =
                            country.displayName;
                      });
                    },*//*

                  );
                },
                icon: Icon(Icons.public),
                label:
                Text("Select Hero Citizenship"),
              ),*/


              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}