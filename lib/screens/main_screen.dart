import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification/screens/Matches.dart';
import 'package:notification/screens/profile.dart';
import 'package:notification/util/state.dart';
import 'package:notification/util/state_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'chats.dart';

class MainScreen extends StatefulWidget {
    MainScreen({
    Key key,
    this.userId,
    this.followingGroupsLocal,
    this.launchKey,
    this.followingGroupsReadCountLocal
  }) : super(key: key);
  final String userId;
  List followingGroupsLocal, followingGroupsReadCountLocal;
  int launchKey;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  StateModel appState;  
  int _page = 1;
  List localDataFollowingGroups =[];
  


// loadingData()async{
//   print(' iwas here');
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//    var check = await prefs.getStringList('followingGroups');
//     print('checking groups 2 check ${check}');
//    setState(() {
//      localDataFollowingGroups = check;
//    });
// }
getUserData(userId)async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     var followingGroups = await prefs.getStringList('followingGroups');
    // return followingGroups;


print('wowow check this  ${followingGroups}');
   localDataFollowingGroups = followingGroups ?? [];

}

  @override
  Widget build(BuildContext context) {
            appState = StateWidget.of(context).state;
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    // final localFollowingGroups = appState.user;
       final approvedGroups = appState?.user?.approvedGroups;

    print('approvedGroups==> ${approvedGroups}');
    print('checking groups 2 ${localDataFollowingGroups}');
    // loadingData();
    print('it should show up here ${widget.followingGroupsReadCountLocal}');
  
    

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          // ChatsOld(),
          // Home(),
           DisplayMatches(uId: userId, uEmailId: email),
          Chats(uId: userId, uEmailId: email, followingGroupsLocal: widget.followingGroupsLocal, followingGroupsReadCountLocal: widget.followingGroupsReadCountLocal ),
          // Notifications(),
          // Home(),
          Profile(),
        ],
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Theme.of(context).primaryColor,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.grey[500]),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            //  BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.check,
            //   ),
            //   title: Container(height: 0.0),
            // ),
            
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.home,
            //   ),
            //   title: Container(height: 0.0),
            // ),
        
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.calendarAlt,
              ),
              title: Text("Schedule", style:GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                )),
            ),

           
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              title: Text("Chats", style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                )),
            ),
            

            // BottomNavigationBarItem(
            //   icon: IconBadge(
            //     icon: Icons.notifications,
            //   ),
            //   title: Container(height: 0.0),
            // ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              title: Text("Profile", style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xff3A4276),
                  fontWeight: FontWeight.w500,
                )),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
     getUserData(widget.userId);
   // loadingData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    // getUserData(widget.userId).dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
