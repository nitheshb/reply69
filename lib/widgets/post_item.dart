import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;

  PostItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.img
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    print('check for urls ${widget.img}');
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "${widget.dp}",
                ),
              ),

              contentPadding: EdgeInsets.all(0),
              title: Text(
                "${widget.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),

            Image.network(
              "${widget.img}",
              // "https://firebasestorage.googleapis.com/v0/b/teamplayers-f3b25.appspot.com/o/myimage1.jpg?alt=media&token=8b2069b9-aeb0-4c1d-a861-b7e9ab1e1dd6",
              height: 250,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),

          ],
        ),
        onTap: (){},
      ),
    );
  }
}
