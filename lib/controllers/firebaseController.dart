import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:notification/screens/createGroup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController {
  static FirebaseController get instanace => FirebaseController();

  final dbRef = FirebaseDatabase.instance.reference().child("royalPro");
     

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

        var joinedGroups = doc.data['joinedGroups'] ?? [];
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
  sendChatMessage(chatId,body, lastMessageBody, type) async {
    print('i was here at sendChatMessage');
    //  final dbRef = FirebaseDatabase.instance.reference().child("royalPro").child(chatId);
    //  dbRef.set({ 'lastMessageDetails':lastMessageBody});

     final dbRef1 = FirebaseDatabase.instance.reference().child("Notify").child(chatId);
     if(type== "Prime"){
       print("===> try it prime");
          dbRef1.update({ 'pm':"${lastMessageBody["lastPmMsg"] ?? ''}",'pc' : lastMessageBody["msgFullPmCount"] ?? 0, });
          Firestore.instance.collection('Chats').document("${chatId}PGrp").updateData({ 'lastMessageDetails':lastMessageBody, 'messages' : FieldValue.arrayUnion([body])});
     }else if(type== "Non-Prime"){
          dbRef1.update({ 'm':"${lastMessageBody["lastMsg"] ?? ''}", 'c' : lastMessageBody["msgFullCount"] ?? 0, });
          Firestore.instance.collection('Chats').document(chatId).updateData({ 'lastMessageDetails':lastMessageBody, 'messages' : FieldValue.arrayUnion([body])});
     }else{
         dbRef1.update({ 'm':"${lastMessageBody["lastMsg"] ?? ''}", 'c' : lastMessageBody["msgFullCount"] ?? 0, 'pm':"${lastMessageBody["lastPmMsg"] ?? ''}",'pc' : lastMessageBody["msgFullPmCount"] ?? 0, });
         Firestore.instance.collection('Chats').document(chatId).updateData({ 'lastMessageDetails':lastMessageBody, 'messages' : FieldValue.arrayUnion([body])});
         Firestore.instance.collection('Chats').document("${chatId}PGrp").updateData({ 'lastMessageDetails':lastMessageBody, 'messages' : FieldValue.arrayUnion([body])});

     
     }
    
    
  }
  
  sendChatImage(chatId,body, msgFullCount, msgFullPmCount, type){
    final dbRef1 = FirebaseDatabase.instance.reference().child("Notify").child(chatId);
      if(type== "Prime"){
          dbRef1.update({ 'pm':"Image :-)"});
           Firestore.instance.collection('Chats').document("${chatId}PGrp").updateData({ 'messages' : FieldValue.arrayUnion([body])});
     }else if(type== "Non-Prime"){
          dbRef1.update({ 'm':"Image :-)" });
          Firestore.instance.collection('Chats').document(chatId).updateData({ 'messages' : FieldValue.arrayUnion([body])});
     }else{
         dbRef1.update({ 'm':"Image :-)",  'pm':"Image :-)", });
         Firestore.instance.collection('Chats').document("${chatId}PGrp").updateData({ 'messages' : FieldValue.arrayUnion([body])});
         Firestore.instance.collection('Chats').document(chatId).updateData({ 'messages' : FieldValue.arrayUnion([body])});
     }
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
createGroup(body,userId, searchGroupBody,groupTitle,firstName,
               selCategoryValue,configImageCompression, 
               ImageUrl, _paymentScreenshotPhoneNo,  _premiumPrice1 , 
               _premiumDays1 ) async{
      // var createdDocDb =   await dbRef.push().set(body);
      // await dbRef.orderByChild("userId").

      // get frist letter from title and convert to small
      
        var check1 =     await Firestore.instance.collection("groups").add(body);
        var documentId = { "chatId": "${check1.documentID}"} ;
        var groupSearchTag=searchGroupBody['title'][0].toLowerCase();

        await Firestore.instance.collection("groups").document("${check1.documentID}").updateData(documentId);
        await Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayUnion(['${check1.documentID}'])});
       body['chatId'] = check1.documentID;
       searchGroupBody['chatId'] = check1.documentID;
        await Firestore.instance.collection('GroupSearch').document('groupSearch${groupSearchTag}').updateData({ 'payload' : FieldValue.arrayUnion([{
                                          "title": groupTitle,
                                          "ownerName": firstName,
                                          "createdBy":userId,
                                          "category": selCategoryValue,
                                          "groupType": configImageCompression,
                                          "logo": ImageUrl,
                                          "chatId": check1.documentID,
                                          "paymentNo": _paymentScreenshotPhoneNo,
                                          "FeeDetails": [{"fee": _premiumPrice1, "days": _premiumDays1}],
                                        }])});
        await Firestore.instance.collection("PrimeGroups").document("${check1.documentID}").setData(body);
        await Firestore.instance.collection("Devices").document("${check1.documentID}").setData(body);
        await Firestore.instance.collection("Chats").document("${check1.documentID}").setData(body);
        await Firestore.instance.collection("Chats").document("${check1.documentID}PGrp").setData(body);
        final dbRef1 = await FirebaseDatabase.instance.reference().child("Notify").child(check1.documentID);
     dbRef1.set({ 'm':"", 't':"${body['title']}",'c' : 0,'i':ImageUrl, "pc": 0, "pm": "" });
     final dbRef2 = await FirebaseDatabase.instance.reference().child("ChatOwnerId").child(check1.documentID);
     dbRef2.set({ 'o':"${body['createdBy']}" });
        
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
followGroup(chatId,userId, userToken)async{

  print('token i s ${userToken}');
      var snap =   await FirebaseController.instanace.getChatOwnerId(chatId);
                print('what is snap ${snap}');
      await FirebaseController.instanace.addGroupsCount(chatId, snap['c']);          
      Firestore.instance.collection('IAM').document(userId).updateData({ 'followingGroups0' : FieldValue.arrayUnion([chatId])});
      Firestore.instance.collection('groups').document(chatId).updateData({ 'followers' : FieldValue.arrayUnion([userId]), 'AlldeviceTokens': FieldValue.arrayUnion([userToken]) });
}

addGroupsCount(chatId, count) async {
  print('getChatOwnerId called ');
   final dbRef1 = FirebaseDatabase.instance.reference().child("ChatOwnerId").child(chatId);
     dbRef1.update({ 'c' : count+1, });
}

// get read counts 
getMessagesCount(chatId) async {
    var snap = await FirebaseDatabase.instance.reference().child("Notify").child(chatId).once();
  return snap.value;
}

// chat groups Display
getChatOwnerId(chatId) async {
  print('getChatOwnerId called ');
  var snap = await FirebaseDatabase.instance.reference().child("ChatOwnerId").child(chatId).once();
  return snap.value;
}
fetchChatGroupsList(followingGroupsLocal){
  return Firestore.instance.collection('groups').where('chatId', whereIn: followingGroupsLocal).snapshots();
}

getChatContent(chatId, getChatContent){
  print('chat id is ${chatId}');

  if(getChatContent == "Prime"){
  // return Firestore.instance.collection('groups').document(chatId).snapshots();
  return Firestore.instance.collection('Chats').document("${chatId}PGrp").snapshots();
  }else{
     return Firestore.instance.collection('Chats').document(chatId).snapshots();
  }
}
// used to check if group values already exists while creating a new group
searchResultsByName(query){
  print('==>i was at search3');
  var searchTag = query[0].toLowerCase();
  // return Firestore.instance.collection('groups').where("caseSearch", arrayContains: query).limit(4).snapshots();
   return Firestore.instance.collection('GroupSearch').document('groupSearch${searchTag}').snapshots();
}
searchIfGroupAlreadyExists(groupTitle){
  return Firestore.instance.collection('groups').where("title", isEqualTo: groupTitle).getDocuments(); 
}

// get kYc content
getUserKycStatus(chatId,userId){
  return Firestore.instance.collection('KYC').where("chatId", isEqualTo: chatId).where("uid", isEqualTo: userId).where("approve_status", isEqualTo: 'Review_Waiting').snapshots();
}
submitKycDoc(body,userId, chatId)async{
   final collRef = await Firestore.instance.collection('KYC');                                             
    DocumentReference docReferance = collRef.document();                                       
          docReferance.setData(body); 
        final userTable = await Firestore.instance.collection('IAM');
       DocumentReference userTableDocRef = userTable.document(userId);
     return  ;                                              userTableDocRef.updateData({ 'WaitingGroups' : FieldValue.arrayUnion([chatId]),  'WaitingGroupsJson' : FieldValue.arrayUnion([body])}); 
}

getKycDocsList(chatId){
  return  Firestore.instance.collection('KYC').where("chatId", isEqualTo: chatId).where("payment_approve_status", isEqualTo: 'Review_Waiting').snapshots();
}
approveKycDoc(kycDocId,modifiedDate, period, userId, chatId, userToken, phoneNumber, firstName){
        Firestore.instance.collection('KYC').document(kycDocId).updateData({'payment_approve_status': "Approved",'ApprovedOn': DateTime.now(),'expiresOn':  modifiedDate,'membershipDuration': period, 'reviewBy': userId});
        Firestore.instance.collection('IAM').document(userId).updateData({'approvedGroups': FieldValue.arrayUnion([chatId]), 'approvedGroupsJson': FieldValue.arrayUnion([{'chatId':chatId,'kycDocId': kycDocId }]),'WaitingGroups':FieldValue.arrayRemove([chatId])});
              var groupUserBody = {'userId':userId, 'joinedId': DateTime.now(), 'expiresOn':  modifiedDate,'membershipDuration': period, 'kycDocId': kycDocId, 'phoneNumber': phoneNumber, 'firstName': firstName };
        Firestore.instance.collection('PrimeGroups').document(chatId).updateData({'premiumMembers': FieldValue.arrayUnion([userId]),'approvedGroupsJson': FieldValue.arrayUnion([groupUserBody]),'FdeviceTokens': FieldValue.arrayUnion([userToken]),'AlldeviceTokens': FieldValue.arrayRemove([userToken]),'rejectedId': FieldValue.arrayRemove([userId])});
}

rejectKycDoc(kycDocId,modifiedDate, period, userId, chatId){
        Firestore.instance.collection('KYC').document(kycDocId).updateData({'payment_approve_status': "Rejected",'rejectedOn': DateTime.now()});
        Firestore.instance.collection('IAM').document(userId).updateData({'rejectedGroups': FieldValue.arrayUnion([chatId]), 'rejectedGroupsJson': FieldValue.arrayUnion([chatId]),'WaitingGroups':FieldValue.arrayRemove([chatId])});
        Firestore.instance.collection('PrimeGroups').document(chatId).updateData({'rejectedId': FieldValue.arrayUnion([userId]), 'rejectedIdJson': FieldValue.arrayUnion([userId]),'WaitingCount': 100});
}

removeMemberOnExpiry(userId,joinedTime,expiredTime, kycDocId, period, chatId, fullBody){
        Firestore.instance.collection('IAM').document(userId).updateData({'approvedGroups': FieldValue.arrayRemove([chatId]), 'approvedGroupsJson': FieldValue.arrayRemove([{'chatId':chatId,'kycDocId': kycDocId }]),'expiredGroups':FieldValue.arrayUnion([{'chatId':chatId,'kycDocId': kycDocId }])});
              var groupUserBody = {'userId':userId, 
              'joinedId': joinedTime, 
              'expiresOn':  expiredTime,
              'membershipDuration': period, 
              'kycDocId': kycDocId, 
              'phoneNumber': null,
              'firstName': ""};
        
        print('1 was correct');
        Firestore.instance.collection('PrimeGroups').document(chatId).updateData({'premiumMembers': FieldValue.arrayRemove([userId]),'approvedGroupsJson': FieldValue.arrayRemove([fullBody]),'expiredMembers': FieldValue.arrayUnion([userId])});
}

// Display PrimeGroups docs list

getPrimeGroupsContent(chatId) async {
  print('chat id is ${chatId}');

  // return Firestore.instance.collection('PrimeGroups').document(chatId).snapshots();

   DocumentSnapshot value = await Firestore.instance.collection('PrimeGroups').document(chatId).get();



  return value.data['approvedGroupsJson'] ?? [];
}

// Dispaly matches based on category
getMatchesList(categoryName){
  return Firestore.instance.collection('Matches').where('category', isEqualTo: categoryName).snapshots();
}
}