import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notification/util/phoneAuthServices.dart';

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Enter phone number'),
                    onChanged: (val) {
                      setState(() {
                        // this.phoneNo = '+918555974390';
                        // this.phoneNo = '+919849000525';
                        this.phoneNo = val;
                      });
                    },
                  )),
              codeSent
                  ? Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(hintText: 'Enter OTP'),
                        onChanged: (val) {
                          setState(() {
                            this.smsCode = val;
                          });
                        },
                      ))
                  : Container(),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: RaisedButton(
                      child: Center(
                          child: codeSent ? Text('Login') : Text('Verify')),
                      onPressed: () {
                        codeSent
                            ? PhoneAuthService()
                                .signInWithOTP(smsCode, verificationId)
                            : verifyPhone(phoneNo);
                      }))
            ],
          )),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      PhoneAuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {};

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}

//  not rajayogan

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:prochats/screens/main_screen.dart';

// class PhoneLoginScreen extends StatelessWidget {
//   final _phoneController = TextEditingController();
//   final _codeController = TextEditingController();

//   Future<bool> loginUser(String phone, BuildContext context) async{
//     FirebaseAuth _auth = FirebaseAuth.instance;

//     _auth.verifyPhoneNumber(
//         phoneNumber: phone,
//         timeout: Duration(seconds: 60),
//         verificationCompleted: (AuthCredential credential) async{
//           Navigator.of(context).pop();

//           AuthResult result = await _auth.signInWithCredential(credential);

//           FirebaseUser user = result.user;

//           if(user != null){
//             Navigator.push(context, MaterialPageRoute(
//               builder: (context) => MainScreen()
//             ));
//           }else{
//             print("Error");
//           }

//           //This callback would gets called when verification is done auto maticlly
//         },
//         verificationFailed: (AuthException exception){
//           print(exception);
//         },
//         codeSent: (String verificationId, [int forceResendingToken]){
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text("Give the code?"),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     TextField(
//                       controller: _codeController,
//                     ),
//                   ],
//                 ),
//                 actions: <Widget>[
//                   FlatButton(
//                     child: Text("Confirm"),
//                     textColor: Colors.white,
//                     color: Colors.blue,
//                     onPressed: () async{
//                       final code = _codeController.text.trim();
//                       AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);

//                       AuthResult result = await _auth.signInWithCredential(credential);

//                       FirebaseUser user = result.user;

//                       if(user != null){
//                         Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => MainScreen()
//                         ));
//                       }else{
//                         print("Error");
//                       }
//                     },
//                   )
//                 ],
//               );
//             }
//           );
//         },
//         codeAutoRetrievalTimeout: null
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(32),
//             child: Form(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text("Login", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),),

//                   SizedBox(height: 16,),

//                   TextFormField(
//                     decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(8)),
//                             borderSide: BorderSide(color: Colors.grey[200])
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(8)),
//                             borderSide: BorderSide(color: Colors.grey[300])
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         hintText: "Mobile Number"

//                     ),
//                     controller: _phoneController,
//                   ),

//                   SizedBox(height: 16,),

//                   Container(
//                     width: double.infinity,
//                     child: FlatButton(
//                       child: Text("LOGIN"),
//                       textColor: Colors.white,
//                       padding: EdgeInsets.all(16),
//                       onPressed: () {
//                         final phone = _phoneController.text.trim();

//                         loginUser(phone, context);

//                       },
//                       color: Colors.blue,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         )
//     );
//   }
// }
