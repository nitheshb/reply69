import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notification/controllers/notificationController.dart';
import 'package:notification/util/AlgoliaApplication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  // Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
  //   AlgoliaQuery query = _algoliaApp.instance.index("Posts").search(input);
  //   AlgoliaQuerySnapshot querySnap = await query.getObjects();
  //   List<AlgoliaObjectSnapshot> results = querySnap.hits;
  //   print('results were ${results}');
  //   return results;
  // }

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("Posts").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    print('results were ${results}');
     return results;
    var query1 = Firestore.instance.collection('groups').snapshots();

  }
  // getCasesDetailList(query) async{
  // List<DocumentSnapshot> documentList = (await Firestore.instance
  //       .collection("cases")
  //       .document(await firestoreProvider.getUid())
  //       .collection('groups')
  //       .where("caseNumber", arrayContains: query)
  //       .getDocuments())
  //   .documents;
  // }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Learning Algolia", style:TextStyle(color: Colors.black),),
          ),
        body: SingleChildScrollView(
                  child: Column(
            children:<Widget>[ 
              TextField(
                  onChanged: (val) {
                  setState(() {
                    _searchTerm = val;
                  });
                },
                style: new TextStyle(color: Colors.black, fontSize: 20),
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search ...',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.search, color: Colors.black
              ))),
              StreamBuilder<List<AlgoliaObjectSnapshot>>(
                  stream: Stream.fromFuture(_operation(_searchTerm)),  
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Text("Start Typing", style: TextStyle(color: Colors.black ),);
                    else{
                    List<AlgoliaObjectSnapshot> currSearchStuff = snapshot.data;

                    switch (snapshot.connectionState) {
                     case ConnectionState.waiting: return Container();
                     default:
                       if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                       else
                    return CustomScrollView(shrinkWrap: true,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            ( context,  index) {
                              return _searchTerm.length > 0 ? DisplaySearchResult(title: currSearchStuff[index].data["artShowDescription"], groupOwnerName: currSearchStuff[index].data["name"], genre: currSearchStuff[index].data["genre"],) :
                              Container();
                              
                            },
                            childCount: currSearchStuff.length ?? 0,
                          ),
                        ),
                    ],
                    ); }}
                  },
                ),
            ]),
        ),
      ),
    );
  }

}

class DisplaySearchResult extends StatelessWidget {
  final String title;
  final String groupOwnerName;
  final String genre;
  final List  category;

  DisplaySearchResult({Key key, this.groupOwnerName, this.title, this.genre, this.category}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return ListTile(
                                   title: Text(title ?? "", style: TextStyle(color: Colors.black ),),
                                   subtitle: Text(groupOwnerName ?? "", style: TextStyle(color: Colors.black ),),
                                 );
    return Column(
      children: <Widget>[
        Text(title ?? "", style: TextStyle(color: Colors.black ),),
        Text(groupOwnerName ?? "", style: TextStyle(color: Colors.black ),),
        Text('Category ${category}'),
        Text(genre ?? "", style: TextStyle(color: Colors.black ),),
        Divider(color: Colors.black,),
        SizedBox(height: 20)
      ]
    );
  }
}


class GroupAddButtons extends StatefulWidget {
  final String title,userId, chatId, fcmToken;
  final String groupOwnerName;
  final String genre;
  final bool following;
  final List  category;


  GroupAddButtons({Key key, this.groupOwnerName, this.title, this.genre, this.category, this.following, this.userId, this.chatId, this.fcmToken}) : super(key: key);

  @override
  _GroupAddButtonsState createState() => _GroupAddButtonsState();
}

class _GroupAddButtonsState extends State<GroupAddButtons> {
    bool lockModify;
   @override
  void initState() {
    super.initState();

    lockModify = widget.following;
  }
   @override
  Widget build(BuildContext context) {

    return  lockModify ? FlatButton(
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
                        Firestore.instance.collection('groups').document(widget.chatId).updateData({ 'followers' : FieldValue.arrayRemove([widget.userId]),'AlldeviceTokens': FieldValue.arrayRemove([userToken])});
                        Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups0' : FieldValue.arrayRemove([widget.chatId])});
                        Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups1' : FieldValue.arrayRemove([widget.chatId])});
                        Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups2' : FieldValue.arrayRemove([widget.chatId])});
                        Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups3' : FieldValue.arrayRemove([widget.chatId])});
                      
                      setState(() {
                        lockModify = !lockModify;
                      });
                      return;
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
                        print("check for doc id of group ${widget.chatId}  id is ${widget.userId}");
                        // make an entry in db as joinedGroups
                       try {
                         //  this is for token 
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
                        Firestore.instance.collection('groups').document(widget.chatId).updateData({ 'followers' : FieldValue.arrayUnion([widget.userId]), 'AlldeviceTokens': FieldValue.arrayUnion([userToken]) });
  
   var q1 = await Firestore.instance.collection('IAM').document(widget.userId).get();

   var followingGroups0 = q1.data['followingGroups0'] ?? [];
   var followingGroups1 = q1.data['followingGroups1'] ?? [];
   var followingGroups2 = q1.data['followingGroups2'] ?? [];
   var followingGroup3 = q1.data['followingGroups3'] ?? [];




   setState(() {
                        lockModify = !lockModify;
                      });
  if(followingGroups0.length <9){
    print('i was at following groups 0 ${widget.chatId}');
      Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups0' : FieldValue.arrayUnion([widget.chatId])});
      return;
  }else if (followingGroups1.length <9){
      Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups1' : FieldValue.arrayUnion([widget.chatId]) });
      return;
  }else if (followingGroups2.length <9){
      Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups2' : FieldValue.arrayUnion([widget.chatId]) });
      return;
  }else if(followingGroup3.length <9){
      Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups3' : FieldValue.arrayUnion([widget.chatId])});
  // ds.documentID

 NotificationController.instance.subScribeChannelNotification("${widget.chatId}");
  
      return;
  }
                       } catch (e) {
                         print('error at joining a group ${e}');
                       }
          
 
                      },
                    );
  }
}



class GroupPrileGroupTiles extends StatefulWidget {
  final String title,userId, chatId, fcmToken;
  final String groupOwnerName;
  final String genre;
  final bool following;
  final List  category;


  GroupPrileGroupTiles({Key key, this.groupOwnerName, this.title, this.genre, this.category, this.following, this.userId, this.chatId, this.fcmToken}) : super(key: key);

  @override
  _GroupPrileGroupTilesState createState() => _GroupPrileGroupTilesState();
}

class _GroupPrileGroupTilesState extends State<GroupPrileGroupTiles> {
    bool lockModify;
   @override
  void initState() {
    super.initState();

    lockModify = widget.following;
  }
   @override
  Widget build(BuildContext context) {
    return Text('check');
  }}
