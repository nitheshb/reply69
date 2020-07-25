// import 'package:flutter/material.dart';
import 'package:notification/Animation/FadeAnimation.dart';
import 'package:notification/pages/forget_password.dart';
import 'package:notification/pages/sign_in.dart';
import 'package:notification/pages/sign_up.dart';
import 'package:notification/screens/main_screen.dart';
import 'package:notification/util/auth.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/util/validators.dart';
import 'package:notification/widgets/loading.dart';
// import 'package:prochats/pages/homeNavScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:test_app_1/Animation/FadeAnimation.dart';
// import 'package:test_app_1/bid365_app_theme.dart';
// import 'package:test_app_1/pages/homeNavScreen1.dart';
// import 'package:test_app_1/ui/screens/forgot_password.dart';
// import 'package:test_app_1/ui/screens/home.dart';
// import 'package:test_app_1/ui/screens/homeNew.dart';
// import 'package:test_app_1/ui/screens/signUp_Anim.dart';

// import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bid365_app_theme.dart';

// import 'package:test_app_1/util/state_widget.dart';
// import 'package:test_app_1/util/auth.dart';
// import 'package:test_app_1/util/validator.dart';
// import 'package:test_app_1/ui/widgets/loading.dart';

class MySignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage()
              },
              home: new MySignInScreenHome(),
            );
          }
        }
   

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  

  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: true,
        body: LoadingScreen(
          
          child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        ClipPath(
                          clipper: LoginImageClipper(),
                          child: Container(
                            width: double.infinity,
                            height:300,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  right: -260,
                                  bottom: -220,
                                  child: Image.asset(
                                  "assets/images/cricWall.jpg",
                                  fit: BoxFit.cover
                                )
                                ),
        //                          Positioned(
        //                           right: 0,
        //                           left: 0,
        //                           bottom: 0,
        //                           child: Container(
        //                             width: double.infinity,
        //                             height: 340,
        //           decoration: new BoxDecoration(
        //             gradient: LinearGradient(
        //   colors: [
        //     Color(0xFFE2B0FF).withOpacity(0.8),
        //     Color(0xFF9F44D3).withOpacity(0.05),
        //   ],
        //   begin: Alignment.bottomRight,
        //   end: Alignment.topCenter,
        // ),
                    

        //           ),
        //                         )
        //                         ),
                             Positioned(
                                  top: 50,
                                  left: 20,
                                  child:Text('FAN CHATS', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w900, color:Colors.redAccent,fontSize:30),)
                                  ),
                              ]
                            )
                          ),
                        ),                                 
                      ],
                    ),
             
                   
                  ),
                    Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                            Padding(padding: 
                               const EdgeInsets.only(left:10.0),
                               child:FlatButton(onPressed: (){
                                  Navigator.of(context).pushNamed('/signup');
                                  
                               }, child: 
                                Text('SIGN IN', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w900, color:Bid365AppTheme.nearlyBlack,fontSize:24),)
                               ),
                            ),
                           FlatButton(onPressed: (){
                                  Navigator.of(context).pushNamed('/signup');                                
                               }, child: 
                                Text('SIGN UP', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w900, color:Bid365AppTheme.nearlyBlack,fontSize:12),)
                               ),
                          ],),
                          SizedBox(height: 20),
                          builUsername(),
                          SizedBox(height:10.0),
                          buildPasswordBox(),
                           SizedBox(height: 5.0),
                          FadeAnimation(1.5,Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(top: 15.0, left: 20.0,right:18),
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
                          )), 
                           SizedBox(height:20),
                          // Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red.withOpacity(.5),
                            ),
                          ),
                          child: Icon(
                            Icons.android,
                            color: Colors.red.withOpacity(.5),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red.withOpacity(.5),
                            ),
                          ),
                          child: Icon(
                            Icons.chat,
                            color: Colors.red.withOpacity(.5),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                           onTap: (){
                                 _emailLogin(
                                email: _email.text, password: _password.text, context: context);
                              },
                          child:
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Bid365AppTheme.nearlyRed,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        )
                        )
                      ],
                    ),
                  ),
                
                ],
              ))),
          inAsyncCall: _loadingVisible,
        ));
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
     
        await Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
        builder: (BuildContext context)
        => MainScreen(),
        ),(Route<dynamic> route) => false);
        
      } catch (e) {
        _changeLoadingVisible();
        print("Sign In Error: $e");
        String exception = Auth.getExceptionText(e);
        //    Fluttertoast.showToast(
        // msg: "Sign In Error ${exception}",
        //    );
        // Flushbar(
        //   title: "Sign In Error",
        //   message: exception,
        //   duration: Duration(seconds: 5),
        // )..show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}

class LoginImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
     path.lineTo(0, size.height);
     path.quadraticBezierTo(12, size.height -38, 40, size.height - 48);
     path.lineTo(size.width - 40, size.height - 140);
    path.quadraticBezierTo(
      size.width,size.height - 145, size.width, size.height -212);
      path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
class LoginButtonShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(200, 0);
    // path.lineTo(size.width, size.height);
    path.quadraticBezierTo(0, size.height / 4, 0, size.height / 2);
    path.quadraticBezierTo(0, size.height - (size.height / 4), 200, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  



  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
class LoginButtonShape extends StatefulWidget {
    LoginButtonShape({Key key, this.btnTxt}) : super(key: key);
   
  String btnTxt;

  @override
  _LoginButtonShapeState createState() => _LoginButtonShapeState();
}

class _LoginButtonShapeState extends State<LoginButtonShape> {
   @override
  Widget build(BuildContext context) {
    return ClipPath(
       clipper: LoginButtonShapeClipper(),
      child: 
      
      Container(
                                      width: 120,
                                      height: 155,
                    decoration: new BoxDecoration(
                      gradient: LinearGradient(
            colors: [
              Color(0xFF44ACE8),
              Color(0xFFA03BB1),
              Color(0xFFED3978),
              Color(0xFFFE534),
              
            ],
                      begin: Alignment.bottomRight,
          end: Alignment.topCenter,
           
          ),
                      

                    ),
                    child: Center(
                      child: Padding(padding: EdgeInsets.only(left:30),
                        child: Row(
                          children: <Widget>[
                            Text('${widget.btnTxt}',style: TextStyle(fontSize: 18, color: Colors.white,  fontFamily: 'Poppins'),),
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                          ],
                        )
                      )
                    ),
                                  ),
    );
  }
}
