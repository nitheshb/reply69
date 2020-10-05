import 'dart:convert';
import 'package:notification/util/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/screens/conversation.dart';
import 'package:notification/screens/createGroup.dart';
import 'package:notification/screens/matchDetails.dart';
import 'package:notification/util/data.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/displayChatsMenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';


Color color1 = Colors.grey[600];

final style2 = GoogleFonts.nunito(
    color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600);

final style1 = GoogleFonts.nunito(
    color: Color(0xff352D80), fontSize: 18.5, fontWeight: FontWeight.w800);

final style3 = GoogleFonts.nunito(
    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800);

class DisplayMatches extends StatefulWidget {
  DisplayMatches({
    Key key,
    this.uId,
    this.uEmailId,
  }) : super(key: key);
  final String uId, uEmailId;
  @override
  _DisplayMatchesState createState() => _DisplayMatchesState();
}

class _DisplayMatchesState extends State<DisplayMatches>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  StateModel appState;
  List waitingGroups = [], approvedGroups = [], followingGroups = [];
  List chatIdGroups = [
    'nQ4T04slkEdANneRb4k6',
    'nQ4T04slkEdANneRb4k61',
    'nQ4T04slkEdANneRb4k62',
    'nQ4T04slkEdANneRb4k63',
    'nQ4T04slkEdANneRb4k64',
    'nQ4T04slkEdANneRb4k65',
    'nQ4T04slkEdANneRb4k66',
    'nQ4T04slkEdANneRb4k67',
    'nQ4T04slkEdANneRb4k68',
    'btl5r2JUwn5imaTToPKq'
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 4);
    print('iwas called');
  }

  // void dispose() {
  //   super.dispose();
  // }

  saveLocal(index, lastMessagesIs, chatDocId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {'chatId': index, 'lastMessage': lastMessagesIs.length};
    // new chat id means no reads

    if (chatDocId == null) {
      prefs.setInt('$chatDocId', lastMessagesIs.length);
      return lastMessagesIs.length;
    } else {
      var chatDataIs = await prefs.getInt('$chatDocId');

      return (lastMessagesIs.length - chatDataIs);
    }
    //  print('chat data is ${chatDataIs}');
  }

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //followingGroups =  ['nQ4T04slkEdANneRb4k62'];
    appState = StateWidget.of(context).state;
    // getUserData(userId);
    print('check ${followingGroups}');

    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          isScrollable: false,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w400,
          ),
          tabs: <Widget>[
            Tab(
              text: "Cricket",
            ),
            Tab(
              text: "Baseball",
            ),
            Tab(
              text: "Basketball",
            ),
            Tab(
              text: "FootBall",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          MatchListBuilder('Cricket'),
          MatchListBuilder('Baseball'),
          MatchListBuilder('Basetball'),
          MatchListBuilder('Football'),
          // second tab
        ],
      ),
    );
  }

  Widget MatchListBuilder(categoryName) {
    return Container(
        child: StreamBuilder(
            stream: FirebaseController.instanace.getMatchesList(categoryName),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              }
              if (snapshot.hasData && snapshot.data.documents.length == 0) {
                var imgLink;
                if (categoryName == "Basketball") {
                  imgLink =
                      "https://static.sports.roanuz.com/images/plans/performance.svg";
                }
                return Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 4.5),
                        new Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: SvgPicture.asset('assets/performance.svg'),
                        ),
                        new Text(
                          'No ${categoryName} Matches Scedules',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Color(0xff3A4276),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ));
              }
              if (snapshot.hasData && snapshot.data.documents.length > 0) {
                // return Text("snapshot ${snapshot.data.documents.length}");
                return InkWell(
                  child: ListView.separated(
                    padding: EdgeInsets.all(10),
                    separatorBuilder: (BuildContext context, int index) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 0.5,
                          // width: MediaQuery.of(context).size.width / 1.3,
                          child: Divider(
                            color: Colors.transparent,
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                     // Map friend = friends[index];
                      DocumentSnapshot ds = snapshot.data.documents[index];
                      var matchDetails = ds['matchDetails'] ?? {};
                      var format = DateFormat('d-MMMM HH:mm a');

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Constants.lightPrimary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 9.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right:10,top: 5),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MatchDetails()));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Today in 09h 47m 44s',style:style2.copyWith(fontSize: 11,color: Colors.red,fontWeight: FontWeight.w800)),
                                      Text('Indian T20 League, 2020',style: style2.copyWith(fontSize: 11,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[600].withOpacity(0.3),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("${matchDetails['team-1']}"),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:10.5),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          matchDetails['team_1_pic'],
                                        ),
                                        radius: 20,
                                      ),
                                    ),
                                    Text('vs',style: TextStyle(color: Colors.grey),),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:10.5),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          matchDetails['team_2_pic'],
                                        ),
                                        radius: 20,
                                      ),
                                    ),
                                    Text("${matchDetails['team-2']}"),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey[600].withOpacity(0.3),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Join your 1st Contest',style: style2.copyWith(fontSize: 11,fontWeight: FontWeight.bold)),
                                    GestureDetector(
                                      onTap: (){
                                      _settingModalBottomSheet(context);
                                      },
                                      child: Text('Pre Match Analysis',style:style2.copyWith(fontSize: 11,color: Colors.green,fontWeight: FontWeight.w800)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

//                      return Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Container(
//                            child: Row(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                              Column(
//                                children: <Widget>[
//                                  CircleAvatar(
//                                    backgroundImage: NetworkImage(
//                                      matchDetails['team_1_pic'],
//                                    ),
//                                    radius: 25,
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.only(top: 8.0),
//                                    child: Text("${matchDetails['team-1']}",
//                                        style: GoogleFonts.poppins(
//                                          fontSize: 15,
//                                          color: Color(0xff3A4276),
//                                          fontWeight: FontWeight.w800,
//                                        )),
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: Text(
//                                      'Join Contest',
//                                      style: TextStyle(
//                                          color: Colors.grey[600],
//                                          fontSize: 13,
//                                          fontWeight: FontWeight.bold),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              GestureDetector(
//                                onTap: () {
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (context) =>
//                                              MatchDetails()));
//                                },
//                                child: Column(
//                                  children: <Widget>[
//                                    Text("${matchDetails['type']}",
//                                        style: GoogleFonts.poppins(
//                                          fontSize: 12,
//                                          color: Color(0xff3A4276),
//                                          fontWeight: FontWeight.w700,
//                                        )),
//                                    SizedBox(height: 30),
//                                    Text(
//                                        "${format.format(DateTime.fromMicrosecondsSinceEpoch(int.parse(ds['startTime']) * 1000))}",
//                                        style: GoogleFonts.poppins(
//                                          fontSize: 12,
//                                          color: Color(0xff3A4276),
//                                          fontWeight: FontWeight.w500,
//                                        )),
//                                  ],
//                                ),
//                              ),
//                              Column(
//                                children: <Widget>[
//                                  CircleAvatar(
//                                    backgroundImage: NetworkImage(
//                                      matchDetails['team_2_pic'],
//                                    ),
//                                    radius: 25,
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.only(top: 8.0),
//                                    child: Text("${matchDetails['team-2']}",
//                                        style: GoogleFonts.poppins(
//                                          fontSize: 15,
//                                          color: Color(0xff3A4276),
//                                          fontWeight: FontWeight.w800,
//                                        )),
//                                  ),
//                                  GestureDetector(
//                                    onTap: () {
//                                      _settingModalBottomSheet(context);
//                                    },
//                                    child: Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Text(
//                                        'Pre Match Analysis',
//                                        style: TextStyle(
//                                            color: Colors.green,
//                                            fontSize: 13,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ])),
//                      );
                    },
                  ),
                );
              }
              return Text("Loading...");
            }));
  }

  @override
  bool get wantKeepAlive => true;
}

void _settingModalBottomSheet(context) {


  showModalBottomSheet<dynamic>(
      // barrierColor: Colors.black.withOpacity(0.7),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.1,
            height: 655,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: GestureDetector(
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 25,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 23.0, left: 2),
                          child: Text('Pre Match Analysis', style: style1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 2),
                          child: Text('Indian T20 League, 2020', style: style2),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 60),
                      child: Text('⏱ 9h 47m Left', style: style2),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                Divider(
                  height: 10,
                  color: Colors.grey.withOpacity(0.1),
                  thickness: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset('assets/facts.png',
                            width: 25, height: 25),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          bottom: 3, // space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Color(0xffEBD148), // Text colour here
                          width: 3.0, // Underline width
                        ))),
                        child: Text("Match", style: style3),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          bottom: 3, // space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.transparent, // Text colour here
                          width: 3.0, // Underline width
                        ))),
                        child: Text(" Facts", style: style3),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/checklist.png',
                          width: 20, height: 20),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "It\'s easy to not look beyond Warner or Baristow, but \nManish Pandey has been solid for Hydrabad with 85 \nruns in 2 games at an average of 43.",
                        style: style2.copyWith(
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 15, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/checklist.png',
                          width: 20, height: 20),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Rishabh Pant is a dasher but you can take a punt on \nhim since he has scored 31 in the first match & 37 in \nthe second.",
                        style: style2.copyWith(
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 15, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/checklist.png',
                          width: 20, height: 20),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Jonny Bairstow failed to make a big score in the 2nd \nmatch but he made a handy 61 in the first & could do \nso again.",
                        style: style2.copyWith(
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 15, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/checklist.png',
                          width: 20, height: 20),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Anrich Nortje has had a good tournament , picked up \n2 wickets at an economy rate just under 7",
                        style: style2.copyWith(
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xffEDFFf0),
                        border: Border.all(color: Color(0xffd9f9d1))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/idea.png',
                                  width: 22, height: 22),
                              Text(
                                'Tip',
                                style: style3.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            "Depending on who bats first, try picking your captain \nfrom the team,since it is easier to bat without \nscoreboard pressure as trend has shown in this \ntournament & both these team prefer to bat first.",
                            style: style2.copyWith(
                              color: Colors.black,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Is this information helpful?',
                        style: style2.copyWith(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 25,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                              child: Text(
                            'Yes',
                            style:
                                TextStyle(fontSize: 12.5, color: Colors.grey),
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          height: 25,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                              child: Text(
                            'No',
                            style:
                                TextStyle(fontSize: 12.5, color: Colors.grey),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff00C37A),
                        Color(0xff00A155),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'PLAY NOW',
                    style:
                        style3.copyWith(color: Colors.white.withOpacity(0.9)),
                  )),
                ),
              ],
            ),
          ),
        );
      });
  //#00A155 #00C37A
}
