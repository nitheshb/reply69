import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notification/controllers/notificationController.dart';
import 'package:notification/pages/AlgoliaFullTextSearch.dart';
import 'package:notification/util/screen_size.dart';
import 'package:notification/widgets/linearPercentIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile3 extends StatefulWidget {
   Profile3({
    Key key,
    this.title,
    this.chatId,
    this.feeArray,
    this.avatarUrl,
    this.categories,
    this.paymentScreenshotNo,
    this.rating,
    this.followers,
    this.following,
    this.userId,
    this.groupOwnerName,
    this.feeDetails,
    this.seasonRating,
    this.lastWeekRating,
    this.thisWeekRating
  }) : super(key: key);
   final String chatId,title,avatarUrl, paymentScreenshotNo, rating, seasonRating, lastWeekRating, thisWeekRating;
   final feeArray, categories, followers, userId, feeDetails, groupOwnerName;
   final bool following;
  @override
  _Profile3State createState() => _Profile3State();
}

class _Profile3State extends State<Profile3> {
  bool lockModify;
  List followCountModify =[] ;
   @override
  void initState() {
    super.initState();

    lockModify = widget.following;
    followCountModify = widget.followers;
  }



  List<Widget> _buildStatsView(dynamic values, _media) {
          List<Widget> selectedOptions = [];

          if (values != null) {
            values.forEach((item) {
              selectedOptions.add(
                winStats(context, _media, item['categoryName'] ?? '', item['rating'] ?? 0)

             
              );
            });
          }

          return selectedOptions;
        }

  List<Widget> _buildSelectedOptions(dynamic values) {
          List<Widget> selectedOptions = [];

          if (values != null) {
            values.forEach((item) {
              selectedOptions.add(
                Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12,),
                                      child: Center(
                                        child: Text(
                                          "${item['categoryName'] ?? ''}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700
                                          ),
                                        ),
                                      ),
                                    ),
              );
            });
          }

          return selectedOptions;
        }
Widget followUnfollowButtons(context){
return lockModify ? FlatButton(
                      child: Text(
                        "Unfollow",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.grey,
                      onPressed: ()async{
                        //  this is for token 
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
                        Firestore.instance.collection('groups').document(widget.chatId).updateData({ 'followers' : FieldValue.arrayRemove([widget.userId]),'AlldeviceTokens': FieldValue.arrayRemove([userToken])});
                        Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups0' : FieldValue.arrayRemove([widget.chatId])});
                        Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups1' : FieldValue.arrayRemove([widget.chatId])});
                        Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups2' : FieldValue.arrayRemove([widget.chatId])});
                        Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups3' : FieldValue.arrayRemove([widget.chatId])});
                      
                      setState(() {
                        lockModify = !lockModify;
                        followCountModify.remove(widget.userId);
                      
                      });
                      return;
                      },
                    ):
                                 FlatButton(
                      child: Text(
                        "Follow",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: ()async{
                        print("check for doc id of group ${widget.chatId}  id is ${widget.userId}");
                        // make an entry in db as joinedGroups
                       try {
                           setState(() {
                        lockModify = !lockModify;
                        followCountModify.add(widget.userId);
                      });
                         //  this is for token 
     SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.get('FCMToken');
                        Firestore.instance.collection('groups').document(widget.chatId).updateData({ 'followers' : FieldValue.arrayUnion([widget.userId]), 'AlldeviceTokens': FieldValue.arrayUnion([userToken]) });
  
   var q1 = await Firestore.instance.collection('IAM').document(widget.userId).get();

   var followingGroups0 = q1.data['followingGroups0'] ?? [];
   var followingGroups1 = q1.data['followingGroups1'] ?? [];
   var followingGroups2 = q1.data['followingGroups2'] ?? [];
   var followingGroup3 = q1.data['followingGroups3'] ?? [];




 
  if(followingGroups0.length <9){
    print('i was at following groups 0 ${widget.chatId}');
      Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups0' : FieldValue.arrayUnion([widget.chatId])});
      return;
  }else if (followingGroups1.length <9){
      Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups1' : FieldValue.arrayUnion([widget.chatId]) });
      return;
  }else if (followingGroups2.length <9){
      Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups2' : FieldValue.arrayUnion([widget.chatId]) });
      return;
  }else if(followingGroup3.length <9){
      Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups3' : FieldValue.arrayUnion([widget.chatId])});
  // ds.documentID

 NotificationController.instance.subScribeChannelNotification("${widget.chatId}");
  
      return;
  }
                       } catch (e) {
                         print('error at joining a group ${e}');
                       }
          
 
                      },
                    );
}

Widget winStats(context, _media, gameName, rating){
  return         Row(
                  children: <Widget>[
                    Container(
                      width: 70,
                      child:
                    Text('${gameName}', style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontFamily: "Varela",
                  ),
                  overflow: TextOverflow.ellipsis,),
                    ),
                  SizedBox(
                    width: 6
                  ),
                    LinearPercentIndicator(
                      width: screenAwareSize(
                          _media.width - (_media.longestSide <= 775 ? 140 : 200),
                          context),
                      lineHeight: 20.0,
                      percent: rating/ 100,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: Color(0xFF1b52ff),
                      animation: true,
                      animateFromLastPercent: true,
                      alignment: MainAxisAlignment.spaceEvenly,
                      animationDuration: 1000,
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      center: Text(
                        "${rating} %",
                        style: 
                        rating > 45?
                        TextStyle(color: Colors.white): TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
}

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final _media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 20,
        ),
        children: <Widget>[
       
 Align(
              alignment: Alignment.topCenter,
              child: 

              Container(
                  height: size.height * 0.45,
                 
                  margin: EdgeInsets.only(
              top: 15,
              right: 20,
            ),
            padding: EdgeInsets.all(10),
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

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                CircleAvatar(
                                  radius: 36,
                                  backgroundImage: NetworkImage("${widget.avatarUrl}"),
                                ),

                                Row(
                                  children: <Widget>[
                                  followUnfollowButtons(context),
                                 

                                    SizedBox(
                                      width: 8,
                                    ),

                            

                                  ],
                                ),

                              ],
                            ),

                            SizedBox(
                              height: 8,
                            ),

                            Text(
                              "${widget.title.toUpperCase()}",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(
                              height: 8,
                            ),

                            Text(
                              "@ ${widget.groupOwnerName}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(
                              height: 8,
                            ),

                            Text(
                              "NA",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                             Row(
                                         children: <Widget>[
                                           Wrap(
                    spacing: 4.0, // gap between adjacent chips
                    runSpacing: 1.0, // gap between lines
                    children:
                    _buildSelectedOptions(widget.categories),
                  ),
                                         ],
                                       ),

                          ],
                        ),
                      ),

                      Expanded(
                        child: Container(),
                      ),

                      Divider(
                        color: Colors.grey[400],
                      ),

                      Container(
                        height: 64,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Text(
                                    "30-DAYS FEE", 
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    "${widget.feeDetails[0]['fee']}", 
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Text(
                                    "FOLLOWERS", 
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    "${followCountModify.length}", 
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Text(
                                    "RATING", 
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    "${widget.seasonRating ?? 'NA'}", 
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
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
              
            ),
          


            SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Win Stastics",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Varela",
                  ),
                ),
                TextSpan(
                  text: "    This Week",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontFamily: "Varela",
                  ),
                ),
              ],
            ),
          ),
         Container(
            margin: EdgeInsets.only(
              top: 15,
              right: 20,
            ),
            padding: EdgeInsets.all(10),
            // height: screenAwareSize(145, context),
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
            child: 
            
            Column(
              children: <Widget>[
                     Wrap(
                    spacing: 0.0, // gap between adjacent chips
                    runSpacing: 1.0, // gap between lines
                    children:
                    
                    _buildStatsView(widget.categories, _media),
                  )

              ],
            ),
          )

        ],
        
        
      ),
    
    );
  }
}