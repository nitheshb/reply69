import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notification/pages/imageFullView.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;
  final String message;
  final String type;
  final String messageMode;
  final String selMessageMode;
  final String uxId;
  final  premium;

  PostItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.img,
    @required this.message,
    @required this.messageMode,
    @required this.selMessageMode,
    this.uxId,
    this.premium,
    this.type
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
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
    print('check for urls ${widget.img}');
    var colorBg;
    if(widget.selMessageMode == 'All'){
                colorBg= Color(0xff1AC470);
              } else if(widget.selMessageMode == 'Prime') {
                colorBg = Color(0xffFFCB2D);
              }else{
                colorBg = Color(0xff3AD4C5);
                
              }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      
      child: Container(
         decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 6,
                  spreadRadius: 10,
                )
              ],
            ),
        child: InkWell(
          
          child: Column(
            children: <Widget>[
             
            widget.type =='text' ? Container(
            
              width: MediaQuery.of(context).size.width,
              color: colorBg,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.message == "" ? "Empty Message" :widget.message,
                      style:  TextStyle(
                        color: true
                            ? Colors.white
                            : Theme.of(context).textTheme.title.color,
                      ),
                    ),
                  )
            ):

  InkWell(
    onTap:(){
        onTapProfileChatItem(context, widget.img);
    },
  child: Image(
        image: CachedNetworkImageProvider(widget.img),
        height: MediaQuery.of(context).size.width,
                 width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
    )
  ),
              // Image.network(
              //   "${widget.img}",
              //   // "https://firebasestorage.googleapis.com/v0/b/teamplayers-f3b25.appspot.com/o/myimage1.jpg?alt=media&token=8b2069b9-aeb0-4c1d-a861-b7e9ab1e1dd6",
              //   height: 250,
              //   width: MediaQuery.of(context).size.width,
              //   fit: BoxFit.cover,
              // ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // this is for only the user screenshot approval view
                          child:Visibility(
                              visible: widget.messageMode == 'paymentAccept',
                              child:Text(
                            "${widget.uxId}",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                  )

                          ),
                        
                        ),
                        Row(
                          children: <Widget>[
                            Visibility(
                              visible: widget.messageMode == 'Prime',
                              child:
                            Padding(
                              padding: const EdgeInsets.only(right:8.0,bottom:2),
                              child: Icon(
                                  FontAwesomeIcons.crown,
                                  color: Colors.blue,
                                  size: 8,
                                ),
                            ),
                            ),
                            Visibility(
                              visible: widget.messageMode == 'All',
                              child:
                            Padding(
                              padding: const EdgeInsets.only(right:8.0,bottom:2),
                              child: Icon(
                                  FontAwesomeIcons.users,
                                  color: Colors.blue,
                                  size: 8,
                                ),
                            ),
                            ),
                            Text(
                            "${widget.time}",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 11,
                            ),
                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

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
          onTap: (){},
        ),
      ),
    );
  }
}
