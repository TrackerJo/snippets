import 'dart:convert';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phone_input/phone_input_package.dart';

import '../helper/helper_function.dart';

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
      "uid": uid
    });
    //Add uid to snippet's answered list

    await currentSnippetsCollection.doc(snippetId).update({
      "answered": FieldValue.arrayUnion([uid]),
    });
  }

  Future<List<String>> getFriendsList() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    List<dynamic> friendsList = snapshot["friends"];
    return friendsList.cast<String>();
  }

  Future<Stream> getResponsesList(String snippetId) async {
    //Then the rest of the responses from friends
    List<String> friendsList = await getFriendsList();
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

  Future sendFriendRequest(String friendUid) async {
    DocumentSnapshot snapshot = await userCollection.doc(friendUid).get();
    List<dynamic> friendRequests = snapshot["friendRequests"];
    friendRequests.add(uid);
    await userCollection.doc(friendUid).update({
      "friendRequests": friendRequests,
    });
  }

  Future acceptFriendRequest(String friendUid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    List<dynamic> friends = snapshot["friends"];
    friends.add(friendUid);
    await userCollection.doc(uid).update({
      "friends": friends,
    });

    snapshot = await userCollection.doc(friendUid).get();
    friends = snapshot["friends"];
    friends.add(uid);
    await userCollection.doc(friendUid).update({
      "friends": friends,
    });

    snapshot = await userCollection.doc(uid).get();
    List<dynamic> friendRequests = snapshot["friendRequests"];
    friendRequests.remove(friendUid);
    await userCollection.doc(uid).update({
      "friendRequests": friendRequests,
    });
  }

  Future declineFriendRequest(String friendUid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    List<dynamic> friendRequests = snapshot["friendRequests"];
    friendRequests.remove(friendUid);
    await userCollection.doc(uid).update({
      "friendRequests": friendRequests,
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

  Future removeFriend(String friendUid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    List<dynamic> friends = snapshot["friends"];
    friends.remove(friendUid);
    await userCollection.doc(uid).update({
      "friends": friends,
    });

    snapshot = await userCollection.doc(friendUid).get();
    friends = snapshot["friends"];
    friends.remove(uid);
    await userCollection.doc(friendUid).update({
      "friends": friends,
    });
  }

  Future<bool> checkFriendRequest(String friendUid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    List<dynamic> friendRequests = snapshot["friendRequests"];
    if (friendRequests.contains(friendUid)) {
      return true;
    } else {
      return false;
    }
  }

  Future cancelFriendRequest(String friendUid) async {
    DocumentSnapshot snapshot = await userCollection.doc(friendUid).get();
    List<dynamic> friendRequests = snapshot["friendRequests"];
    friendRequests.remove(uid);
    await userCollection.doc(friendUid).update({
      "friendRequests": friendRequests,
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
    return currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .orderBy("date", descending: false)
        .snapshots();
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
}
