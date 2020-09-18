import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
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


class Chats extends StatefulWidget {
    Chats({
    Key key,
    this.uId,
    this.uEmailId,
    this.followingGroupsLocal,
    this.followingGroupsReadCountLocal
  }) : super(key: key);
  final String uId, uEmailId;
   List followingGroupsLocal, followingGroupsReadCountLocal;
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with SingleTickerProviderStateMixin,
    AutomaticKeepAliveClientMixin{
  TabController _tabController;
  StateModel appState;  
  List waitingGroups = [], approvedGroups =[], followingGroups =[], primeGroups=[];
  List chatIdGroups = ['nQ4T04slkEdANneRb4k6','nQ4T04slkEdANneRb4k61','nQ4T04slkEdANneRb4k62','nQ4T04slkEdANneRb4k63','nQ4T04slkEdANneRb4k64','nQ4T04slkEdANneRb4k65','nQ4T04slkEdANneRb4k66','nQ4T04slkEdANneRb4k67','nQ4T04slkEdANneRb4k68','btl5r2JUwn5imaTToPKq'];
  String _searchTerm;
  bool allowGroupCreation = true;

  List NotifyData = [];
  List searchLists = [];
  int selTabIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    print('iwas called');
    getlocalPrimeGroups(); 
    selTabIndex =0;


  //   loadData().then((_) {
  //   getBizList();
  // });

    // DatabaseReference postsRef =FirebaseDatabase.instance.reference().child("Notify");
    // postsRef.once().then((DataSnapshot snap){
    //   print('wow iwas here');
    //     var keys = snap.value.keys;
    //     var data = snap.value;
    //     NotifyData.clear();

    // print(' wow i have snap ${snap.value}');
    //     for(var individualKeys in keys){
    //       NotifyList notify = new NotifyList(
    //           data[individualKeys]['c'],
    //           data[individualKeys]['m'],
    //           data[individualKeys]['t'],
    //       );
    //       NotifyData.add(notify);
    //     }
    //     setState(() {
    //       print('length ${NotifyData}');
    //     });
    // });
  //  realTime ('kAUE9NsXpQyn4cseIpPt');
  //  realTime ('om4c5QKsa5mk1pUG897z');
    // widget.followingGroupsLocal.forEach((data){
    //   realTime(data);
    //   print('data@@1 ${data}');
    // });
 new Future.delayed(Duration.zero,() {
       print('readl initialLoad Test ${widget.followingGroupsLocal}');
    loopFollowingGroup(widget.followingGroupsLocal);
    });
   
  }


  void _toggleTab() {
    
    _tabController.animateTo(1);
  }

getlocalPrimeGroups() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

  approvedGroups = await prefs.getStringList('approvedPrimeGroups');
}
 void updateInformation(String information) {
   print('wow its working ### ${information}');
  }
loopFollowingGroup(dataArray){
  print('litmus test ${widget.followingGroupsLocal}');
  var testArray = ['kAUE9NsXpQyn4cseIpPt','om4c5QKsa5mk1pUG897z'];
widget.followingGroupsLocal.forEach((data){
      realTime(data);
      print('data@@1 ${data}');
    });
}
 realTime (id){
   if(id==null){
     return;
   }
    DatabaseReference postsRef =FirebaseDatabase.instance.reference().child("Notify").child(id);
    postsRef.onValue.listen((event){
        print('==>event is ,${event.snapshot.value}');
        var snap = event.snapshot;
          print('wow iwas here');
        // var keys = snap.value.keys;
        var data = snap.value;
        // NotifyData.clear();
if(data!= null){
       NotifyData.removeWhere((item) => 
       item['t'] == 
       '${data['t']}');

//  NotifyList notify = new NotifyList(
//               data.c,
//               data.m,
//               data.t,
//           );
          data['chatId']= id;
          NotifyData.add(data);
}else{
  return;
}
    // print(' wow i have snap ${snap.value}');
    //     for(var individualKeys in keys){
    //       NotifyList notify = new NotifyList(
    //           data[individualKeys]['c'],
    //           data[individualKeys]['m'],
    //           data[individualKeys]['t'],
    //       );
    //       NotifyData.add(notify);
    //     }
        setState(() {
          print('length ${NotifyData}');
        });
    });
}
Widget chatViewListRealtimeDb(context){

           appState = StateWidget.of(context).state;
    // final localFollowingGroups = appState.user;
      //  final approvedGroups = appState?.user?.approvedGroups;
      //  print('grops fro local fetch ${approvedGroups}');
 if(widget.followingGroupsLocal.length >8){
    allowGroupCreation = false;
  }
     
  print('is it working in cahts ${widget.followingGroupsReadCountLocal}');
return widget.followingGroupsLocal.length == 0 ? noGroupsFolllowed():

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
                itemCount: NotifyData.length,
                itemBuilder: (BuildContext context, int index)  {
          //  var searchGroupForReadCount =   widget.followingGroupsReadCountLocal.firstWhere((data)=> data['id'] == NotifyData[index]['chatId']);
                //  print('searchGroup ${searchGroupForReadCount['count'] ?? 0}');
                  return InkWell(
                       onTap: () async {
                var snap =   await FirebaseController.instanace.getChatOwnerId(NotifyData[index]['chatId']);
                print('what is snap ${snap}');

              var chatId = approvedGroups.contains(NotifyData[index]['chatId']) ? "${NotifyData[index]['chatId']}PGrp" : "${NotifyData[index]['chatId']}" ;
                
final information = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Conversation(followingGroupsLocal: widget.followingGroupsLocal,groupFullDetails: [],chatId: chatId, 
                                                groupSportCategory: [],
                                                chatOwnerId: snap['o'],
                                                groupTitle: NotifyData[index]['t']?? "", 
                                                groupLogo:  NotifyData[index]['i'], 
                                                followers:  [],
                                                approvedGroupsJson: [], 
                                                userId: widget.uId, 
                                                senderMailId: widget.uEmailId,
                                                chatType: "",
                                                waitingGroups: waitingGroups,
                                                approvedGroups: [], 
                                                followersCount: snap['c'] ?? 0,
                                                msgFullCount: NotifyData[index]['c'],
                                                msgFullPmCount: NotifyData[index]['pc'],
                                                msgReadCount: 0 ),
                        ),
                      );

                      updateInformation(information);
            
                       },
                      
                    child: ChatMenuIcon(
                      dp: "${NotifyData[index]['i']}",
                      groupName: "${NotifyData[index]['t']}",
                      isOnline: true,
                      // counter: "${NotifyData[index]['c']- searchGroupForReadCount['count'] ?? 0}",
                      counter: 0,
                      msg: "${approvedGroups.contains(NotifyData[index]['chatId']) ? NotifyData[index]['pm'] :  NotifyData[index]['m']}",
                      time: "${""}",
                    ),
                  );
                
              
              
     }
   );

  
}
Widget noGroupsFolllowed(){
  return Align(
                       alignment: Alignment.center,
                     child: Column(
                       children: <Widget>[
                         SizedBox(height: MediaQuery.of(context).size.height/4.5),
                         
                         new Container(
              height: MediaQuery.of(context).size.height / 5.5,
              child:  Icon(FontAwesomeIcons.star, color: Colors.grey, size: 70,),
            
            ),

            Column(
              children: <Widget>[
                new Text("No groups subscribed yet", style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                )),
                SizedBox(height: 16),
                InkWell(
                  onTap: (){
                      _toggleTab();
                  },
                child:new Text("Subscribe to a group", style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                )),
                )
              ],
            ),
                         
                       ],
                     )
                     );
}

Widget groupSearViewRealDB (_searchTerm){
 return FutureBuilder(
    future:FirebaseDatabase.instance.reference().child("NameSearch")
                            .orderByChild("childNode")
                            .startAt('$_searchTerm')
                            .endAt('${_searchTerm}\uF7FF')
                            .once(),
    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
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
    if(query != null && ((query.length ==1))){
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
    final phoneNumber = appState.user.phoneNumber;
   var data = Auth.getFollowingGroups;
   print('own it has getFollowingGroups data ${data}');
   print('own it has widget value data ${widget.followingGroupsLocal}');
    print('own it has widget followGroupState data ${followGroupState}');
   // getUserData(userId);
    print('check ${followingGroups}');
     if(widget.followingGroupsLocal == null){

    widget.followingGroupsLocal = followGroupState;
  }

  // widget.followingGroupsLocal.forEach((data){
  //   realTime(data);
  //     print('data@@ ${data}');
  //   });

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
          onTap: (index){
            setState(() {
              selTabIndex= index;
            });
              
          },
          tabs: <Widget>[
            Tab(
              text: "Messages",
            ),
            Tab(
              text: "Follow Groups",
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // first tab
          Container(
            child: chatViewListRealtimeDb(context)
            // child: chatViewList(context, userId, email, followingGroups, data, followGroupState)
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
                  borderSide: BorderSide(color: Colors.grey[400], width: 2)
            ),
            focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
            ),
            border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 2)
            ),
                        // border: InputBorder.none,
                          hintText: 'Search Group Name....',
                          hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),
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
                 Text("Popular Searches To Try", style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                )),
                 Row(
                   children: <Widget>[
                     popularSearchTextContainer('gamepro11'),
                     popularSearchTextContainer('allGamesPredictor'),
                     popularSearchTextContainer('groupName1'),
                 
                
                   ],
                 ),
                

               ],
             ),
            ),    
                        )      
                       ],
                     );
                     
                    
                    
                    // return Text("Start Typing for a Group", style: TextStyle(color: Colors.black ),);

                    else if(snapshot.hasData){

//                     // start of new search
//               return ListView.builder(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 itemCount: snapshot.data['payload'].length,
//                 // reverse: true,
//                 itemBuilder: (BuildContext context, int index) {
//                   var ds = snapshot.data['payload'][index];
//                     return ListTile(
//                                    title: Text(ds['title'] ?? "", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800 ),),
//                                    subtitle: Column(
//                                      children: <Widget>[
//                                        Padding(
//                                          padding: const EdgeInsets.only(bottom:8.0, top: 2.0),
//                                          child: Align(
//                                            alignment: Alignment.centerLeft,
//                                       child: Text("@ ${ds['groupOwnerName'] ?? ""}" ?? "", style: TextStyle(color: Colors.black ),),
//                                          ),
//                                        ),
//                                        Row(
//                                          children: <Widget>[
//                                            Wrap(
//                     spacing: 4.0, // gap between adjacent chips
//                     runSpacing: 1.0, // gap between lines
//                     children:
//                     _buildSelectedOptions(ds['category']),
//                   ),
//                                          ],
//                                        ),
                                      
//                                      ],
//                                    ),
//                                    trailing: true ? 
//                                    FlatButton(
//                       child: Text(
//                         "Unfollow",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       color: Colors.grey,
//                       onPressed: ()async{
//                         //  this is for token 
//                         print('---> phonenumber is ${phoneNumber}');
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//       String userToken = prefs.get('FCMToken');
//      await  FirebaseController.instanace.unfollowGroup(ds['chatId'], userId, userToken);

//                         // Auth.setFollowingGroups(followingGroup_real,ds['chatId'], 'remove' );
//                         // StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'remove' );
//                         setState(() {
//                           // followingGroup_real.remove(ds['chatId']);
//                           widget.followingGroupsLocal.remove(ds['chatId']);
//                           StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'remove' );
//                         });

//                           await Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
//         builder: (BuildContext context)
//         => MainScreen(userId: userId,followingGroupsLocal: widget.followingGroupsLocal),
//         ),(Route<dynamic> route) => false);
//                       },
//                     ):
//                                  FlatButton(
//                       child: Text(
//                         "Follow",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       color: Theme.of(context).accentColor,
//                       onPressed: ()async{
//                         print("check for doc id of group ${ds['chatId']}  id is ${userId}");
//                         // make an entry in db as joinedGroups
//                        try {
//                          //  this is for token 
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//       String userToken = prefs.get('FCMToken');





//   if(widget.followingGroupsLocal.length <9){
//     print('i was at following groups 0 with length  ${widget.followingGroupsLocal.length}, ${ds['chatId']}');
//     print('---> phonenumber is ${phoneNumber}');
//     FirebaseController.instanace.followGroup(ds['chatId'], userId, userToken);

  
  
//                         // Auth.setFollowingGroups(widget.followingGroupsLocal,ds['chatId'], 'add' );
//                         // StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'add' );
//                         setState(() {
//                           print('i was hit ones');
//                           // followingGroup_real.add(ds['chatId']);
//                           widget.followingGroupsLocal.add(ds['chatId']);
//                           StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'add' );
//                         });
//                           await Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
//         builder: (BuildContext context)
//         => MainScreen(userId: userId,followingGroupsLocal: widget.followingGroupsLocal),
//         ),(Route<dynamic> route) => false);
//   }else{

//  _showBasicsFlash(context:  context, duration: Duration(seconds: 4), messageText : 'Overall max 9 group can be followed...!');
//   }
  
//                        } catch (e) {
//                           _showBasicsFlash(context:  context, duration: Duration(seconds: 4), messageText : 'error at following ${e}');
//                          print('error at joining a group ${e}');
//                        }
          
 
//                       },
//                     ),
//                       onTap: (){

//                         Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Profile3(
//                 title: ds['title'],
//                 avatarUrl: ds['logo'],
//                 categories: ds['category'],
//                 following: true,
//                 chatId: ds['chatId'],
//                 userId: userId,
//                 followers: ds['followers'] ?? [],
//                 groupOwnerName : ds['groupOwnerName']?? '',
//                 feeDetails: ds['FeeDetails'] ?? [],
//                 seasonRating: ds['seasonRating'] ?? 'NA',
//                 thisWeekRating: ds['thisWeekRating'] ?? 'NA',
//                 lastWeekRating: ds['lastWeekRating'] ?? 'NA',
//                 followingGroupsLocal: widget.followingGroupsLocal
//               )),
//             );
//                       },          
//                     );
//                 }
//               );
   
//   //  end of new start
                    //  return Text('data');
                  print('data fetch ${_searchTerm}');
                  return  CustomScrollView(shrinkWrap: true,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            ( context,  index) {
                                 DocumentSnapshot ds = snapshot.data; 
                                 print('===>value check $ds['']');
                                 var followersA =  [];
                                return ListTile(
                                   title: Text(ds['payload'][index]['title']?? "", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800 ),),
                                   subtitle: Column(
                                     children: <Widget>[
                                       Padding(
                                         padding: const EdgeInsets.only(bottom:8.0, top: 2.0),
                                         child: Align(
                                           alignment: Alignment.centerLeft,
                                      child: Text("@ ${ ds['payload'][index]['ownerName'] ?? ""}" ?? "", style: TextStyle(color: Colors.black ),),
                                         ),
                                       ),
                                       Row(
                                         children: <Widget>[
                                           Wrap(
                    spacing: 4.0, // gap between adjacent chips
                    runSpacing: 1.0, // gap between lines
                    children:
                    _buildSelectedOptions(ds['payload'][index]['category']),
                  ),
                                         ],
                                       ),
                                      
                                     ],
                                   ),
                                   trailing: widget.followingGroupsLocal.contains(ds['payload'][index]['chatId']) ? 
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
                        print('---> phonenumber is ${phoneNumber}');
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
     await  FirebaseController.instanace.unfollowGroup(ds['payload'][index]['chatId'], userId, userToken);

                        // Auth.setFollowingGroups(followingGroup_real,ds['chatId'], 'remove' );
                        // StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'remove' );
                        setState(() {
                          // followingGroup_real.remove(ds['chatId']);
                          widget.followingGroupsLocal.remove(ds['payload'][index]['chatId']);
                           prefs.setStringList('followingGroups',widget.followingGroupsLocal );
                          StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['payload'][index]['chatId'], 'remove' );
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
                        print("check for doc id of group ${ds['payload'][index]['chatId']}  id is ${userId}");
                        // make an entry in db as joinedGroups
                       try {
                         //  this is for token 
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');





  if(widget.followingGroupsLocal.length <9){
    print('i was at following groups 0 with length  ${widget.followingGroupsLocal.length}, ${ds['chatId']}');
    print('---> phonenumber is ${phoneNumber}');
  
    FirebaseController.instanace.followGroup(ds['payload'][index]['chatId'], userId, userToken);

  
  
                        // Auth.setFollowingGroups(widget.followingGroupsLocal,ds['chatId'], 'add' );
                        // StateWidget.of(context).setFollowingGroupState(widget.followingGroupsLocal,ds['chatId'], 'add' );
                        setState(() {
                          print('i was hit ones');
                          // followingGroup_real.add(ds['chatId']);
                          widget.followingGroupsLocal.add(ds['payload'][index]['chatId']);
 prefs.setStringList('followingGroups',widget.followingGroupsLocal );
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
                title: ds['payload'][index]['title'],
                avatarUrl: ds['payload'][index]['logo'],
                categories: ds['payload'][index]['category'],
                following: followersA.contains(widget.uId),
                chatId: ds['payload'][index]['chatId'],
                userId: userId,
                followers: ds['payload'][index]['followers'] ?? [],
                groupOwnerName : ds['payload'][index]['ownerName']?? '',
                feeDetails: ds['payload'][index]['FeeDetails'] ?? [],
                seasonRating: ds['payload'][index]['seasonRating'] ?? 'NA',
                thisWeekRating: ds['payload'][index]['thisWeekRating'] ?? 'NA',
                lastWeekRating: ds['payload'][index]['lastWeekRating'] ?? 'NA',
                followingGroupsLocal: widget.followingGroupsLocal
              )),
            );
                      },          
                    );
                    
                              
                            },
                            childCount: snapshot.data['payload'].length ?? 0,
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
  
      floatingActionButton:
      Visibility(
        visible: selTabIndex== 1,
        child:
       FloatingActionButton(
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
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
