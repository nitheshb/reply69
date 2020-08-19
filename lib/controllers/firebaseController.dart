import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:notification/screens/createGroup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController {
  static FirebaseController get instanace => FirebaseController();

  // Save Image to Storage
  Future<String> saveUserImageToFirebaseStorage(userId,userName,userIntro,userImageFile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId',userId);
      await prefs.setString('name',userName);
      await prefs.setString('intro',userIntro);

      String filePath = 'userImages/$userId';
      final StorageReference storageReference = FirebaseStorage().ref().child(filePath);
      final StorageUploadTask uploadTask = storageReference.putFile(userImageFile);

      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String imageURL = await storageTaskSnapshot.ref.getDownloadURL(); // Image URL from firebase's image file
      String result = await saveUserDataToFirebaseDatabase(userId,userName,userIntro,imageURL);
      return result;
    }catch(e) {
      print(e.message);
      return null;
    }
  }

  Future<String> sendImageToUserInChatRoom(croppedFile,chatID) async {
    try {
      String imageTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'chatrooms/$chatID/$imageTimeStamp';
      final StorageReference storageReference = FirebaseStorage().ref().child(filePath);
      final StorageUploadTask uploadTask = storageReference.putFile(croppedFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String result = await storageTaskSnapshot.ref.getDownloadURL();
      return result;
    }catch(e) {
      print(e.message);
    }
  }

  // About Firebase Database
  Future<String> saveUserDataToFirebaseDatabase(userId,userName,userIntro,downloadUrl) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final QuerySnapshot result = await Firestore.instance.collection('users').where('FCMToken', isEqualTo: prefs.get('FCMToken')).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      String myID = userId;
      if (documents.length == 0) {
        await Firestore.instance.collection('users').document(userId).setData({
          'userId':userId,
          'name':userName,
          'intro':userIntro,
          'userImageUrl':downloadUrl,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'FCMToken':prefs.get('FCMToken')?? 'NOToken',
        });
      }else {
        String userID = documents[0]['userId'];
        myID = userID;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId',myID);
        await Firestore.instance.collection('users').document(userID).updateData({
          'name':userName,
          'intro':userIntro,
          'userImageUrl':downloadUrl,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'FCMToken':prefs.get('FCMToken')?? 'NOToken',
        });
      }
      return myID;
    }catch(e) {
      print(e.message);
      return null;
    }
  }

  Future<void> updateUserToken(userID, token, oldToken) async {
    await Firestore.instance.collection('IAM').document(userID).updateData({
      'FCMToken':token,
    });
     await Firestore.instance.collection('IAM').document(userID).get().then((doc) {
        print('doc ${doc.data['followingGroups0']}');
        print('doc ${doc.data['joinedGroups']}');

        var joinedGroups = doc.data['joinedGroups'];
        var followingGroups0 = doc.data['followingGroups0'];

        for(final e in joinedGroups){
  //
  var currentElement = e;
   Firestore.instance.collection('groups').document(e).updateData({ 'FdeviceTokens' : FieldValue.arrayUnion([token]), 'FdeviceTokens' : FieldValue.arrayRemove([oldToken])});
}

   for(final e in followingGroups0){
  //
  var currentElement = e;
   Firestore.instance.collection('groups').document(e).updateData({ 'AlldeviceTokens' : FieldValue.arrayUnion([token]), 'AlldeviceTokens' : FieldValue.arrayRemove([oldToken])});
}



     });

     
  }

  Future<List<DocumentSnapshot>> takeUserInformationFromFBDB() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance.collection('users').where('FCMToken', isEqualTo: prefs.get('FCMToken') ?? 'None').getDocuments();
    return result.documents;
  }

  Future<int> getUnreadMSGCount([String peerUserID]) async{
    try {
      int unReadMSGCount = 0;
      String targetID = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      peerUserID == null ? targetID = (prefs.get('userId') ?? 'NoId') : targetID = peerUserID;
//      if (targetID != 'NoId') {
        final QuerySnapshot chatListResult =
        await Firestore.instance.collection('users').document(targetID).collection('chatlist').getDocuments();
        final List<DocumentSnapshot> chatListDocuments = chatListResult.documents;
        for(var data in chatListDocuments) {
          final QuerySnapshot unReadMSGDocument = await Firestore.instance.collection('chatroom').
          document(data['chatID']).
          collection(data['chatID']).
          where('idTo', isEqualTo: targetID).
          where('isread', isEqualTo: false).
          getDocuments();

          final List<DocumentSnapshot> unReadMSGDocuments = unReadMSGDocument.documents;
          unReadMSGCount = unReadMSGCount + unReadMSGDocuments.length;
        }
        print('unread MSG count is $unReadMSGCount');
//      }
      if (peerUserID == null) {
        FlutterAppBadger.updateBadgeCount(unReadMSGCount);
        return null;
      }else {
        return unReadMSGCount;
      }

    }catch(e) {
      print(e.message);
    }
  }

  Future updateChatRequestField(String documentID,String lastMessage,chatID,myID,selectedUserID) async{
    await Firestore.instance
        .collection('users')
        .document(documentID)
        .collection('chatlist')
        .document(chatID)
        .setData({'chatID':chatID,
      'chatWith':documentID == myID ? selectedUserID : myID,
      'lastChat':lastMessage,
      'timestamp':DateTime.now().millisecondsSinceEpoch});
  }

  Future sendMessageToChatRoom(chatID,myID,selectedUserID,content,messageType) async {
    await Firestore.instance
        .collection('chatroom')
        .document(chatID)
        .collection(chatID)
        .document(DateTime.now().millisecondsSinceEpoch.toString()).setData({
      'idFrom': myID,
      'idTo': selectedUserID,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'content': content,
      'type':messageType,
      'isread':false,
    });
  }
  Future<QuerySnapshot> lookForExistingUserName(pickedUserName) async {
    var userName = await Firestore.instance.collection('IAM').where("firstName", isEqualTo: pickedUserName).getDocuments();
    return userName;
  }

  // send chat messages from conversation screen
  sendChatMessage(chatId,body, lastMessageBody){
    Firestore.instance.collection('groups').document(chatId).updateData({ 'lastMessageDetails':lastMessageBody, 'messages' : FieldValue.arrayUnion([body])});
  }
  
  sendChatImage(chatId,body){
    Firestore.instance.collection('groups').document(chatId).updateData({ 'messages' : FieldValue.arrayUnion([body])});
  }

  // voting 
  firstVote(groupId,body){
     Firestore.instance.collection('votingBalletHeap').document(groupId).setData(body);
  }
  userFirstVote(groupId,defaultBody){
     Firestore.instance.collection('votingBalletHeap').document(groupId).updateData({ 'VotingStats' : FieldValue.arrayUnion([defaultBody])});
  }
  userVote(groupId,homeGroup){
      Firestore.instance.collection('votingBalletHeap').document(groupId).setData({ 'VotingStats' : homeGroup});
  }
  getCurrentVotes(chatId){
    return Firestore.instance
  .collection('votingBalletHeap')
  .document(chatId)
  .get();
  }

  //voting cards display
  votingAvailableMatches(groupCategoriesArray,){
   return Firestore.instance.collection('Matches').where("category", arrayContainsAny: groupCategoriesArray).where("status", isEqualTo: "FbStart").snapshots();
  }

// groupPROFILE PAGE  (Follow and Unfollow)
createGroup(body,userId) async{
        var check1 =     await Firestore.instance.collection("groups").add(body);
        var documentId = { "chatId": "${check1.documentID}"} ;
        await Firestore.instance.collection("groups").document("${check1.documentID}").updateData(documentId);
        await   Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayUnion(['${check1.documentID}'])});
return check1;
}
editGroupProfile(chatId, body){
  Firestore.instance.collection("groups").document("${chatId}").updateData(body);
}
unfollowGroup(chatId,userId, userToken){
        Firestore.instance.collection('groups').document(chatId).updateData({ 'followers' : FieldValue.arrayRemove([userId]),'AlldeviceTokens': FieldValue.arrayRemove([userToken])});
        Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayRemove([chatId])});
                        // Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups1' : FieldValue.arrayRemove([widget.chatId])});
                        // Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups2' : FieldValue.arrayRemove([widget.chatId])});
                        // Firestore.instance.collection('IAM').document(widget.userId).updateData({ 'followingGroups3' : FieldValue.arrayRemove([widget.chatId])});
}
followGroup(chatId,userId, userToken){
      Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayUnion([chatId])});
      Firestore.instance.collection('groups').document(chatId).updateData({ 'followers' : FieldValue.arrayUnion([userId]), 'AlldeviceTokens': FieldValue.arrayUnion([userToken]) });
}

// chat groups Display
fetchChatGroupsList(followingGroupsLocal){
  return Firestore.instance.collection('groups').where('chatId', whereIn: followingGroupsLocal).snapshots();
}

getChatContent(chatId){
  return Firestore.instance.collection('groups').document(chatId).snapshots();
}
// used to check if group values already exists while creating a new group
searchResultsByName(query){
  return Firestore.instance.collection('groups').where("caseSearch", arrayContains: query).snapshots();
}
searchIfGroupAlreadyExists(groupTitle){
  return Firestore.instance.collection('groups').where("title", isEqualTo: groupTitle).getDocuments(); 
}

// get kYc content
getUserKycStatus(chatId,userId){
  return Firestore.instance.collection('KYC').where("chatId", isEqualTo: chatId).where("uid", isEqualTo: userId).where("approve_status", isEqualTo: 'Review_Waiting').snapshots();
}
submitKycDoc(body,userId, chatId)async{
   final collRef = await Firestore.instance.collection('KYC');                                              DocumentReference docReferance = collRef.document();                                             docReferance.setData(body); 
        final userTable = await Firestore.instance.collection('IAM');
                                                       DocumentReference userTableDocRef = userTable.document(userId);
     return  ;                                              userTableDocRef.updateData({ 'WaitingGroups' : FieldValue.arrayUnion([chatId]),  'WaitingGroupsJson' : FieldValue.arrayUnion([body])}); 
}

getKycDocsList(chatId){
  return  Firestore.instance.collection('KYC').where("chatId", isEqualTo: chatId).where("payment_approve_status", isEqualTo: 'Review_Waiting').snapshots();
}
approveKycDoc(kycDocId,modifiedDate, period, userId, chatId, userToken){
        Firestore.instance.collection('KYC').document(kycDocId).updateData({'payment_approve_status': "Approved",'ApprovedOn': DateTime.now(),'expiresOn':  modifiedDate,'membershipDuration': period, 'reviewBy': userId});
        Firestore.instance.collection('IAM').document(userId).updateData({'approvedGroups': FieldValue.arrayUnion([chatId]), 'approvedGroupsJson': FieldValue.arrayUnion([{'chatId':chatId,'kycDocId': kycDocId }]),'WaitingGroups':FieldValue.arrayRemove([chatId])});
              var groupUserBody = {'userId':userId, 'joinedId': DateTime.now(), 'expiresOn':  modifiedDate,'membershipDuration': period, 'kycDocId': kycDocId };
        Firestore.instance.collection('groups').document(chatId).updateData({'premiumMembers': FieldValue.arrayUnion([userId]),'approvedGroupsJson': FieldValue.arrayUnion([groupUserBody]),'FdeviceTokens': FieldValue.arrayUnion([userToken]),'AlldeviceTokens': FieldValue.arrayRemove([userToken]),'rejectedId': FieldValue.arrayRemove([userId])});
}

rejectKycDoc(kycDocId,modifiedDate, period, userId, chatId){
        Firestore.instance.collection('KYC').document(kycDocId).updateData({'payment_approve_status': "Rejected",'rejectedOn': DateTime.now()});
        Firestore.instance.collection('IAM').document(userId).updateData({'rejectedGroups': FieldValue.arrayUnion([chatId]), 'rejectedGroupsJson': FieldValue.arrayUnion([chatId]),'WaitingGroups':FieldValue.arrayRemove([chatId])});
        Firestore.instance.collection('groups').document(chatId).updateData({'rejectedId': FieldValue.arrayUnion([userId]), 'rejectedIdJson': FieldValue.arrayUnion([userId]),'WaitingCount': 100});
}

removeMemberOnExpiry(userId,joinedTime,expiredTime, kycDocId, period, chatId){
        Firestore.instance.collection('IAM').document(userId).updateData({'approvedGroups': FieldValue.arrayRemove([chatId]), 'approvedGroupsJson': FieldValue.arrayRemove([{'chatId':chatId,'kycDocId': kycDocId }]),'expiredGroups':FieldValue.arrayUnion([{'chatId':chatId,'kycDocId': kycDocId }])});
              var groupUserBody = {'userId':userId, 'joinedId': joinedTime, 'expiresOn':  expiredTime,'membershipDuration': period, 'kycDocId': kycDocId };
        Firestore.instance.collection('groups').document(chatId).updateData({'premiumMembers': FieldValue.arrayRemove([userId]),'approvedGroupsJson': FieldValue.arrayRemove([groupUserBody]),'expiredMembers': FieldValue.arrayUnion([userId])});
}



// Dispaly matches based on category
getMatchesList(categoryName){
  return Firestore.instance.collection('Matches').where('category', isEqualTo: categoryName).snapshots();
}
}