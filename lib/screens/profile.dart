import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/screens/phoneLoginScreen.dart';
import 'package:notification/screens/sign_in.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';

import 'conversation.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  StateModel appState; 
  static Random random = Random();
  @override
  Widget build(BuildContext context) {
        appState = StateWidget.of(context).state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
           margin: EdgeInsets.only(
              top: 15,
              
              bottom: 100,
            ),
            padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 6,
                  spreadRadius: 10,
                )
              ],
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 60),
              CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/cm${random.nextInt(1000)}.jpeg",
                ),
                radius: 50,
              ),
              SizedBox(height: 10),
              Text(
                '${email}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
          //         FlatButton(
          //           child: Icon(
          //             Icons.message,
          //             color: Colors.white,
          //           ),
          //           color: Colors.grey,
          //           onPressed: (){
          //              Navigator.of(context, rootNavigator: true).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context){
          //       return Conversation();
          //     },
          //   ),
          // );
          //           },
          //         ),
              
                  
                  // SizedBox(width: 10),
              //     FlatButton(
              //       child: Icon(
              //         Icons.phone,
              //         color: Colors.white,
              //       ),
              //       color: Theme.of(context).accentColor,
              //       onPressed: (){
              //                   Navigator.of(context).push(MaterialPageRoute(
              // builder: (BuildContext context)
              //             => PhoneLoginScreen(),
              //                     ));
              //       },
              //     ),
              //     SizedBox(width: 10),
                   FlatButton(
                    child: Row(
                      children: <Widget>[
                        
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text('Logout',style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ))
                      ],
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: (){
                                                             StateWidget.of(context).logOutUser();
                      // Navigator.pushNamedAndRemoveUntil(context, "/signin", (r) => false);
                      // await Navigator.of(context).pushNamed('/signup');
                       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (BuildContext context)
                          => MySignInScreenHome(),
                                  ), (Route<dynamic> route) => false);
                    },
                  ),

                ],
              ),

              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildCategory("Followers"),

                    _buildCategory("Earnings"),

                    _buildCategory("Groups"),
                  ],
                ),
              ),
              SizedBox(height: 20),
         
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String title){
    return Column(
      children: <Widget>[
        Text(
          'NA',
          style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w800,
                ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
        ),
      ],
    );
  }
}
