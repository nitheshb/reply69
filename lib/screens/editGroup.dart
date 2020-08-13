import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notification/Animation/FadeAnimation.dart';
import 'package:notification/screens/main_screen.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/loading.dart';
import 'package:path/path.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

class EditGroupProfile extends StatefulWidget {
  final String primaryButtonRoute, groupName,phNumber
  ;
  final List groupCategory;
  final fee, selState,
  expiryDays, chatId;
  String dp;
  
  EditGroupProfile(
      {
      @required this.primaryButtonRoute,
      this.groupName,
      this.groupCategory,
      this.fee,
      this.expiryDays,
      this.phNumber,
      this.selState,
      this.dp,
      this.chatId,
});
  @override
  _EditGroupProfileState createState() => _EditGroupProfileState();
}

class _EditGroupProfileState extends State<EditGroupProfile> {
  StateModel appState; 
  static Random random = Random();
  
     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _groupTitle = new TextEditingController();

  final TextEditingController _groupCategory = new TextEditingController();
 final TextEditingController _paymentScreenshotPhoneNo = new TextEditingController();
  final TextEditingController _premium = new TextEditingController();
    final TextEditingController _premiumPrice1 = new TextEditingController();
    final TextEditingController _premiumPrice2 = new TextEditingController();
     final TextEditingController _premiumPrice3 = new TextEditingController();

         final TextEditingController _premiumDays1 = new TextEditingController();
    final TextEditingController _premiumDays2 = new TextEditingController();
     final TextEditingController _premiumDays3 = new TextEditingController();
     

File _image;
  bool _autoValidate = false;

  bool _loadingVisible = false;
  bool configImageCompression = true;
  List selCategoryValue = [];
  String groupNameAlreadyExists;
  List PastCategory =[];

  void initState() {
    // TODO: implement initState
    super.initState();
    _groupTitle.text = widget.groupName;
    _premiumPrice1.text = widget.fee[0]['fee'];
    _premiumDays1.text = widget.fee[0]['days'];
    _paymentScreenshotPhoneNo.text = widget.phNumber;
    widget.groupCategory.map((data)=> {
      PastCategory.add(data['categoryName'])
      
    });
//  for(var x in widget.groupCategory){
//       print('cateog ${widget.groupCategory[x]}');
//       // PastCategory.add({'categoryName':categoryArray[x], 'rating': 20});
//     }

    print('check for fee ${widget.fee}');
  //   print('what was here ${widget.groupSportCategory}');
  // widget.groupSportCategory.forEach((data){
  //   print('values are ${data}');
  //       groupCategoriesArray.add(data['categoryName']);
    
    
  
  }

  Future getImage() async{
   var image =  await ImagePicker.pickImage(source: ImageSource.gallery);
   setState(() {
     _image = image;
     print('image path ${_image}');
   });
  }
  List categoryArray = ['Baseball', 'Basketball', 'Cricket', 'FootBall', 'Kabaddi'];  
  String _selected;
  List<Map> _myJson = [
    {"id": '1', "image": "assets/banks/affinbank.png", "name": "Andhra Pradesh"},
    {"id": '2', "image": "assets/banks/ambank.png", "name": "Arunachal Pradesh"},
    {"id": '3', "image": "assets/banks/bankislam.png", "name": "Assam"},
    {"id": '4', "image": "assets/banks/bankrakyat.png", "name": "Bihar"},
    {
      "id": '5',
      "image": "assets/banks/bsn.png",
      "name": "Chhattisgarh"
    },
    {"id": '6', "image": "assets/banks/cimb.png", "name": "Goa"},
    {
      "id": '7',
      "image": "assets/banks/hong-leong-connect.png",
      "name": "Gujarat"
    },
    {"id": '8', "image": "assets/banks/hsbc.png", "name": "Haryana"},
    {"id": '9', "image": "assets/banks/maybank.png", "name": "Himachal Pradesh"},
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
    {
      "id": '13',
      "image": "assets/banks/uob.png",
      "name": "Kerala"
    },
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
    {"id": '28', "image": "assets/banks/ocbc.png", "name": "Andaman and Nicobar Islands"},
    {"id": '29', "image": "assets/banks/ocbc.png", "name": "Chandigarh"},
    {"id": '30', "image": "assets/banks/ocbc.png", "name": "Dadar and Nagar Haveli"},
    {"id": '31', "image": "assets/banks/ocbc.png", "name": "Delhi"},
    {"id": '32', "image": "assets/banks/ocbc.png", "name": "Lakshadeep"},
    {"id": '33', "image": "assets/banks/ocbc.png", "name": "Pondicherry"},

  ];
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
  void _showBottomFlash(
      {bool persistent = true, EdgeInsets margin = EdgeInsets.zero, BuildContext context}) {
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
        appState = StateWidget.of(context).state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: (){},
          ),
        ],
      ),
      body: 
       LoadingScreen(
         inAsyncCall: _loadingVisible,
          child:SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Image.network(
                            "${widget.dp}",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  Padding(padding: EdgeInsets.only(top:60.0),
                  child: IconButton(icon: Icon(Icons.edit,),
                  onPressed: (){
                    getImage();
                  },
                  
                  ))
                ],
              ),
              SizedBox(height: 10),
              Text(
                '${widget.groupName.toUpperCase()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Editing Group Profile",
                style: TextStyle(
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        groupCategoryFieldCustomField(),
                        premiumGroupToggle(context),
                        // FadeAnimation(1.3, makeCagegoryField(label: "Group Category", obscureText: false)),
//  premium



                        Visibility(
                          visible: configImageCompression,
                          child: Column(
                            children: <Widget>[
                                                  
      FadeAnimation(1.3, Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: FadeAnimation(1.2, makePremiumPrice(label: "VIP Join Fee", obscureText: false, controlValue: _premiumPrice1),),
          ),
          SizedBox(width: 30),
          Expanded(
            flex: 3,
            child: FadeAnimation(1.2, makePremiumDays(label: "Valid Days", obscureText: false, controlValue: _premiumDays1),),
          ),
        ],
      ),
      ),
        SizedBox(height: 10),  
                              FadeAnimation(1.3, makePremiumField(label: "Phone pe or Google Pay Number", obscureText: false)),
                          

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: <Widget>[
                            //     FadeAnimation(1.2, makePremiumPrice(label: "Premium Price", obscureText: false, controlValue: _premiumPrice1),),
                            //      FadeAnimation(1.2, makePremiumDays(label: "Days", obscureText: false, controlValue: _premiumDays1),),
                            //   ],
                            // ),
                                                  // FadeAnimation(1.3,  stateSelection()
                         // ),

   
      
        ],
                          ),
                        ),

                        SizedBox(height: 10),
        FadeAnimation(1.4, Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () async{
                           
                           Pattern pattern = r'^.{1,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(_groupTitle.text))
             setState(() {      
                this.groupNameAlreadyExists = 'Please enter a name.';
              }); 
    else{
                        var UserNameData =  await Firestore.instance.collection('groups').where("title", isEqualTo: _groupTitle.text).getDocuments(); 
                        setState(() {      
                this.groupNameAlreadyExists = UserNameData.documents.length> 0 ?'Group Name Already Taken' : null; 
              });
    }

    if(_image == null && widget.dp == null){
      _showBasicsFlash(context:  context, duration: Duration(seconds: 2), messageText : 'Please upload group DP ...!');
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
                     try{   
                      // data name split
              
                   await    _changeLoadingVisible();
                     _formKey.currentState.save(); 
                     String ImageUrl; 
if(_image !=null){
    String fileName =  basename(_image.path);
     DateTime now = new DateTime.now();
       StorageReference firebaseStorageRef =   FirebaseStorage.instance.ref().child("${userId}${now.millisecondsSinceEpoch}.jpg");
       StorageUploadTask uploadTask =  firebaseStorageRef.putFile(_image);
           var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
     ImageUrl = dowurl.toString();
       setState(() {
          print("Profile Picture uploaded $fileName");
         // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
}
                        //TODO: Implement sign out
                              var body ={
                                          "editedOn": new DateTime.now().millisecondsSinceEpoch,
                                          "category": selCategoryValue,
                                          "logo": _image ==null ? "${widget.dp}" :ImageUrl,
                                          "paymentNo": _paymentScreenshotPhoneNo.text,
                                          "FeeDetails": [{"fee": _premiumPrice1.text, "days": _premiumDays1.text }],
                                        };

               await Firestore.instance.collection("groups").document("${widget.chatId}").updateData(body);
            
                 await Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
        builder: (BuildContext context)
        => MainScreen(userId: userId,),
        ),(Route<dynamic> route) => false);
                  
                     }catch (e) {
        _changeLoadingVisible();
        print("Create Group Creation Error: $e");
        //    Fluttertoast.showToast(
        // msg: "Sign In Error ${e}",
        //    );
        // Flushbar(
        //   title: "Sign In Error",
        //   message: exception,
        //   duration: Duration(seconds: 5),
        // )..show(context);
      }
                        }
                        else {
      setState(() => _autoValidate = true);
    }
                        },
                        color: Colors.blueAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Edit Group", style: TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 18,
                          color: Colors.white
                        ),),
                      ),
                    ),
                  )),
    
                            
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

  Widget _buildCategory(String title){
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
          style: TextStyle(
          ),
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
Widget premiumGroupToggle(context){
  return 
       Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // Icon(
                                    //   Icons.photo_size_select_small,
                                    //   size: 15,
                                    // ),
                                  
                                    Text(
                                      'Premium Group',
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: configImageCompression,
                                  onChanged: (value) => 
                                  ConfigValueChanged(value)
                                ),
                              ],
                            );
}
Widget groupCategoryFieldCustomField(){

  return    FadeAnimation(1.3, MultiSelect(
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
  value: PastCategory,
  onSaved: (value) {
    print('The value is $value');
    for(var x in value){
      // print('cateog ${categoryArray[x]}');
      selCategoryValue.add({'categoryName':categoryArray[x], 'rating': 20});
    }
      // selCategoryValue = value;
       print('category check  ${selCategoryValue}');

    
  }
),
                           );


}  



Widget makeCagegoryField({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          obscureText: obscureText,
               autofocus: false,
          controller: _groupCategory,
                            // validator: Validator.validatePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
 Widget makePremiumField({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          obscureText: obscureText,
               autofocus: false,
          controller: _paymentScreenshotPhoneNo,
                            // validator: Validator.validatePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
   Widget makePremiumPrice({label, obscureText = false, controlValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          obscureText: obscureText,
               autofocus: false,
          controller: controlValue,
                            // validator: Validator.validatePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
   Widget makePremiumDays({label, obscureText = false, controlValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          obscureText: obscureText,
               autofocus: false,
          controller: controlValue,
                            // validator: Validator.validatePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
  Widget makeUserNameField({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
           keyboardType: TextInputType.emailAddress,
          obscureText: obscureText,
          controller: _groupTitle,
          // validator: Validator.validateGroupName,
          validator:(value){
            return groupNameAlreadyExists;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
  
}
