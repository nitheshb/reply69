import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/Animation/FadeAnimation.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/models/users.dart';
import 'package:notification/util/auth.dart';
import 'package:notification/util/validators.dart';
import 'package:notification/widgets/loading.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _phoneNumber = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _referralCode = new TextEditingController();
  final TextEditingController _userName = new TextEditingController();

  AutoCompleteTextField searchTextField;
  bool loading = true;

  bool _autoValidate = false;
  bool _loadingVisible = false;
  String groupNameAlreadyExists;
  @override
  void initState() {
    super.initState();
  }

  String phoneNo;
  String smsCode;
  String verificationId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: LoadingScreen(
            inAsyncCall: _loadingVisible,
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  height: MediaQuery.of(context).size.height - 50,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FadeAnimation(
                              1,
                              Text(
                                "Sign up",
                                style: GoogleFonts.lato(
                                  fontSize: 30,
                                  color: Color(0xff3A4276),
                                  fontWeight: FontWeight.w800,
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                              1.2,
                              Text(
                                "Create an account, It's free",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Color(0xff3A4276),
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          FadeAnimation(1.2, makeEmailInput(label: "Email")),
                          FadeAnimation(
                              1.2, makeUserNameInput(label: "Pick User Name")),
                          FadeAnimation(
                              1.2,
                              makePasswordInput(
                                  label: "Choose Password", obscureText: true)),
                          FadeAnimation(
                              1.2, makePhoneNumberInput(label: "Phone Number")),
                          // FadeAnimation(1.4, makeReferralCodeInput(label: "Confirm Password", obscureText: true)),
                        ],
                      ),
                      FadeAnimation(
                          1.5,
                          Container(
                            padding: EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () async {
                                Pattern pattern = r'^.{1,}$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(_userName.text))
                                  setState(() {
                                    this.groupNameAlreadyExists =
                                        'Please enter a name.';
                                  });
                                else {
                                  QuerySnapshot userNameData =
                                      await FirebaseController.instanace
                                          .lookForExistingUserName(
                                              _userName.text);
                                  setState(() {
                                    this.groupNameAlreadyExists =
                                        userNameData.documents.length > 0
                                            ? 'User Name Already Taken'
                                            : null;
                                  });
                                  if (_formKey.currentState.validate()) {
                                    try {
                                      _emailSignUp(
                                          firstName: _userName.text,
                                          phoneNumber: _phoneNumber.text,
                                          email: _email.text,
                                          password: _password.text,
                                          referralCode: _referralCode.text,
                                          region:
                                              "searchTextField.textField.controller.text",
                                          context: context);
                                    } catch (e) {
                                      _changeLoadingVisible();

                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text("Sign Up Error ${e}"),
                                      ));
                                    }
                                  }
                                }
                              },
                              color: Colors.greenAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                "Sign up",
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Color(0xff3A4276),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )),
                      FadeAnimation(
                          1.6,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Already have an account?",
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Color(0xff3A4276),
                                    fontWeight: FontWeight.w500,
                                  )),
                              Text(
                                " Login",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Color(0xff3A4276),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget makeEmailInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          controller: _email,
          validator: Validator.validateEmail,
          obscureText: obscureText,
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
          height: 30,
        ),
      ],
    );
  }

  Widget makePasswordInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          autofocus: false,
          obscureText: true,
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
          height: 30,
        ),
      ],
    );
  }

  Widget makeUserNameInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          controller: _userName,
          // validator: Validator.validateEmail,
          validator: (value) {
            return groupNameAlreadyExists;
          },
          obscureText: obscureText,
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
          height: 30,
        ),
      ],
    );
  }

  Widget makePhoneNumberInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          autofocus: false,
          obscureText: false,
          controller: _phoneNumber,
          validator: Validator.validateNumber,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
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
            myOwnGroups: []
          ));
        });
        //now automatically login user too
        //await StateWidget.of(context).logInUser(email, password);
        await Navigator.pushNamed(context, '/signin');
      } catch (e) {
        _changeLoadingVisible();

        String exception = Auth.getExceptionText(e);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("${exception}"),
        ));
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
