import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/util/data.dart';
import 'package:notification/widgets/chat_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class GroupMembersHome extends StatefulWidget {
  // GroupMembersJson
  GroupMembersHome(
      {Key key,
      this.groupMembersJson,
      this.chatId,
      this.ownerMailId,
      this.groupTitle});
  List groupMembersJson, expiredDataJson;
  final String chatId, ownerMailId, groupTitle;
  @override
  _GroupMembersHomeState createState() => _GroupMembersHomeState();
}

class _GroupMembersHomeState extends State<GroupMembersHome>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
      Dio dio = new Dio();
  TabController _tabController;
  List filteredData;
  String filePath;
  String currentProcess;
  bool isProcessing = false;

  List removedUserdLocal = [];


  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();

    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/Chatogram.csv';
    return File('$path/Chatogram.csv').create();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    setInitialValue();
  }

  setInitialValue() async {
    var docSnap =
        await FirebaseController.instanace.getPrimeGroupsContent(widget.chatId);

    setState(() {
      widget.groupMembersJson = docSnap;
    });
  }
// static  filterList(users) {
//   var now = new DateTime.now();
//   var tempUsers = users;
//     List _users = tempUsers
//         .where((u) =>
//             (u.expiresOn.toDate().isBefore(now))
//             )
//         .toList();
//     users.users = _users;
//     return users;
// }

// searchResults(arrayData){
//     var now = new DateTime.now();
//     arrayData.forEach((u) {
//       if (u.expiresOn.toDate().isBefore(now))
//         filteredData.add(u);
//     });
// }
  getCsv() async {
    setState(() {
      currentProcess = "Getting data from the cloud";
      isProcessing = true;
    });
    var datestamp = new DateFormat("dd-MM'T'HH:mm");
    List<List<dynamic>> rows = List<List<dynamic>>();
    var cloud = await widget.groupMembersJson;
    rows.add([
      "Name",
      "Days",
      "Joined Date",
      "Expiry Date",
      "uxId",
    ]);
    if (cloud != null) {
      for (int i = 0; i < widget.groupMembersJson.length; i++) {
        List<dynamic> row = List<dynamic>();
        row.add(cloud[i]["firstName"]);
        row.add(cloud[i]["membershipDuration"]);
        row.add(datestamp.format(cloud[i]["joinedId"].toDate()).toString());
        row.add(datestamp.format(cloud[i]["expiresOn"].toDate()).toString());
        row.add(cloud[i]["uxId"]);
        rows.add(row);
      }

      File f = await _localFile.whenComplete(() {
        setState(() {
          currentProcess = "Writing to CSV";
        });
      });
      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
      filePath = f.uri.path;
    }
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body:
          'Data Collected and Compiled by the CHATOGRAM. <br> A CSV file is attached to this <b></b> <hr><br> Compiled at ${DateTime.now()}',
      subject: 'CHATOGRAM backup on ${DateTime.now().toString()}',
      recipients: ['test@gmail.com'],
      isHTML: true,
      attachmentPath: filePath,
    );

    await FlutterEmailSender.send(email);
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // am i coming here
    print('am i coming here');
     widget.expiredDataJson = widget.groupMembersJson.where((m) => (m['expiresOn'].toDate().isBefore(new DateTime.now()) && !(removedUserdLocal.contains(m['kycDocId'])))).toList();
    

    
// searchResults(widget.groupMembersJson);

    return Form(
        key: _formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Prime Members",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w800,
                )),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlatButton(
                  child: Text(
                    "Download Prime List",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  color: Colors.blueAccent,
                  onPressed: (isProcessing)
                      ? null
                      : () async {
                          if (_formkey.currentState.validate()) {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                await getCsv().then((v) {
                                  //print('check for email csv ${v}');
                                  setState(() {
                                    currentProcess =
                                        "Compiling and sending mail";
                                  });

                                  sendMailAndAttachment().whenComplete(() {
                                    setState(() {
                                      isProcessing = false;
                                    });
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Data Sent"),
                                    ));
                                  });
                                });
                              }
                            } on SocketException catch (_) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    "Connect your device to the internet, and try again"),
                              ));
                            }
                          }
                        },
                ),
              ),
            ],
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
                  text: "All Prime Members",
                ),
                Tab(
                  text: "Expired Members",
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              // first tab
              FutureBuilder(
                  future: FirebaseController.instanace
                      .getPrimeGroupsContent(widget.chatId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error ${snapshot.error}');
                    }
                    if (snapshot.hasData && snapshot.data.length == 0) {
                      return Text("No Members",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Color(0xff3A4276),
                            fontWeight: FontWeight.w500,
                          ));
                    }
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return ListView.separated(
                        padding: EdgeInsets.all(10),
                        separatorBuilder: (BuildContext context, int index) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 0.5,
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Divider(),
                            ),
                          );
                        },
                        itemCount: widget.groupMembersJson.length,
                        itemBuilder: (BuildContext context, int index) {
                          var member = widget.groupMembersJson[index];

                          Map chat = chats[4];
                          return ChatItem(
                            dp: chat['dp'],
                            name: member['firstName'] ?? 'User ${index + 1}',
                            //name: 'User ${index + 1}',
                            isOnline: chat['isOnline'],
                            counter: 0,
                            msg: "${member['membershipDuration']} days plan 🚀",
                            time: Jiffy(member['expiresOn'].toDate())
                                .fromNow()
                                .toString(),
                            groupTitle: widget.groupTitle,
                          );
                        },
                      );
                    }
                    return Container(width: 0.0, height: 0.0);
                  }),
                // second tab
                  Stack(
                    children: <Widget>[
                      Visibility(
                visible: widget.expiredDataJson.length ==0,
                child: Container(
                              child: Text("No Expired Members",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color(0xff3A4276),
                                    fontWeight: FontWeight.w500,
                                  )))
                ),
                    
                Visibility(
                visible: widget.expiredDataJson.length > 0,
                child: ListView.separated(
                  padding: EdgeInsets.all(10),
                  separatorBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 0.0,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Divider(),
                      ),
                    );
                  },
                  itemCount: widget.expiredDataJson.length,
                  itemBuilder: (BuildContext context, int index) {
                    print('expired data is  ${widget.expiredDataJson.length}${widget.expiredDataJson}');
                    
                    var member = widget.expiredDataJson[index];
                     Map chat = chats[2];
                       return 
                       InkWell(
                         onTap: (){
                          print('am i here');
                          showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Expired Member'),
                    content: Text(
                        'Remove user?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Canel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () async {
                          print('insidet this');

                           widget.groupMembersJson =  widget.groupMembersJson.where((m) => (member['kycDocId'] != m['kycDocId'] )).toList();
                          setState(() {
                             
                            widget.expiredDataJson = widget.groupMembersJson;
                            // expiredDataJson = [];
                            // widget.groupMembersJson = expiredDataJson;
                            Navigator.of(context).pop();
                          });
                          
                      //        var userId = member['userId'];
                      // var modifiedDate = member['expiresOn'];
                      // var kycDocId = member['kycDocId'];
                      // var period = member['membershipDuration'];
                      // var joinedTime = member['joinedId'];
                      // var expiredTime = member['expiresOn'];

                      // FirebaseController.instanace.removeMemberOnExpiry(
                      //     userId,
                      //     joinedTime,
                      //     expiredTime,
                      //     kycDocId,
                      //     period,
                      //     widget.chatId,
                      //     member);
               
                      // try {
                      //   var response = await dio.get(
                      //       "https://asia-south1-royalpro.cloudfunctions.net/onMemberRemove?id=${userId}&chatId=${widget.chatId}&groupName=${widget.groupTitle}");
                      // } catch (e) {
                      //   print('error is ${e}');
                      // }

                    widget.groupMembersJson =  widget.groupMembersJson.where((m) => (member['kycDocId'] != m['kycDocId'] )).toList();
                      removedUserdLocal.add(member['kycDocId']);
                        },
                      ),
                    ],
                  );
                });
                         },
                       
                        //  child: Text('test')
                        child: ChatItem(
                        dp: chat['dp'],
                        name: member['firstName'] ?? 'User ${index + 1}',
                        isOnline: chat['isOnline'],
                        counter: "Remove",
                        msg: "The last rocket🚀",
                        time: Jiffy(member['expiresOn'].toDate())
                            .fromNow()
                            .toString(),
                        fullUserJson: member,
                        chatId: widget.chatId,
                        groupTitle: widget.groupTitle,
                      )
                       
                       );
                  },
                ),
              ),
              ],
                  ),
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
