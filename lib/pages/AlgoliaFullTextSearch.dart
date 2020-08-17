import 'package:flash/flash.dart';
import 'package:flutter/material.dart';



class ShowSnackBar extends StatefulWidget {
  final String text;
  final int duration;



  ShowSnackBar({Key key, this.text, this.duration}) : super(key: key);

  @override
  _ShowSnackBarState createState() => _ShowSnackBarState();
}

class _ShowSnackBarState extends State<ShowSnackBar> {
    bool lockModify;
   @override
  void initState() {
    super.initState();

  }
  Widget _showBasicsFlash({
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
    print('i was here-->');
    return _showBasicsFlash(context:  context, duration: Duration(seconds: 4), messageText : '${widget.text}');
  }}
