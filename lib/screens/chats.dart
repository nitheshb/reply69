import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/pages/chatWindow.dart';
import 'package:notification/screens/conversation.dart';
import 'package:notification/screens/createGroup.dart';
import 'package:notification/util/data.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/displayChatsMenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Chats extends StatefulWidget {
    Chats({
    Key key,
    this.uId,
    this.uEmailId,
  }) : super(key: key);
  final String uId, uEmailId;
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with SingleTickerProviderStateMixin,
    AutomaticKeepAliveClientMixin{
  TabController _tabController;
  StateModel appState;  
  List waitingGroups = [], approvedGroups =[], followingGroups =[];
  List chatIdGroups = ['nQ4T04slkEdANneRb4k6','nQ4T04slkEdANneRb4k61','nQ4T04slkEdANneRb4k62','nQ4T04slkEdANneRb4k63','nQ4T04slkEdANneRb4k64','nQ4T04slkEdANneRb4k65','nQ4T04slkEdANneRb4k66','nQ4T04slkEdANneRb4k67','nQ4T04slkEdANneRb4k68','btl5r2JUwn5imaTToPKq'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
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
        title: TextField(
          decoration: InputDecoration.collapsed(
            hintText: 'Search',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: (){},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          isScrollable: false,
          tabs: <Widget>[
            Tab(
              text: "Message",
            ),
            Tab(
              text: "Groups",
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(child: FutureBuilder<List<DocumentSnapshot>>(
        // stream:  Firestore.instance.collection('groups').where('chatId', whereIn: ['nQ4T04slkEdANneRb4k6','nQ4T04slkEdANneRb4k61','nQ4T04slkEdANneRb4k62','nQ4T04slkEdANneRb4k63','nQ4T04slkEdANneRb4k64','nQ4T04slkEdANneRb4k65','nQ4T04slkEdANneRb4k66','nQ4T04slkEdANneRb4k67','nQ4T04slkEdANneRb4k68']).where('chatId', whereIn: ['btl5r2JUwn5imaTToPKq']).snapshots(),
        future: getFollowedGroups(userId),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshotList){
                     if (snapshotList.hasError) {
          return Text('Error ${snapshotList.error}');
        }
          if(snapshotList.hasData && snapshotList.data.length > 0 ){
            // return Text('value is ');
        return  ListView.separated(
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
            itemCount: snapshotList.data.length,
            itemBuilder: (BuildContext context, int index)  {
              DocumentSnapshot ds = snapshotList.data[index];              
              var lastMessagesIs = ds['lastMessageDetails'] ?? {"lastMsg":"No msg", "lastMsgTime": ""};
             int x;
            //  saveLocal(index,ds['messages'] ?? [], ds.documentID).then((data) {
            //       x = data;
            //  });

              Map chat = chats[index];
              return InkWell(
                   onTap: (){
            Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Conversation(groupFullDetails: ds.data,chatId: ds.documentID, groupSportCategory: ds.data['category'],chatOwnerId: ds.data['createdBy'],groupTitle: ds.data['title']?? "", groupLogo: ds.data['logo']?? null, followers: ds.data['followers']?? [],approvedGroupsJson: ds.data['approvedGroupsJson'], userId: userId, senderMailId: email,chatType: "", waitingGroups: waitingGroups, approvedGroups: approvedGroups),
                        ),
                      );
                   },
                child: ChatMenuIcon(
                  dp: chat['dp'],
                  groupName: ds['title'],
                  isOnline: chat['isOnline'],
                  counter: 0,
                  msg:  lastMessagesIs['lastMsg'],
                  time: lastMessagesIs['lastMsgTime'] =="" ? "" :Jiffy(lastMessagesIs['lastMsgTime'].toDate()).fromNow().toString(),
                ),
              );
            },
          
          );
          }
          return Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text('No Groups Selected'),
          );
        })),
            Container(child: StreamBuilder(
        stream:  Firestore.instance.collection('groups').snapshots(),
        builder: (context,snapshot){
                     if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
          if(snapshot.hasData && snapshot.data.documents.length > 0 ){
            // return Text('value is ');
        return  ListView.separated(
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
              DocumentSnapshot ds = snapshot.data.documents[index];
              var lastMessagesIs = ds['lastMessageDetails'] ?? {"lastMsg":"No msg", "lastMsgTime": ""};
              Map chat = chats[index];
              return InkWell(
                   onTap: (){
            Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatWindow(chatId: ds.documentID, chatOwnerId: ds.data['creatorBy'],approvedGroupsJson: ds.data['approvedGroupsJson'], userId: userId, senderMailId: email,chatType: "", waitingGroups: waitingGroups, approvedGroups: approvedGroups, title: ds.data['title'],feeArray:ds.data['FeeDetails'], paymentScreenshotNo:ds.data['paymentNo'] , avatarUrl: ds.data['logo'] ),
                        ),
                      );
                   },
                child: ChatMenuIcon(
                  dp: chat['dp'],
                  groupName: ds['title'],
                  isOnline: chat['isOnline'],
                  counter: chat['counter'],
                  msg:  lastMessagesIs['lastMsg'],
                  time: lastMessagesIs['lastMsgTime'] =="" ? "" :Jiffy(lastMessagesIs['lastMsgTime'].toDate()).fromNow().toString(),
                ),
              );
            },
          
          );
          }
          return Text('Loading');
        })),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Container(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onPressed: () async{
    String token = await _firebaseMessaging.getToken();
    print('token is : ${token}');

          // 
            Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateGroupProfile(primaryButtonRoute: "/home"),
                        ),
                      );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
