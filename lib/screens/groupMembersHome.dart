import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/pages/csvGroupDownload.dart';
import 'package:notification/util/data.dart';
import 'package:notification/widgets/chat_item.dart';

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
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // var expiredDataJson = widget.groupMembersJson.removeWhere((m) => m['expiresOn'].toDate().isAfter(new DateTime.now()));
;
// searchResults(widget.groupMembersJson);



    return Scaffold(
      appBar: AppBar(
        title: Text("Members"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: (){
                                  Navigator.push(
                                    context,
                                   new  MaterialPageRoute(
                                        builder: (BuildContext context) => 
                                        AdminGroupCsvDownload(chatId: widget.chatId,approvedGroupDetails: widget.groupMembersJson, ownerEmail: widget.ownerMailId,),
                                        ),
                                 );
            },
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
              text: "Members",
            ),
            Tab(
              text: "Expiring",
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
