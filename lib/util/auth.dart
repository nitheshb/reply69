import 'dart:async';
//import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:notification/models/settings.dart';
import 'package:notification/models/users.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  static Future<String> signUp(String email, String password) async {
    AuthResult user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.user.uid;
  }

  static addUserSettingsDB(User user) async {
    checkUserExist(user.userId).then((value) async {
      if (!value) {
        String emails = user.email;
        var userId = await Firestore.instance
            .document("IAM/${user.userId}")
            .setData(user.toJson());
        QuerySnapshot docs = await Firestore.instance
            .collection('IAM')
            .where("email", isEqualTo: emails)
            .getDocuments();

        if (!docs.documents.isEmpty) {
          String docId = await docs.documents[0].data["userId"];

          await Firestore.instance.document("IAM/$docId").updateData(
              {'walletMoney': (docs.documents[0].data["walletMoney"] + 50)});

          await print("query data is ${docId}");
        } else {}
        _addSettings(new Settings(
          settingsId: user.userId,
        ));
      } else {}
    });
  }

  static showBasicsFlash({
    Duration duration,
    flashStyle = FlashStyle.floating,
    BuildContext context,
    String messageText,
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

  static addReportData(uId, chatId, category, description) async {
    var jsonData = {
      'uid': uId,
      'chatId': chatId,
      'category': category,
      'description': description
    };
    var userId = await Firestore.instance
        .collection('complaints')
        .document()
        .setData(jsonData);
  }

  static Future<bool> checkUserExist(String userId) async {
    bool exists = false;
    try {
      await Firestore.instance.document("IAM/$userId").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static void _addSettings(Settings settings) async {
    Firestore.instance
        .document("settings/${settings.settingsId}")
        .setData(settings.toJson());
  }

  static Future<String> signIn(String email, String password) async {
    AuthResult user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return user.user.uid;
  }

  static Future<void> forgetPassword(
    String email,
  ) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    // AuthResult user = await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<User> getUserFirestore(String userId) async {
    if (userId != null) {
      return Firestore.instance
          .collection('IAM')
          .document(userId)
          .get()
          .then((documentSnapshot) => User.fromDocument(documentSnapshot));
    } else {
      return null;
    }
  }

  static Future<Settings> getSettingsFirestore(String settingsId) async {
    if (settingsId != null) {
      return Firestore.instance
          .collection('settings')
          .document(settingsId)
          .get()
          .then((documentSnapshot) => Settings.fromDocument(documentSnapshot));
    } else {
      return null;
    }
  }

  static Future<String> storeUserLocal(User user, userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> approvedGroupsList = [];
    List<String> myOwnGroupsList = [];
    String storeUser = userToJson(user);
    await prefs.setString('user', storeUser);

    //  this is used in notifications
    String storeUserId = user.userId;
    await prefs.setString('FireUserId', storeUserId);
    await prefs.setString('userId', userId);
    await prefs.setString('firstName', user.firstName);

    if (user.approvedGroups != null) {
      await user.approvedGroups.forEach((data) async {
        // search for the rc count and update it
        await approvedGroupsList.add(data);
 await prefs.setStringList('approvedGroups_pref', myOwnGroupsList);

      });
    }

    if(user.myOwnGroups!= null) {

    await   user.myOwnGroups.forEach((data) async {
        // search for the rc count and update it
        await myOwnGroupsList.add(data);
       
       });
      await prefs.setStringList('myOwnGroups_pref', myOwnGroupsList);
      var local = await prefs.getStringList('myOwnGroups_pref');
  
        //     }
    }
    await prefs.setStringList('approvedPrimeGroups', approvedGroupsList);


    List<String> followingGroupsLocal = [];

    List<String> followingGroupsReadCountLocal = [];
    if (user.followingGroups != null) {
      await user.followingGroups.forEach((data) async {
        // search for the rc count and update it
        await followingGroupsLocal.add(data);

      });
    }

    // await prefs.setStringList('followingGroups', followingGroupsLocal);
    await prefs.setStringList('followingGroups_pref', followingGroupsLocal);
    await prefs.setStringList(
        'followingGroupsReadCountLocal', followingGroupsReadCountLocal);
    var check = await prefs.getStringList('followingGroups_pref');

    var followingGroupsReadCountLocal1 =
        await prefs.getStringList('followingGroupsReadCountLocal');

    return user.userId;
  }

  static Future<String> getAndUpdateFcmToken(User user, userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var oldFcm = prefs.get('FCMToken');
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String currentFcm = await _firebaseMessaging.getToken();

    //String currentFcm = 'xyz3';
    if (oldFcm != currentFcm) {
      prefs.setString('FCMToken', currentFcm);
      // now set in user iam
      FirebaseController.instanace.updateUserToken(userId, currentFcm, oldFcm);
      // fetch the following groups and update and remove the data
    }
    return '';
  }

  static getFollowingGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List followingGroups = await prefs.getStringList('followingGroups_pref');
    return followingGroups;
  }

  static Future<List> setFollowingGroups(oldData, value, action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (action == 'remove') {
      // await prefs.setStringList('followingGroups', oldData.remove(value));
    } else {
      //  await prefs.setStringList('followingGroups', oldData.add(value));
    }
    // return followingGroups;
  }

  static Future<String> storeUserLocationLocal(
      String user, locationId, soId, soName, hoId, hoName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = (user);
    await prefs.setString('locationName', storeUser);
    await prefs.setString('locationId', locationId);
    await prefs.setString('soId', soId);
    await prefs.setString('soName', soName);
    await prefs.setString('hoId', hoId);
    await prefs.setString('hoName', hoName);
    return user;
  }

  static Future<String> storeSettingsLocal(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeSettings = settingsToJson(settings);
    await prefs.setString('settings', storeSettings);
    return settings.settingsId;
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

  static Future<User> getUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      User user = userFromJson(prefs.getString('user'));
      //print('USER: $user');
      return user;
    } else {
      return null;
    }
  }

  static Future<String> getUserLocationLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('locationName') != null) {
      String locationName = prefs.getString('locationName');
      //print('USER: $user');
      return locationName;
    } else {
      return null;
    }
  }

  static Future<String> getLocationIdLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('locationId') != null) {
      String locationId = prefs.getString('locationId');
      //print('USER: $user');
      return locationId;
    } else {
      return null;
    }
  }

  static Future<String> gethoIdLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('hoId') != null) {
      String hoId = prefs.getString('hoId');
      //print('USER: $user');
      return hoId;
    } else {
      return null;
    }
  }

  static Future<String> getsoIdLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('soId') != null) {
      String soId = prefs.getString('soId');
      //print('USER: $user');
      return soId;
    } else {
      return null;
    }
  }

  static Future<String> gethoNameLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('hoName') != null) {
      String hoName = prefs.getString('hoName');
      return hoName;
    } else {
      return null;
    }
  }

  static Future<String> getsoNameLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('soName') != null) {
      String soName = prefs.getString('soName');
      //print('USER: $user');
      return soName;
    } else {
      return null;
    }
  }

  static Future<Settings> getSettingsLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('settings') != null) {
      Settings settings = settingsFromJson(prefs.getString('settings'));
      //print('SETTINGS: $settings');
      return settings;
    } else {
      return null;
    }
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    FirebaseAuth.instance.signOut();
  }

  static Future<void> forgotPasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

  /*static Stream<User> getUserFirestore(String userId) {
    print("...getUserFirestore...");
    if (userId != null) {
      //try firestore
      return Firestore.instance
          .collection("users")
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return User.fromDocument(doc);
        }).first;
      });
    } else {
      print('firestore user not found');
      return null;
    }
  }*/

  /*static Stream<Settings> getSettingsFirestore(String settingsId) {
    print("...getSettingsFirestore...");
    if (settingsId != null) {
      //try firestore
      return Firestore.instance
          .collection("settings")
          .where("settingsId", isEqualTo: settingsId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return Settings.fromDocument(doc);
        }).first;
      });
    } else {
      print('no firestore settings available');
      return null;
    }
  }*/
}
