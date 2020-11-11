import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notification/models/settings.dart';
import 'package:notification/models/users.dart';
import 'package:notification/util/state.dart';
import 'package:notification/controllers/firebaseController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
            as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  StateModel appState;

  final obj = FirebaseController();
  //GoogleSignInAccount googleAccount;
  //final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    //print('...initUser...');
    FirebaseUser firebaseUserAuth = await Auth.getCurrentFirebaseUser();
    User user = await Auth.getUserLocal();
    Settings settings = await Auth.getSettingsLocal();
    String location = await Auth.getUserLocationLocal();
    String locationId = await Auth.getLocationIdLocal();
    String hoId = await Auth.gethoIdLocal();
    String soId = await Auth.getsoIdLocal();
    String soName = await Auth.getsoNameLocal();
    String hoName = await Auth.gethoNameLocal();
    List followingGroups = await Auth.getFollowingGroups();

    setState(() {
      state.isLoading = false;
      state.firebaseUserAuth = firebaseUserAuth;
      state.user = user;
      state.settings = settings;
      state.locationId = locationId;
      state.locationName = location;
      state.soId = soId;
      state.soName = soName;
      state.hoId = hoId;
      state.hoName = hoName;
      state.followingGroups = followingGroups;
    });
  }



  Future<void> userLocation(
      location, locationId, soId, soName, hoId, hoName) async {
    //  await initUserLocation(location, locationId);
    setState(() {
      state.locationId = locationId;
      state.locationName = location;
      state.soId = soId;
      state.soName = soName;
      state.hoId = hoId;
      state.hoName = hoName;
    });
    await Auth.storeUserLocationLocal(
        location, locationId, soId, soName, hoId, hoName);
    await initUser();
  }

  Future<void> logOutUser() async {
    await Auth.signOut();
    FirebaseUser firebaseUserAuth = await Auth.getCurrentFirebaseUser();

    obj.logout_removeall_fcmtoken(firebaseUserAuth); //for removing fcm tokens

    setState(() {
      state.user = null;
      state.settings = null;
      state.firebaseUserAuth = firebaseUserAuth;
    });
  }

  Future<void> resetPassword(email) async {
    await Auth.forgetPassword(email);
  }

  Future<void> logInUser(email, password) async {
    String userId = await Auth.signIn(email, password);
    User user = await Auth.getUserFirestore(userId);

    await Auth.getAndUpdateFcmToken(user, userId);
    await Auth.storeUserLocal(user, userId);
    Settings settings = await Auth.getSettingsFirestore(userId);
    await Auth.storeSettingsLocal(settings);
    await initUser();
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
