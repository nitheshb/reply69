import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/controllers/notificationController.dart';
import 'package:notification/pages/chatWindow.dart';
import 'package:notification/screens/conversation.dart';
import 'package:notification/screens/createGroup.dart';
import 'package:notification/util/data.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/displayChatsMenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

class _DisplayMatchesState extends State<DisplayMatches> with SingleTickerProviderStateMixin,
    AutomaticKeepAliveClientMixin{
  TabController _tabController;
  StateModel appState;  
  List waitingGroups = [], approvedGroups =[], followingGroups =[];
  List chatIdGroups = ['nQ4T04slkEdANneRb4k6','nQ4T04slkEdANneRb4k61','nQ4T04slkEdANneRb4k62','nQ4T04slkEdANneRb4k63','nQ4T04slkEdANneRb4k64','nQ4T04slkEdANneRb4k65','nQ4T04slkEdANneRb4k66','nQ4T04slkEdANneRb4k67','nQ4T04slkEdANneRb4k68','btl5r2JUwn5imaTToPKq'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 4);
    print('iwas called');
     getUserData(widget.uId);
    
  }

    // void dispose() {
  //   super.dispose();
  // }

getUserData(userId)async {
  var response = await  Firestore.instance.collection('IAM').document(userId).get();
  print(('respnse is ${response.data}'));
  setState(() {
   waitingGroups = response.data['WaitingGroups'] ?? [];
   approvedGroups = response.data['approvedGroups'] ?? [];
   followingGroups = response.data['followingGroups'] ?? ['nQ4T04slkEdANneRb4k63'];

  });
  return response.data;
  }

  saveLocal(index,lastMessagesIs, chatDocId)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
  
    var body = {'chatId': index, 'lastMessage': lastMessagesIs.length};
              // new chat id means no reads
             
            if(chatDocId == null) {
                prefs.setInt('$chatDocId',lastMessagesIs.length);
                return lastMessagesIs.length ;
            }else{
              var chatDataIs = await prefs.getInt('$chatDocId');

              return (lastMessagesIs.length - chatDataIs);
            }
            //  print('chat data is ${chatDataIs}');
  }

 Future<List<DocumentSnapshot>> getFollowedGroups(userId) async {
  // print('aread details are ${areaId}');
  // Stream stream1 = manager.contactListNow;
  // getLengthMatches(areaId);
  var response = await  Firestore.instance.collection('IAM').document(userId).get();
  var followingGroups0 = response.data['followingGroups0'] ?? ['check'];
  var followingGroups1 = response.data['followingGroups1'] ?? ['check'];
  var followingGroups2 = response.data['followingGroups2'] ?? ['check'];
  var followingGroups3 = response.data['followingGroups3'] ?? ['check'];
    List<DocumentSnapshot> listSnaps = List();
     QuerySnapshot q1 = await Firestore.instance.collection('groups').where(
        'chatId', whereIn: followingGroups0.length >0 ? followingGroups0 : ['check'] )
        .getDocuments();
    QuerySnapshot q2 = await Firestore.instance.collection('groups').where(
        'chatId', whereIn: followingGroups1.length >0 ? followingGroups1 : ['check'] )
        .getDocuments();
    QuerySnapshot q3 = await Firestore.instance.collection('groups').where(
        'chatId', whereIn: followingGroups2.length >0 ? followingGroups2 : ['check'] )
        .getDocuments();
     QuerySnapshot q4 = await Firestore.instance.collection('groups').where(
        'chatId', whereIn: followingGroups3.length >0 ? followingGroups3 : ['check'] )
        .getDocuments();
    listSnaps.addAll(q1.documents);
    listSnaps.addAll(q2.documents);
    listSnaps.addAll(q3.documents);
    listSnaps.addAll(q4.documents);
print("--->check1");
    return listSnaps;
//    return stream1;
//     return StreamZip([stream1,stream2]);
//    Stream stream = StreamGroup.merge([stream1, stream2]).asBroadcastStream();
//    stream.listen((event) {
//      print(event);
//    });
//    return stream;
    // return Firestore.instance.collection(collectionName).where("mother_match_Id", isEqualTo: widget.matchId ).where("areaId",isEqualTo: areaId).where("status",isEqualTo: 'Start').snapshots();
  }

   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
         Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //followingGroups =  ['nQ4T04slkEdANneRb4k62'];
        appState = StateWidget.of(context).state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
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

  Widget MatchListBuilder(categoryName){
    return      Container(child:StreamBuilder(
        stream:  Firestore.instance.collection('Matches').where('category', isEqualTo: categoryName).snapshots(),
        builder: (context,snapshot){
                     if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData && snapshot.data.documents.length == 0 ){
          return Container(child: Text('No ${categoryName} Matches Scedules'));
        }
          if(snapshot.hasData && snapshot.data.documents.length > 0 ){
              // return Text("snapshot ${snapshot.data.documents.length}");  
      return 
       ListView.separated(
        padding: EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: snapshot.data.documents.length,
        itemBuilder: (BuildContext context, int index) {
          Map friend = friends[index];
          DocumentSnapshot ds = snapshot.data.documents[index];
          var matchDetails = ds['matchDetails'] ?? {};

          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      matchDetails['team_1_pic'],
                    ),
                    radius: 25,
                  ),
                  Text("${matchDetails['team-1']}")
                ],
              ),
               Column(
                children: <Widget>[
                  Text("${matchDetails['type']}"),
                  Text("${ds['startTime']}")
                ],
              ),
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      matchDetails['team_2_pic'],
                    ),
                    radius: 25,
                  ),
                  Text("${matchDetails['team-2']}")
                ],
              ),
              ]
            )
          );
        },
      );
          }
          return Text("Loading...");
        }
      ));
  }

  @override
  bool get wantKeepAlive => true;
}
