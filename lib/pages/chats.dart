import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notification/pages/chatWindow.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/customDialog.dart';
import 'package:notification/widgets/custom_heading.dart';


class ChatsOld extends StatefulWidget {
  @override
  _ChatsOldState createState() => _ChatsOldState();
}

class _ChatsOldState extends State<ChatsOld> {
    StateModel appState;  
    List waitingGroups = [], approvedGroups =[];
    Map WaitingGroupsJSON, JoinedGroupsJson;


    @override
  // void dispose() {
  //   super.dispose();
  // }

getUserData(userId)async {
  var response = await  Firestore.instance.collection('IAM').document(userId).get();
  print(('respnse is ${response.data}'));
  setState(() {
   waitingGroups = response.data['WaitingGroups'] ?? [];
   approvedGroups = response.data['approvedGroups'] ?? [];

  });
  return response.data;
  }


  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
   // getUserData(userId);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        backgroundColor: Colors.white,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {

showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: "Create Group1",
                        description:
                            "With an account, your data will be securely saved, allowing you to access it from multiple devices.",
                        primaryButtonText: "Create My Account",
                        primaryButtonRoute: "/signUp",
                        secondaryButtonText: "Maybe Later",
                        secondaryButtonRoute: "/home",
                      ),
                    );
            },
            child: Text('Create Group'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomHeading(
              title: 'Groups',
            ),
              Container(child: StreamBuilder(
        stream:  Firestore.instance.collection('groups').snapshots(),
        builder: (context,snapshot){
                     if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
          if(snapshot.hasData && snapshot.data.documents.length > 0 ){
              // return Text("snapshot ${snapshot.data.documents.length}");

           return Container(
              height: 150,
              child: 
              
              ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(15),
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return Column(
                    children: <Widget>[
                      Container(
                        width: 90,
                        height: 90,
                        margin: EdgeInsets.only(right: 15),
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
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(' ${ds['title']}'),
                      )
                    ],
                  );
                },
              ),
            );
             }
      }),),
            CustomHeading(
              title: 'All Groups',
            ),
              Container(child: StreamBuilder(
        stream:  Firestore.instance.collection('groups').snapshots(),
        builder: (context,snapshot){
                     if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
          if(snapshot.hasData && snapshot.data.documents.length > 0 ){
          return  ListView.builder(
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                return Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatWindow(chatId: ds.documentID, chatOwnerId: ds.data['creatorBy'],approvedGroupsJson: ds.data['approvedGroupsJson'], userId: userId, senderMailId: email,chatType: "", waitingGroups: waitingGroups, approvedGroups: approvedGroups),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(50),
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/11$index'),
                                  minRadius: 35,
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${ds['title']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Text(
                                  'Hi How are you ?',
                                  style: TextStyle(
                                    color: Color(0xff8C68EC),
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Text(
                                  '11:00 AM',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        })
              ),
          ],
        ),
      ),
    );
  }
}
