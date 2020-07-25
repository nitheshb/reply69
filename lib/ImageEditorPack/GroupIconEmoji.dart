import 'package:flutter/material.dart';

class EmojiView extends StatefulWidget {
  final double left;
  final double top;
  final Function ontap;
  final Function(DragUpdateDetails) onpanupdate;
  final double fontsize;
  final String value;
  final TextAlign align;
  const EmojiView(
      {Key key,
      this.left,
      this.top,
      this.ontap,
      this.onpanupdate,
      this.fontsize,
      this.value,
      this.align})
      : super(key: key);
  @override
  _EmojiViewState createState() => _EmojiViewState();
}

class _EmojiViewState extends State<EmojiView> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: GestureDetector(
          onTap: widget.ontap,
          onPanUpdate: widget.onpanupdate,
          child: 
          
          Row(
            children: <Widget>[
              Visibility(
                visible: widget.value == null,
                child:
              Container(
                   height: 100,
                   width: 100,
                  //  color: Colors.red,
                   child: Image.asset(widget.value),
                ),
              ),
              Visibility(
                visible: widget.value != null,
                child:
              Container(
                   height: 100,
                   width: 100,
                  decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.value),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      )
                
                ),
              ),
            ],
          )
              
              ),
    );
  }
}
