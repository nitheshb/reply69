import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notification/screens/conversation.dart';


class ChatItem extends StatefulWidget {

  final String dp;
  final String name;
  final String time;
  final String msg;
  final bool isOnline;
  final counter;
  final fullUserJson;
  final chatId;

  ChatItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.msg,
    @required this.isOnline,
    @required this.counter,
    this.chatId,
    this.fullUserJson,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(
                "${widget.dp}",
              ),
              radius: 25,
            ),

            Positioned(
              bottom: 0.0,
              left: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 11,
                width: 11,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isOnline
                          ?Colors.greenAccent
                          :Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 7,
                    width: 7,
                  ),
                ),
              ),
            ),

          ],
        ),

        title: Text(
          "${widget.name}",
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${widget.msg}",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "${widget.time}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            ),

            SizedBox(height: 5),
            widget.counter == 0
                ?SizedBox()
                :InkWell(
                  onTap: (){
                    print('remove was clicked');
                    var userId = widget.fullUserJson['userId'];
                    var modifiedDate = widget.fullUserJson['expiresOn'];
                    var kycDocId = widget.fullUserJson['kycDocId'];
                    var period = widget.fullUserJson['membershipDuration'];
                    var joinedTime = widget.fullUserJson['joinedId'];
                    var expiredTime = widget.fullUserJson['expiresOn'];
              Firestore.instance.collection('IAM').document(userId).updateData({'approvedGroups': FieldValue.arrayRemove([widget.chatId]), 'approvedGroupsJson': FieldValue.arrayRemove([{'chatId':widget.chatId,'kycDocId': kycDocId }]),'expiredGroups':FieldValue.arrayUnion([{'chatId':widget.chatId,'kycDocId': kycDocId }])});
              var groupUserBody = {'userId':userId, 'joinedId': joinedTime, 'expiresOn':  expiredTime,'membershipDuration': period, 'kycDocId': kycDocId };
         Firestore.instance.collection('groups').document(widget.chatId).updateData({'premiumMembers': FieldValue.arrayRemove([userId]),'approvedGroupsJson': FieldValue.arrayRemove([groupUserBody]),'expiredMembers': FieldValue.arrayUnion([userId])});
            //  Firestore.instance.collection('groups').document(widget.chatId).collection('collectionPath').updateData({'premiumMembers': FieldValue.arrayRemove([userId]),'approvedGroupsJson': FieldValue.arrayRemove([groupUserBody]),'rejectedId': FieldValue.arrayRemove([userId])});
                  },
                  child:Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 11,
                minHeight: 11,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 2),
                child:Text(
                  "${widget.counter}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
                ),
          ],
        ),
        onTap: (){
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (BuildContext context){
                return Conversation();
              },
            ),
          );
        },
      ),
    );
  }
}
