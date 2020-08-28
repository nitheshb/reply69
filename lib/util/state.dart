import 'package:notification/models/settings.dart';
import 'package:notification/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;
  String locationId, soId, hoId;
  String locationName, soName, hoName;
  List followingGroups;
  List followingGroupsReadCountLocal;



  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
    this.locationId = "0",
    this.locationName="",
    this.followingGroups,
    this.followingGroupsReadCountLocal
  });
}
