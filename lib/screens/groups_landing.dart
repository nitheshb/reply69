import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
final Color color3 = Color(0xff14142B);
final Color color4 = Color(0xffFFF7F4);
//final Color color4=Color(0xffE8FDF6);
final Color color2 = AppTheme.kteal;
final Color color1 = AppTheme.ktheme;

final style2 = GoogleFonts.poppins(
    color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600);

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
      approvedGroups = [],
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
  int _current=0;
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

  void _toggleTab() {
    _tabController.animateTo(1);
  }

  getlocalPrime_OwnGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    approvedGroups = await prefs.getStringList('approvedPrimeGroups');
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
                    child: 
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(
                        "Created Groups ",
                        style: style2.copyWith(
                                                  fontSize: 24,
                                                  color: Color(0xffA0A3BD),
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1
                                                  ),
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
            child: Padding(
              padding: const EdgeInsets.only(left:0.0),
              child: Text(
                "Following Groups ",
                style: style2.copyWith(
                                                    fontSize: 24,
                                                    color: Color(0xffA0A3BD),
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.25
                                                    ),
              ),
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
        ),
        Container(color: Colors.pink,height: 500,width: double.infinity,child:  CarouselWithIndicatorDemo(),),

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
                      SizedBox(height: 6),
                      Container(
                        height: 57,
                                    decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(0xffEFF0F6),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.4),
                                //     blurRadius: 9.0,
                                //     spreadRadius: 1.0,
                                //   ),
                                // ]
                                ),
                        
                        child: Padding(
                          padding: const EdgeInsets.only(top:7.5, bottom: 7.5, left: 4, right: 4),
                          child: TextField(

                              onChanged: (val) {
                                setState(() {
                                  _searchTerm = val;
                                  print('search term ${_searchTerm}');
                                });
                              },
                              style: new TextStyle(
                                  color:  Color(0xff14142B), fontSize: 20),
                              decoration: new InputDecoration(
                                filled: true,
                                 fillColor: Color(0xffEFF0F6),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  // enabledBorder: OutlineInputBorder(
                                  //     borderSide:
                                  //     BorderSide(color: color3, width: 2)),
                                  // focusedBorder: OutlineInputBorder(
                                  //     borderSide: BorderSide(
                                  //         color: Color(0xffEFF0F6))),
                                   
                                  // border: OutlineInputBorder(
                                  //     borderSide:
                                  //     BorderSide(color: Color(0xffEFF0F6), width: 2)),
                                   border: InputBorder.none,
                                  hintText: 'Search Group Name....',
                                  isDense: true,                      // Added this

                                  hintStyle: GoogleFonts.poppins(
    color: Color(0xffA0A3BD), fontSize: 16, fontWeight: FontWeight.w600),
                                  prefixIcon:
                                  Icon(Icons.search, color: color3, size: 28))),
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
                    SizedBox(height: 60,),
                    Column(
                        children: [
                          Container(
                            height: 70,
                            width: double.infinity,
                            child: CarouselSlider(
                              items: expertSliders,
                              options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  //aspectRatio: 2.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imgList.map((url) {
                              int index = imgList.indexOf(url);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ]
                    ),
//                    SingleChildScrollView(
//                      //code for trendindg widget
//                      scrollDirection: Axis.horizontal,
//                      child: Row(
//                        children: <Widget>[
//                          Column(
//                            children: <Widget>[
//                              SizedBox(
//                                height: 80,
//                                //width: 500,
//                                child: Container(
//                                  child: StreamBuilder(
//                                      stream: searchGroupsQuery('G'),
//                                      builder: (context, snapshot) {
//                                        if (!snapshot.hasData) {
//                                          print("Loading");
//                                        } else {
//                                          return Container(
//                                            child: ListView.builder(
//                                                itemCount: snapshot.data['payload']
//                                                    .length,
//                                                shrinkWrap: true,
//                                                padding: EdgeInsets.only(top: 8),
//                                                physics: BouncingScrollPhysics(),
//                                                scrollDirection: Axis.horizontal,
//                                                itemBuilder: (context, index){
//                                                  DocumentSnapshot ds = snapshot.data;
//                                                  return Container(
//                                                    //height: 30,
//                                                    //child: Text(ds['payload'][index]['title']),
//                                                    child: trending(
//                                                      ds['payload'][index]
//                                                          ['logo'],
//                                                      ds['payload'][index]
//                                                          ['title'],
//                                                      ds['payload'][index]
//                                                          ['ownerName'],
//                                                    ),
//                                                  );
//                                                }
//                                            ),
//                                          );
//                                        }
//                                        return Container();
//                                      }),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    )
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
        var chatId = approvedGroups.contains(NotifyData['chatId'])
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
        "${approvedGroups.contains(NotifyData['chatId'])
            ? NotifyData['pm']
            : NotifyData['m']}",
        time: "${""}",
        amiPrime: approvedGroups.contains(NotifyData['chatId']),
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
                TabBar(
                  controller: _tabController,
                  indicatorColor: Color(0xff14142B),
                  unselectedLabelColor: Color(0xff6E7191),
                  labelColor: Color(0xff14142B),
                  
                  isScrollable: false,
                  labelStyle: style2.copyWith(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.25
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
                      text: "Follow",
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
              padding: EdgeInsets.all(5),
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
        //     boxShadow: [
        //       BoxShadow(
        //         color: color1.withOpacity(0.1),
        //         blurRadius: 0,
        //         offset: Offset(0, 0),
        //       )
        //     ],
        //     gradient: LinearGradient(
        //       colors: [Color(0xffF1F3F6), Color(0xffF1F3F6)],
        //     ),
        //     borderRadius: BorderRadius.circular(6),
        //     color: Color(0xffF1F3F6)),
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
                    height: 40,
                    width: 120,
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
border: Border.all(color: AppTheme.ktheme),
                      color: isFollow
                          ? AppTheme.ktheme
                          : Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isFollow ? "Following" : "Follow",
                        style: isFollow
                            ? GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xffF7F7FC),
                        )
                            : GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.ktheme,
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

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];


searchGroupsQuery(query) {
  if (query != null && ((query.length == 1))) {
    var followGroupState =
    FirebaseController.instanace.searchResultsByName(query);
    return followGroupState;
  } else {
    return;
  }
}

final List<Widget> expertSliders = imgList.map((item) => Container(
  child: StreamBuilder(
      stream: searchGroupsQuery('G'),
      builder: (context, snapshot) {
        DocumentSnapshot ds = snapshot.data;
        int index=1;
        if (!snapshot.hasData) {
          print("Loading");
        } else {
          return Container(
            child: Container(
                    //child: Text(ds['payload'][index]['title']),
                    child: trending(
                      ds['payload'][index]
                      ['logo'],
                      ds['payload'][index]
                      ['title'],
                      ds['payload'][index]
                      ['ownerName'],
                    ),
                  ),
          );
        }
        return Container(
        );
      }),
)).toList();

Widget trending(logoUrl, title, owner){
  return Container(
    child: Column(
      children: <Widget>[
        Card(
          elevation: 3,
          //color: Colors.white70,
          child: Container(
            padding: EdgeInsets.all(5),
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

final List<Widget> imageSliders = imgList.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(item, fit: BoxFit.fill, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'Win like these Experts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
    ),
  ),
)).toList();

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Win cash with Experts')),
      body: Column(
          children: [
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((url) {
                int index = imgList.indexOf(url);
                return Container(
                  width: 4.0,
                  height: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ]
      ),
    );
  }
}


