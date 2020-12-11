import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MyTeamsBottomSheetClass extends StatefulWidget {
  MyTeamsBottomSheetClass({Key key, this.chatId, this.trxtype, this.chatOwnerId}) : super(key: key);

  final String chatId, trxtype, chatOwnerId;
  @override
  _MyTeamsBottomSheetClassState createState() =>
      new _MyTeamsBottomSheetClassState();
}

class _MyTeamsBottomSheetClassState extends State<MyTeamsBottomSheetClass> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List mySelTeams;

  String collectionName1 = "f_Ind_wi_27_001";
  var WalletMoney;
  bool joinError;
  String errorMsg;
  String statusTxt;
  double percentage = 0.0;
  String animationName = "celebrationstart";
  final myAmount = TextEditingController();
  var paymentController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Razorpay _razorpay;

  int payMoney;
  String Trxtype;

  void _playAnimation() {
    setState(() {
      if (animationName == "celebrationstart")
        animationName = "celebrationstop";
      else
        animationName = "celebrationstart";
    });
  }

  @override
  void initState() {
    _firebaseMessaging.getToken().then((token) {
      print("my token is $token");
    });
    mySelTeams = [];
    joinError = false;
    WalletMoney = 0;
    statusTxt = '';

    _playAnimation();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  final style1 = GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      color: Colors.white.withOpacity(0.87));
  final style2 = GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 13,
      color: Colors.white.withOpacity(0.87));
  final style3 = GoogleFonts.lato(
      fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xff00CEB8));
  final style4 = GoogleFonts.lato(
      fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xff677897));
  final head3 = GoogleFonts.lato(
      fontWeight: FontWeight.w400, fontSize: 11, color: Color(0xffA3BBD3));
  final prize = GoogleFonts.lato(
      fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xffFFFFFF));
  final join = GoogleFonts.lato(
      fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xffFFFFFF));
  final fullSpots = GoogleFonts.lato(
      fontWeight: FontWeight.w400, fontSize: 11, color: Color(0xffFFFFFF));
  final filledSpots = GoogleFonts.lato(
      fontWeight: FontWeight.w400, fontSize: 11, color: Color(0xffA3BBD3));
  final bottomText = GoogleFonts.lato(
      fontWeight: FontWeight.w400, fontSize: 11, color: Color(0xff7888A4));

  getSavedTeams(emailId, matchId) {
    print('values of here is ${emailId}  ${matchId}');
    return Firestore.instance
        .collection("f_Ind_wi_27_001")
        .where("matchID", isEqualTo: matchId)
        .where("email", isEqualTo: emailId)
        .snapshots();
  }

  @override
  void dispose() {
    // _controllerTopCenter.dispose();

    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    print(' iwas clicked');
    payMoney = int.tryParse(paymentController.text);
    var options = {
      'key': 'rzp_live_edn0izaZh4NpX1',
      'amount': int.parse(paymentController.text + "00"),
      'name': 'BID365',
      'description': 'Just Do it1...!',
      'prefill': {'contact': '9849000525', 'email': "nithe.nithesh@gmail.com"},
      // 'prefill': { 'email': widget.emailId},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      if (payMoney == null || payMoney == 0) {
        // showInSnackBar('Please, Enter your valid Amount.');
      } else {
        _razorpay.open(options);
      }
    } catch (e) {
      print('error is ${e}');
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) {
    // Do something when payment succeeds
    try {
      FirebaseController.instanace
          .updateWalletMoney(widget.chatOwnerId, payMoney, Trxtype);
      Fluttertoast.showToast(msg: "Transaction Successful...Thank you");
      print('payment success');
    } catch (e) {
      Fluttertoast.showToast(msg: "failed ${e}");
      print('payment failed');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(msg: "Transaction failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    // TODO: implement build
    // return final _media = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Color(0xff102131),
      appBar: AppBar(
        elevation: 3,
        title: PreferredSize(
            child: Text(
              "Applause",
              //  textAlign: TextAlign.left,
              style: style3.copyWith(
                fontSize: 15,
                color: Color(0xFF5F2EEA)
              ),
            ),
            preferredSize: Size.fromHeight(0.0)),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //       height: 60, child: createTeamFloatBtn(context, uId, emailId)),
      //   color: Colors.green,
      // ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 16.0,
                      right: 16,
                      bottom: 6,
                    ),
                  ),
                  // Container(
                  //   child: Center(
                  //     child: Text(
                  //       "Support by",
                  //       style: TextStyle(
                  //         fontSize: 14.0,
                  //         color: Color(0xFF5F2EEA).withOpacity(0.6),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      'Please Add amount',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(4.0),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.5),
                          width: 1.2,
                        ),
                      ),
                      child: TextFormField(
                        controller: paymentController,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          prefix: Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          border: InputBorder.none,
                          labelStyle: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  paymentController.text = '50';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '₹50',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  paymentController.text = '100';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '₹100',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  paymentController.text = '200';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '₹200',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),


                  InkWell(
                              onTap: () {
                                print(widget.chatId);
                                  openCheckout();
                              },
                              child: Center(
                                child: Container(
                                  height: 45.0,
                                  width: 170.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFF5F2EEA),
                                          style: BorderStyle.solid,
                                          width: 3.0),
                                      borderRadius: BorderRadius.circular(40.0),
                                      color: Color(0xFF5F2EEA)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(46, 8.0, 20, 8),
                                    child: Center(
                                      child: Row(
                                        children: [
                                        
                                          SizedBox(width: 6),
                                          Text( 'Send'.toUpperCase(),
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xffF7F7FC),
                                                  // letterSpacing: 0.75,
                                                  fontSize: 16.0)),
                                                    SizedBox(width: 4),
                                          Center(
                                              //             child: Image.asset(
                                              //   'assets/win.png',
                                              //   width: 30.0,
                                              //   height: 70.0,
                                              // )
                                              child: Container(
                                            width: 20.0,
                                            height: 70.0,
                                            child: Icon(
                                              FontAwesomeIcons.heart,
                                              color: Color(0xffF7F7FC),
                                              size: 14,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
            
                ],
              ),
            )),
          ],
        ),
      ),
    );

    void showInSnackBar(String value) {
      print("inside snack check");
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
