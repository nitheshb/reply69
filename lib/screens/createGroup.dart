import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notification/Animation/FadeAnimation.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/screens/main_screen.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/loading.dart';
import 'package:path/path.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroupProfile extends StatefulWidget {
  final String primaryButtonRoute;
  List followingGroupsLocal;

  CreateGroupProfile({
    @required this.primaryButtonRoute,
    this.followingGroupsLocal,
  });

  @override
  _CreateGroupProfileState createState() => _CreateGroupProfileState();
}

class _CreateGroupProfileState extends State<CreateGroupProfile> {
  StateModel appState;
  static Random random = Random();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _groupTitle = new TextEditingController();

  final TextEditingController _groupCategory = new TextEditingController();
  final TextEditingController _paymentScreenshotPhoneNo =
      new TextEditingController();
  final TextEditingController _premium = new TextEditingController();
  final TextEditingController _premiumPrice1 = new TextEditingController();

  // we are not using below two lines controllers
  //final TextEditingController _premiumPrice2 = new TextEditingController();
  //final TextEditingController _premiumPrice3 = new TextEditingController();

  final TextEditingController _premiumDays1 = new TextEditingController();
  final TextEditingController _premiumDays2 = new TextEditingController();
  final TextEditingController _premiumDays3 = new TextEditingController();

  File _image;
  bool _autoValidate = false;

  bool _loadingVisible = false;
  bool configImageCompression = true;
  List selCategoryValue = [];
  String groupNameAlreadyExists;
  String str_validatefess, str_validatedays, str_validate_phoneno;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  List categoryArray = [
    'Baseball',
    'Basketball',
    'Cricket',
    'FootBall',
    'Kabaddi'
  ];
  String _selected;
  List<Map> _myJson = [
    {
      "id": '1',
      "image": "assets/banks/affinbank.png",
      "name": "Andhra Pradesh"
    },
    {
      "id": '2',
      "image": "assets/banks/ambank.png",
      "name": "Arunachal Pradesh"
    },
    {"id": '3', "image": "assets/banks/bankislam.png", "name": "Assam"},
    {"id": '4', "image": "assets/banks/bankrakyat.png", "name": "Bihar"},
    {"id": '5', "image": "assets/banks/bsn.png", "name": "Chhattisgarh"},
    {"id": '6', "image": "assets/banks/cimb.png", "name": "Goa"},
    {
      "id": '7',
      "image": "assets/banks/hong-leong-connect.png",
      "name": "Gujarat"
    },
    {"id": '8', "image": "assets/banks/hsbc.png", "name": "Haryana"},
    {
      "id": '9',
      "image": "assets/banks/maybank.png",
      "name": "Himachal Pradesh"
    },
    {
      "id": '10',
      "image": "assets/banks/public-bank.png",
      "name": "Jammu and Kashmir"
    },
    {"id": '11', "image": "assets/banks/rhb-now.png", "name": "Jharkhand"},
    {
      "id": '12',
      "image": "assets/banks/standardchartered.png",
      "name": "Karnataka"
    },
    {"id": '13', "image": "assets/banks/uob.png", "name": "Kerala"},
    {"id": '14', "image": "assets/banks/ocbc.png", "name": "Madya Pradesh"},
    {"id": '15', "image": "assets/banks/ocbc.png", "name": "Maharashtra"},
    {"id": '16', "image": "assets/banks/ocbc.png", "name": "Manipur"},
    {"id": '17', "image": "assets/banks/ocbc.png", "name": "Meghalaya"},
    {"id": '18', "image": "assets/banks/ocbc.png", "name": "Mizoram"},
    {"id": '19', "image": "assets/banks/ocbc.png", "name": "Nagaland"},
    {"id": '20', "image": "assets/banks/ocbc.png", "name": "Orissa"},
    {"id": '21', "image": "assets/banks/ocbc.png", "name": "Punjab"},
    {"id": '22', "image": "assets/banks/ocbc.png", "name": "Sikkim"},
    {"id": '23', "image": "assets/banks/ocbc.png", "name": "Tamil Nadu"},
    {"id": '24', "image": "assets/banks/ocbc.png", "name": "Telagana"},
    {"id": '25', "image": "assets/banks/ocbc.png", "name": "Tripura"},
    {"id": '26', "image": "assets/banks/ocbc.png", "name": "Uttaranchal"},
    {"id": '27', "image": "assets/banks/ocbc.png", "name": "West Bengal"},
    {
      "id": '28',
      "image": "assets/banks/ocbc.png",
      "name": "Andaman and Nicobar Islands"
    },
    {"id": '29', "image": "assets/banks/ocbc.png", "name": "Chandigarh"},
    {
      "id": '30',
      "image": "assets/banks/ocbc.png",
      "name": "Dadar and Nagar Haveli"
    },
    {"id": '31', "image": "assets/banks/ocbc.png", "name": "Delhi"},
    {"id": '32', "image": "assets/banks/ocbc.png", "name": "Lakshadeep"},
    {"id": '33', "image": "assets/banks/ocbc.png", "name": "Pondicherry"},
  ];

  void _showBasicsFlash({
    Duration duration,
    flashStyle = FlashStyle.floating,
    BuildContext context,
    String messageText,
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

  void _showBottomFlash(
      {bool persistent = true,
      EdgeInsets margin = EdgeInsets.zero,
      BuildContext context}) {
    showFlash(
      context: context,
      persistent: persistent,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          margin: margin,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Colors.blue,
          boxShadows: kElevationToShadow[8],
          backgroundGradient: RadialGradient(
            colors: [Colors.amber, Colors.black87],
            center: Alignment.topLeft,
            radius: 2,
          ),
          onTap: () => controller.dismiss(),
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: FlashBar(
              title: Text('Hello Flash'),
              message: Text('You can put any message of any length here.'),
              leftBarIndicatorColor: Colors.red,
              icon: Icon(Icons.info_outline),
              primaryAction: FlatButton(
                onPressed: () => controller.dismiss(),
                child: Text('DISMISS'),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => controller.dismiss('Yes, I do!'),
                    child: Text('YES')),
                FlatButton(
                    onPressed: () => controller.dismiss('No, I do not!'),
                    child: Text('NO')),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      return;
    });
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    // caseNumber.length > 9 ? 9: caseNumber.length;
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    appState = StateWidget.of(context).state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    final firstName = appState.user?.firstName ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingScreen(
        inAsyncCall: _loadingVisible,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // SizedBox(height: 60),

                // Text(
                //   '${email}',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 22,
                //   ),
                // ),
                SizedBox(height: 80),
                Text(
                  "Are you a fantasy sports expert ?",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Create Group Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Color(0xff3A4276),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10),

                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Container(
                    height: 650,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(height: 5),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: <Widget>[
                                    FadeAnimation(
                                      1.2,
                                      makeUserNameField(
                                          label: "Group Name",
                                          obscureText: false),
                                    ),
                                    FadeAnimation(1.3, groupPicUpload()),
                                    SizedBox(height: 10),
                                    FadeAnimation(
                                        1.3, groupCategoryFieldCustomField()),
                                    SizedBox(height: 10),
                                    FadeAnimation(
                                        1.3, premiumGroupToggle(context)),
                                    SizedBox(height: 10),
                                    // FadeAnimation(1.3, makeCagegoryField(label: "Group Category", obscureText: false)),
//  premium

                                    Visibility(
                                      visible: configImageCompression,
                                      child: Column(
                                        children: <Widget>[
                                          FadeAnimation(
                                            1.3,
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: FadeAnimation(
                                                    1.3,
                                                    makePremiumPrice(
                                                        label: "VIP Join Fee",
                                                        obscureText: false),
                                                  ),
                                                ),
                                                SizedBox(width: 30),
                                                Expanded(
                                                  flex: 3,
                                                  child: FadeAnimation(
                                                    1.3,
                                                    makePremiumDays(
                                                        label: "Valid Days",
                                                        obscureText: false),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          FadeAnimation(
                                              1.3,
                                              makePremiumField(
                                                  label:
                                                      "Phone pe or Google Pay Number",
                                                  obscureText: false)),

                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          //   children: <Widget>[
                                          //     FadeAnimation(1.2, makePremiumPrice(label: "Premium Price", obscureText: false, controlValue: _premiumPrice1),),
                                          //      FadeAnimation(1.2, makePremiumDays(label: "Days", obscureText: false, controlValue: _premiumDays1),),
                                          //   ],
                                          // ),
                                          FadeAnimation(1.3, stateSelection()),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 30),

                                    InkWell(
                                      onTap: () async {
                                        Pattern pattern = '[@#^%&]';
                                        RegExp regex = new RegExp(pattern);
                                        String checklen =
                                            _groupTitle.toString();
                                        if (!(checklen.length >= 3)) {
                                          setState(() {
                                            this.groupNameAlreadyExists =
                                                "enter Name";
                                          });
                                        } else {
                                          if (regex.hasMatch(_groupTitle.text))
                                            setState(() {
                                              this.groupNameAlreadyExists =
                                                  'Please enter Alphanumeric Name.';
                                            });
                                          else {
                                            String groupTitle = _groupTitle.text
                                                .toLowerCase()
                                                .replaceAll(
                                                    new RegExp(r"\s+"), "");
                                            var UserNameData =
                                                await FirebaseController
                                                    .instanace
                                                    .searchIfGroupAlreadyExists(
                                                        groupTitle);
                                            setState(() {
                                              this.groupNameAlreadyExists =
                                                  UserNameData.documents
                                                              .length >
                                                          0
                                                      ? 'Group Name Already Taken'
                                                      : null;
                                            });
                                          }
                                        }

                                        if (_image == null) {
                                          _showBasicsFlash(
                                              context: context,
                                              duration: Duration(seconds: 3),
                                              messageText:
                                                  'Please upload group DP ...!');
                                          // _showBottomFlash(context:  context);
                                          //  Flushbar(
                                          //             title:  "Hey Ninja",
                                          //             message:  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                                          //             duration:  Duration(seconds: 3),
                                          //           )..show(context);
                                          return;
                                        }

                                        if (_formKey.currentState.validate()) {
                                          //  the below save line is to trigger the save of multi select category

                                          //
                                          try {
                                            // data name split

                                            await _changeLoadingVisible();
                                            _formKey.currentState.save();

                                            String fileName =
                                                basename(_image.path);
                                            DateTime now = new DateTime.now();
                                            StorageReference
                                                firebaseStorageRef =
                                                FirebaseStorage.instance
                                                    .ref()
                                                    .child(
                                                        "${userId}${now.millisecondsSinceEpoch}.jpg");
                                            StorageUploadTask uploadTask =
                                                firebaseStorageRef
                                                    .putFile(_image);
                                            var dowurl = await (await uploadTask
                                                    .onComplete)
                                                .ref
                                                .getDownloadURL();
                                            String ImageUrl = dowurl.toString();
                                            setState(() {
                                              // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
                                            });
                                            String groupTitle = _groupTitle.text
                                                .toLowerCase()
                                                .replaceAll(
                                                    new RegExp(r"\s+"), "");
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            String userToken =
                                                prefs.get('FCMToken');
                                            //TODO: Implement sign out
                                            var body = {
                                              "title": groupTitle,
                                              "createdBy": userId,
                                              "createdOn": new DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              "category": selCategoryValue,
                                              "groupType":
                                                  configImageCompression,
                                              "members": [],
                                              "messages": [],
                                              "followers": ['${userId}'],
                                              "color": '',
                                              "logo": ImageUrl,
                                              "paymentNo":
                                                  _paymentScreenshotPhoneNo
                                                      .text,
                                              "state": _selected,
                                              "FeeDetails": [
                                                {
                                                  "fee": _premiumPrice1.text,
                                                  "days": _premiumDays1.text
                                                }
                                              ],
                                              "caseSearch":
                                                  setSearchParam(groupTitle),
                                              "AlldevicesTokens": [],
                                              "FdeviceToken": [],
                                            };

                                            Map searchGroupBody = {
                                              "title": groupTitle,
                                              "ownerName": firstName,
                                              "createdBy": userId,
                                              "category": selCategoryValue,
                                              "groupType":
                                                  configImageCompression,
                                              "logo": ImageUrl,
                                              "paymentNo":
                                                  _paymentScreenshotPhoneNo
                                                      .text,
                                              "FeeDetails": [
                                                {
                                                  "fee": _premiumPrice1.text,
                                                  "days": _premiumDays1.text
                                                }
                                              ],
                                            };
                                            if (widget.followingGroupsLocal
                                                    .length <
                                                9) {
                                              var check1 = await FirebaseController
                                                  .instanace
                                                  .createGroup(
                                                      body,
                                                      userId,
                                                      searchGroupBody,
                                                      groupTitle,
                                                      firstName,
                                                      selCategoryValue,
                                                      configImageCompression,
                                                      ImageUrl,
                                                      _paymentScreenshotPhoneNo
                                                          .text,
                                                      _premiumPrice1.text,
                                                      _premiumDays1.text);

                                              await widget.followingGroupsLocal
                                                  .add(check1.documentID);
                                              await StateWidget.of(context)
                                                  .setFollowingGroupState(
                                                      widget
                                                          .followingGroupsLocal,
                                                      check1.documentID,
                                                      'add');
                                              await Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MainScreen(
                                                                userId: userId,
                                                                followingGroupsLocal:
                                                                    widget
                                                                        .followingGroupsLocal),
                                                      ),
                                                      (Route<dynamic> route) =>
                                                          false);

                                              return;
                                            } else {
                                              _showBasicsFlash(
                                                  context: context,
                                                  duration:
                                                      Duration(seconds: 4),
                                                  messageText:
                                                      'Cannot Create Group ');
                                            }
                                          } catch (e) {
                                            _changeLoadingVisible();
                                            _showBasicsFlash(
                                                context: context,
                                                duration: Duration(seconds: 4),
                                                messageText: 'Error $e ');
                                          }
                                        } else {
                                          setState(() => _autoValidate = true);
                                        }
                                      },
                                      child: Container(
                                        height: 65,
                                        // width: 100,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xff0072ff),
                                              Color(0xff00d4ff),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.topRight,
                                          ),
                                          // color: isFollow ? Colors.grey :Colors.blueAccent,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(6),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Create Group",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )

                // SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String title) {
    return Column(
      children: <Widget>[
        Text(
          random.nextInt(10000).toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(),
        ),
      ],
    );
  }

  // new data

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  ConfigValueChanged(value) async {
    setState(() {
      configImageCompression = value;
    });
  }

  Widget premiumGroupToggle(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Icon(
            //   Icons.photo_size_select_small,
            //   size: 15,
            // ),

            Text('Prime Group Details',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ],
    );
  }

  Widget groupCategoryFieldCustomField() {
    return FadeAnimation(
      1.3,
      MultiSelect(
          autovalidate: false,
          titleText: "Group Category",
          validator: (value) {
            if (value == null) {
              return 'Please select one or more option(s)';
            }
          },
          errorText: 'Please select one or more option(s)',
          dataSource: [
            {
              "display": "Baseball",
              "value": 0,
            },
            {
              "display": "Basketball",
              "value": 1,
            },
            {
              "display": "Cricket",
              "value": 2,
            },
            {
              "display": "FootBall",
              "value": 3,
            },
            {
              "display": "Kabaddi",
              "value": 4,
            }
          ],
          textField: 'display',
          valueField: 'value',
          filterable: true,
          required: true,
          value: null,
          onSaved: (value) {
            for (var x in value) {
              // print('cateog ${categoryArray[x]}');
              selCategoryValue
                  .add({'categoryName': categoryArray[x], 'rating': 20});
            }
            // selCategoryValue = value;
          }),
    );
  }

  Widget stateSelection() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isDense: true,
                    hint: new Text(
                      "Select State",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xff3A4276),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    value: _selected,
                    onChanged: (String newValue) {
                      setState(() {
                        _selected = newValue;
                      });
                    },
                    items: _myJson.map((Map map) {
                      return new DropdownMenuItem<String>(
                        value: map["id"].toString(),
                        // value: _mySelection,
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(map["name"])),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeCagegoryField({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          autofocus: false,
          controller: _groupCategory,
          // validator: Validator.validatePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  // by - Padmanabh wattamwar
  // below widget for phone pe / g pay phone no (previous dev wrote wrong name)
  Widget makePremiumField({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          autofocus: false,
          keyboardType: TextInputType.number,
          controller: _paymentScreenshotPhoneNo,
          // validator: Validator.validatePassword,
          validator: (String value) {
            int val;
            if (!(value.isEmpty)) val = int.tryParse(value);
            Pattern pattern = '[.,]';
            RegExp regex = new RegExp(pattern);
            String retstatemnt;
            if (value.isEmpty) {
              retstatemnt = 'Enter Phone Number';
            } else if (regex.hasMatch(value)) {
              retstatemnt = 'Enter only Numbers';
            } else if (val.toString().length > 10 ||
                val.toString().length < 10) {
              retstatemnt = 'Enter Valid phone Number';
            }

            return retstatemnt;
          },

          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget makePremiumPrice({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          autofocus: false,
          controller: _premiumPrice1,
          keyboardType: TextInputType.number,
          // validator: Validator.validatePassword,
          validator: (String value) {
            int val;
            if (!(value.isEmpty)) val = int.tryParse(value);
            Pattern pattern = '[.,]';
            RegExp regex = new RegExp(pattern);

            String retstatemnt;
            if (value.isEmpty) {
              retstatemnt = 'Enter Fess';
            } else if (regex.hasMatch(value)) {
              retstatemnt = 'Enter only Numbers';
            } else if (!(val >= 0)) {
              retstatemnt = 'Enter postivie fees';
            }
            return retstatemnt;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget makePremiumDays({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          autofocus: true,
          keyboardType: TextInputType.number,
          controller: _premiumDays1,
          validator: (String value) {
            int val;
            if (!(value.isEmpty)) val = int.parse(value);
            Pattern pattern = '[.,]';
            RegExp regex = new RegExp(pattern);
            String retstatemnt;
            if (value.isEmpty) {
              retstatemnt = 'Enter Days';
            } else if (regex.hasMatch(value)) {
              retstatemnt = 'Enter only Numbers';
            } else if (!(val >= 0)) {
              retstatemnt = 'Enter postivie Days';
            }
            return retstatemnt;
          },
          // validator: Validator.validatePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget groupPicUpload() {
    return Container(
      child: InkWell(
        onTap: () {
          getImage();
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), color: Color(0xffF1F3F6)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: new SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: (_image != null)
                          ? Image.file(
                              _image,
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              "https://www.iconfinder.com/data/icons/hawcons/32/698394-icon-130-cloud-upload-512.png",
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 4.0),
                    Text(
                      "Upload group profile picture",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Color(0xff3A4276),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeUserNameField({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Color(0xff3A4276),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          obscureText: obscureText,
          controller: _groupTitle,
          // validator: Validator.validateGroupName,
          validator: (value) {
            // print("the value is  $value");
            return groupNameAlreadyExists;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 4)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
