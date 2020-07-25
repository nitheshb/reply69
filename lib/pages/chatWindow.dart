import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/pages/imageEditor.dart';
import 'package:notification/screens/groupMembersHome.dart';
import 'package:notification/screens/joinPremium.dart';
import 'package:notification/screens/joinRequestApproval.dart';
import 'package:notification/util/data.dart';
import 'package:notification/widgets/chat_bubble.dart';
import 'package:notification/widgets/sendTextMsg.dart';


class ChatWindow extends StatefulWidget {
  ChatWindow({Key key, this.chatId,this.userId,this.senderMailId, this.chatType, this.waitingGroups, this.approvedGroups, this.chatOwnerId, this.approvedGroupsJson,this.title, this.feeArray, this.paymentScreenshotNo, this.avatarUrl});
  final String chatId, userId,chatType, chatOwnerId, senderMailId, title,  paymentScreenshotNo, avatarUrl;
  List waitingGroups, approvedGroups;
  List approvedGroupsJson;
  final feeArray;
  
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
   final TextEditingController _chatMessageText = new TextEditingController();
    ScrollController _scrollController = new ScrollController();

   File _image;
   int selectedRadio;
   bool msgDeliveryMode = true;

   // Changes the selected value on 'onChanged' click on each radio button
setSelectedRadio(int val) {
  setState(() {
    selectedRadio = val;
  });
}
setDeliveryModeCheckBox(bool val) {
  setState(() {
    msgDeliveryMode = val;
  });
}



scrollToBottomFun(){
  SchedulerBinding.instance.addPostFrameCallback((_) {
  _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
    duration: const Duration(milliseconds: 10),
    curve: Curves.easeOut,);
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/110'),
                backgroundColor: Colors.grey[200],
                minRadius: 30,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.chatId}',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Online Now',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                // group header
                  Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: Offset(-2, 0),
                  blurRadius: 5,
                ),
              ]),
              child: Row(
                children: <Widget>[
                    Visibility(
                      visible: widget.chatOwnerId == widget.userId,
                      child: FlatButton(
                child: Text(
                  "Requests",
                  style: TextStyle(
                      color: Colors.white,
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: (){
                       Navigator.push(
                                    context,
                                   new  MaterialPageRoute(
                                        builder: (BuildContext context) => 
                                        JoinRequestApproval(chatId: widget.chatId,),
                                        ),
                                 );
                },
              ),
                    ),
                    SizedBox(width: 10),
                      Visibility(
                        visible: true,
                     // visible: widget.chatOwnerId == widget.userId,
                      child: FlatButton(
                child: Text(
                  "Members",
                  style: TextStyle(
                      color: Colors.white,
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: (){
                  print('check for prone ${widget.chatOwnerId}  ccc ${widget.userId}');
                       Navigator.push(
                                    context,
                                   new  MaterialPageRoute(
                                        builder: (BuildContext context) => 
                                        GroupMembersHome(groupMembersJson : widget.approvedGroupsJson, chatId: widget.chatId),
                                        ),
                                 );
                },
              ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _chatMessageText,
                      decoration: InputDecoration(
                        hintText: 'Enter Message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print('user send tis message ${_chatMessageText.text}');
                      try {
                        var body ={ "messageBody":_chatMessageText.text, "date": "","author": widget.userId, "type": "text" };
                        Firestore.instance.collection('groups').document(widget.chatId).updateData({ 'messages' : FieldValue.arrayUnion([body])});
                        _chatMessageText.text ="";
                      } catch (e) {
                      }
 
                      

                    },
                    icon: Icon(
                      Icons.send,
                      color: Color(0xff3E8DF3),
                    ),
                  ),
                 Visibility(
                   visible: widget.waitingGroups.contains(widget.chatId),
                   child: 
                  FlatButton(
                child: Text(
                  "Waiting",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: (){
                     Navigator.push(
                                  context,
                                 new  MaterialPageRoute(
                                      builder: (BuildContext context) => JoinPremiumGroup(chatId: widget.chatId,userId: widget.userId,lock: true,title: widget.title,feeArray: widget.feeArray, paymentScreenshotNo: widget.paymentScreenshotNo, avatarUrl: widget.avatarUrl ),
                                      ),
                               );
                },
              )
                 ),
                    Visibility(
                   visible: widget.approvedGroups.contains(widget.chatId),
                   child: 
                  FlatButton(
                child: Text(
                  "Your Pemium Member",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blueAccent,
                onPressed: (){
                     Navigator.push(
                                  context,
                                 new  MaterialPageRoute(
                                      builder: (BuildContext context) => JoinPremiumGroup(chatId: widget.chatId,userId: widget.userId,lock: true,title: widget.title,feeArray: widget.feeArray, paymentScreenshotNo: widget.paymentScreenshotNo, avatarUrl: widget.avatarUrl ),
                                      ),
                               );
                },
              )
                 ),
                   Visibility(
                   visible: !widget.waitingGroups.contains(widget.chatId) && !widget.approvedGroups.contains(widget.chatId),
                   child: 
                  FlatButton(
                child: Text(
                  "Join Premium",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: (){
                     Navigator.push(
                                  context,
                                 new  MaterialPageRoute(
                                      builder: (BuildContext context) => JoinPremiumGroup(chatId: widget.chatId,userId: widget.userId,lock: false,title: widget.title,feeArray: widget.feeArray, paymentScreenshotNo: widget.paymentScreenshotNo, avatarUrl: widget.avatarUrl ),
                                      ),
                               );
                },
              )
                 ),
                ],
              ),
            ),
          ),

                Flexible(
                  child:StreamBuilder(
        stream:  Firestore.instance.collection('groups').document(widget.chatId).snapshots(),
        builder: (context,snapshot){
                     if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
          if(snapshot.hasData && snapshot.data['messages'].length > 0){
            
              return     ListView.builder(
                    itemCount: snapshot.data['messages'].length,
                    controller: _scrollController,
                 // reverse: true,
                  shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var totalMessageLength = snapshot.data['messages'].length;
                      DocumentSnapshot ds = snapshot.data;
                      var indexVal = index;
                      print('value of messages are ${ds['messages'] ?? "empty"}');
                      scrollToBottomFun();
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Today',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            
                            snapshot.data['messages'][indexVal]['type'] == 'Image' ?
                               ChatBubble(
                    message: snapshot.data['messages'][indexVal]['type']  == "text"
                        ? snapshot.data['messages'][indexVal]['messageBody']
                        :snapshot.data['messages'][indexVal]['imageUrl'],
                    username: widget.userId,
                    time: "${random.nextInt(50)} min ago",
                    type: "image",
                    replyText: "check",
                    isMe: false,
                    isGroup: false,
                    isReply: false,
                    replyName: widget.userId,
                  ) : 
                  //  WhatsAppBubble(
                  //             message: '${snapshot.data['messages'][indexVal]['messageBody']}',
                  //             isMe: true,
                  //             time: Jiffy(snapshot.data['messages'][indexVal]['date'].toDate()).fromNow().toString(),
                  //             delivered:  true,
                  //             type: "text",

                              
                  //           )
                  SendedMessageWidget(
                    content: '${snapshot.data['messages'][indexVal]['messageBody']}',
                    // time: Jiffy(snapshot.data['messages'][indexVal]['date'].toDate()).fromNow().toString()
                    time: "21:30"

                  ),
                          ],
                        ),
                      );
                    },
                  );
          }
          return Text('Empty Chat');
          })
                ),
new Divider(height: 1.0),
                     Visibility(
            visible: widget.chatOwnerId == widget.userId,
            child: Positioned(
              bottom: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-2, 0),
                    blurRadius: 5,
                  ),
                ]),
                child: Row(
                  children: <Widget>[
  //                   CheckboxListTile(
  //   title: Text("title text"),
  //   value: msgDeliveryMode,
  //   onChanged: (newValue) { 
  //                setState(() {
  //                  msgDeliveryMode = newValue; 
  //                }); 
  //              },
  //   controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
  // ),

  Checkbox(
      value: msgDeliveryMode,
      onChanged: setDeliveryModeCheckBox
    ),
    //               Radio(
    //   value: 1,
    //   groupValue: selectedRadio,
    //   activeColor: Colors.green,
    //   onChanged: (val) {
    //     print("Radio $val");
    //     setSelectedRadio(val);
    //   },
    // ),
                    IconButton(
                      onPressed: () {
                          Navigator.push(
                                    context,
                                   new  MaterialPageRoute(
                                        builder: (BuildContext context) => ImageEditorPage(chatId: widget.chatId,userId: widget.userId,chatType: "Image",),
                                        ),
                                 );
                        
                        // getImage();
                      },
                      icon: Icon(
                        Icons.image,
                        color: Color(0xff3E8DF3),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Expanded(
                      child: TextFormField(
                        onTap: () {
Timer(
Duration(milliseconds: 300),
() => _scrollController
    .jumpTo(_scrollController.position.maxScrollExtent));
},
                        keyboardType: TextInputType.text,
                        controller: _chatMessageText,
                        decoration: InputDecoration(
                          hintText: 'Enter Message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        print('user send tis message ${_chatMessageText.text}');
                        var now = new DateTime.now();
                        var alt =  now.add(Duration(days: 1));
                        print('time was ${alt}');
                        try {
                          var now = new DateTime.now();
                          var body ={ "messageBody":_chatMessageText.text, "date": now,"author": widget.userId, "type": "text" , "premium": msgDeliveryMode  };
                         var lastMessageBody ={"lastMsg":_chatMessageText.text, "lastMsgTime": now};
                          Firestore.instance.collection('groups').document(widget.chatId).updateData({ 'lastMessageDetails':lastMessageBody, 'messages' : FieldValue.arrayUnion([body])});
                          _chatMessageText.text ="";
                            Timer(Duration(milliseconds: 500),
            () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
                        } catch (e) {
                        }
 
                        

                      },
                      icon: Icon(
                        Icons.send,
                        color: Color(0xff3E8DF3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              ],
            ),
          ),
     
        ],
      ),
    );
  }
    Future getImage() async {
   print("launching image picker");
var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  print('ending image picker');

      setState(() {
          _image = image;
        });
    // if (image != null) {
    //   File cropimage = await cropImage(image);
    //   if (cropimage != null) {
    //     if (!mounted) return;
    //     setState(() {
    //       _image = cropimage;
    //     });
    //   }
    // }

  }
    Future<File> cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    return croppedFile;
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final msgTime;

  Bubble({this.message, this.isMe, this.msgTime});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [
                              0.1,
                              1
                            ],
                          colors: [
                              Color(0xFFF6D365),
                              Color(0xFFFDA085),
                            ])
                      : LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [
                              0.1,
                              1
                            ],
                          colors: [
                              Color(0xFFEBF5FC),
                              Color(0xFFEBF5FC),
                            ]),
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(0),
                        ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              //     Positioned(
              //   bottom: 0.0,
              //   right: 0.0,
              //   child: Row(
              //     children: <Widget>[
              //       Text(
              //         "${msgTime}",
              //         style: TextStyle(
              //           color: Colors.black38,
              //           fontSize: 7.5,
              //         ),
              //       ),
              //       SizedBox(width: 3.0),
              //       Icon(Icons.done_all,
              //           size: 12.0,
              //           color: true ? Colors.blue : Colors.black38)
              //     ],
              //   ),
              // )
            ],
          )
        ],
      ),
    );
  }
}
