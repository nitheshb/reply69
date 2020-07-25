import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class DialogHelpers {
  static Dialog getProfileDialog({
    @required BuildContext context,
    int id,
    String imageUrl,
    String name,
    GestureTapCallback onTapMessage,
    GestureTapCallback onTapCall,
    GestureTapCallback onTapVideoCall,
    GestureTapCallback onTapInfo,
  }) {
    Widget image =
        
         Image(
      image: CachedNetworkImageProvider(imageUrl),
    );
    return new Dialog(
      shape: RoundedRectangleBorder(),
      child: Container(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                child: Stack(
                  children: <Widget>[
                    image,
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showRadioDialog(List allOptions, String title, Function getText, BuildContext context, option, bool isActions, onChanged) {
    showDialog(
        barrierDismissible: !isActions,
        context: context,
        builder: (context) {
          List<Widget> widgets = [];
          for(dynamic opt in allOptions) {
            widgets.add(
              ListTileTheme(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RadioListTile(
                  value: opt,
                  title: Text(getText(opt), style: TextStyle(fontSize: 18.0),),
                  groupValue: option,
                  onChanged: (value) {
                    onChanged(value);
                    Navigator.of(context).pop();
                  },
                  activeColor: Colors.grey,
                ),
              ),
            );
          }

          return AlertDialog(
            contentPadding: EdgeInsets.only(bottom: 8.0),
            title: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.w600),),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widgets,
                    ),
                  ),
                ),
              ],
            ),
            actions: !isActions ? null : <Widget>[
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(false);
                },
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        }
    );
  }

  // static _defOnTapMessage(BuildContext context, int id) {
  //   Application.router.navigateTo(
  //     context,
  //     "/chat?profileId=$id",
  //     transition: TransitionType.inFromRight,
  //   ).then((result) {
  //     Navigator.of(context).pop();
  //   });
  // }




}