import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:notification/controllers/notificationController.dart';
import 'package:notification/util/data.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupsSearch extends StatefulWidget {
    GroupsSearch({
    Key key,
    this.uId,
    this.uEmailId,
  }) : super(key: key);
  final String uId, uEmailId;
  @override
  _GroupsSearchState createState() => _GroupsSearchState();
}

class _GroupsSearchState extends State<GroupsSearch> {
  StateModel appState;  
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
  @override
  Widget build(BuildContext context) {
         appState = StateWidget.of(context).state;
         final userId = appState?.firebaseUserAuth?.uid ?? '';
         final email = appState?.firebaseUserAuth?.email ?? '';
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
      ),

      body:StreamBuilder(
        stream:  Firestore.instance.collection('groups').snapshots(),
        builder: (context,snapshot){
                     if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
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
          var followersA = ds['followers'] ?? [];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  friend['dp'],
                ),
                radius: 25,
              ),

              contentPadding: EdgeInsets.all(0),
              title: Text(ds['title']),
              subtitle: Text(ds.documentID),
              trailing: followersA.contains(widget.uId)
                  ? FlatButton(
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
                  Firestore.instance.collection('groups').document(ds.documentID).updateData({ 'followers' : FieldValue.arrayRemove([userId]),'AlldeviceTokens': FieldValue.arrayRemove([userToken])});
                  Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayRemove([ds.documentID])});
                  // Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups1' : FieldValue.arrayRemove([ds.documentID])});
                  // Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups2' : FieldValue.arrayRemove([ds.documentID])});
                  // Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups3' : FieldValue.arrayRemove([ds.documentID])});
                },
              ):FlatButton(
                child: Text(
                  "Follow",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).accentColor,
                onPressed: ()async{
                  print("check for doc id of group ${ds.documentID}");
                  // make an entry in db as joinedGroups
                 try {
                   //  this is for token 
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
                  // Firestore.instance.collection('groups').document(ds.documentID).updateData({ 'followers' : FieldValue.arrayUnion([userId]), 'AlldeviceTokens': FieldValue.arrayUnion([userToken]) });
  
   var q1 = await Firestore.instance.collection('IAM').document(userId).get();

   var followingGroups0 = q1.data['followingGroups0'] ?? [];
  //  var followingGroups1 = q1.data['followingGroups1'] ?? [];
  //  var followingGroups2 = q1.data['followingGroups2'] ?? [];
  //  var followingGroup3 = q1.data['followingGroups3'] ?? [];





  if(followingGroups0.length <9){
    print('i was at following groups 0dd ${ds.documentID}');
      Firestore.instance.collection('groups').document(ds.documentID).updateData({ 'followers' : FieldValue.arrayUnion([userId]), 'AlldeviceTokens': FieldValue.arrayUnion([userToken]) });
      Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayUnion([ds.documentID])});
      return;
  }else{
   
 _showBasicsFlash(context:  context, duration: Duration(seconds: 4), messageText : 'Overall max 9 group can be followed...!');
  }
//   else if (followingGroups1.length <9){
//       Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups1' : FieldValue.arrayUnion([ds.documentID]) });
//       return;
//   }else if (followingGroups2.length <9){
//       Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups2' : FieldValue.arrayUnion([ds.documentID]) });
//       return;
//   }else if(followingGroup3.length <9){
//       Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups3' : FieldValue.arrayUnion([ds.documentID])});
//   // ds.documentID
//  NotificationController.instance.subScribeChannelNotification("${ds.documentID}");
//       return;
//   }
                 } catch (e) {
                   print('error at joining a group');
                 }
          
 
                },
              ),
              onTap: (){},
            ),
          );
        },
      );
          }
          return Text("Loading...");
        }
      )
    );
  }
}
