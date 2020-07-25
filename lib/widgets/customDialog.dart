import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomDialog extends StatefulWidget {
  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryButtonRoute;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.primaryButtonText,
      @required this.primaryButtonRoute,
      this.secondaryButtonText,
      this.secondaryButtonRoute});

  static const double padding = 20.0;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
    final TextEditingController _groupName = new TextEditingController();
     final TextEditingController _groupCategory = new TextEditingController();
  final primaryColor = const Color(0xFF75A2EA);

  final grayColor = const Color(0xFF939393);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomDialog.padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(CustomDialog.padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(CustomDialog.padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0),
                AutoSizeText(
                  widget.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 24.0),
   TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: false,
                                    controller: _groupName,
                                    decoration: InputDecoration(
                                        labelText: 'Group Name',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                            border: OutlineInputBorder(
                                            borderSide:
                                               new  BorderSide(color: Color(0xFFE7E7E7))),
                                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFE7E7E7)))
                                           
                                                ),
                                  ),
                                  SizedBox(height: 16),
                                     TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: false,
                                    controller: _groupCategory,
                                    decoration: InputDecoration(
                                        labelText: 'Category',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                            border: OutlineInputBorder(
                                            borderSide:
                                               new  BorderSide(color: Color(0xFFE7E7E7))),
                                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFE7E7E7)))        
                                                ),
                                  ),
                SizedBox(height: 24.0),
                RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: AutoSizeText(
                      widget.primaryButtonText,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () async {

                                           var body ={
                                          "title": _groupName.text,
                                          "createdBy":"check",
                                          "createdOn": "cehck",
                                          "category": _groupCategory.text,
                                          "groupType": "premium",
                                          "members": [],
                                          "color": '',
                                          "logo": '',
                                        };
                   await Firestore.instance.collection("groups").document().setData(body);
                  await  Navigator.of(context).pop();
                await    Navigator.of(context)
                        .pushReplacementNamed(widget.primaryButtonRoute);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}