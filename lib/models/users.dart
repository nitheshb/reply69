import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String userId;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String referralCode;
  var walletMoney;
  String location;
  List<dynamic> followingGroups;
  List<dynamic> approvedGroups;
  List<dynamic> myOwnGroups;
  
  String FCMToken;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email, 
    this.referralCode, 
    this.walletMoney,
    this.location,
    this.followingGroups,
    this.approvedGroups,
    this.myOwnGroups,
    this.FCMToken
  });



  factory User.fromJson(Map<String, dynamic> json) => new User(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        walletMoney: json["walletMoney"],
        followingGroups: json['followingGroups0'],
        approvedGroups: json['approvedGroups'],
        myOwnGroups: json['myOwnGroups'],
        FCMToken: json['FCMToken'] ?? ""
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "email": email,
        "walletMoney": walletMoney,
        "followingGroups": followingGroups,
        "approvedGroups" : approvedGroups,
        "myOwnGroups" : myOwnGroups,
        "FCMToken": FCMToken,
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
