import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/util/data.dart';
import 'package:notification/widgets/post_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bid365_app_theme.dart';

class JoinRequestApproval extends StatefulWidget {
      JoinRequestApproval({Key key, this.chatId}) : super(key: key);
      final String chatId;
  @override
  _JoinRequestApprovalState createState() => _JoinRequestApprovalState();
}

class _JoinRequestApprovalState extends State<JoinRequestApproval>with SingleTickerProviderStateMixin,
    AutomaticKeepAliveClientMixin {
   TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }


    updatePaymentRequestStatus(kycDocId,userId,chatId,status, period) async{
      DateTime d = Jiffy().add(days: 30);
      print('pancard hellooc ${d}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
  //     // chatgroupid, userId, status, duration, time, 
  //     print('i was at pancard, ${kycDocId}');
      if(status=="Rejected"){
        //  
        Firestore.instance.collection('KYC').document(kycDocId).updateData({'payment_approve_status': "Rejected",'rejectedOn': DateTime.now()});
         Firestore.instance.collection('IAM').document(userId).updateData({'rejectedGroups': FieldValue.arrayUnion([chatId]), 'rejectedGroupsJson': FieldValue.arrayUnion([chatId]),'WaitingGroups':FieldValue.arrayRemove([chatId])});
      
         Firestore.instance.collection('groups').document(chatId).updateData({'rejectedId': FieldValue.arrayUnion([userId]), 'rejectedIdJson': FieldValue.arrayUnion([userId]),'WaitingCount': 100});
        
      //  Firestore.instance.collection('Kyc').document(docId).updateData({'approve_status': "Rejected",'pancard_approve_status': value, 'pancard_review_by': userId});
      }
   else if(status == 'Approved'){
      var now = new DateTime.now();
                        var modifiedDate =  now.add(Duration(days: 30));
    // Firestore.instance.collection('Kyc').document(docId).updateData({'approve_status': "Approved",'pancard_approve_status': value, 'pancard_review_by': userId});
            Firestore.instance.collection('KYC').document(kycDocId).updateData({'payment_approve_status': "Approved",'ApprovedOn': DateTime.now(),'expiresOn':  modifiedDate,'membershipDuration': period, 'reviewBy': userId});
          Firestore.instance.collection('IAM').document(userId).updateData({'approvedGroups': FieldValue.arrayUnion([chatId]), 'approvedGroupsJson': FieldValue.arrayUnion([{'chatId':chatId,'kycDocId': kycDocId }]),'WaitingGroups':FieldValue.arrayRemove([chatId])});
              var groupUserBody = {'userId':userId, 'joinedId': DateTime.now(), 'expiresOn':  modifiedDate,'membershipDuration': period, 'kycDocId': kycDocId };
         Firestore.instance.collection('groups').document(chatId).updateData({'premiumMembers': FieldValue.arrayUnion([userId]),'approvedGroupsJson': FieldValue.arrayUnion([groupUserBody]),'FdeviceTokens': FieldValue.arrayUnion([userToken]),'AlldeviceTokens': FieldValue.arrayRemove([userToken]),'rejectedId': FieldValue.arrayRemove([userId])});
    }else{
       print('i was at inside disapproval pancard');
      // Firestore.instance.collection('Kyc').document(docId).updateData({'pancard_approve_status': value, 'pancard_review_by': userId});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MemberShip Requests"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          isScrollable: false,
          tabs: <Widget>[
            Tab(
              text: "New Requests",
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
        stream:  Firestore.instance.collection('KYC').where("chatId", isEqualTo: widget.chatId).where("payment_approve_status", isEqualTo: 'Review_Waiting').snapshots(),
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
                print('doc id is : ${ds['pancardDocUrl']}');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                     decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red, width: 0.2),
        ),
                    child: Column(
                      children: <Widget>[
                        PostItem(
                          img: ds['pancardDocUrl'],
                          name: ds['uid'],
                          dp: "assets/cm${random.nextInt(10)}.jpeg",
                          time: ds['uploadedTime'],
                        ),
                           SizedBox(height: 15,),
                          //  duration buttons
      // action buttions
                      Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCircularBtn(70.0, "assets/hate.png", 2,() =>updatePaymentRequestStatus(snapshot.data.documents[index].documentID,ds['uid'],ds['chatId'],"Rejected", "30days")),
              _buildCircularBtn(70.0, "assets/like.png", 3,() =>updatePaymentRequestStatus(snapshot.data.documents[index].documentID,ds['uid'],ds['chatId'],"Approved", 30)),
              
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

      Container(child: Text("REcent logs")),
      ]),
  
        
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: (){},
      ),
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
      color: Colors.white,
      elevation: 4.0,
      onPressed: () {
        onTapFun();
        print('i was clicked');
      },
      height: height,
      shape: CircleBorder(),
      child: Container(
        height: 40.0,
        child: Image.asset(
          img,
          height: imageSize,
          width: imageSize,
        ),
      ),
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
