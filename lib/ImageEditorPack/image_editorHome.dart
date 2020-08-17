import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_pro/modules/all_emojies.dart';
import 'package:image_editor_pro/modules/bottombar_container.dart';
import 'package:image_editor_pro/modules/colors_picker.dart';
// import 'package:image_editor_pro/modules/emoji.dart';
import 'package:image_editor_pro/modules/text.dart';
import 'package:image_editor_pro/modules/textview.dart';
import 'package:notification/ImageEditorPack/GroupIconEmoji.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/widgets/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 300;
var height = 300;

List fontsize = [];
var howmuchwidgetis = 0;
List multiwidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller =
    SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class MyImageEditorPro extends StatefulWidget {
  final Color appBarColor;
  final Color bottomBarColor;
  final String groupLogo, userId, chatId, deliveryMode;
  final bool premiumMode;
  MyImageEditorPro({this.appBarColor, 
  this.premiumMode,this.bottomBarColor, 
  this.groupLogo, this.userId, this.chatId, 
  this.deliveryMode});

  @override
  _MyImageEditorProState createState() => _MyImageEditorProState();
}

var slider = 0.0;

class _MyImageEditorProState extends State<MyImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller =
        SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];
  bool _loadingVisible = false;

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = new GlobalKey();
  File _image;
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;
  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }
    void setopenbottomsheet() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      openbottomsheet = true;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    fontsize.clear();
    offsets.clear();
    multiwidget.clear();
    howmuchwidgetis = 0;
    
    // TODO: implement initState
    super.initState();
  }

   Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        key: scaf,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          actions: <Widget>[
    
            new IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _controller.points.clear();
                  setState(() {});
                }),
            new IconButton(
                icon: Icon(FontAwesomeIcons.images, color: Colors.redAccent),
                onPressed: () async{
                  var image = await ImagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    var decodedImage =
                                        await decodeImageFromList(
                                            image.readAsBytesSync());

                                    setState(() {
                                      height = decodedImage.height;
                                      width = decodedImage.width;
                                      _image = image;
                                    });
                                    setState(() => _controller.clear());
                  // bottomsheets();
                }),
            new FlatButton(
                child: new Text("Upload"),
                textColor: Colors.black,
                onPressed: ()async {
                  if(_image == null){
                    print('i was inside');
                    _showBasicsFlash(context:  context, duration: Duration(seconds: 2), messageText : 'Please upload any pic to proceed ...!');
                    return;
                  }
                  await _changeLoadingVisible();
                  File _imageFile;
                  _imageFile = null;
                  screenshotController
                      .capture(
                          delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                      .then((File image) async {
                    //print("Capture Done");
                    setState(() {
                      _imageFile = image;
                    });
                    final paths = await getExternalStorageDirectory();
                    image.copy(paths.path +
                        '/' +
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        '.png');



// save the pic to db

     DateTime now = new DateTime.now();
      
    final StorageReference firebaseStorageRef = await FirebaseStorage.instance.ref().child('${widget.chatId}${now.millisecondsSinceEpoch}.jpg');
    final StorageUploadTask uploadTask = await firebaseStorageRef.putFile(image);
     var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    print('uploaded url is $url');
        try {
                        var body ={ "imageUrl":url, "date": now,"author": widget.userId, "type": "Image", "premium": widget.premiumMode, "messageMode": widget.deliveryMode };
                      await  FirebaseController.instanace.sendChatImage(widget.chatId, body);
                     image = null;
                      } catch (e) {
                        print('error was catched ${e}');
                      }
         // _image = null;
          setState(() {});

                    Navigator.pop(context, image);
                  }).catchError((onError) {
                    _changeLoadingVisible();
                    print(onError);
                  });
                }),
          ],
        ),
        body: Center(
          child: 
          LoadingScreen(
         inAsyncCall: _loadingVisible,
         child: Screenshot(
            controller: screenshotController,
            child: Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              width: width.toDouble(),
              height: height.toDouble(),
              child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: <Widget>[
                      _image != null
                          ? Image.file(
                              _image,
                              height: height.toDouble(),
                              width: width.toDouble(),
                              fit: BoxFit.cover,
                            )
                          : Container(
                            child:    
                     Align(
                       alignment: Alignment.center,
                     child: Column(
                       children: <Widget>[
                         SizedBox(height: MediaQuery.of(context).size.height/4.5),
                         
                         new Container(
              height: MediaQuery.of(context).size.height / 3,
              child: SvgPicture.asset('assets/emptyBox.svg'),
            
            ),

            new Text('Upload Image', style: TextStyle(color: Colors.black, fontSize: 20),),
                         
                       ],
                     )
                     )
                          ),
                      Container(
                        child: GestureDetector(
                            onPanUpdate: (DragUpdateDetails details) {
                              setState(() {
                                RenderBox object = context.findRenderObject();
                                Offset _localPosition = object
                                    .globalToLocal(details.globalPosition);
                                _points = new List.from(_points)
                                  ..add(_localPosition);
                              });
                            },
                            onPanEnd: (DragEndDetails details) {
                              _points.add(null);
                            },
                            child: Signat()),
                      ),
                      Stack(
                        children: multiwidget.asMap().entries.map((f) {
                          return type[f.key] == 1
                              ? EmojiView(
                                  left: offsets[f.key].dx,
                                  top: offsets[f.key].dy,
                                  ontap: () {
                                    scaf.currentState
                                        .showBottomSheet((context) {
                                      return Sliders(
                                        size: f.key,
                                        sizevalue: fontsize[f.key].toDouble(),
                                      );
                                    });
                                  },
                                  onpanupdate: (details) {
                                    setState(() {
                                      offsets[f.key] = Offset(
                                          offsets[f.key].dx + details.delta.dx,
                                          offsets[f.key].dy + details.delta.dy);
                                    });
                                  },
                                  // value: f.value.toString(),
                                  // value : "assets/background.png",
                                  // value: "assets/background.png",
                                 value: widget.groupLogo,
                                  fontsize: fontsize[f.key].toDouble(),
                                  align: TextAlign.center,
                                )
                              : type[f.key] == 2
                                  ? TextView(
                                      left: offsets[f.key].dx,
                                      top: offsets[f.key].dy,
                                      ontap: () {
                                        scaf.currentState
                                            .showBottomSheet((context) {
                                          return Sliders(
                                            size: f.key,
                                            sizevalue:
                                                fontsize[f.key].toDouble(),
                                          );
                                        });
                                      },
                                      onpanupdate: (details) {
                                        setState(() {
                                          offsets[f.key] = Offset(
                                              offsets[f.key].dx +
                                                  details.delta.dx,
                                              offsets[f.key].dy +
                                                  details.delta.dy);
                                        });
                                      },
                                      value: f.value.toString(),
                                      fontsize: fontsize[f.key].toDouble(),
                                      align: TextAlign.center,
                                    )
                                  : new Container();
                        }).toList(),
                      )
                    ],
                  )),
            ),
          ),
        ),
        ),
        bottomNavigationBar: openbottomsheet
            ? new Container()
            : Container(
                decoration: BoxDecoration(
                    color: widget.bottomBarColor,
                    boxShadow: [BoxShadow(blurRadius: 10.9)]),
                height: 70,
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                            BottomBarContainer(
                      icons: FontAwesomeIcons.smile,
                      ontap: () {
type.add(1);
                            fontsize.add(20);
                            offsets.add(Offset.zero);
                            multiwidget.add("😂");
                            howmuchwidgetis++;

                        // Future getemojis = showModalBottomSheet(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return Emojies();
                        //     });
                        // getemojis.then((value) {
                        //   print('value is check  ${value}');
                        //   if (value != null) {
                        //     type.add(1);
                        //     fontsize.add(20);
                        //     offsets.add(Offset.zero);
                        //     multiwidget.add("😂");
                        //     howmuchwidgetis++;
                        //   }
                        // });
                      },
                      title: 'Logo',
                    ),
                    // BottomBarContainer(
                    //   colors: widget.bottomBarColor,
                    //   icons: FontAwesomeIcons.brush,
                    //   ontap: () {
                    //     // raise the [showDialog] widget
                    //     showDialog(
                    //         context: context,
                    //         child: AlertDialog(
                    //           title: const Text('Pick a color!'),
                    //           content: SingleChildScrollView(
                    //             child: ColorPicker(
                    //               pickerColor: pickerColor,
                    //               onColorChanged: changeColor,
                    //               showLabel: true,
                    //               pickerAreaHeightPercent: 0.8,
                    //             ),
                    //           ),
                    //           actions: <Widget>[
                    //             FlatButton(
                    //               child: const Text('Got it'),
                    //               onPressed: () {
                    //                 setState(() => currentColor = pickerColor);
                    //                 Navigator.of(context).pop();
                    //               },
                    //             ),
                    //           ],
                    //         ));
                    //   },
                    //   title: 'Brush',
                    // ),
                    BottomBarContainer(
                      icons: Icons.text_fields,
                      ontap: () async {
                        final value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TextEditor()));
                        if (value.toString().isEmpty) {
                          print("true");
                        } else {
                          type.add(2);
                          fontsize.add(20);
                          offsets.add(Offset.zero);
                          multiwidget.add(value);
                          howmuchwidgetis++;
                        }
                      },
                      title: 'Text',
                    ),
                    BottomBarContainer(
                      icons: FontAwesomeIcons.eraser,
                      ontap: () {
                        _controller.clear();
                        type.clear();
                        fontsize.clear();
                        offsets.clear();
                        multiwidget.clear();
                        howmuchwidgetis = 0;
                      },
                      title: 'Eraser',
                    ),
                    BottomBarContainer(
                      icons: Icons.photo,
                      ontap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ColorPiskersSlider();
                            });
                      },
                      title: 'Filter',
                    ),
                    BottomBarContainer(
                      icons: FontAwesomeIcons.smile,
                      ontap: () async {
                        type.add(1);
                          fontsize.add(20);
                          offsets.add(Offset.zero);
                          multiwidget.add("wowddx");
                          howmuchwidgetis++;
                        // final value = await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => TextEditor()));
                        // if (value.toString().isEmpty) {
                        //   print("true");
                        // } else {
                        //   type.add(2);
                        //   fontsize.add(20);
                        //   offsets.add(Offset.zero);
                        //   multiwidget.add("wow");
                        //   howmuchwidgetis++;
                        // }
                      },
                      title: 'Logo',
                    ),
//                     BottomBarContainer(
//                       icons: FontAwesomeIcons.smile,
//                       ontap: () {
//                         print('i was touched');
// // type.add(1);
// //                             fontsize.add(20);
// //                             offsets.add(Offset.zero);
// //                             multiwidget.add("😂");
// //                             howmuchwidgetis++;

//                         Future getemojis = showModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return Emojies();
//                             });
//                         getemojis.then((value) {
//                           print('value is check  ${value}');
//                           if (value != null) {
//                             type.add(1);
//                             fontsize.add(20);
//                             offsets.add(Offset.zero);
//                             multiwidget.add("😂");
//                             howmuchwidgetis++;
//                           }
//                         });
//                       },
//                       title: 'Logo',
//                     ),
                  ],
                ),
              ));
  }
 void _showBasicsFlash({
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

 
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {
    return //SIGNATURE CANVAS
        //SIGNATURE CANVAS
        ListView(
      children: <Widget>[
        Signature(
            controller: _controller,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}

class Sliders extends StatefulWidget {
  final int size;
  final sizevalue;
  const Sliders({Key key, this.size, this.sizevalue}) : super(key: key);
  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    slider = widget.sizevalue;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Text("Slider Size"),
            ),
            Divider(
              height: 1,
            ),
            new Slider(
                value: slider,
                min: 0.0,
                max: 100.0,
                onChangeEnd: (v) {
                  setState(() {
                    fontsize[widget.size] = v.toInt();
                  });
                },
                onChanged: (v) {
                  setState(() {
                    slider = v;
                    print(v.toInt());
                    fontsize[widget.size] = v.toInt();
                  });
                }),
          ],
        ));
  }
}

class ColorPiskersSlider extends StatefulWidget {
  @override
  _ColorPiskersSliderState createState() => _ColorPiskersSliderState();
}

class _ColorPiskersSliderState extends State<ColorPiskersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 260,
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Text("Slider Filter Color"),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(height: 20),
          new Text("Slider Color"),
          SizedBox(height: 10),
          BarColorPicker(
              width: 300,
              thumbColor: Colors.white,
              cornerRadius: 10,
              pickMode: PickMode.Color,
              colorListener: (int value) {
                setState(() {
                  //  currentColor = Color(value);
                });
              }),
          SizedBox(height: 20),
          new Text("Slider Opicity"),
          SizedBox(height: 10),
          Slider(value: 0.1, min: 0.0, max: 1.0, onChanged: (v) {})
        ],
      ),
    );
  }
}
