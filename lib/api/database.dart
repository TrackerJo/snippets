import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_input/phone_input_package.dart';

import '../helper/helper_function.dart';
import 'notifications.dart';

class Database {
  final String? uid;
  Database({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference publicCollection =
      FirebaseFirestore.instance.collection("public");
  final CollectionReference currentSnippetsCollection =
      FirebaseFirestore.instance.collection("currentSnippets");

  Future savingUserData(String fullName, String email, String username,
      PhoneNumber? phoneNumber) async {
    await userCollection.doc(uid).set({
      "fullname": fullName,
      "email": email,
      "username": username,
      "searchKey": fullName.toLowerCase(),
      "uid": uid,
      "phoneNumber": phoneNumber != null ? phoneNumber.international : "none",
      "friends": [],
      "friendRequests": [],
      "answeredSnippets": [],
      "discussions": [],
      "FCMToken": await PushNotifications().getDeviceToken(),
      "outgoingRequests": []
    });

    DocumentSnapshot snapshot = await publicCollection.doc("usernames").get();
    List<dynamic> usernames = snapshot["usernames"];
    usernames.add(username);
    await publicCollection.doc("usernames").update({
      "usernames": usernames,
    });
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    return snapshot.data() as Map<String, dynamic>;
  }

  Future<bool> checkUsername(String username) async {
    DocumentSnapshot snapshot = await publicCollection.doc("usernames").get();
    List<dynamic> usernames = snapshot["usernames"];
    if (usernames.contains(username)) {
      return true;
    } else {
      return false;
    }
  }

  Future<Stream> getCurrentSnippets() async {
    Stream snapshot = currentSnippetsCollection.snapshots();

    return snapshot;
  }

  Future submitAnswer(String snippetId, String answer) async {
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(uid)
        .set({
      "answer": answer,
      "displayName": await HelperFunctions.getUserDisplayNameFromSF(),
      "uid": uid,
      "discussionUsers": [
        {"userId": uid, "FCMToken": await PushNotifications().getDeviceToken()}
      ],
    });
    //Add uid to snippet's answered list

    await currentSnippetsCollection.doc(snippetId).update({
      "answered": FieldValue.arrayUnion([uid]),
    });
  }

  Future<List<String>> getFriendsList() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    List<dynamic> friendsList = snapshot["friends"];
    //Map each element to a string
    friendsList = friendsList.map((e) => e["userId"]).toList();
    return friendsList.cast<String>();
  }

  Future<List<Map<String, dynamic>>> getFriendsListMap() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    List<dynamic> friendsList = snapshot["friends"];
    return friendsList.cast<Map<String, dynamic>>();
  }

  Future<Stream> getResponsesList(String snippetId) async {
    //Then the rest of the responses from friends
    List<String> friendsList = await getFriendsList();
    if (friendsList.isEmpty) {
      return Stream.value("EMPTY");
    }
    Stream querySnapshot = currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .where("uid", whereIn: friendsList)
        .snapshots();

    return querySnapshot;
  }

  Future<Map<String, dynamic>> getUserResponse(String snippetId) async {
    DocumentSnapshot snapshot = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(uid)
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }

  Future<Stream> getComments(String snippetId, String userId) async {
    Stream snapshot = currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("comments")
        .orderBy("date", descending: false)
        .snapshots();

    return snapshot;
  }

  Future addComment(String snippetId, String comment, String userId) async {
    await userCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("comments")
        .add({
      "comment": comment,
      "displayName": await HelperFunctions.getUserDisplayNameFromSF(),
      "uid": uid,
      "date": DateTime.now(),
    });
  }

  Future sendFriendRequest(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    String displayName = (await HelperFunctions.getUserDisplayNameFromSF())!;
    await userCollection.doc(friendUid).update({
      "friendRequests": FieldValue.arrayUnion([
        {
          "userId": uid,
          "FCMToken": await PushNotifications().getDeviceToken(),
          "displayName": displayName,
          "username": await HelperFunctions.getUserNameFromSF(),
        }
      ]),
    });

    await userCollection.doc(uid).update({
      "outgoingRequests": FieldValue.arrayUnion([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
        }
      ]),
    });

    await PushNotifications().sendNotification(
        title: "$displayName just sent you a friend request!",
        body: "Tap here to accept",
        targetIds: [
          friendFCMToken
        ],
        data: {
          "type": "friendRequest",
          "userId": uid,
          "displayName": displayName,
          "username": await HelperFunctions.getUserNameFromSF(),
          "FCMToken": await PushNotifications().getDeviceToken(),
        });
  }

  Future acceptFriendRequest(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    String displayName = (await HelperFunctions.getUserDisplayNameFromSF())!;
    await userCollection.doc(uid).update({
      "friends": FieldValue.arrayUnion([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
        }
      ])
    });

    await userCollection.doc(friendUid).update({
      "friends": FieldValue.arrayUnion([
        {
          "userId": uid,
          "displayName": displayName,
          "username": await HelperFunctions.getUserNameFromSF(),
        }
      ]),
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": displayName,
          "username": await HelperFunctions.getUserNameFromSF(),
        }
      ])
    });

    await userCollection.doc(uid).update({
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "FCMToken": friendFCMToken,
          "displayName": friendDisplayName,
          "username": friendUsername,
        }
      ])
    });

    await PushNotifications().sendNotification(
        title: "Friend request accepted!",
        body: "$displayName accepted your friend request!",
        targetIds: [
          friendFCMToken
        ],
        data: {
          "type": "friendRequestAccepted",
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
        });
  }

  Future declineFriendRequest(String friendUid, String friendFCMToken,
      String friendDisplayName, String friendUsername) async {
    await userCollection.doc(uid).update({
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "FCMToken": friendFCMToken,
          "displayName": friendDisplayName,
          "username": friendUsername,
        }
      ]),
    });
    await userCollection.doc(friendUid).update({
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": await HelperFunctions.getUserDisplayNameFromSF(),
          "username": await HelperFunctions.getUserNameFromSF(),
        }
      ]),
    });
  }

  Future<Stream> getFriendRequests() async {
    Stream snapshot = userCollection
        .doc(uid)
        .collection("friendRequests")
        .orderBy("date", descending: false)
        .snapshots();

    return snapshot;
  }

  Future removeFriend(
      String friendUid, String friendDisplayName, String friendUsername) async {
    await userCollection.doc(uid).update({
      "friends": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
        }
      ]),
    });

    await userCollection.doc(friendUid).update({
      "friends": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": await HelperFunctions.getUserDisplayNameFromSF(),
          "username": await HelperFunctions.getUserNameFromSF(),
        }
      ]),
    });
  }

  Future<bool> checkFriendRequest(String friendUid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    List<dynamic> friendRequests = snapshot["friendRequests"];
    for (var element in friendRequests) {
      if (element["userId"] == friendUid) {
        return true;
      }
    }
    return false;
  }

  Future cancelFriendRequest(
      String friendUid, String friendDisplayName, String friendUsername) async {
    await userCollection.doc(friendUid).update({
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "FCMToken": await PushNotifications().getDeviceToken(),
          "displayName": await HelperFunctions.getUserDisplayNameFromSF(),
          "username": await HelperFunctions.getUserNameFromSF(),
        }
      ]),
    });

    await userCollection.doc(uid).update({
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
        }
      ]),
    });
  }

  Future<Stream> searchUsers(String search) async {
    Stream snapshot = userCollection
        .where("searchKey", isGreaterThanOrEqualTo: search.toLowerCase())
        .where("searchKey",
            isLessThanOrEqualTo: search.toLowerCase() + "\uf8ff")
        .snapshots();

    return snapshot;
  }

  Future<Stream<QuerySnapshot>> getDiscussion(
      String snippetId, String userId) async {
    Stream<QuerySnapshot> snapshot = currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .orderBy("date", descending: false)
        .snapshots();

    return snapshot;
  }

  Future updateReadBy(String snippetId, String userId, String messageId) async {
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .doc(messageId)
        .update({
      "readBy": FieldValue.arrayUnion([uid]),
    });
  }

  Future sendDiscussionMessage(
      String snippetId, String userId, Map<String, dynamic> message) async {
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .add(message);
  }

  Future updateDiscussionUsers(String snippetId, String answerId,
      Map<String, dynamic> discussionUsers) async {
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(answerId)
        .update({
      "discussionUsers": FieldValue.arrayUnion([discussionUsers]),
    });
  }

  Future addUserToDiscussion(String userId, String snippetId, String answerId,
      String snippetQuestion, String theme) async {
    await userCollection.doc(userId).update({
      "discussions": FieldValue.arrayUnion([
        {
          "snippetId": snippetId,
          "answerId": answerId,
          "snippetQuestion": snippetQuestion,
          "theme": theme,
        }
      ]),
    });

//Update user's discussion list in the local database
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    userData["discussions"].add({
      "snippetId": snippetId,
      "answerId": answerId,
    });
    await HelperFunctions.saveUserDataSF(jsonEncode(userData));
  }

  Future<List<Map<String, dynamic>>> getDiscussions(String userId) async {
    Map<String, dynamic> userData = await getUserData(userId);
    List<dynamic> discussions = userData["discussions"];

    List<Map<String, dynamic>> discussionsData = [];
    for (var element in discussions) {
      // DocumentSnapshot snippetData =
      // await currentSnippetsCollection.doc(element["snippetId"]).get();
      DocumentSnapshot answerData = await currentSnippetsCollection
          .doc(element["snippetId"])
          .collection("answers")
          .doc(element["answerId"])
          .get();
      discussionsData.add({
        "snippetQuestion": element["snippetQuestion"],
        "answerUser": answerData["displayName"],
        "lastMessage": await getLastDiscussionMessage(
            element["snippetId"], element["answerId"]),
        "snippetId": element["snippetId"],
        "answerId": element["answerId"],
        "theme": element["theme"],
        "answerResponse": answerData["answer"],
        "discussionUsers": answerData["discussionUsers"],
      });
    }
    return discussionsData;
  }

  Future<Map<String, dynamic>> getLastDiscussionMessage(
      String snippetId, String userId) async {
    QuerySnapshot snapshot = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .orderBy("date", descending: true)
        .limit(1)
        .get();
    return snapshot.docs[0].data() as Map<String, dynamic>;
  }

  StreamSubscription userDataStream() {
    Stream stream = userCollection.doc(uid).snapshots();
    StreamSubscription streamListen = stream.listen((event) async {
      await HelperFunctions.saveUserDataSF(jsonEncode(event.data()));
      print("Changed");
      print(event.data());
    }, onDone: () {
      print("No longer");
    });
    //On Auth State change end stream
    return streamListen;
  }
}
