import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification/Animation/FadeAnimation.dart';
import 'package:notification/screens/forget_password.dart';

import 'package:notification/screens/main_screen.dart';
import 'package:notification/util/auth.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/util/validators.dart';
import 'package:notification/widgets/loading.dart';


class MySignInScreenHome extends StatefulWidget {
  @override
  _MySignInScreenHomeState createState() => _MySignInScreenHomeState();
}

class _MySignInScreenHomeState extends State<MySignInScreenHome> {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = new TextEditingController();

  final TextEditingController _password = new TextEditingController();

  bool _autoValidate = false;

  bool _loadingVisible = false;
    StateModel appState; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: LoadingScreen(
         inAsyncCall: _loadingVisible,
          child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[

                      Align(
                        alignment: Alignment.center,
                        child: new Container(
              height: MediaQuery.of(context).size.height / 12,
              child: Image(image: AssetImage('assets/logo.png')),
            
            ),
                    //  child: Container(
                    //   width: 160,
                    //     child: Row(
                    //       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       // crossAxisAlignment: CrossAxisAlignment.stretch,
                    //       children: <Widget>[
                    //         FadeAnimation(1, Text("Chat", style: TextStyle(
                    //           fontSize: 30,
                    //           fontWeight: FontWeight.bold
                    //         ),)),
                    //         FadeAnimation(1, Text("O", style: TextStyle(
                    //           fontSize: 30,
                    //           fontWeight: FontWeight.bold
                    //         ),)),
                    //         FadeAnimation(1, Text("gram", style: TextStyle(
                    //           fontSize: 30,
                    //           fontWeight: FontWeight.bold
                    //         ),)),
                    //       ],
                    //     ),
                    //   ),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(1.2, Text("Login to your account", style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700]
                      ),)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(1.2, makeUserNameField(label: "Email", obscureText: false),),
                        FadeAnimation(1.3, makePasswordField(label: "Password", obscureText: true)),
                      ],
                    ),
                  ),
                  FadeAnimation(1.4, Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                                                           _emailLogin(
                                email: _email.text, password: _password.text, context: context);
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Login", style: TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 18
                        ),),
                      ),
                    ),
                  )),
                  FadeAnimation(1.5, InkWell(
                    onTap: (){ 
                      Navigator.of(context).pushNamed('/signup');}  ,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            alignment: Alignment(1.0, 0.0),
                            // padding: EdgeInsets.only(top: 15.0, left: 20.0,right:18),
                            child: InkWell(
                              onTap: (){
                                //  Navigator.pushNamed(context, '/forgot-password');

                                   Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ForgotPasswordScreen(
                                                              ),
                                                      ));
      
                                //  StateWidget.of(context).resetPassword('nithe.nithesh@gmail.com');
         
                              },
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                   ),
                              ),
                            ),
                        ),
                        Text("Sign up", style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18
                        ),),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
          )
      )
    );
  }

 Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

Widget builUsername(){
  return Container(
    width: double.infinity,
    height: 58,
 
    child: Padding(padding: EdgeInsets.only(top:4, left:24,right:16),
    child:TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            controller: _email,
                            validator: Validator.validateEmail,
                            decoration: InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                    border: OutlineInputBorder(
                                    borderSide:
                                      new  BorderSide(color:  Color(0xFFE7E7E7))),
                            
                                        ),
                          )
    ),
  );
}

Widget buildPasswordBox(){
  return Container(
    width: double.infinity,
    height: 58,
 
    child: Padding(padding: EdgeInsets.only(top:4, left:24,right:16),
    child:TextFormField(
                            // keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            obscureText: true,
                            controller: _password,
                            validator: Validator.validatePassword,
                            
                            decoration: InputDecoration(
                                labelText: 'PASSWORD',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                    border: OutlineInputBorder(
                                    borderSide:
                                      new  BorderSide(color: Colors.blue)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFE7E7E7)))),
                          )
    ),
  );
}

  void _emailLogin(
      {String email, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
        await StateWidget.of(context).logInUser(email, password);
        print('successfully validated');
                 appState = StateWidget.of(context).state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final followingGroups = await appState.followingGroups;
        await Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
        builder: (BuildContext context)
        => MainScreen(userId: userId,followingGroupsLocal: followingGroups),
        ),(Route<dynamic> route) => false);
        
      } catch (e) {
        _changeLoadingVisible();
        print("Sign In Error: $e");
        String exception = Auth.getExceptionText(e);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      "Sign In Error ${exception}"),
                                ));

      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  Widget makePasswordField({label, obscureText = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          obscureText: obscureText,
               autofocus: false,
          controller: _password,
                            validator: Validator.validatePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
  Widget makeUserNameField({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
           keyboardType: TextInputType.emailAddress,
          obscureText: obscureText,
          controller: _email,
          validator: Validator.validateEmail,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}