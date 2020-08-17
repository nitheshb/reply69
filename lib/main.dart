import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification/screens/forget_password.dart';

import 'package:notification/screens/main_screen.dart';
import 'package:notification/screens/sign_in.dart';
import 'package:notification/screens/sign_up.dart';
import 'package:notification/util/const.dart';
import 'package:notification/util/state_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controllers/notificationController.dart';
// import 'package:r_upgrade/r_upgrade.dart';


// import 'package:test_app_1/pages/homeNavScreen1.dart';
// import 'package:test_app_1/ui/screens/homeNew.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:package_info/package_info.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// // import 'package:r_upgrade/r_upgrade.dart';

// import 'package:test_app_1/pages/auction_homeP.dart';
// import 'package:test_app_1/pages/leadershipPitch.dart';
// import 'package:test_app_1/pages/razorPayHome.dart';
// import 'package:test_app_1/pages/savedTeams.dart';
// import 'package:test_app_1/pages/scratch_card.dart';
// import 'package:test_app_1/pages/start_page.dart';
// import 'package:test_app_1/pages/wallet_home.dart';
// import 'package:test_app_1/pages/webSocketTest.dart';
// import 'package:test_app_1/ui/screens/confettiDemo.dart';
// import 'package:test_app_1/ui/screens/fixtures.dart';
// import 'package:test_app_1/ui/screens/homePage.dart';
// import 'package:test_app_1/ui/screens/newFixtures.dart';
// import 'package:test_app_1/util/state_widget.dart';
// import 'package:test_app_1/ui/theme.bloc.dart';
// import 'package:test_app_1/ui/theme.dart';
// import 'package:test_app_1/ui/screens/home.dart';
// import 'package:test_app_1/ui/screens/sign_in.dart';
// import 'package:test_app_1/ui/screens/sign_up.dart';
// import 'package:test_app_1/ui/screens/forgot_password.dart';
// import 'package:test_app_1/pages/Admin/add_matches_P.dart';
// import 'package:test_app_1/services/authentication.dart';






const APP_STORE_URL =
'https://firebasestorage.googleapis.com/v0/b/teamplayers-f3b25.appspot.com/o/build%2Fapp-release.apk?alt=media&token=6af161a4-2467-4b1f-8161-34e6a412ad76';
const PLAY_STORE_URL =
'https://firebasestorage.googleapis.com/v0/b/teamplayers-f3b25.appspot.com/o/build%2Fapp-release.apk?alt=media&token=6af161a4-2467-4b1f-8161-34e6a412ad76';



class MyApp extends StatefulWidget {
  MyApp() {
    //Navigation.initPaths();
  }

  @override
  _MyAppState createState() => _MyAppState();
}
Future<dynamic> myBackgroundHandler(Map<String, dynamic> message){
  return _MyAppState()._showNotification(message);
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


     Future _showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel desc',
      importance: Importance.Max,
      priority: Priority.High,
    );
 
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0,
      'new message arived',
      'i want ${message['data']['title']} for ${message['data']['price']}',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
 

  getTokenz() async {
    String token = await _firebaseMessaging.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('FCMToken', token);

    print('token is : ${token}');
  }

  Future selectNotification(String payload)async{
    await flutterLocalNotificationsPlugin.cancelAll();
  }



@override
  void initState() {
    // themeBloc.changeTheme(Themes.gameOrganizer);

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

var initializationSettings = InitializationSettings(
    initializationSettingsAndroid, null);
 flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: selectNotification);
    super.initState();

    _firebaseMessaging.configure(
      onBackgroundMessage: myBackgroundHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage4: $message");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text( 'new message arived'),
                content: Text('i want ${message['data']['title']} for ${message['data']['price']}'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
    );

    getTokenz();


      try {
    versionCheck(context);
       // NotificationController.instance.takeFCMTokenWhenAppLaunch();
   // NotificationController.instance.initLocalNotification();
     String token =  _firebaseMessaging.getToken() as String;
    print('token is : ${token}');
      } catch (e) {
        print(e);
      }
       super.initState();
      }

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      @override
      Widget build(BuildContext context) {
         SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
        return MaterialApp(
          title: 'MyApp Title',
         
          //onGenerateRoute: Navigation.router.generator,
          debugShowCheckedModeBanner: false,
          theme: Constants.lightTheme,
          darkTheme: Constants.darkTheme,
          home:   FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
                       if (snapshot.hasData){
                           FirebaseUser user = snapshot.data; // this is your user instance
                           /// is because there is user already logged
                           return MainScreen();
                        }
                         /// other way there is no user logged.
                         return MySignInScreenHome();
             }
          ),
          
          routes: {
            '/boot':(context) => MainScreen(),
            '/signin': (context) => MySignInScreenHome(),
            '/signup': (context) => SignupPage(),
            '/forgot-password': (context) => ForgotPasswordScreen(),
            '/SignInAnim': (context)=> MySignInScreenHome(), 
          },
        );
      }

      versionCheck(BuildContext context) async {
  //Get Current installed version of app
  final PackageInfo info = await PackageInfo.fromPlatform();
  double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));

  print('curr version is $currentVersion');

  //Get Latest version info from firebase config
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  try {
    // Using default duration to force fetching from remote server.
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    remoteConfig.getString('force_update_current_version');
    double newVersion = double.parse(remoteConfig
        .getString('force_update_current_version')
        .trim()
        .replaceAll(".", ""));
        print('version details $newVersion old currentv $currentVersion');
    if (newVersion > currentVersion) {
      // Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      _showVersionDialog(context);
          }
        } on FetchThrottledException catch (exception) {
          // Fetch throttled.
          print(exception);
        } catch (exception) {
          print('Unable to fetch remote config. Cached or default values will be '
              'used');
        }
      }
      void upgrade() async {
        print('inside version upgrader');
        //  bool isSuccess =await RUpgrade.upgradeFromUrl(
        //             PLAY_STORE_URL,
        //           );
        // print('check for upgrade ${isSuccess}');
       
      // int id = await RUpgrade.upgrade(
      //            PLAY_STORE_URL,
      //            apkName: 'app-release.apk',
      //            isAutoRequestInstall: true,
      //             useDownloadManager: false
      //            );


      //           //  Navigator.pop(context);
      //   //  await _showFreezer(context);

          // print('app upgrade id is $id');
    }

        _showVersionDialog(context) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = "New Update Available";
      String message =
          "There is a newer version of app available please download it.";
      String btnLabel = "Update Now";
      String btnLabelCancel = "Later";
      return Platform.isIOS
          ? new CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                   onPressed: () => _launchURL(APP_STORE_URL),
                ),
                // FlatButton(
                //   child: Text(btnLabelCancel),
                //   onPressed: () => Navigator.pop(context),
                // ),
              ],
            )
          : new AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => upgrade(),
                  // onPressed: () => _launchURL(PLAY_STORE_URL),
                ),
                // FlatButton(
                //   child: Text(btnLabelCancel),
                //   onPressed: () => Navigator.pop(context),
                // ),
              ],
            );
    },
  );
}

     _showFreezer(context) async {
       Navigator.pop(context);
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = "Downloading";
      String message =
          "New version is downloading, verify";
      String btnLabel = "Update Now";
      String btnLabelCancel = "Later";

      return Platform.isIOS
          ? new CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),          
            )
          : new AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                // FlatButton(
                //   child: Text(btnLabel),
                //   onPressed: upgrade,
                //   // onPressed: () => _launchURL(PLAY_STORE_URL),
                // ),
                // FlatButton(
                //   child: Text(btnLabelCancel),
                //   onPressed: () => Navigator.pop(context),
                // ),
              ],
            );
    },
  );
}

_launchURL(String url) async {
 
  if (await canLaunch(url)) {
    await launch(url);
    
  } else {
    throw 'Could not launch $url';
  }
}
}

void main() {
    WidgetsFlutterBinding.ensureInitialized(); 
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent)
  );
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MaterialApp(home: stateWidget));
    });
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:prochats/pages/sign_in.dart';

// void main() {
//   runApp(MySignInScreen());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//         // This makes the visual density adapt to the platform that you run
//         // the app on. For desktop platforms, the controls will be smaller and
//         // closer together (more dense) than on mobile platforms.
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//               Expanded(child: StreamBuilder(
//         stream:  Firestore.instance.collection('IAM').snapshots(),
//         builder: (context,snapshot){
//                      if (snapshot.hasError) {
//           return Text('Error ${snapshot.error}');
//         }
//           if(snapshot.hasData && snapshot.data.documents.length > 0 ){
//               return Text("snapshot ${snapshot.data.documents.length}");
//           }
//       }),),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
