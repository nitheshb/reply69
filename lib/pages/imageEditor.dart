import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:intl/intl.dart';
import 'package:notification/ImageEditorPack/image_editorHome.dart';



class ImageEditorPage extends StatefulWidget {
  ImageEditorPage({Key key, this.chatId,this.userId, this.chatType, this.groupLogo});
  final String chatId, userId,chatType, groupLogo;
  @override
  _ImageEditorPageState createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
   @override
  void initState() {
 
    super.initState();
  }
  Future<void> getimageditor() {
    final geteditimage =
        Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyImageEditorPro(
        appBarColor: Colors.blue,
        bottomBarColor: Colors.blue,
        groupLogo: widget.groupLogo,
      );
    })).then((geteditimage) {
      if (geteditimage != null) {
        setState(() {
          _image = geteditimage;
        });
      }
    }).catchError((er) {
      print(er);
    });
  }

  File _image;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor Pro example'),
      ),
      body: _image == null
          ? Center(
              child: RaisedButton(
                onPressed: () {
                  getimageditor();
                },
                child: new Text("Open Editor"),
              ),
            )
          : Center(
              child: Image.file(_image),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () async {
          print('i was clicked');
               DateTime now = new DateTime.now();
    
          var datestamp = new DateFormat("yyyyMMdd'T'HHmmss");
          String currentdate = datestamp.format(now);
      // myimage1
    final StorageReference firebaseStorageRef = await FirebaseStorage.instance.ref().child('${currentdate}.jpg');
    final StorageUploadTask uploadTask = await firebaseStorageRef.putFile(_image);
     var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    print('uploaded url is $url');
        try {
                        var body ={ "imageUrl":url, "date": now,"author": widget.userId, "type": "Image" };
                      await  Firestore.instance.collection('groups').document(widget.chatId).updateData({ 'messages' : FieldValue.arrayUnion([body])});
                     _image = null;
                     await Navigator.pop(context);
                      } catch (e) {
                        print('error was catched ${e}');
                      }
         // _image = null;
          setState(() {});
        },
      ),
    );
  }
}