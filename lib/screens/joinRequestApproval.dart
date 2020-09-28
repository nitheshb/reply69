import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/util/data.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:notification/widgets/post_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bid365_app_theme.dart';

class JoinRequestApproval extends StatefulWidget {
      JoinRequestApproval({Key key, this.chatId, this.groupName}) : super(key: key);
      final String chatId, groupName;
  @override
  _JoinRequestApprovalState createState() => _JoinRequestApprovalState();
}

class _JoinRequestApprovalState extends State<JoinRequestApproval>with SingleTickerProviderStateMixin,
    AutomaticKeepAliveClientMixin {
   TabController _tabController;
   StateModel appState;
  Dio dio = new Dio();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }


    updatePaymentRequestStatus(kycDocId,userId,chatId,status, period,phoneNumber, firstName) async{

      DateTime d = Jiffy().add(days: 30);
      print('pancard hellooc ${d}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
  //     // chatgroupid, userId, status, duration, time, 
  //     print('i was at pancard, ${kycDocId}');
      if(status=="Rejected"){
            var now = new DateTime.now();
                        var modifiedDate =  now.add(Duration(days: 30));
        FirebaseController.instanace.rejectKycDoc(kycDocId,modifiedDate, period, userId, chatId);
        try {
          var response = await dio.get("https://asia-south1-royalpro.cloudfunctions.net/onMembershipRejected?id=${userId}&chatId=${chatId}&groupName=${widget.groupName}");
                  
                  print('remove was clicked  ${response}');
      } catch (e) {
        print('error is ${e}');
      }
   
        
      }
   else if(status == 'Approved'){
      var now = new DateTime.now();
                        var modifiedDate =  now.add(Duration(days: 30));
                         FirebaseController.instanace.approveKycDoc(kycDocId,modifiedDate, period, userId, chatId,userToken, phoneNumber, firstName);
try {
          var response = await dio.get("https://asia-south1-royalpro.cloudfunctions.net/onMemberAdd?id=$userId&chatId=${chatId}&groupName=${widget.groupName}");
                  
                  print('add was clicked  ${response}');
      } catch (e) {
        print('error is ${e}');
      }
   

    }
  }
  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    final phoneNumber = appState.user.phoneNumber;
    final firstName = appState.user.firstName;
    return Scaffold(
      appBar: AppBar(
        title: Text("Membership Requests", style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w800,
                )),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          isScrollable: false,
          labelStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color(0xff3A4276),
                    fontWeight: FontWeight.w600,
                  ),
          tabs: <Widget>[
            Tab(
              text: "New Payments",
            ),
            Tab(
              text: "Recent Approvals",
            ),
          ],
        ),
      ),

      body: 
      TabBarView(
        controller: _tabController,
        children: <Widget>[
          Column(
        children: <Widget>[
                Expanded(
                  child:StreamBuilder(
        stream:  FirebaseController.instanace.getKycDocsList(widget.chatId),
        builder: (context,snapshot){
                     if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
          if(snapshot.hasData  && snapshot.data.documents.length >0){
            print('--> ${snapshot.data.documents.length}');
              return  
              ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                var ds = snapshot.data.documents[index].data;
                var docId = snapshot.data.documents[index].documentID;
                print('doc id is : ${docId}');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                     decoration: BoxDecoration(
          color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 6,
                  spreadRadius: 10,
                )
              ],
        ),
                    child: Column(
                      children: <Widget>[
                        PostItem(
                          img: ds['pancardDocUrl'],
                          name: ds['firstName'],
                          uxId: ds['uxId'],
                          dp: "assets/cm${random.nextInt(10)}.jpeg",
                          time: ds['uploadedTime'],
                          messageMode: "paymentAccept",
                        ),
                           SizedBox(height: 15,),
                          //  duration buttons
      // action buttions
                      Container(
                        color: Colors.white,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                _buildCircularBtn(70.0, "assets/like.png", 3,() =>updatePaymentRequestStatus(snapshot.data.documents[index].documentID,ds['uid'],ds['chatId'],"Approved", 30, ds['phoneNumber']??  null, ds['firstName']??  null)),
              _buildCircularBtn(70.0, "assets/hate.png", 2,() =>updatePaymentRequestStatus(snapshot.data.documents[index].documentID,ds['uid'],ds['chatId'],"Rejected", "30days", ds['phoneNumber']??  null, ds['firstName']??  null)),
            
              
            ],
        ),
      ),
      SizedBox(height: 15,),
                      ],
                    ),
                  ),
                );
            //  return Container(
            //     child: Text('i ahve data'));
              });
                
                }
              return Text('No New Requests');
        }
                  )
                ),
                
        ],
      ),

      Container(child: Text("Recent logs")),
      ]),
  

    );
  }
   Widget _buildCircularBtn(double height, String img, int type, Function onTapFun) {
    double imageSize;

    if (type == 1 || type == 4) {
      imageSize = 25.0;
    } else {
      imageSize = 35.0;
    }

    return MaterialButton(
      color: type == 2 ? Colors.greenAccent : Colors.greenAccent,
      elevation: 0.0,
      onPressed: () {
        onTapFun();
        print('i was clicked');
      },
      height: 40,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)
                        ),
      child: Text("${type == 2 ? "Reject" : "Accept"}", style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                ),),
    );
  }
  Widget durationTag (){
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: true
                ? Bid365AppTheme.nearlyBlue
                : Bid365AppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: Bid365AppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                // categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  "30 Days",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: true
                        ? Bid365AppTheme.nearlyWhite
                        : Bid365AppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
