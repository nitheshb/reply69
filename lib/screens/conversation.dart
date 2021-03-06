import 'dart:async';
import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:notification/ImageEditorPack/image_editorHome.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/controllers/gradeMaker.dart';
import 'package:notification/pages/feedBacker.dart';
import 'package:notification/pages/reports.dart';
import 'package:notification/screens/bottomSheetApplause.dart';
import 'package:notification/screens/groupEarnings.dart';
import 'package:notification/util/admob_service.dart';
import 'package:notification/util/data.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/chat_bubble.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'groupMembersHome.dart';
import 'joinPremium.dart';
import 'joinRequestApproval.dart';

class Conversation extends StatefulWidget {
  Conversation(
      {Key key,
      this.groupFullDetails,
      this.followingGroupsLocal,
      this.msgFullCount,
      this.msgReadCount,
      this.msgFullPmCount,
      this.chatId,
      this.groupSportCategory,
      this.userId,
      this.groupLogo,
      this.groupTitle,
      this.senderMailId,
      this.chatType,
      this.waitingGroups,
      this.approvedGroups,
      this.followers,
      this.chatOwnerId,
      this.approvedGroupsJson,
      this.AllDeviceTokens,
      this.FDeviceTokens,
      this.followersCount});
  var chatId,
      userId,
      chatType,
      chatOwnerId,
      senderMailId,
      groupTitle,
      groupLogo;
  List waitingGroups,
      approvedGroups,
      AllDeviceTokens,
      FDeviceTokens,
      groupSportCategory,
      followers;
  List followingGroupsLocal;
  List approvedGroupsJson;
  var msgFullCount, msgReadCount, msgFullPmCount;
  var groupFullDetails;
  var followersCount;
  bool inverted = false;
  bool shouldShowLoadEarlier = false;

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final ams = AdMobService();
  final TextEditingController _chatMessageText = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  Razorpay _razorpay;

//  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;
  StateModel appState;
  FocusNode inputFocusNode;
  TextEditingController textController;
  File _image;
  int selectedRadio = 0;
  String msgDeliveryMode = "All";
  List votingBalletHeapData;
  List groupCategoriesArray = [];
  int selectedRadioTile;
  List feeDetails;
  int messageCount, nonPrimeMsgCount = 0;
  List nonPrimeMessageContent;
  var groupGrade;
  Timer _timer;
  bool isFirstScrollDone = false;
  String payMoney;
  Dio dio = new Dio();

  // Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (val == 2) {
        msgDeliveryMode = "Prime";
        WidgetsBinding.instance.addPostFrameCallback(widgetBuilt);
      } else if (val == 1) {
        msgDeliveryMode = "All";
        WidgetsBinding.instance.addPostFrameCallback(widgetBuilt);
      } else if (val == 3) {
        msgDeliveryMode = "Non-Prime";
        WidgetsBinding.instance.addPostFrameCallback(widgetBuilt);
      }
    });
  }

  scrollToBottomFun() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      )
          .whenComplete(() {
        _timer = Timer(Duration(milliseconds: 1000), () {
          if (this.mounted) {
            print('check here scroll fun');
            isFirstScrollDone = true;
            // setState(() {
            //   _initialLoad = false;
            // });
          }
        });
      });
    });
  }

//  this is of no use but just to check if bottom is reached or not
  bool scrollNotificationFunc(ScrollNotification scrollNotification) {
    double bottom =
        widget.inverted ? 0.0 : scrollNotification.metrics.maxScrollExtent;

    if (scrollNotification.metrics.pixels == bottom) {
      // if (widget.visible) {
      //   // widget.changeVisible(false);
      // }
      print('here');
    } else if ((scrollNotification.metrics.pixels - bottom).abs() > 100) {
      // if (!widget.visible) {
      //   widget.changeVisible(true);
      // }
      print('here1');
    }
    return true;
  }

  void widgetBuilt(Duration d) {
    print(' ==>i wass here1');

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,
      )
          .whenComplete(() {
        _timer = Timer(Duration(milliseconds: 1000), () {
          if (this.mounted) {
            print('check here mounted ');
            // setState(() {
            //   _initialLoad = false;
            // });
          }
        });
      });
    });
    double initPos = widget.inverted
        ? 0.0
        : _scrollController.position.maxScrollExtent + 25.0;

    // _scrollController
    //     .animateTo(
    //   initPos,
    //   duration: const Duration(milliseconds: 150),
    //   curve: Curves.easeInOut,
    // )
    //     .whenComplete(() {
    //   _timer = Timer(Duration(milliseconds: 1000), () {
    //     if (this.mounted) {
    //       print('check here');
    //       // setState(() {
    //       //   _initialLoad = false;
    //       // });
    //     }
    //   });
    // });

    _scrollController.addListener(() {
      bool topReached = widget.inverted
          ? _scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange
          : _scrollController.offset <=
                  _scrollController.position.minScrollExtent &&
              !_scrollController.position.outOfRange;

      if (widget.shouldShowLoadEarlier) {
        if (topReached) {
          print('on showLoadMore');
          setState(() {
            // showLoadMore = true;
          });
        } else {
          print('on showLoadMore');
          setState(() {
            // showLoadMore = false;
          });
        }
      } else if (topReached) {
        print('on load Earlier');
        // widget.onLoadEarlier();
      }
    });
  }

  static Random random = Random();
  String name = names[random.nextInt(10)];

  Color backgroundColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey[700];
    } else {
      return Colors.grey[50];
    }
  }

  upadateFeeDetails(feeDetailsv) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('thisFee', feeDetailsv[0]['fee'].toString());
    prefs.setString('thisFeeDays', feeDetailsv[0]['days'].toString());
    feeDetails = feeDetailsv;
  }

  getFeeDeatils() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fee = prefs.getString('thisFee');
    var details = prefs.getString('thisFeeDays');

    feeDetails = [
      {'fee': fee}
    ];
  }

  fetIt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fee = prefs.getString('thisFee');
    return fee;
  }

  void initState() {
    // TODO: implement initState
    //  WidgetsBinding.instance.addPostFrameCallback(widgetBuilt);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    //  Admob.initialize(ams.getAdMobAppId());

    loadGrade();

    upadateFeeDetails([
      {'fee': 0, 'days': 0}
    ]);

    if ((widget.approvedGroups.contains(widget.userId))) {
      //  prime group
      selectedRadio = 2;
      selectedRadioTile = 2;
      setSelectedRadio(2);
    } else if ((widget.chatOwnerId == widget.userId)) {
      selectedRadio = 3;
      selectedRadioTile = 3;
      setSelectedRadio(3);
    } else {
      selectedRadio = 3;
      selectedRadioTile = 3;
      setSelectedRadio(3);
    }

    if (widget.groupSportCategory.length != 0) {
      widget.groupSportCategory.forEach((data) {
        groupCategoriesArray.add(data['categoryName']);
      });
    }
    setReadCountToClear();

    // _keyboardState = _keyboardVisibility.isKeyboardVisible;
    // _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
    //   onChange: (bool visible) {
    //     scrollToBottomFun();
    //     setState(() {
    //       _keyboardState = visible;
    //     });
    //   },
    // );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    print(' iwas clicked');
    // payMoney = int.tryParse(paymentController.text);
    var options = {
      'key': 'rzp_live_edn0izaZh4NpX1',
      'amount': int.parse(payMoney + "00"),
      'name': 'Chat11',
      'description': 'prime Membership ${widget.groupTitle.toString().toUpperCase()}!',
      // 'prefill': {'contact': '9000000000', 'email': "nithe.nithesh@gmail.com"},
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

  Future<void> _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    // Do something when payment succeeds
    try {
      FirebaseController.instanace.updateWalletMoney(
          widget.chatOwnerId,
          int.parse(widget.groupFullDetails.data['FeeDetails'][0]['fee']),
          'Prime');
          var now = new DateTime.now();
      var modifiedDate = now.add(Duration(days: 30));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
      FirebaseController.instanace.approveKycDoc(response.paymentId, modifiedDate, 30,
          widget.userId, widget.chatId, userToken, appState.user.phoneNumber, appState.user.firstName);
      try {
        var response = await dio.get(
            "https://asia-south1-royalpro.cloudfunctions.net/onMemberAdd?id=${widget.userId}&chatId=${widget.chatId}&groupName=${widget.groupTitle}");
      } catch (e) {}
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

  setReadCountToClear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("${widget.chatId}", widget.msgFullCount);
  }

  loadGrade() async {
    var grade = await followerGrades(widget.followersCount);

    setState(() {
      groupGrade = grade;
    });
  }

  profileRoute(context, origin) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => JoinPremiumGroup(
          chatId: widget.chatId,
          userId: widget.userId,
          lock: false,
          title: widget.groupTitle,
          feeArray: widget.groupFullDetails['FeeDetails'] ?? [],
          paymentScreenshotNo: widget.groupFullDetails['paymentNo'] ?? "",
          avatarUrl: widget.groupFullDetails['logo'] ?? "",
          categories: widget.groupFullDetails['category'] ?? [],
          followers: widget.groupFullDetails['followers'] ?? [],
          groupOwnerName: widget.groupFullDetails['ownerName'] ?? '',
          seasonRating: widget.groupFullDetails['seasonRating'] ?? 'NA',
          thisWeekRating: widget.groupFullDetails['thisWeekRating'] ?? 'NA',
          lastWeekRating: widget.groupFullDetails['lastWeekRating'] ?? 'NA',
          followingGroupsLocal: widget.followingGroupsLocal,
          accessingBy: origin,
          followersCount: NumberFormat.compact().format(widget.followersCount),
        ),
      ),
      //  new  MaterialPageRoute(
      //       builder: (BuildContext context) => JoinPremiumGroup(chatId: widget.chatId,userId: widget.userId,lock: false,title: widget.groupTitle,feeArray: widget.groupFullDetails['FeeDetails'] ?? [], paymentScreenshotNo: widget.groupFullDetails['paymentNo'] ?? "", avatarUrl: widget.groupFullDetails['logo']?? "" ),
      //       ),
    );
  }

  Future<bool> _onBackPress() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pop(context, 'testing');
    return false; // return true if the route to be popped
  }

  Future<void> _shareImages(textData, appLink) async {
    FlutterShare.share(
        title: 'Check out',
        text: 'textData',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');

    return;
    try {
      final ByteData bytes1 = await rootBundle.load('assets/like.png');

      await Share.files(
          'esys images',
          {
            'esys.png': bytes1.buffer.asUint8List(),
          },
          '*/*',
          text: textData);
    } catch (e) {}
    return;
    try {
      Share.text('my text title',
          'This is my text to share with other applications.', 'text/plain');
    } catch (e) {}
    return;
    try {
      final ByteData bytes1 = await rootBundle.load('assets/like.png');
      final ByteData bytes2 = await rootBundle.load('assets/like.png');

      await Share.files(
          'esys images',
          {
            'esys.png': bytes1.buffer.asUint8List(),
            'bluedan.png': bytes2.buffer.asUint8List(),
          },
          'image/png');
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
      appState = StateWidget
        .of(context)
        .state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    final followGroupState = appState.followingGroups;
    final phoneNumber = appState.user.phoneNumber;
    final firstName = appState.user.firstName;
    double dw = MediaQuery.of(context).size.width;
    // getFeeDeatils();
//     int setScrollDelay = widget.chatId.contains('PGrp') ? 1 : 0;
//     Timer(
//     Duration(seconds: setScrollDelay),
//     () => {
//       if(_scrollController.hasClients) {
//     _scrollController.animateTo(
//   _scrollController.position.maxScrollExtent,
//   duration: Duration(seconds: 1),
//   curve: Curves.fastOutSlowIn,

// ),
//       }
//       }
//   );
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        backgroundColor: backgroundColor(),
        appBar: appBarWid(),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Container(
                height: 10,
              ),
// Ad here
              // AdmobBanner(adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER),
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseController.instanace
                          .getChatContent(widget.chatId, msgDeliveryMode),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error ${snapshot.error}');
                        }
                        if (snapshot.hasData) {
                          DocumentSnapshot ds = snapshot.data;
                          // upadateFeeDetails(ds['FeeDetails']);
                          widget.groupFullDetails = ds;
                          if (snapshot.hasData &&
                              snapshot.data['messages'].length > 0) {
                            messageCount = snapshot.data['messages'].length;
                            nonPrimeMessageContent = snapshot.data['messages'];
                            if (!isFirstScrollDone) {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
// Here you can write your code
                                scrollToBottomFun();
                              });
                            }
                            return NotificationListener<ScrollNotification>(
                                onNotification: scrollNotificationFunc,
                                child: CupertinoScrollbar(
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    itemCount: snapshot.data['messages'].length,
                                    controller: _scrollController,
                                    // shrinkWrap: true,
                                    reverse: false,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot ds = snapshot.data;
                                      var indexVal = index;
                                      var datestamp = new DateFormat("HH:mm");
                                      var messageArray =
                                          snapshot.data['messages'];

                                      return ChatBubble(
                                          message: messageArray[indexVal]
                                                      ['type'] ==
                                                  "text"
                                              ? messageArray[indexVal]
                                                  ['messageBody']
                                              : messageArray[indexVal]
                                                  ['imageUrl'],
                                          premium: messageArray[indexVal]
                                              ['premium'],
                                          type: messageArray[indexVal]['type'],
                                          img: messageArray[indexVal]
                                              ['imageUrl'],
                                          name: messageArray[indexVal]['type'],
                                          dp: messageArray[indexVal]
                                              ['imageUrl'],
                                          messageMode: messageArray[indexVal]
                                              ['messageMode'],
                                          time: datestamp
                                              .format(messageArray[indexVal]
                                                      ['date']
                                                  .toDate())
                                              .toString(),
                                          selMessageMode: msgDeliveryMode);

                                      // fresh start check
                                    },
                                  ),
                                ));
                          }
                        } else {
                          messageCount = 0;
                        }
                        return Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        4.5),
                                new Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child:
                                      SvgPicture.asset('assets/emptyBox.svg'),
                                ),
                                new Text(
                                  'Empty Chat',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ],
                            ));
                      })),
              SizedBox(height: 10),
              Visibility(
                visible: (widget.chatOwnerId == widget.userId),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    width: dw * 1,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Send to :",
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w500,
                              )),
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 6),
                                  // Radio(
                                  //   value: 1,
                                  //   groupValue: selectedRadio,
                                  //   activeColor: Colors.green,
                                  //   onChanged: (val) {
                                  //     setSelectedRadio(val);
                                  //   },
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      setSelectedRadio(1);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 7, 16, 7),
                                      decoration: BoxDecoration(
                                          color: selectedRadio == 1
                                              ? Color(0xffF1FCFF)
                                              : Color(0xffEFF0F6),
                                          border: Border.all(
                                              width: 2,
                                              color: selectedRadio == 1
                                                  ? Color(0xff1CC8EE)
                                                  : Color(0xffEFF0F6)),
                                          borderRadius:
                                              BorderRadius.circular(39)),
                                      child: Text("Common",
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: selectedRadio == 1
                                                  ? Color(0xff0096B7)
                                                  : Color(0xffA0A3BD),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.25)),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      setSelectedRadio(2);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 7, 16, 7),
                                      decoration: BoxDecoration(
                                          color: selectedRadio == 2
                                              ? Color(0xffFFF3F8)
                                              : Color(0xffEFF0F6),
                                          border: Border.all(
                                              width: 2,
                                              color: selectedRadio == 2
                                                  ? Color(0xffFF84B7)
                                                  : Color(0xffEFF0F6)),
                                          borderRadius:
                                              BorderRadius.circular(39)),
                                      child: Text("Prime",
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: selectedRadio == 2
                                                  ? Color(0xffC30052)
                                                  : Color(0xffA0A3BD),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.25)),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      setSelectedRadio(3);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 7, 16, 7),
                                      decoration: BoxDecoration(
                                          color: selectedRadio == 3
                                              ? Color(0xffFFF9EF)
                                              : Color(0xffEFF0F6),
                                          border: Border.all(
                                              width: 2,
                                              color: selectedRadio == 3
                                                  ? Color(0xffFFD789)
                                                  : Color(0xffEFF0F6)),
                                          borderRadius:
                                              BorderRadius.circular(39)),
                                      child: Text("Non-Prime",
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: selectedRadio == 3
                                                  ? Color(0xff946200)
                                                  : Color(0xffA0A3BD),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.25)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: (widget.chatOwnerId != widget.userId),
                child: Visibility(
                  visible: !widget.chatId.contains('PGrp'),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                //  profileRoute(context, 'member');
                                setState(() {
                                  payMoney = widget.groupFullDetails
                                      .data['FeeDetails'][0]['fee'];
                                });
                                openCheckout();
                                // _settingMyTeamsBottomSheet(context);

                                // if(lock){
                                //   // showInSnackBar('Doc already uploaded');
                                //     Scaffold.of(context).showSnackBar(SnackBar(content: Text("Doc already uploaded"),));
                                // }else{
                                //   getImage();
                                // }
                              },
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
                                      const EdgeInsets.fromLTRB(29, 8.0, 20, 8),
                                  child: Center(
                                    child: Row(
                                      children: [
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
                                            FontAwesomeIcons.crown,
                                            color: Color(0xffF7F7FC),
                                            size: 14,
                                          ),
                                        )),
                                        SizedBox(width: 6),
                                        Text('Join Prime',
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xffF7F7FC),
                                                // letterSpacing: 0.75,
                                                fontSize: 16.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              )),

                          InkWell(
                              onTap: () {
                                print(
                                    'check io ${widget.groupFullDetails.data['FeeDetails'][0]['fee']}');
                                _settingMyTeamsBottomSheet(context);
                                // profileRoute(context, 'member');

                                // if(lock){
                                //   // showInSnackBar('Doc already uploaded');
                                //     Scaffold.of(context).showSnackBar(SnackBar(content: Text("Doc already uploaded"),));
                                // }else{
                                //   getImage();
                                // }
                              },
                              child: Container(
                                height: 50.0,
                                width: 155.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFF5F2EEA),
                                      style: BorderStyle.solid,
                                      width: 3.0),
                                  borderRadius: BorderRadius.circular(40.0),
                                  //color: Color(0xFF5F2EEA)
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(19, 8.0, 20, 8),
                                  child: Center(
                                    child: Row(
                                      children: [
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
                                            FontAwesomeIcons.handHoldingHeart,
                                            color: Color(0xFF5F2EEA),
                                            size: 16,
                                          ),
                                        )),
                                        SizedBox(width: 8),
                                        Text('Applause',
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF5F2EEA),
                                                // letterSpacing: 0.75,
                                                fontSize: 16.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              )),

                          // Container(
                          //   height: 65.0,
                          //   width: 60.0,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //         color: Colors.grey,
                          //         style: BorderStyle.solid,
                          //         width: 1.0),
                          //     borderRadius: BorderRadius.circular(10.0),
                          //   ),
                          //   child: Center(
                          //     child: Icon(FontAwesomeIcons.heart, color: Colors.black),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: widget.chatOwnerId == widget.userId,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomAppBar(
                    elevation: 10,
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      constraints:
                          BoxConstraints(maxHeight: 120, minHeight: 56),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.image,
                                color: Color(0xffA0A3BD),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MyImageEditorPro(
                                    appBarColor: Colors.blue,
                                    bottomBarColor: Colors.blue,
                                    groupLogo: widget.groupLogo,
                                    chatId: widget.chatId,
                                    userId: widget.userId,
                                    premiumMode: msgDeliveryMode == 'Prime',
                                    deliveryMode: msgDeliveryMode,
                                    msgFullCount: widget.msgFullCount,
                                    msgFullPmCount: widget.msgFullPmCount,
                                  );
                                })).then((geteditimage) {
                                  if (geteditimage != null) {
                                    setState(() {
                                      _image = geteditimage;
                                    });
                                  }
                                }).catchError((er) {});
                                //  Navigator.push(
                                //     context,
                                //    new  MaterialPageRoute(
                                //         builder: (BuildContext context) => ImageEditorPage(chatId: widget.chatId,userId: widget.userId,chatType: "Image", groupLogo: widget.groupLogo),
                                //         ),
                                //  );
                              },
                            ),
                            Flexible(
                              child: TextField(
//                                                     onTap: () {
// Timer(
// Duration(milliseconds: 300),
// () => _scrollController
//     .jumpTo(_scrollController.position.maxScrollExtent));
// },
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color:
                                      Theme.of(context).textTheme.title.color,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText:
                                      "Write your message... ${messageCount}",
                                  hintStyle: GoogleFonts.lato(
                                      fontSize: 13,
                                      color: Color(0xffA0A3BD),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.25),
                                ),
                                controller: _chatMessageText,
                                maxLines: null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Color(0xff1CC8EE),
                              ),
                              onPressed: () {
                                // TODO: show error to user when message is not delivered
                                sendMessageFun();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: widget.approvedGroups.contains(widget.chatId),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: FloatingActionButton.extended(
              onPressed: () async {
                var snapShot = await FirebaseController.instanace
                    .getCurrentVotes(widget.chatId);

// this creates feedback entry for newGroup or a group which does not have entry yet in DB
                if (snapShot == null || !snapShot.exists) {
                } else {
                  votingBalletHeapData = await snapShot.data['VotingStats'];

                  // List reqGroupA =  data.where((i) => i["gameId"] == matchId).toList();
                  // List homeGroup =  data.where((i) => i["gameId"] != matchId).toList();
                }

                // powerPredictor
                await Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => PowerFeedbacker(
                        groupCategories: widget.groupSportCategory,
                        groupCategoriesArray: groupCategoriesArray,
                        groupId: widget.chatId,
                        groupTitle: widget.groupTitle,
                        votingBalletHeapData: votingBalletHeapData ?? []),
                  ),
                );
              },
              icon: Icon(FontAwesomeIcons.check),
              label: Text("Feedback"),
            ),
          ),
        ),
      ),
    );
  }

  void _settingMyTeamsBottomSheet(
    context,
  ) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          // return Container(
          //  child:  showSavedTeamsWidget('tcsrahulhyd@gmail.com')
          // );
          return AnimatedContainer(
            duration: Duration(milliseconds: 1400),
            decoration: new BoxDecoration(
                color: Color(0xFF737373),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: FractionallySizedBox(
              heightFactor: 0.72,
              child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Color(0xFF737373),
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0))),
                    child: MyTeamsBottomSheetClass(
                      chatId: widget.chatId,
                      chatOwnerId: widget.chatOwnerId,
                      trxtype: 'Applause',
                    ),
                  )),
            ),
          );
        });
  }

  Widget appBarWid() {
    return AppBar(
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Color(0xff4E4B66), size: 10.0),
      elevation: 3,
      titleSpacing: 0,
      title: InkWell(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  "${widget.groupLogo}",
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "${widget.groupTitle.toString().toUpperCase()}",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Color(0xff1B1A57),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: Text(
                          "${NumberFormat.compact().format(widget.followersCount) ?? '0'} Followers ",
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff4F5E7B),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF2ecc71),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          "👑 ${groupGrade} ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.share,
              color: Color(0xff4E4B66),
            ),
            onPressed: () async {
              FlutterShare.share(
                  title: 'check our my official Group # ${widget.groupTitle} ✌',
                  text:
                      'Check out my official Group ⚡ ${widget.groupTitle} 🔥🎯✌ 👑🎁 👍',
                  linkUrl:
                      "https://play.google.com/store/apps/details?id=com.candc.chatogram",
                  chooserTitle: 'Example Chooser Title');
            }),
// START of feedback button
//                IconButton(
//               icon: Icon(
//                 Icons.notifications,
//               ),
//               onPressed: () async{
//                var  snapShot = await FirebaseController.instanace.getCurrentVotes(widget.chatId);

// // this creates feedback entry for newGroup or a group which does not have entry yet in DB
// if (snapShot == null || !snapShot.exists) {

// }else{
//   votingBalletHeapData = await  snapShot.data['VotingStats'];
//   print('full data of heap is ${votingBalletHeapData}');
//   // List reqGroupA =  data.where((i) => i["gameId"] == matchId).toList();
//   // List homeGroup =  data.where((i) => i["gameId"] != matchId).toList();
// }
//                 // powerPredictor
//                await   Navigator.push(
//                                     context,
//                                    new  MaterialPageRoute(
//                                         builder: (BuildContext context) => PowerFeedbacker(
//                                         groupCategories: widget.groupSportCategory ,
//                                         groupCategoriesArray : groupCategoriesArray,
//                                         groupId: widget.chatId,
//                                         groupTitle: widget.groupTitle,
//                                         votingBalletHeapData: votingBalletHeapData ?? []),
//                                         ),
//                                  );
//               },
//             ),

        // END of feedback button
        // display for group members

        Visibility(
          visible: widget.chatOwnerId != widget.userId,
          child: new PopupMenuButton(
              onSelected: (value) {
                if (value == "Profile") {
                  profileRoute(context, 'member');
                } else if (value == "Report") {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => ReportScreen(
                          chatId: widget.chatId, uId: widget.userId),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    PopupMenuItem(
                      value: "Profile",
                      child: Text("Profile",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Color(0xff3A4276),
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    PopupMenuItem(
                      value: "Report",
                      child: Text("Report",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Color(0xff3A4276),
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    // PopupMenuItem(
                    //   value: "Exit Group",
                    //   child: Text("Exit Group"),
                    // ),
                  ]),
        ),
        // display for group owners
        Visibility(
          visible: widget.chatOwnerId == widget.userId,
          child: new PopupMenuButton(
              color: Color(0xffEFF0F6),
              onSelected: (value) {
                if (value == "Approve Payments") {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => JoinRequestApproval(
                        chatId: widget.chatId,
                        groupName: widget.groupTitle,
                      ),
                    ),
                  );
                } else if (value == "Expired Memberships") {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) => GroupMembersHome(
                          groupMembersJson: widget.approvedGroupsJson ?? [],
                          chatId: widget.chatId,
                          ownerMailId: widget.senderMailId,
                          groupTitle: widget.groupTitle,
                        ),
                      ));
                } else if (value == "Earnings") {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) => GroupEarnings(),
                      ));
                } else if (value == "Edit Details") {
                  profileRoute(context, 'owner');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    PopupMenuItem(
                      value: "Approve Payments",
                      child: Text("User Payments",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Color(0xff14142B),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.75)),
                    ),
                    PopupMenuItem(
                      value: "Expired Memberships",
                      child: Text("Prime Members",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Color(0xff14142B),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.75)),
                    ),
                    PopupMenuItem(
                      value: "Earnings",
                      child: Text("Earnings",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Color(0xff14142B),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.75)),
                    ),
                    PopupMenuItem(
                      value: "Edit Details",
                      child: Text("Edit Profile",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Color(0xff14142B),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.75)),
                    ),
                  ]),
        )
      ],
    );
  }

  // sendMessgeFun
  sendMessageFun() {
    try {
      if (msgDeliveryMode == "Prime") {
        widget.msgFullPmCount = widget.msgFullPmCount + 1;
      } else if (msgDeliveryMode == "Non-Prime") {
        widget.msgFullCount = widget.msgFullCount + 1;
      } else {
        widget.msgFullCount = widget.msgFullCount + 1;
        widget.msgFullPmCount = widget.msgFullPmCount + 1;
      }

      var now = new DateTime.now();
      var body = {
        "messageBody": _chatMessageText.text,
        "date": now,
        "author": widget.userId,
        "type": "text",
        "premium": (msgDeliveryMode == "Prime"),
        "messageMode": msgDeliveryMode
      };
      // var lastMessageBody ={"lastMsg":_chatMessageText.text, "lastMsgTime": now};
      var lastMessageBody = {
        "lastMsg": _chatMessageText.text,
        "lastMsgTime": now.toString(),
        "title": widget.groupTitle,
        "msgFullCount": widget.msgFullCount,
        "msgFullPmCount": widget.msgFullPmCount,
        "lastPmMsg": _chatMessageText.text
      };

      if (messageCount > 120 &&
          (msgDeliveryMode == "Prime" || msgDeliveryMode == "Non-Prime")) {
        nonPrimeMessageContent.removeAt(0);
        nonPrimeMessageContent.add(body);
        FirebaseController.instanace.sendToClear121Message(widget.chatId,
            nonPrimeMessageContent, lastMessageBody, msgDeliveryMode);
      } else {
        FirebaseController.instanace.sendChatMessage(
            widget.chatId, body, lastMessageBody, msgDeliveryMode);
      }

      _chatMessageText.text = "";
      scrollToBottomFun();
      Timer(
          Duration(milliseconds: 500),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    } catch (e) {
      print('error at sending message ${e}');
    }
  }
}
