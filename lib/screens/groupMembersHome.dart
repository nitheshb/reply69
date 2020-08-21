import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/util/data.dart';
import 'package:notification/widgets/chat_item.dart';
import 'package:path_provider/path_provider.dart';

class GroupMembersHome extends StatefulWidget {
  // GroupMembersJson
    GroupMembersHome({Key key, this.groupMembersJson, this.chatId, this.ownerMailId});
    final List  groupMembersJson;
    final String chatId, ownerMailId;
  @override
  _GroupMembersHomeState createState() => _GroupMembersHomeState();
}

class _GroupMembersHomeState extends State<GroupMembersHome> with SingleTickerProviderStateMixin,
    AutomaticKeepAliveClientMixin{
  TabController _tabController;
  List filteredData;
  String filePath;
  String currentProcess;
  bool isProcessing = false;

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
      "KycId",
    ]);
    if (cloud != null) {
      for (int i = 0; i < widget.groupMembersJson.length; i++) {
        List<dynamic> row = List<dynamic>();
        row.add(cloud[i]["userId"]);
        row.add(cloud[i]["membershipDuration"]);    
        row.add(datestamp.format(cloud[i]["joinedId"].toDate()).toString());
        row.add(datestamp.format(cloud[i]["expiresOn"].toDate()).toString());
        row.add(cloud[i]["kycDocId"]);
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
      print('file path is ${filePath}, ${csv}');
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

    // var expiredDataJson = widget.groupMembersJson.removeWhere((m) => m['expiresOn'].toDate().isAfter(new DateTime.now()));
;
// searchResults(widget.groupMembersJson);



    return Form(
            key: _formkey,
            child: Scaffold(
      appBar: AppBar(
        title: Text("Prime Members"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FlatButton(
                  child: Text(
                    "Download Prime List",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blueAccent,
                  onPressed: (isProcessing)    ? null
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
          tabs: <Widget>[
            Tab(
              text: "All Members",
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
          ListView.separated(
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
              print('memeber details ${index}== ${member}');
              Map chat = chats[4];
              return ChatItem(
                dp: chat['dp'],
                name: member['userName'] ?? 'User ${index + 1}',
                //name: 'User ${index + 1}',
                isOnline: chat['isOnline'],
                counter: "Remove",
                msg: "${member['membershipDuration']} days plan 🚀",
                time: Jiffy(member['expiresOn'].toDate()).fromNow().toString(),
              );
            },
          ),
          ListView.separated(
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
              if(member['expiresOn'].toDate().isBefore(new DateTime.now())){
              Map chat = chats[2];
              return ChatItem(
                dp: chat['dp'],
                name: member['userId'],
                isOnline: chat['isOnline'],
                counter: "Remove",
                msg: "The last rocket🚀",
                time: Jiffy(member['expiresOn'].toDate()).fromNow().toString(),
                fullUserJson: member,
                chatId: widget.chatId
              );
              }
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: (){},
      ),
    )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
