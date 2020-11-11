import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/app_theme.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/models/users.dart';
import 'package:notification/pages/groupProfile1.dart';
import 'package:notification/screens/conversation.dart';
import 'package:notification/screens/createGroup.dart';
import 'package:notification/screens/main_screen.dart';
import 'package:notification/util/NotifyJson.dart';
import 'package:notification/util/auth.dart';
import 'package:notification/util/data.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/displayChatsMenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

//final Color color1=AppTheme.kdarkorange;
//final Color color2=AppTheme.korange;
final Color color3 = Colors.black.withOpacity(0.6);
final Color color4 = Color(0xffFFF7F4);
//final Color color4=Color(0xffE8FDF6);
final Color color2 = AppTheme.kteal;
final Color color1 = AppTheme.ktheme;

class GroupsLandingScreen extends StatefulWidget {
  GroupsLandingScreen({Key key,
    this.uId,
    this.uEmailId,
    this.followingGroupsLocal,
    this.followingGroupsReadCountLocal})
      : super(key: key);
  final String uId, uEmailId;
  List followingGroupsLocal, followingGroupsReadCountLocal;

  @override
  _GroupsLandingScreenState createState() => _GroupsLandingScreenState();
}

class _GroupsLandingScreenState extends State<GroupsLandingScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  StateModel appState;
  List waitingGroups = [],
      approvedGroupsP = [],
      myOwnGroups = [],
      followingGroupsP = [],
      followingGroups = [],
      primeGroups = [];

  String _searchTerm;
  bool allowGroupCreation = true;
  List widgetCountCheck = [];

  List NotifyData = [];
  List searchLists = [];
  int selTabIndex;
  var shimmer = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);

    getlocalPrime_OwnGroups();
    selTabIndex = 0;

    // new Future.delayed(Duration.zero, () {
    //   loopFollowingGroup(followingGroupsP);
    // });
  }
   void didChangeDependencies() {
      super.didChangeDependencies();
      // set your stuff here 
      print('%%%%%%%%%%%%%% what is this about');
       getlocalPrime_OwnGroups();
      }

  void _toggleTab() {
    _tabController.animateTo(1);
  }


syncApprovedData(syncCheck, approvedNewData) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> approvedGroupsList = [];
approvedGroupsP =approvedNewData;
// getlocalPrime_OwnGroups();
   await approvedNewData.forEach((data) async {
        // search for the rc count and update it
        await approvedGroupsList.add(data);

  prefs.setStringList('approvedPrimeGroups' , approvedGroupsList);
 approvedGroupsP =  prefs.getStringList('approvedPrimeGroups');
 

      });
   
   getlocalPrime_OwnGroups();
}
  getlocalPrime_OwnGroups() async {

    print(' iwas called');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = await prefs.getString('userId');
    print('===============> $userId');
      DocumentSnapshot variable =  await Firestore.instance
          .collection('IAM')
          .document(userId)
          .get();
          

          print('value of shit is ${variable.data['approvedGroups']}');


    
    approvedGroupsP = await prefs.getStringList('approvedPrimeGroups');
    myOwnGroups = await prefs.getStringList('myOwnGroups_pref');
    followingGroupsP = await prefs.getStringList('followingGroups_pref');

    if (myOwnGroups == null) {
      myOwnGroups = [];
    }

    List addFollowMyOwnGroups = [...followingGroupsP, ...myOwnGroups];

    await loopFollowingGroup(addFollowMyOwnGroups);
    print('local true by swetan1 ${addFollowMyOwnGroups}');
  }


  void updateInformation(String information) {}

  loopFollowingGroup(dataArray) {
    dataArray.forEach((data) {
      realTime(data);
    });
  }

  realTime(id) {
    if (id == null) {
      return;
    }
    DatabaseReference postsRef =
    FirebaseDatabase.instance.reference().child("Notify").child(id);
    postsRef.onValue.listen((event) async {
      var snap = event.snapshot;

      // var keys = snap.value.keys;
      var data = snap.value;

      // NotifyData.clear();
      if (data != null) {
        //code for disabaling shiimmer effect
        // setState(() {
        //   shimmer = false;
        // });

        NotifyData.removeWhere((item) => item['t'] == '${data['t']}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var msgReadCountvar = prefs.getInt("${"qoX1aNeMcKgl69UCntgq"}");

        data['chatId'] = id;
        data['readCount'] = msgReadCountvar ?? 0;
        NotifyData.add(data);

        print("notify is ${NotifyData}");
      } else {
        //code for shimmer effect

        double containerWidth = 280;
        double containerHeight = 15;
        //code for shimmer effect
        ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Shimmer.fromColors(
                  highlightColor: Colors.white,
                  baseColor: Colors.grey[300],
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 7.5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          color: Colors.grey,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: containerHeight,
                              width: containerWidth,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: containerHeight,
                              width: containerWidth,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: containerHeight,
                              width: containerWidth * 0.75,
                              color: Colors.grey,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  period: Duration(milliseconds: 2),
                ));
          },
        );
      }

      setState(() {});
    });
  }

  getMsgReadCount(chatId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var msgReadCountvar = prefs.getInt("${chatId}");
    return msgReadCountvar ?? 1000;
  }

  Widget messagesTabDisplay(context, userId) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Visibility(
          visible: myOwnGroups.length > 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Created Groups ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff3A4276),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  ListView.builder(
                    itemCount: NotifyData.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return myOwnGroups.contains(NotifyData[index]['chatId'])
                          ? recentChatDetailsCard(
                        NotifyData[index],
                        userId,
                        0,
                      )
                          : Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Following Groups ",
              // style: TextStyle(
              //   fontSize: 18,
              //   color: Color(0xff3A4276),
              //   fontWeight: FontWeight.w700,
              // ),
              style: TextStyle(
                  fontSize: 22,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        followingGroupsP.length == 0
            ? noGroupsFolllowed()
            : ListView.builder(
          itemCount: NotifyData.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 8),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var searchGroupForReadCount;
            try {
              searchGroupForReadCount = widgetCountCheck.firstWhere(
                      (data) =>
                  data['chatId'] == NotifyData[index]['chatId']);
            } catch (e) {
              print('error is ${e}');
              searchGroupForReadCount = {'readCount': 0};
            }

            return (followingGroupsP
                .contains(NotifyData[index]['chatId']))
                ? recentChatDetailsCard(
              NotifyData[index],
              userId,
              searchGroupForReadCount['readCount'] ?? 0,
            )
                : Container();
          },
        )
      ]),
    );
  }

  Widget followGroupsTabDisplay(context, userId) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(180),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 9, left: 12, right: 12),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.white],
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.circular(6),
                    //color: Color.fromRGBO(49, 39, 79, 1),
                    border: Border.all(color: color1.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 0,
                        offset: Offset(0, 0),
                      )
                    ]),
                //height: 140,
                //width: double.infinity,
                child: Container(
                  //height: MediaQuery.of(context).size.height*0.35,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, right: 15, left: 15, bottom: 0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 2),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Win more under guidance of Experts",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: color3.withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Follow to receive expert messages",
                                  style: GoogleFonts.openSans(
                                    fontSize: 14.5,
                                    color: color3,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  _searchTerm = val;
                                  print('search term ${_searchTerm}');
                                });
                              },
                              style: new TextStyle(
                                  color: color3.withOpacity(0.9), fontSize: 20),
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: color3, width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: color3.withOpacity(0.9))),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: color3, width: 2)),
                                  // border: InputBorder.none,
                                  hintText: 'Search Group Name....',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: color3.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon:
                                  Icon(Icons.search, color: color3))),
                        ),
                      ),
                      // SizedBox(height: 200,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: searchGroupsQuery(_searchTerm),
            builder: (context, snapshot) {
              // display default img/ placeholder when no results are available
              if (!snapshot.hasData || _searchTerm== null||_searchTerm.length == 0) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: new Container(
                        height: 128,
                        width: 140,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/searchFind.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: new Container(
                        height: 40,
                        // width: 160,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text("Use above search bar to find",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Top Experts",
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    )),
                              ),
                    ),
                    SingleChildScrollView(
                      //code for trendindg widget
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 80,
                                //width: 500,
                                child: Container(
                                  child: StreamBuilder(
                                      stream: searchGroupsQuery('G'),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          print("Loading");
                                        } else {
                                          return Container(
                                            child: ListView.builder(
                                                itemCount: snapshot.data['payload']
                                                    .length,
                                                shrinkWrap: true,
                                                padding: EdgeInsets.only(top: 8),
                                                physics: BouncingScrollPhysics(),
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index){
                                                  DocumentSnapshot ds = snapshot.data;
                                                  return Container(
                                                    //height: 30,
                                                    //child: Text(ds['payload'][index]['title']),
                                                    child: trending(
                                                      ds['payload'][index]
                                                          ['logo'],
                                                      ds['payload'][index]
                                                          ['title'],
                                                      ds['payload'][index]
                                                          ['ownerName'],
                                                    ),
                                                  );
                                                }

                                            ),
                                          );
                                        }
                                        return Container();
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasData) {
                return snapshot.data['payload'].length == 0
                    ? Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 60),
                      new Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 3,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                AssetImage('assets/searchFind.png'),
                                fit: BoxFit.cover)),
                      ),
                      new Text('No Matched Data Found'),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: snapshot.data['payload'].length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 8),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DocumentSnapshot temp = snapshot.data;
                    DocumentSnapshot ds;
                    var a;
                    a = temp['payload'][index]['title'];
                    if (a.contains(
                      //if loop for improving search results
                        new RegExp(_searchTerm, caseSensitive: false))) {
                      ds = snapshot.data;
                      var followersA = [];
                      return InkWell(
                        // This is card Widget
                        child: buildApplication(
                            ds['payload'][index]['logo'],
                            ds['payload'][index]['title'],
                            ds['payload'][index]['ownerName'],
                            ds['payload'][index]['category'],
                            followingGroupsP
                                .contains(ds['payload'][index]['chatId']),
                            ds['payload'][index]['chatId'],
                            userId),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Profile3(
                                        title: ds['payload'][index]['title'],
                                        avatarUrl: ds['payload'][index]
                                        ['logo'],
                                        categories: ds['payload'][index]
                                        ['category'],
                                        following:
                                        followersA.contains(widget.uId),
                                        chatId: ds['payload'][index]
                                        ['chatId'],
                                        userId: userId,
                                        followers: ds['payload'][index]
                                        ['followers'] ??
                                            [],
                                        groupOwnerName: ds['payload'][index]
                                        ['ownerName'] ??
                                            '',
                                        feeDetails: ds['payload'][index]
                                        ['FeeDetails'] ??
                                            [],
                                        seasonRating: ds['payload'][index]
                                        ['seasonRating'] ??
                                            'NA',
                                        thisWeekRating:
                                        ds['payload'][index]['thisWeekRating'] ??
                                            'NA',
                                        lastWeekRating: ds['payload'][index]['lastWeekRating'] ??
                                            'NA',
                                        followingGroupsLocal: followingGroupsP)),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }

                    // Todo:  check y this followersA was declared
                  },
                );
              }
              return Container();
            },
          ),
        ));
  }

  Widget recentChatDetailsCard(NotifyData, userId, alreadyReadCount) {
    return InkWell(
      onTap: () async {
        var snap = await FirebaseController.instanace
            .getChatOwnerId(NotifyData['chatId']);
        var chatId = approvedGroupsP.contains(NotifyData['chatId'])
            ? "${NotifyData['chatId']}PGrp"
            : "${NotifyData['chatId']}";
        final information = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Conversation(
                    followingGroupsLocal: followingGroupsP,
                    groupFullDetails: [],
                    chatId: chatId,
                    groupSportCategory: [],
                    chatOwnerId: snap['o'],
                    groupTitle: NotifyData['t'] ?? "",
                    groupLogo: NotifyData['i'],
                    followers: [],
                    approvedGroupsJson: [],
                    userId: widget.uId,
                    senderMailId: widget.uEmailId,
                    chatType: "",
                    waitingGroups: waitingGroups,
                    approvedGroups: [],
                    followersCount: snap['c'] ?? 0,
                    msgFullCount: NotifyData['c'],
                    msgFullPmCount: NotifyData['pc'],
                    msgReadCount: 0),
          ),
        );
        updateInformation(information);
      },
      child: ChatMenuIcon(
        user: userId,
        dp: "${NotifyData['i']}",
        groupName: "${NotifyData['t']}",
        isOnline: true,
        counter: "${NotifyData['c'] - alreadyReadCount}",
        // counter: 0,
        msg:
        "${approvedGroupsP.contains(NotifyData['chatId'])
            ? NotifyData['pm']
            : NotifyData['m']}",
        time: "${""}",
        amiPrime: approvedGroupsP.contains(NotifyData['chatId']),
        amiOwner: myOwnGroups.contains(NotifyData['chatId']),
      ),
    );
  }

  Widget noGroupsFolllowed() {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height / 4.5),
            new Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 5.5,
              child: Icon(
                FontAwesomeIcons.star,
                color: Colors.grey,
                size: 70,
              ),
            ),
            Column(
              children: <Widget>[
                new Text("No groups subscribed yet",
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    _toggleTab();
                  },
                  child: new Text("Subscribe to a group",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: color2,
                        fontWeight: FontWeight.w600,
                      )),
                )
              ],
            ),
          ],
        ));
  }

  Widget groupSearViewRealDB(_searchTerm) {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child("NameSearch")
            .orderByChild("childNode")
            .startAt('$_searchTerm')
            .endAt('${_searchTerm}\uF7FF')
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (!snapshot.hasData)
            return Column(
              children: <Widget>[
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: new Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/searchFind.png'),
                            fit: BoxFit.fill)),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.topLeft,
                  child: new Container(
                    height: 160,
                    // width: 160,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Type to find a group...!",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );

          if (snapshot.hasData) {
            searchLists.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              searchLists.add(values);
            });
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: searchLists.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Name: " + searchLists[index]["n"]),
                      ],
                    ),
                  );
                });
          }
          return CircularProgressIndicator();
        });
  }

  void _showBasicsFlash({
    Duration duration,
    flashStyle = FlashStyle.floating,
    BuildContext context,
    String messageText,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          style: flashStyle,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            message: Text('$messageText'),
          ),
        );
      },
    );
  }

  List<Widget> _buildSelectedOptions(dynamic values) {
    List<Widget> selectedOptions = [];

    if (values != null) {
      values.forEach((item) {
        selectedOptions.add(
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 6,
            ),
            child: Center(
              child: Text(
                "${item['categoryName'] ?? item}",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      });
    }

    return selectedOptions;
  }

  searchGroupsQuery(query) {
    if (query != null && ((query.length == 1))) {
      var followGroupState =
      FirebaseController.instanace.searchResultsByName(query);
      return followGroupState;
    } else {
      return;
    }
  }

  readCountLooper(array) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widgetCountCheck = [];

    followingGroupsP.forEach((chatId) {
      var readCountLocal = prefs.getInt("${chatId}");
      var payload = {'chatId': chatId, 'readCount': readCountLocal ?? 0};
      widgetCountCheck.add(payload);
    });
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //followingGroups =  ['nQ4T04slkEdANneRb4k62'];
    appState = StateWidget
        .of(context)
        .state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    final followGroupState = appState.followingGroups;
    final phoneNumber = appState.user.phoneNumber;
    var data = Auth.getFollowingGroups;

    readCountLooper(followingGroupsP);

    if (widget.followingGroupsReadCountLocal == null) {
      widget.followingGroupsReadCountLocal = [];
    }

    // getUserData(userId);

    if (followingGroupsP == null) {
      followingGroupsP = followGroupState;
    }

    // followingGroupsP.forEach((data){
    //   realTime(data);
    //     print('data@@ ${data}');
    //   });

    return Scaffold(
      // appBar: appBarWid(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            // backgroundColor: color1,

            flexibleSpace: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 0),
                  child: Container(
                    width: double.infinity,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'MyExperts',
                          style: GoogleFonts.nunito(
                              color: Colors.black38.withOpacity(0.9),
                              fontSize: 24,
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                ),
            
                 StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection('IAM').document(userId).snapshots(),
                      builder: (BuildContext context, snapshot){
                        if(snapshot.hasError) {
                        print('erros ${snapshot.hasError}');
                          return Center(child: Text('Error: '));
                        }
                        else if(snapshot.hasData) {

                          Function deepEq = const DeepCollectionEquality().equals;
List list1 = [ 1, 2, 3];
List list2 = [ 1, 2, 3];
// print(    eq(list1, list2)); // => false
print(deepEq(list1, list2));
Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
                        var check =  unOrdDeepEq(list1,list1);
                        // var check1 =  unOrdDeepEq( [ 1, 3, 2],[ 1, 2, 3]);
                        // var check3 =   unOrdDeepEq([ 1, 3] == [ 1, 2]);
                        //  print('doctor is is  $check ,  $check1 , $check3  ${snapshot.data.data}');

                          var ds = snapshot.data.data;
                     
                          List followingGroups = ds['followingGroups0'];
                         
                          List approvedGroups = ds['approvedGroups'];
                          // List approvedGroups = ['approvedNewData'];
                          List myOwnGroups = ds['myOwnGroups'] ;

                          print('doctor is is ${deepEq(approvedGroups,approvedGroupsP )}  ${approvedGroupsP}');

                          if(! deepEq(approvedGroups,approvedGroupsP )) {
                             syncApprovedData('sync', approvedGroups);
                          }
                          
                         return Container();
                        }
                        

                      },
                    ),
                
                TabBar(
                  controller: _tabController,
                  indicatorColor: Theme
                      .of(context)
                      .accentColor,
                  labelColor: Theme
                      .of(context)
                      .accentColor,
                  unselectedLabelColor:
                  Theme
                      .of(context)
                      .textTheme
                      .caption
                      .color,
                  isScrollable: false,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xff3A4276),
                    fontWeight: FontWeight.w400,
                  ),
                  onTap: (index) {
                    setState(() {
                      selTabIndex = index;
                    });
                  },
                  tabs: <Widget>[
                    Tab(
                      text: "Messages",
                    ),
                    Tab(
                      text: "Follow Experts",
                    ),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(controller: _tabController, children: <Widget>[
          // first tab
          messagesTabDisplay(context, userId),

          // second tab
          followGroupsTabDisplay(context, userId)
        ]),
        floatingActionButton: Visibility(
          // this floating button should be visiable only in Follow Experts Tab
          visible: selTabIndex == 1,
          child: FloatingActionButton(
            backgroundColor: color1,
            child: Container(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (allowGroupCreation) {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateGroupProfile(
                            primaryButtonRoute: "/home",
                            followingGroupsLocal: followingGroupsP),
                  ),
                );
              } else {
                _showBasicsFlash(
                    context: context,
                    duration: Duration(seconds: 4),
                    messageText: 'Limit Reached.Unfollow any group to proceed');
              }
            },
          ),
        ));
  }

// UnFollow Group Function

  unFollowFun(chatId, userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.get('FCMToken');

    setState(() {
      followingGroupsP.remove(chatId);
      prefs.setStringList('followingGroups_pref', followingGroupsP);
    });

    await Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
          builder: (BuildContext context) =>
              MainScreen(
                  userId: userId, followingGroupsLocal: followingGroupsP),
        ),
            (Route<dynamic> route) => false);
  }

// Follow Group Function
  followFun(chatId, userId) async {
    // make an entry in db as joinedGroups
    try {
      //  this is for token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');

      prefs.setInt("${chatId}", 00000);

      if (followingGroupsP.length < 9) {
        FirebaseController.instanace.followGroup(chatId, userId, userToken);

        setState(() {
          followingGroupsP.add(chatId);
          prefs.setStringList('followingGroups_pref', followingGroupsP);
        });
        await Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainScreen(
                      userId: userId, followingGroupsLocal: followingGroupsP),
            ),
                (Route<dynamic> route) => false);
      } else {
        _showBasicsFlash(
            context: context,
            duration: Duration(seconds: 4),
            messageText: 'Overall max 9 group can be followed...!');
      }
    } catch (e) {
      _showBasicsFlash(
          context: context,
          duration: Duration(seconds: 4),
          messageText: 'error at following ${e}');
    }
  }

  Widget trending(logoUrl, title, owner){
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 3,
            //color: Colors.white70,
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(logoUrl),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(90),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${title[0].toUpperCase() + title.substring(1)}",
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.userAlt,
                              size: 9,
                              color: Colors.grey[400],
                            ),
                            SizedBox(width: 3),
                            Text(
                              "${owner[0].toUpperCase() +
                                  owner.substring(1)}",
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),

                      ],
                    ),
                  )

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget buildApplication(logoUrl, title, owner, categories, isFollow, chatId,
      userId) {
    return Padding(
      padding: EdgeInsets.only(left: 13, right: 13, bottom: 2),
      child: Container(
        height: 106,
        padding: EdgeInsets.fromLTRB(19, 14, 19, 14),
        margin: EdgeInsets.symmetric(vertical: 2),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(10),
        //   ),
        // ),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: color1.withOpacity(0.1),
                blurRadius: 0,
                offset: Offset(0, 0),
              )
            ],
            gradient: LinearGradient(
              colors: [Color(0xffF1F3F6), Color(0xffF1F3F6)],
            ),
            borderRadius: BorderRadius.circular(6),
            color: Color(0xffF1F3F6)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(logoUrl),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(90),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${title[0].toUpperCase() + title.substring(1)}",
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.userAlt,
                                size: 9,
                                color: Colors.grey[400],
                              ),
                              SizedBox(width: 3),
                              Text(
                                "${owner[0].toUpperCase() +
                                    owner.substring(1)}",
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Wrap(
                                  spacing: 4.0, // gap between adjacent chips
                                  runSpacing: 1.0, // gap between lines
                                  children: _buildSelectedOptions(categories),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                InkWell(
                  onTap: () {
                    if (isFollow) {
                      unFollowFun(chatId, userId);
                    } else {
                      followFun(chatId, userId);
                    }
                  },
                  child: Container(
                    height: 35,
                    width: 92,
                    decoration: BoxDecoration(
//                    gradient: isFollow
//                        ? LinearGradient(
//                      colors: [
//                        Colors.grey,
//                        Colors.grey,
//                      ],
//                      begin: Alignment.topLeft,
//                      end: Alignment.topRight,
//                    )
//                        : LinearGradient(
//                      colors: [
//                        Colors.white,
//                      Colors.white,
//                      ],
//                      begin: Alignment.topLeft,
//                      end: Alignment.topRight,
//                    ),
                      color: isFollow
                          ? Colors.grey
                          : Theme
                          .of(context)
                          .accentColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isFollow ? "UnFollow" : "Follow",
                        style: isFollow
                            ? GoogleFonts.openSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        )
                            : GoogleFonts.openSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget appBarWid() {
    return AppBar(
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Colors.blueAccent, size: 10.0),
      elevation: 3,
      titleSpacing: 0,
      title: InkWell(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Title",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff3A4276),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: Text(
                          "Followers ",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff171822),
                          ),
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
    );
  }
}
