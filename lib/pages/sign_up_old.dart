import 'package:notification/Animation/FadeAnimation.dart';
import 'package:notification/models/users.dart';
import 'package:notification/pages/myHomePageTest.dart';
import 'package:notification/pages/sign_in.dart';
import 'package:notification/util/auth.dart';
import 'package:notification/util/validators.dart';
import 'package:notification/widgets/dataSearch.dart';
import 'package:notification/widgets/loading.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



// import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';


import 'package:http/http.dart' as http;
// import 'user.dart';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../bid365_app_theme.dart';

class SignupPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signin': (BuildContext context) => new MySignInScreenHome()
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _phoneNumber = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _referralCode = new TextEditingController();

    AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User1>> key = new GlobalKey();
  static List<User1> users = new List<User1>();
  bool loading = true;

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    getUsers();
    super.initState();
  }


   String phoneNo;
  String smsCode;
  String verificationId;

   void getUsers() async {
    try {
      final response =
          await http.get("https://jsonplaceholder.typicode.com/users");
      if (response.statusCode == 200) {
        print('data value  ${response.body}');
        
        users = loadUsers(response.body);
        print('Users: ${users.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }
  
  static List<User1> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User1>((json) => User1.fromJson(json)).toList();
  }
Widget row(User1 user) {
   return  ListTile(
   

        title: Row(
          children: <Widget>[
            Icon(Icons.location_city, color: Colors.grey,),
            SizedBox(width:5),
            RichText(text: 
             TextSpan(
              text: user.name.substring(0,searchTextField.textField.controller.text.length),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [TextSpan(
                text:user.name.substring(searchTextField.textField.controller.text.length),
                style: TextStyle(color:Colors.grey)
                
              )]
              
               ),
              
      ),
          ],
        ),
      );

  }
  Future<void> verifyNumber() async{
    final PhoneCodeAutoRetrievalTimeout autoRetrieve=(String verID){
        this.verificationId=verID;
        ///Dialog here
        smsCodeDialog(context);
    };

    final PhoneVerificationCompleted verificationSuccess=(AuthCredential credential){
      print("Verified");
      Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context)
                      => HomePageTest(),
        )
        );
    };

    final PhoneCodeSent smsCodeSent=(String verID,[int forceCodeResend]){
      this.verificationId=verID;
      Navigator.pop(context);
     Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context)
                      => HomePageTest(),
        )
        );
    };

    final PhoneVerificationFailed verificationFailed=(AuthException exception){
      print('$exception.message');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationSuccess,
      verificationFailed: verificationFailed

    );
  }

  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> AlertDialog(
        title: Text("Enter SMS code"),
        content: TextField(
          onChanged: (value){
            this.smsCode=value;
          }
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.teal,
            child: Text("Done", style: TextStyle(color: Colors.white),),
            onPressed: (){
              FirebaseAuth.instance.currentUser().then((user){
                 if(user!=null){
                    Navigator.pop(context);
                     Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context)
                      => HomePageTest(),
        )
                     );
                 }
                 else{
                   Navigator.pop(context);
                   signIn();
                 }
              });
            },
          )
        ],
      )
      );
  }

  signIn()async{
    final AuthCredential credential= PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((user){
         Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context)
                      => HomePageTest(),
        )
         );
    }).catchError((e)=>print(e));
  }

  Widget build(BuildContext context) {

    return new Scaffold(
        // resizeToAvoidBottomPadding: false,
        drawer: Drawer(),
        body: Stack(
          children: <Widget>[
            LoadingScreen(
              child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Stack(
                      children: <Widget>[
                        // ClipPath(
                        //   clipper: LoginImageClipper(),
                        //   child: Container(
                        //     width: double.infinity,
                        //     height:260,
                        //     child: Stack(
                        //       children: <Widget>[
                        //         Positioned(
                        //             right: -260,
                        //           bottom: -220,
                        //           child: Image.asset(
                        //           "assets/images/beautyEyes.png",
                        //           fit: BoxFit.cover
                        //         )
                        //         ),
                        //   Positioned(
                        //           top: 50,
                        //           left: 20,
                        //           child:Text('FAN CHATS', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w900, color:Colors.redAccent,fontSize:30),)
                        //           )
                        //       ]
                        //     )
                        //   ),
                        // ),

                                  
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
                                Text('SIGN UP', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w900, color:Bid365AppTheme.nearlyBlack,fontSize:24),)
                               ),
                            ),
                           FlatButton(onPressed: (){
                                   Navigator.of(context).pushNamed('/signin');                             
                               }, child: 
                                Text('SIGN IN', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w900, color:Bid365AppTheme.nearlyBlack,fontSize:12),)
                               ),
                          ],),
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Container(
                              padding:
                                  EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                              child: Column(
                                children: <Widget>[      
                             
              //                          loading
              // ? CircularProgressIndicator()
              // : searchTextField = AutoCompleteTextField<User1>(
              //     key: key,
              //     clearOnSubmit: false,
              //     suggestions: users,
              //     style: TextStyle(color: Colors.black, fontSize: 16.0),
              //     decoration: InputDecoration(
              //       // contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              //       border: OutlineInputBorder(
              //                               borderSide:
              //                                  new  BorderSide(color: Color(0xFFE7E7E7))),
              //       labelText: "Your Region",
              //        labelStyle: TextStyle(
              //                               fontFamily: 'Montserrat',
              //                               fontWeight: FontWeight.bold,
              //                               color: Colors.grey),
              //       // hintStyle: TextStyle(color: Colors.black),
              //     ),
              //     itemFilter: (item, query) {
              //       return item.name
              //           .toLowerCase()
              //           .startsWith(query.toLowerCase());
              //     },
              //     itemSorter: (a, b) {
              //       return a.name.compareTo(b.name);
              //     },
              //     itemSubmitted: (item) {
              //       setState(() {
              //         searchTextField.textField.controller.text = item.name;
              //       });
              //     },
              //     itemBuilder: (context, item) {
              //       // ui for the autocompelete row
              //       return row(item);
              //     },
              //   ),
                                  SizedBox(height: 20.0),
                                  FadeAnimation(1.4,TextFormField(
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
                                  )),
                                  SizedBox(height: 20.0),
                                  FadeAnimation(1.4,TextFormField(
                                    autofocus: false,
                                    obscureText: true,
                                    controller: _password,
                                    // validator: Validator.va,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
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
                                  ),
                                  ),
                                  SizedBox(height: 20.0),
                                  FadeAnimation(1.4,TextFormField(
                                    autofocus: false,
                                    obscureText: true,
                                    controller: _referralCode,
                                    decoration: InputDecoration(
                                        labelText: 'Referral Code',
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
                                  ),
                                  ),
                                      
                              
                                ],
                              )),
                        ],
                      ),
                      SizedBox(height:20),
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
                                 _emailSignUp(
                                 firstName: _firstName.text, phoneNumber: _phoneNumber.text,email: _email.text, password: _password.text, referralCode: _referralCode.text, region:"searchTextField.textField.controller.text", context: context);
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
            ),
          ],
        ));
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }


  void _emailSignUp(
      {String firstName,
      String lastName,
      String phoneNumber,
      String email,
      String password,
      String referralCode,
      String region,
      BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
        await Auth.signUp(email, password).then((uID) {
          Auth.addUserSettingsDB(new User(
            userId: uID,
            phoneNumber: phoneNumber,
            email: email,
            firstName: firstName,
            lastName: lastName,
            referralCode: referralCode,
            walletMoney: 50,
          ));
        });
        //now automatically login user too
        //await StateWidget.of(context).logInUser(email, password);
        await Navigator.pushNamed(context, '/signin');
      } catch (e) {
        _changeLoadingVisible();
        print("Sign Up Error: $e");
        String exception = Auth.getExceptionText(e);
        //   Fluttertoast.showToast(
        // msg: "Sign Up Error: ${exception} " );
        // Flushbar(
        //   title: "Sign Up Error",
        //   message: exception,
        //   duration: Duration(seconds: 5),
        // )..show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
