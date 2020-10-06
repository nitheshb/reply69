import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/controllers/firebaseController.dart';
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
  final groupTitle;

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
    this.groupTitle,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  Dio dio = new Dio();
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
                "",
              ),
              radius: 25,
            ),

            // Positioned(
            //   bottom: 0.0,
            //   left: 6.0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(6),
            //     ),
            //     height: 11,
            //     width: 11,
            //     child: Center(
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: widget.isOnline
            //               ?Colors.greenAccent
            //               :Colors.grey,
            //           borderRadius: BorderRadius.circular(6),
            //         ),
            //         height: 7,
            //         width: 7,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        title: Text(
          "${widget.name}",
          maxLines: 1,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "${widget.msg}",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w300,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "Expiry ${widget.time}",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
            SizedBox(height: 5),
            widget.counter == 0
                ? SizedBox()
                : InkWell(
                    onTap: () async {
                      // var userId = widget.fullUserJson['userId'];
                      // var modifiedDate = widget.fullUserJson['expiresOn'];
                      // var kycDocId = widget.fullUserJson['kycDocId'];
                      // var period = widget.fullUserJson['membershipDuration'];
                      // var joinedTime = widget.fullUserJson['joinedId'];
                      // var expiredTime = widget.fullUserJson['expiresOn'];

                      // FirebaseController.instanace.removeMemberOnExpiry(
                      //     userId,
                      //     joinedTime,
                      //     expiredTime,
                      //     kycDocId,
                      //     period,
                      //     widget.chatId,
                      //     widget.fullUserJson);
                            _showBasicsFlash(
                      context: context,
                      duration: Duration(seconds: 4),
                      messageText: '${widget.name} removed from  Prime group');
                      // try {
                      //   var response = await dio.get(
                      //       "https://asia-south1-royalpro.cloudfunctions.net/onMemberRemove?id=${userId}&chatId=${widget.chatId}&groupName=${widget.groupTitle}");
                      // } catch (e) {
                      //   print('error is ${e}');
                      // }
                    },
                    child: Container(
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
                        padding: EdgeInsets.only(
                            top: 0, left: 5, right: 5, bottom: 2),
                        child: Text(
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
      ),
    );
  }
    void _showBasicsFlash({
    Duration duration,
    flashStyle = FlashStyle.floating,
    BuildContext context,
    String messageText,
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
}
