import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/Animation/FadeAnimation.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/screens/forget_password.dart';

import 'package:notification/screens/main_screen.dart';
import 'package:notification/util/auth.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/util/validators.dart';
import 'package:notification/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

final style2 = GoogleFonts.poppins(
    color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600);
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
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: LoadingScreen(
            inAsyncCall: _loadingVisible,
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: double.infinity,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(height: dh/3),
                                // Align(
                                //   alignment: Alignment.center,
                                //   child: new Container(
                                //     // color: Colors.red,
                                //     height:
                                //         MediaQuery.of(context).size.height / 5,
                                //     width: MediaQuery.of(context).size.width,
                                //     child: Image(
                                //         image: AssetImage('assets/13.png')),
                                //   ),
                                // ),



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
                                
                                // SizedBox(height: 20,),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: <Widget>[
                                  FadeAnimation(
                                      1.2,
                                      Text(
                                        "Login",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Color(0xff3A4276),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                  SizedBox(height: 15),
                                  FadeAnimation(
                                    1.2,
                                    makeUserNameField(
                                        label: "Email", obscureText: false),
                                  ),
                                  FadeAnimation(
                                      1.3,
                                      makePasswordField(
                                          label: "Password",
                                          obscureText: true)),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                            ),
                            FadeAnimation(
                                1.4,
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Container(
                                  
                                  
                                    child: MaterialButton(
                                      minWidth: 108,
                                      height: 40,
                                      onPressed: () {
                                        _emailLogin(
                                            email: _email.text,
                                            password: _password.text,
                                            context: context);
                                      },
                                      color: Color(0xff5F2EEA),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Text(
                                        "Login",
                                        style: style2.copyWith(
                                                fontSize: 14,
                                                color: Color(0xffF7F7FC),
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.75),
                                      ),
                                    ),
                                  ),
                                )),
                                Container(
                              height: 4,
                            ),
                            FadeAnimation(
                                1.5,
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/signup');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0.0, top: 1),
                                    child: 
                                       
                                        Text(
                                          "Signup",
                                          style: style2.copyWith(
                                                fontSize: 16,
                                                color: Color(0xff4E4B66),
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.75),
                                        ),
                                      
                                    
                                  ),
                                )),
                            Container(
                              height: 100,
                            ),
                                 Container(
                                          alignment: Alignment.bottomCenter,
                                          // padding: EdgeInsets.only(top: 15.0, left: 20.0,right:18),
                                          child: InkWell(
                                            onTap: () {
                                              //  Navigator.pushNamed(context, '/forgot-password');

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPasswordScreen(),
                                                  ));

                                              //  StateWidget.of(context).resetPassword('nithe.nithesh@gmail.com');
                                            },
                                            child: Text(
                                              'Forgot Password?',
                                              style: style2.copyWith(
                                                fontSize: 14,
                                                color: Color(0xffA0A3BD),
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.75),
                                            ),
                                          ),
                                        ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  Widget builUsername() {
    return Container(
      width: double.infinity,
      height: 58,
      child: Padding(
          padding: EdgeInsets.only(top: 4, left: 24, right: 16),
          child:TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: false,
                                    controller: _email,
                                    validator: Validator.validateEmail,
                                    decoration: InputDecoration(
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                            border: OutlineInputBorder(
                                            borderSide:
                                               new  BorderSide(color: Color(0xFFE7E7E7))),
                                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFE7E7E7)))
                                           
                                                ),
                                  )
          ),
    );
  }

  Widget buildPasswordBox() {
    return Container(
      width: double.infinity,
      height: 58,
      child: Padding(
          padding: EdgeInsets.only(top: 4, left: 24, right: 16),
          child: TextFormField(
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
                    borderSide: new BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE7E7E7)))),
          )),
    );
  }

  void _emailLogin(
      {String email, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
        await StateWidget.of(context).logInUser(email, password);

        appState = StateWidget.of(context).state;
        final userId = appState?.firebaseUserAuth?.uid ?? '';

        final approvedGroups = appState?.user?.approvedGroups;
        final followingGroups = await appState.followingGroups;
        var followingGroupsReadCountLocal = [];

        await followingGroups.forEach((data) async {
          // search for the rc count and update it
          var NotifySnap =
              await FirebaseController.instanace.getMessagesCount(data);

          // followingGroupsLocal = data.cast<String>();
          await followingGroupsReadCountLocal
              .add({"id": data, "count": NotifySnap['c']});
        });

        await Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
              builder: (BuildContext context) => MainScreen(
                  userId: userId,
                  followingGroupsLocal: followingGroups,
                  followingGroupsReadCountLocal: followingGroupsReadCountLocal),
            ),
            (Route<dynamic> route) => false);
      } catch (e) {
        _changeLoadingVisible();

        String exception = Auth.getExceptionText(e);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Sign In Error ${exception}"),
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
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          style: TextStyle(color: Colors.black),
          obscureText: obscureText,
          autofocus: false,
          controller: _password,
          validator: Validator.validatePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget makeUserNameField({label, obscureText = false}) {
TextStyle textStyle = Theme.of(context).textTheme.title;
    // return Padding(
    //                 padding: EdgeInsets.only(
    //                     top: 5.0, bottom: 5.0),
    //                 child: TextFormField(
    //                   keyboardType: TextInputType.number,
    //                   style: textStyle,
    //                   controller: _email,
    //                   validator: (String value) {
    //                     if (value.isEmpty) {
    //                       return 'Please enter principal amount';
    //                     }
    //                   },
    //                   decoration: InputDecoration(
    //                       labelText: 'Principal',
    //                       hintText: 'Enter Principal e.g. 12000',
    //                       labelStyle: textStyle,
    //                       errorStyle: TextStyle(
    //                         color: Colors.yellowAccent,
    //                         fontSize: 15.0
    //                       ),
    //                       border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(5.0))),
    //                 ));

    return  Container(
        
  height: 64,
        decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Color(0xffEFF0F6),
    
  ),
        
          child: TextFormField(
           
                                          keyboardType: TextInputType.emailAddress,
                                          autofocus: false,
                                          controller: _email,
                                          validator: Validator.validateEmail,
                                          decoration: InputDecoration(
                                              //floatingLabelBehavior:FloatingLabelBehavior.always,
                                           contentPadding: EdgeInsets.only(top: 6,bottom: 4,left: 20,right: 6),
                                              labelText: 'Email',
                                              labelStyle: style2.copyWith(
                                                      fontSize: 14,
                                                      color: Color(0xff6E7191),
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 0.25),
                                                      border: InputBorder.none,
                                                  // border: OutlineInputBorder(
                                                  //   borderRadius:BorderRadius.circular(20.0),
                                                  // borderSide:
                                                  //    new  BorderSide(color: Color(0xff14142B))),

                                               

                                          //             focusedBorder: OutlineInputBorder(
                                          //               borderRadius:BorderRadius.circular(20.0),
                                          // borderSide:
                                          //     BorderSide(color: Colors.red))
                                                 
                                                      ),
                                        
        ),
      
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          style: TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          obscureText: obscureText,
          controller: _email,
          validator: Validator.validateEmail,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
