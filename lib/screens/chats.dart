import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/controllers/notificationController.dart';
import 'package:notification/pages/AlgoliaFullTextSearch.dart';
import 'package:notification/pages/chatWindow.dart';
import 'package:notification/pages/groupProfile1.dart';
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
  String _searchTerm;
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
   followingGroups = response.data['followingGroups'] ?? [];

  });
  return response.data;
  }

Widget popularSearchTextContainer(searchText){
  return     Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                           decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            stops: [0.1, 1],
                            colors: [
                              Color(0xFF8C68EC),
                              Color(0xFF3E8DF3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                  // color: Colors.blueGrey,
                   child:Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(searchText, style: TextStyle(color: Colors.white, fontSize: 12),),
                   )
                 ),
                      );
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
  void _showBasicsFlash({
    Duration duration,
    flashStyle = FlashStyle.floating,BuildContext context, String messageText,
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
              print('item vaue is ${item}');
              selectedOptions.add(
                Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6,),
                                      child: Center(
                                        child: Text(
                                          "${item['categoryName'] ?? item }",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700
                                          ),
                                        ),
                                      ),
                                    ),
              );
            });
          }

          return selectedOptions;
        }

  searchGroupsQuery(query){
    if(query != null){
var check = Firestore.instance.collection('groups').where("caseSearch", arrayContains: query).snapshots();
return check;
    }else{
      return;
    }
  }

 Future<List<DocumentSnapshot>> getFollowedGroups(userId) async {

  //  var query = await Firestore.instance.collection('groups').where("caseSearch", arrayContains: 'dre').getDocuments();
  //  print('aread details are1 ${query.documents}');
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
              text: "Messages",
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
                  dp: ds['logo'],
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
         return 
                     Align(
                       alignment: Alignment.center,
                     child: Column(
                       children: <Widget>[
                         SizedBox(height: MediaQuery.of(context).size.height/4.5),
                         
                         new Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Image(image: AssetImage('assets/emptyMsgs.png'),),
            
            ),

            new Text('Loading or No added Groups', style: TextStyle(color: Colors.black, fontSize: 20),),
                         
                       ],
                     )
                     );
        })),
          
          // second tab
SingleChildScrollView(
                  child: Column(
            children:<Widget>[ 
           
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      onChanged: (val) {
                      setState(() {
                        _searchTerm = val;
                        print('search term ${_searchTerm}');
                      });
                    },
                    style: new TextStyle(color: Colors.black, fontSize: 20),
                      decoration: new InputDecoration(
                         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 4)
            ),
            focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
            ),
            border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 5)
            ),
                        // border: InputBorder.none,
                          hintText: 'Search Group Name....',
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: const Icon(Icons.search, color: Colors.black
                  ))),
                ),
              ),
              StreamBuilder(
                  stream : searchGroupsQuery(_searchTerm),
                  // stream: Firestore.instance.collection('groups').where("caseSearch", arrayContains: _searchTerm).snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) 
                     return 
                      Column(
                       children: <Widget>[
                         SizedBox(height: 30),
                         Align(
                       alignment: Alignment.center,
                     child:
                         new Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/searchFind.png'),
                  fit: BoxFit.fill
                )
              ),
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
                 Text("Popular Searches To Try", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),),
                 Row(
                   children: <Widget>[
                     popularSearchTextContainer('helloPredictors'),
                     popularSearchTextContainer('allGamesPredictor'),
                     popularSearchTextContainer('Dream11Pro'),
                 
                
                   ],
                 ),
                

               ],
             ),
            ),    
                        )      
                       ],
                     );
                     
                    
                    
                    // return Text("Start Typing for a Group", style: TextStyle(color: Colors.black ),);

                    else if(snapshot.hasData && snapshot.data.documents.length > 0 ){

                      
   
                    //  return Text('data');
                  print('data fetch ${_searchTerm}');
                  return  CustomScrollView(shrinkWrap: true,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            ( context,  index) {
                                 var ds = snapshot.data.documents[index].data; 
                                 var followersA = ds['followers'] ?? [];
                                return ListTile(
                                   title: Text(ds['title'] ?? "", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800 ),),
                                   subtitle: Column(
                                     children: <Widget>[
                                       Padding(
                                         padding: const EdgeInsets.only(bottom:8.0, top: 2.0),
                                         child: Align(
                                           alignment: Alignment.centerLeft,
                                      child: Text("@ ${ds['groupOwnerName'] ?? ""}" ?? "", style: TextStyle(color: Colors.black ),),
                                         ),
                                       ),
                                       Row(
                                         children: <Widget>[
                                           Wrap(
                    spacing: 4.0, // gap between adjacent chips
                    runSpacing: 1.0, // gap between lines
                    children:
                    _buildSelectedOptions(ds['category']),
                  ),
                                         ],
                                       ),
                                      
                                     ],
                                   ),
                                   trailing: followersA.contains(widget.uId) ? 
                                   FlatButton(
                      child: Text(
                        "Unfollow",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.grey,
                      onPressed: ()async{
                        //  this is for token 
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
                        Firestore.instance.collection('groups').document(ds['chatId']).updateData({ 'followers' : FieldValue.arrayRemove([userId]),'AlldeviceTokens': FieldValue.arrayRemove([userToken])});
                        Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayRemove([ds['chatId']])});
                        // Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups1' : FieldValue.arrayRemove([ds['chatId']])});
                        // Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups2' : FieldValue.arrayRemove([ds['chatId']])});
                        // Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups3' : FieldValue.arrayRemove([ds['chatId']])});
                      },
                    ):
                                 FlatButton(
                      child: Text(
                        "Follow",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: ()async{
                        print("check for doc id of group ${ds['chatId']}  id is ${userId}");
                        // make an entry in db as joinedGroups
                       try {
                         //  this is for token 
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
                        // Firestore.instance.collection('groups').document(ds['chatId']).updateData({ 'followers' : FieldValue.arrayUnion([userId]), 'AlldeviceTokens': FieldValue.arrayUnion([userToken]) });
  
   var q1 = await Firestore.instance.collection('IAM').document(userId).get();

   var followingGroups0 = q1.data['followingGroups0'] ?? [];
  //  var followingGroups1 = q1.data['followingGroups1'] ?? [];
  //  var followingGroups2 = q1.data['followingGroups2'] ?? [];
  //  var followingGroup3 = q1.data['followingGroups3'] ?? [];





  if(followingGroups0.length <9){
    print('i was at following groups 0 ${ds['chatId']}');
      Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayUnion([ds['chatId']])});
      Firestore.instance.collection('groups').document(ds['chatId']).updateData({ 'followers' : FieldValue.arrayUnion([userId]), 'AlldeviceTokens': FieldValue.arrayUnion([userToken]) });
  
    
  }else{

 _showBasicsFlash(context:  context, duration: Duration(seconds: 4), messageText : 'Overall max 9 group can be followed...!');
  }
  
//   else if (followingGroups1.length <9){
//       Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups1' : FieldValue.arrayUnion([ds['chatId']]) });
//       return;
//   }else if (followingGroups2.length <9){
//       Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups2' : FieldValue.arrayUnion([ds['chatId']]) });
//       return;
//   }else if(followingGroup3.length <9){
//       Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups3' : FieldValue.arrayUnion([ds['chatId']])});
//   // ds.documentID
// //  NotificationController.instance.subScribeChannelNotification("${ds['chatId']}");
//       return;
//   }
                       } catch (e) {
                         print('error at joining a group ${e}');
                       }
          
 
                      },
                    ),
                      onTap: (){

                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile3(
                title: ds['title'],
                avatarUrl: ds['logo'],
                categories: ds['category'],
                following: followersA.contains(widget.uId),
                chatId: ds['chatId'],
                userId: userId,
                followers: ds['followers'] ?? [],
                groupOwnerName : ds['groupOwnerName']?? '',
                feeDetails: ds['FeeDetails'] ?? [],
                seasonRating: ds['seasonRating'] ?? 'NA',
                thisWeekRating: ds['thisWeekRating'] ?? 'NA',
                lastWeekRating: ds['lastWeekRating'] ?? 'NA'


              )),
            );
                      },          
                    );
                    
                              
                            },
                            childCount: snapshot.data.documents.length ?? 0,
                          ),
                        ),
            
                    ],
                  );
                    
                   //  print('data length ${snapshot.data.documents.length} ');
                           

                    }
                     return 
                     Align(
                       alignment: Alignment.center,
                     child: Column(
                       children: <Widget>[
                         SizedBox(height: 60),
                         new Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/searchFind.png'),
                  fit: BoxFit.cover
                )
              ),
            ),
                         new Text('No Matched Data Found'),
                       ],
                     )
                     );
                  },
                ),
            ]),
        ),
        ]
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
