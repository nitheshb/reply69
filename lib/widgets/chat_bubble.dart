import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/pages/imageFullView.dart';

class ChatBubble extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;
  final String message;
  final String type;
  final String messageMode;
  final String selMessageMode;
  final String uxId;
  final String date;
  final premium;

  ChatBubble(
      {Key key,
      @required this.date,
      @required this.dp,
      @required this.name,
      @required this.time,
      @required this.img,
      @required this.message,
      @required this.messageMode,
      @required this.selMessageMode,
      this.uxId,
      this.premium,
      this.type})
      : super(key: key);
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  void onTapProfileChatItem(BuildContext context, chat) {
    Dialog profileDialog = DialogHelpers.getProfileDialog(
      context: context,
      id: 123,
      imageUrl: chat,
      name: "",
    );
    showDialog(
        context: context, builder: (BuildContext context) => profileDialog);
  }

  @override
  Widget build(BuildContext context) {
    var colorBg;
    if (widget.selMessageMode == 'All') {
      colorBg = Color(0xffDEF9FF);
    } else if (widget.selMessageMode == 'Prime') {
      colorBg = Color(0xffFFDFED);
    } else {
      colorBg = Color(0xffFFF4DF);
    }
    return Padding(
      padding: EdgeInsets.all(1),
      child: Container(
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(3),
        //   boxShadow: [
        //     // BoxShadow(
        //     //   color: Colors.grey.shade100,
        //     //   blurRadius: widget.messageMode == 'paymentAccept' ? 0 : 6,
        //     //   spreadRadius: widget.messageMode == 'paymentAccept' ? 0 : 10,
        //     // )
        //   ],
        // ),
        child: InkWell(
          child: Column(
            children: <Widget>[
              widget.type == 'text'
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: colorBg,
                        borderRadius: BorderRadius.circular(5),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.shade100,
                        //     blurRadius:
                        //         widget.messageMode == 'paymentAccept' ? 0 : 2,
                        //     spreadRadius:
                        //         widget.messageMode == 'paymentAccept' ? 0 : 2,
                        //   )
                        // ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.message == ""
                                  ? "Empty Message"
                                  : widget.message,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Color(0xff4E4B66),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.75
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                // this is for only the user screenshot approval view
                                child: Visibility(
                                    visible:
                                        widget.messageMode == 'paymentAccept',
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "${widget.name}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 6.0, top: 4.0),
                                          child: Text(
                                            "${widget.uxId}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              Row(
                                children: <Widget>[
                                  Visibility(
                                    visible: widget.messageMode == 'Prime',
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, bottom: 2),
                                      child: Icon(
                                        FontAwesomeIcons.crown,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.messageMode == 'All',
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, bottom: 2),
                                      child: Icon(
                                        FontAwesomeIcons.users,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                          right: 2.0,
                                          left: 2),
                                      child: widget.date != null
                                          ? Text(
                                              "${widget.date}",
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Color(0xffA0A3BD),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          : Text(
                                              "07-10",
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Color(0xffA0A3BD),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8.0,
                                        right: 8.0,
                                        left: 2),
                                    child: Text(
                                      "${widget.time}",
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        // color: Color(0xff3A4276),
                                        color: Color(0xffA0A3BD),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ))
                  : InkWell(
                      onTap: () {
                        onTapProfileChatItem(context, widget.img);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: colorBg,
                        borderRadius: BorderRadius.circular(5),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.shade100,
                        //     blurRadius:
                        //         widget.messageMode == 'paymentAccept' ? 0 : 2,
                        //     spreadRadius:
                        //         widget.messageMode == 'paymentAccept' ? 0 : 2,
                        //   )
                        // ],
                      ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(1.0,1,1,34),
                          child: Image(
                            image: CachedNetworkImageProvider(widget.img),
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )),
              // Image.network(
              //   "${widget.img}",
              //   // "https://firebasestorage.googleapis.com/v0/b/teamplayers-f3b25.appspot.com/o/myimage1.jpg?alt=media&token=8b2069b9-aeb0-4c1d-a861-b7e9ab1e1dd6",
              //   height: 250,
              //   width: MediaQuery.of(context).size.width,
              //   fit: BoxFit.cover,
              // ),
//  ListTile(
              // leading: CircleAvatar(
              //   backgroundImage: AssetImage(
              //     "${widget.dp}",
              //   ),
              // ),

              // contentPadding: EdgeInsets.all(0),
              // title: Text(
              //   "${widget.name}",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // trailing: Text(
              //   "${widget.time}",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w300,
              //     fontSize: 11,
              //   ),
              // ),
              // ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
