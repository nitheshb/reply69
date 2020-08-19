import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/pages/groupProfile1.dart';
import 'package:notification/screens/conversation.dart';
import 'package:notification/screens/createGroup.dart';
import 'package:notification/screens/main_screen.dart';
import 'package:notification/util/auth.dart';
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
    this.followingGroupsLocal,
  }) : super(key: key);
  final String uId, uEmailId;
   List followingGroupsLocal;
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
  bool allowGroupCreation = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    print('iwas called');

  }



Widget chatViewList(context, userId, email, followingGroupss, data, followGroupState){
        print('following widget groups --> ${widget.followingGroupsLocal}' );
        print('following widget values --> ${data}' );
         print('following widget followGroupState values --> ${followGroupState}' );
          final followGroupState1 = appState.followingGroups;
      print('--> values are ${followGroupState1}');
         var value;
    
  
 if(widget.followingGroupsLocal.length >8){
    allowGroupCreation = false;
  }
        return StreamBuilder(
        stream: FirebaseController.instanace.fetchChatGroupsList(widget.followingGroupsLocal),
        builder: (context,snapshot){
                     if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
          if(snapshot.hasData && snapshot.data.documents.length >0 ){
              print('data is query1 ${snapshot.data.documents.length}');
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
            itemBuilder: (BuildContext context, int index)  {
             DocumentSnapshot ds = snapshot.data.documents[index];   
             var dataSnapshot =   snapshot.data.documents[index].data ;      
              var lastMessagesIs = dataSnapshot['lastMessageDetails'] ?? {"lastMsg":"No msg", "lastMsgTime": ""};
             int x;
            //  saveLocal(index,ds['messages'] ?? [], ds.documentID).then((data) {
            //       x = data;
            //  });

              Map chat = chats[index];
             
              return InkWell(
                   onTap: () async {
                     print('==> i was clicked');
                   //  print('i was at approved list click ${ds.data['approvedGroupsJson'].length}');
                
              if(ds.data['approvedGroupsJson'] != null){
              for(final data in ds.data['approvedGroupsJson']){
  //
      print('i was at approved list of ${ds.documentID}');
                  approvedGroups.add(data['userId']);
}
 await   Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Conversation(followingGroupsLocal: widget.followingGroupsLocal,groupFullDetails: ds.data,chatId: ds.documentID, groupSportCategory: ds.data['category'],chatOwnerId: ds.data['createdBy'],groupTitle: ds.data['title']?? "", groupLogo: ds.data['logo']?? null, followers: ds.data['followers']?? [],approvedGroupsJson: ds.data['approvedGroupsJson'], userId: userId, senderMailId: email,chatType: "", waitingGroups: waitingGroups, approvedGroups: approvedGroups),
                        ),
                      );
                   }else{
                      await   Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Conversation(followingGroupsLocal: widget.followingGroupsLocal,groupFullDetails: ds.data,chatId: ds.documentID, groupSportCategory: ds.data['category'],chatOwnerId: ds.data['createdBy'],groupTitle: ds.data['title']?? "", groupLogo: ds.data['logo']?? null, followers: ds.data['followers']?? [],approvedGroupsJson: ds.data['approvedGroupsJson'], userId: userId, senderMailId: email,chatType: "", waitingGroups: waitingGroups, approvedGroups: []),
                        ),
                      );
                   }
        
                   },
                child: ChatMenuIcon(
                  dp: ds['logo'],
                  groupName: ds['title'],
                  isOnline: ds.data['createdBy'] == userId,
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
        });
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
var followGroupState = FirebaseController.instanace.searchResultsByName(query);
return followGroupState;
    }else{
      return;
    }
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
    final followGroupState = appState.followingGroups;
   var data = Auth.getFollowingGroups;
   print('own it has getFollowingGroups data ${data}');
   print('own it has widget value data ${widget.followingGroupsLocal}');
    print('own it has widget followGroupState data ${followGroupState}');
   // getUserData(userId);
    print('check ${followingGroups}');
     if(widget.followingGroupsLocal == null){

    widget.followingGroupsLocal = followGroupState;
  }

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
          // first tab
          Container(
            child: chatViewList(context, userId, email, followingGroups, data, followGroupState)
          ),
          
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
     await  FirebaseController.instanace.unfollowGroup(ds['chatId'], userId, userToken);

                        // Auth.setFollowingGroups(followingGroup_real,ds['chatId'], 'remove' );
                        // StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'remove' );
                        setState(() {
                          // followingGroup_real.remove(ds['chatId']);
                          widget.followingGroupsLocal.remove(ds['chatId']);
                          StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'remove' );
                        });

                          await Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
        builder: (BuildContext context)
        => MainScreen(userId: userId,followingGroupsLocal: widget.followingGroupsLocal),
        ),(Route<dynamic> route) => false);
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





  if(widget.followingGroupsLocal.length <9){
    print('i was at following groups 0 with length  ${widget.followingGroupsLocal.length}, ${ds['chatId']}');
    FirebaseController.instanace.followGroup(ds['chatId'], userId, userToken);

  
  
                        // Auth.setFollowingGroups(widget.followingGroupsLocal,ds['chatId'], 'add' );
                        // StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'add' );
                        setState(() {
                          print('i was hit ones');
                          // followingGroup_real.add(ds['chatId']);
                          widget.followingGroupsLocal.add(ds['chatId']);
                          StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'add' );
                        });
                          await Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
        builder: (BuildContext context)
        => MainScreen(userId: userId,followingGroupsLocal: widget.followingGroupsLocal),
        ),(Route<dynamic> route) => false);
  }else{

 _showBasicsFlash(context:  context, duration: Duration(seconds: 4), messageText : 'Overall max 9 group can be followed...!');
  }
  
                       } catch (e) {
                          _showBasicsFlash(context:  context, duration: Duration(seconds: 4), messageText : 'error at following ${e}');
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
                lastWeekRating: ds['lastWeekRating'] ?? 'NA',
                followingGroupsLocal: widget.followingGroupsLocal
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
        if(allowGroupCreation){
          // 
            Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateGroupProfile(primaryButtonRoute: "/home", followingGroupsLocal: widget.followingGroupsLocal),
                        ),
                      );
        }else{
           _showBasicsFlash(context:  context, duration: Duration(seconds: 4), messageText : 'Limit Reached.Unfollow any group to proceed');
        }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
