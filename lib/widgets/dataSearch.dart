import 'package:notification/pages/myHomePageTest.dart';
import 'package:notification/util/state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

// import 'user.dart';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../bid365_app_theme.dart';

 
class AutoCompleteDemo extends StatefulWidget {
  AutoCompleteDemo() : super();
 

  final String title = "Select Preferred Location to play";
 
  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
  
}
 
class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User1>> key = new GlobalKey();
  static List<User1> users = new List<User1>();
  bool loading = true;
   String dropdownValue = 'Andhra Pradesh';
  
 
 
  void getUsers(selState) async {
    try {
      final response =
          await http.post("https://us-central1-teamplayers-f3b25.cloudfunctions.net/citiesList",body:{"state": selState});
      if (response.statusCode == 200) {
        print('data value  ${response.body}');
        
        users = loadUsers(response.body);
        print('Users: ${users.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }
 
  static List<User1> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User1>((json) => User1.fromJson(json)).toList();
  }
 
  @override
  void initState() {
    getUsers('Andhra Pradesh');
    super.initState();
  }
 Widget listRow(User1 user){
   return Row(
         children: <Widget>[
                          Container(
                            width: 0,
                                height: 40,
                            padding: EdgeInsets.only(left: 16),
                            child: Icon(Icons.location_city)
   ),

   Expanded(
     child: Container(
       padding: EdgeInsets.only(left: 8),
       child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
               Text(user.name,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
               Text(user.hoName,style: TextStyle(color: Colors.black),),
             ],
           ),
     ),
   )
   
   ]);
 }
  Widget cityRow(User1 user) {
   return  ListTile(
        leading: Icon(Icons.location_city),
        // title: RichText(text: 
        //  TextSpan(
        //   text: user.name.substring(0,searchTextField.textField.controller.text.length),
        //   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //   children: [TextSpan(
        //     text:user.name.substring(searchTextField.textField.controller.text.length),
        //     style: TextStyle(color:Colors.grey)
            
        //   )]
          
        //    ),
       title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
           Text(user.name,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
           Text(user.hoName,style: TextStyle(color: Colors.black),),
         ],
       ),
          
      );
      

  }
 
  @override
  Widget build(BuildContext context) {
    return 
  Scaffold(
      appBar: AppBar(
        backgroundColor: Bid365AppTheme.nearlyGreen,
        automaticallyImplyLeading: false,
        title: Text(widget.title, style: Bid365AppTheme.subtitle,),
        actions: <Widget>[
                IconButton(icon: Icon(Icons.clear), onPressed: (){
       Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
          builder: (BuildContext context)
                      => HomePageTest(),
        ),(Route<dynamic> route) => false);
      })
        ],
      ),
      body:
       Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height:50),
    
              //  Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Text("Select State",
              //             style:
              //                 TextStyle(color: Colors.black, fontSize: 12.0)),
              //         Container(
              //             padding: EdgeInsets.symmetric(horizontal: 16.0),
              //             height: 40,
              //             width: double.maxFinite,
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(8.0),
              //                 color: Colors.grey[300],
              //                 border:
              //                     Border.all(color: Colors.grey, width: 1.0)),
              //             child: _buildDropdown())
              //       ],
              //     ),
              //  ),
                _buildGenderPickerDemo(context),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              
              child: loading
                  ? CircularProgressIndicator(backgroundColor: Colors.black,)
                  : searchTextField = AutoCompleteTextField<User1>(
                      key: key,
                      clearOnSubmit: false,
                      suggestions: users,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      decoration: InputDecoration(
                        
                        contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                        hintText: "Pick a location to play",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      itemFilter: (item, query) {
                        return item.name
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      },
                      itemSorter: (a, b) {
                        return a.name.compareTo(b.name);
                      },
                      itemSubmitted: (item)  {
                        setState(() {
                          searchTextField.textField.controller.text = item.name;
                          
                        });
                  
                        //      print('test ${StateWidget.of(context).state.locationId}');
                         _userLocationUpdate(locationName: searchTextField.textField.controller.text, locatonId: item.id, soId:item.soId, soName: item.soName, hoId: item.hoId, hoName: item.hoName, context: context, );
                        // print("searchTextField.textField.controller.text ${searchTextField.textField.controller.text} ${item.id}");
                      },
                      itemBuilder: (context, item) {
                        // ui for the autocompelete row
                      
                        // return cityRow(item);
                        return listRow(item);
                      },
                    ),
            ),
          ),
                  Container(
                                                        height: 45,
                                                        padding:
                                                            EdgeInsets.only(left: 50, right: 50, bottom: 8),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Flexible(
                                                              child: Container(
                                                                decoration: new BoxDecoration(
                                                                  color:Color(0xff03f585),
                                                                  borderRadius: new BorderRadius.circular(1.0),
                                                                  // boxShadow: <BoxShadow>[
                                                                  //   BoxShadow(
                                                                  //       color: Colors.black.withOpacity(0.5),
                                                                  //       offset: Offset(0, 1),
                                                                  //       blurRadius: 5.0),
                                                                  // ],
                                                                ),
                                                                child: Material(
                                                                  color: Colors.transparent,
                                                                  child: InkWell(
                                                                    borderRadius:
                                                                        new BorderRadius.circular(4.0),
                                                                    onTap: () async {
                                                        await  Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
          builder: (BuildContext context)
                      => HomePageTest(),
        ),(Route<dynamic> route) => false);
                                                                       
                                                                      // Navigator.pop(context);
                                                                    },
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Save Location',
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.white,
                                                                          fontSize: 12.0,
                                                                        ),
                                                                      ),
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
    
    );
  } 
    var genderList = ['Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jammu and Kashmir', 'Jharkhand','Karnataka','Kerala', 'Madya Pradesh', 'Maharashtra', 'Manipur','Meghalaya','Mizoram', 'Nagaland', 'Orissa','Punjab','Rajasthan', 'Sikkim','Tamil Nadu', 'Telagana', 'Tripura', 'Uttaranchal', 'Uttar Pradesh', 'West Bengal', 'Andaman and Nicobar Islands', 'Chandigarh', 'Dadar and Nagar Haveli', 'Daman and Diu', 'Delhi', 'Lakshadeep', 'Pondicherry'];
  var selectedGender = 'male';
  var genderListIndex = 0;
  Widget _buildGenderPickerDemo(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: genderListIndex);
    return Container(
      child: InkWell(
        onTap: () async {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoPicker(
                  scrollController: scrollController,
                  itemExtent: 44,
                  backgroundColor: CupertinoColors.white,
                  onSelectedItemChanged: (int index) {
                    print('this is triggered1');
                    setState(() => genderListIndex = index);
                  },
                  children:
                      List<Widget>.generate(genderList.length, (int index) {
                    return Center(
                      child: Text(genderList[index][0].toUpperCase() +
                          genderList[index].substring(1).toLowerCase()),
                    );
                  }),
                ),
              );
            },
          ).then((t) {
            print('this is triggered ${genderList[genderListIndex]}');
            setState(() {
          loading = true;
        });
            getUsers(genderList[genderListIndex]);
            selectedGender = genderList[genderListIndex];
          });
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Icon(
                FontAwesomeIcons.male,
                color: Color(0xff8C8C8C),
                size: 24,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Select State',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff8C8C8C),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        genderList[genderListIndex][0].toUpperCase() +
                            genderList[genderListIndex]
                                .substring(1)
                                .toLowerCase(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Container(
                        height: 1.2,
                        color: Color(0xff8C8C8C),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
    Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 216.0,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: SafeArea(
          top: false,
          child: picker,
        ),
      ),
    );
  }
    void _userLocationUpdate(
      {String locationName, String locatonId,String soId, String soName, String hoId, String hoName,  BuildContext context})  {
        try{
             StateWidget.of(context).userLocation(locationName, locatonId,soId, soName, hoId, hoName);
        }catch (e) {
           print("locatin set error: $e");
        }
      }

      _buildDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
      icon: Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(81, 41, 161, 1)),
      iconSize: 16.0,
//                          isDense: true,
      style: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jammu and Kashmir', 'Jharkhand','Karnataka','Kerala', 'Madya Pradesh', 'Maharashtra', 'Manipur','Meghalaya','Mizoram', 'Nagaland', 'Orissa','Punjab','Rajasthan', 'Sikkim','Tamil Nadu', 'Telagana', 'Tripura', 'Uttaranchal', 'Uttar Pradesh', 'West Bengal', 'Andaman and Nicobar Islands', 'Chandigarh', 'Dadar and Nagar Haveli', 'Daman and Diu', 'Delhi', 'Lakshadeep', 'Pondicherry'] 
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(child: Text(value), value: value);
      }).toList(),
    );
  }

}

class User1 {

  // int id, soId, hoId;
  String name, soName, hoName, category, id, soId, hoId;
  String email;
 
  User1({this.id, this.name, this.email, this.category, this.soId, this.hoId, this.soName, this.hoName});
 
  factory User1.fromJson(Map<String, dynamic> parsedJson) {
    return User1(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
      soId: parsedJson["soId"],
      hoId:parsedJson["hoId"],
      soName:parsedJson["soName"] as String,
      hoName:parsedJson["hoName"] as String,
      email: parsedJson["email"] as String,
    );
  }
}
