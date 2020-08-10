import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:notification/pages/imageFullView.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;
  final String message;
  final String type;
  final  premium;

  PostItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.img,
    @required this.message,
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
              color: widget.premium ? Color(0xffFFCB2D):Colors.blueAccent,
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
                    child:Text(
                    "${widget.time}",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
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
