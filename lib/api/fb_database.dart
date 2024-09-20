import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/local_database.dart';

import '../helper/helper_function.dart';
import 'notifications.dart';

class FBDatabase {
  final String? uid;
  FBDatabase({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference publicCollection =
      FirebaseFirestore.instance.collection("public");
  final CollectionReference currentSnippetsCollection =
      FirebaseFirestore.instance.collection("currentSnippets");
  final CollectionReference snippetQuestionsCollection =
      FirebaseFirestore.instance.collection("snippetQuestions");
  final CollectionReference botwCollection =
      FirebaseFirestore.instance.collection("blankOfTheWeek");

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
      "description": "Hey there! I'm using Snippets.",
      "friendRequests": [],
      "answeredSnippets": [],
      "discussions": [],
      "FCMToken": await PushNotifications().getDeviceToken(),
      "outgoingRequests": [],
      "botwStatus": {
        "date": "",
        "hasAnswered": false,
        "hasSeenResults": false,
      },
      "votesLeft": 3,
    });
    await HelperFunctions.saveUserDataSF(jsonEncode({
      "fullname": fullName,
      "email": email,
      "username": username,
      "searchKey": fullName.toLowerCase(),
      "uid": uid,
      "phoneNumber": phoneNumber != null ? phoneNumber.international : "none",
      "friends": [],
      "description": "Hey there! I'm using Snippets.",
      "friendRequests": [],
      "answeredSnippets": [],
      "discussions": [],
      "FCMToken": await PushNotifications().getDeviceToken(),
      "outgoingRequests": [],
      "botwStatus": {
        "date": "",
        "hasAnswered": false,
        "hasSeenResults": false,
      },
      "votesLeft": 3,
    }));

    DocumentSnapshot snapshot = await publicCollection.doc("usernames").get();
    List<dynamic> usernames = snapshot["usernames"];
    usernames.add(username);
    await publicCollection.doc("usernames").update({
      "usernames": usernames,
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    return snapshot.data() as Map<String, dynamic>;
  }

  Future<bool> didUserAnswerSnippet(String snippetId) async {
    DocumentSnapshot snapshot =
        await currentSnippetsCollection.doc(snippetId).get();
    List<dynamic> answeredSnippets = snapshot["answered"];
    if (answeredSnippets.contains(uid)) {
      return true;
    } else {
      return false;
    }
  }

  Future<Stream?> getUserStream(String userId) async {
    //Check if doc exists

    try {
      Stream snapshot = userCollection.doc(userId).snapshots();
      return snapshot;
    } on FirebaseException catch (_) {
      //Check if doc doesn't exist
      return null;
    }
  }

  Future updateUserData(Map<String, dynamic> updatedData) async {
    await userCollection.doc(uid).update(updatedData);
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

  getCurrentSnippets(int? latestSnippetDate, StreamController controller,
      StreamController mainController) async {
    if (latestSnippetDate != null) {
      currentSnippetsCollection
          .where("lastRecievedMillis", isGreaterThan: latestSnippetDate)
          .snapshots()
          .listen((event) {
        if (mainController.isClosed) return;
        controller.add(event);
      });
      return;
    }
    currentSnippetsCollection.snapshots().listen((event) {
      if (mainController.isClosed) return;
      controller.add(event);
    });
  }

  Future submitAnswer(String snippetId, String answer, String question,
      String theme, String? id) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(id ?? uid)
        .set({
      "answer": answer,
      "displayName": id == null ? userData["fullname"] : "Anonymous",
      "uid": id ?? uid,
      "discussionUsers": id == null
          ? [
              {
                "userId": uid,
                "FCMToken": userData["FCMToken"],
              }
            ]
          : [],
      "date": DateTime.now(),
      "lastUpdated": DateTime.now(),
      "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
    });
    DateTime now = DateTime.now();
    LocalDatabase().answerSnippet(snippetId, now);

    //Update user's discussion list
    if (id == null) {
      await userCollection.doc(uid).update({
        "discussions": FieldValue.arrayUnion([
          {
            "snippetId": snippetId,
            "answerId": uid,
            "snippetQuestion": question,
            "theme": theme,
            "isAnonymous": id != null,
          }
        ]),
      });
    }

    //Add uid to snippet's answered list

    await currentSnippetsCollection.doc(snippetId).update({
      "answered": FieldValue.arrayUnion([id ?? uid]),
      "lastUpdated": now,
      "lastUpdatedMillis": now.millisecondsSinceEpoch,
    });

    //Send notification to user's friends

    if (id == null) {
      print("Sending notification");
      List<dynamic> friendsList = userData["friends"];
      List<dynamic> friendsFCMTokens =
          friendsList.map((e) => e["FCMToken"]).toList();
      await PushNotifications().sendNotification(
          title: "Look who answered a snippet!",
          body: "${userData["fullname"]} did!",
          targetIds: [
            ...friendsFCMTokens,
          ],
          data: {
            "type": "snippetAnswered",
            "snippetId": snippetId,
            "question": question.replaceAll("?", "~"),
            "theme": "blue",
            "snippetType": id != null ? "anonymous" : "normal",
            "displayName": userData["fullname"],
            "uid": userData["uid"],
            "response": answer,
            "answered": "false"
          });
    }

    if (await WidgetKit.getItem(
            'snippetsResponsesData', 'group.kazoom_snippets') ==
        null) {
      List<String> oldResponses = [];
      String responseString =
          "${userData["fullname"]}|$question|$answer|$snippetId|${id ?? uid}|${id != null ? "anonymous" : "normal"}|${true}";
      if (!oldResponses.contains(responseString)) {
        oldResponses.add(responseString);
        WidgetKit.setItem('snippetsResponsesData',
            jsonEncode({"responses": oldResponses}), 'group.kazoom_snippets');
        WidgetKit.reloadAllTimelines();
      }
    } else {
      Map<String, dynamic> oldResponsesMap = json.decode(
          await WidgetKit.getItem(
              'snippetsResponsesData', 'group.kazoom_snippets'));
      List<String> oldResponses = oldResponsesMap["responses"].cast<String>();
      String responseString =
          "${userData["fullname"]}|$question|$answer|$snippetId|${id ?? uid}|${id != null ? "anonymous" : "normal"}|${true}";
      if (!oldResponses.contains(responseString)) {
        //Mark other responses from the same snippet as read
        for (var element in oldResponses) {
          List<String> response = element.split("|");
          if (response[3] == snippetId) {
            response[6] = "true";
            oldResponses[oldResponses.indexOf(element)] = response.join("|");
          }
        }
        WidgetKit.setItem('snippetsResponsesData',
            jsonEncode({"responses": oldResponses}), 'group.kazoom_snippets');
        WidgetKit.reloadAllTimelines();
      }
      // oldResponses.add(responseString);
    }
  }

  Future<List<String>> getFriendsList() async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    List<dynamic> friendsList = userData["friends"];
    //Map each element to a string
    friendsList = friendsList.map((e) => e["userId"]).toList();
    return friendsList.cast<String>();
  }

  Future<List<Map<String, dynamic>>> getFriendsListMap() async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    List<dynamic> friendsList = userData["friends"];
    return friendsList.cast<Map<String, dynamic>>();
  }

  Future<void> getResponsesList(
      String snippetId,
      int? date,
      bool getFriends,
      List<String> friendsToGet,
      bool isAnonymous,
      StreamController controller) async {
    //Then the rest of the responses from friends
    List<String> friendsList = [];
    if (!isAnonymous) {
      friendsList = await getFriendsList();
    }
    if (date == null) {
      if (friendsList.isEmpty && !isAnonymous) {
        return;
      }
      Stream querySnapshot;
      if (isAnonymous) {
        querySnapshot = currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .snapshots();
      } else {
        querySnapshot = currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .where("uid", whereIn: friendsList)
            .snapshots();
      }

      querySnapshot.listen((event) {
        if (controller.isClosed) return;
        controller.add(event);
      });
    }
    if (getFriends && !isAnonymous) {
      print("Getting friends responses");

      Stream querySnapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .where("uid", whereIn: friendsToGet)
          .snapshots();

      querySnapshot.listen((event) {
        if (controller.isClosed) return;
        controller.add(event);
      });
    }
    Stream querySnapshot;
    if (isAnonymous) {
      querySnapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .where("lastUpdatedMillis", isGreaterThan: date)
          .snapshots();
    } else {
      querySnapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .where("uid", whereIn: friendsList)
          .where("lastUpdatedMillis", isGreaterThan: date)
          .snapshots();
    }

    querySnapshot.listen((event) {
      if (controller.isClosed) return;
      controller.add(event);
    });
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

  Future sendFriendRequest(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await userCollection.doc(friendUid).update({
      "friendRequests": FieldValue.arrayUnion([
        {
          "userId": uid,
          "FCMToken": userData["FCMToken"],
          "displayName": userData["fullname"],
          "username": userData["username"],
        }
      ]),
    });

    await userCollection.doc(uid).update({
      "outgoingRequests": FieldValue.arrayUnion([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
          "FCMToken": friendFCMToken,
        }
      ]),
    });

    PushNotifications().sendNotification(
        title: "New friend request!",
        body: "${userData["fullname"]} wants to be your friend!",
        targetIds: [
          friendFCMToken
        ],
        data: {
          "type": "friendRequest",
          "userId": uid,
          "displayName": userData["fullname"],
          "username": userData["username"],
          "FCMToken": userData["FCMToken"],
        });
  }

  Future acceptFriendRequest(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await userCollection.doc(uid).update({
      "friends": FieldValue.arrayUnion([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
          "FCMToken": friendFCMToken,
        }
      ]),
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "FCMToken": friendFCMToken,
          "displayName": friendDisplayName,
          "username": friendUsername,
        }
      ])
    });

    await userCollection.doc(friendUid).update({
      "friends": FieldValue.arrayUnion([
        {
          "userId": uid,
          "displayName": userData["fullname"],
          "username": userData["username"],
          "FCMToken": userData["FCMToken"],
        }
      ]),
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": userData["fullname"],
          "username": userData["username"],
          "FCMToken": userData["FCMToken"],
        }
      ])
    });

    await PushNotifications().sendNotification(
        title: "Friend request accepted!",
        body: "${userData["fullname"]} accepted your friend request!",
        targetIds: [
          friendFCMToken
        ],
        data: {
          "type": "friendRequestAccepted",
          "userId": uid,
          "displayName": userData["fullname"],
          "username": userData["username"],
        });
  }

  Future declineFriendRequest(String friendUid, String friendFCMToken,
      String friendDisplayName, String friendUsername) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
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
          "displayName": userData["fullname"],
          "username": userData["username"],
          "FCMToken": userData["FCMToken"],
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

  Future removeFriend(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await userCollection.doc(uid).update({
      "friends": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
          "FCMToken": friendFCMToken,
        }
      ]),
    });

    await userCollection.doc(friendUid).update({
      "friends": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": userData["fullname"],
          "username": userData["username"],
          "FCMToken": userData["FCMToken"],
        }
      ]),
    });
  }

  Future<bool> checkFriendRequest(String friendUid) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    List<dynamic> friendRequests = userData["friendRequests"];
    for (var element in friendRequests) {
      if (element["userId"] == friendUid) {
        return true;
      }
    }
    return false;
  }

  Future cancelFriendRequest(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await userCollection.doc(friendUid).update({
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "FCMToken": userData["FCMToken"],
          "displayName": userData["fullname"],
          "username": userData["username"],
        }
      ]),
    });

    await userCollection.doc(uid).update({
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
          "FCMToken": friendFCMToken,
        }
      ]),
    });
  }

  Future searchUsers(String search) async {
    //Order alphabetically
    Stream<QuerySnapshot<Object?>> snapshot = userCollection
        .where("searchKey", isGreaterThanOrEqualTo: search.toLowerCase())
        .where("searchKey",
            isLessThanOrEqualTo: "${search.toLowerCase()}\uf8ff")
        .snapshots();
    return snapshot;
  }

  Future loadDiscussion(
      String snippetId, String userId, int? latestChat) async {
    if (latestChat == null) {
      QuerySnapshot snapshot = await currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .doc(userId)
          .collection("discussion")
          .orderBy("lastUpdatedMillis", descending: false)
          .get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        Map<String, dynamic> chatMessageMap = {
          "messageId": element.id,
          "message": data['message'],
          "senderUsername": data['senderUsername'],
          "senderId": data['senderId'],
          "senderDisplayName": data['senderDisplayName'],
          "date": data['date'].toDate(),
          "readBy": data['readBy'].join(","),
          "chatId": "$snippetId-$userId",
          "snippetId": snippetId,
          "lastUpdatedMillis": data['lastUpdatedMillis']
        };
        await LocalDatabase().insertChat(chatMessageMap);
      }
    } else {
      //add one millisecond to the latest chat
      QuerySnapshot snapshot = await currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .doc(userId)
          .collection("discussion")
          .where("lastUpdatedMillis", isGreaterThan: latestChat + 1)
          .orderBy("lastUpdatedMillis", descending: false)
          .get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        Map<String, dynamic> chatMessageMap = {
          "messageId": element.id,
          "message": data['message'],
          "senderUsername": data['senderUsername'],
          "senderId": data['senderId'],
          "senderDisplayName": data['senderDisplayName'],
          "date": data['date'].toDate(),
          "readBy": data['readBy'].join(","),
          "chatId": "$snippetId-$userId",
          "snippetId": snippetId,
          "lastUpdatedMillis": data['lastUpdatedMillis']
        };
        await LocalDatabase().insertChat(chatMessageMap);
      }
    }
  }

  Future getDiscussion(String snippetId, String userId, int? latestChat,
      StreamController controller) async {
    if (latestChat == null) {
      Stream<QuerySnapshot> snapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .doc(userId)
          .collection("discussion")
          .orderBy("lastUpdatedMillis", descending: false)
          .snapshots();

      snapshot.listen((event) {
        if (controller.isClosed) return;
        controller.add(event);
      });
    } else {
      //add one millisecond to the latest chat

      Stream<QuerySnapshot> snapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .doc(userId)
          .collection("discussion")
          .where("lastUpdatedMillis", isGreaterThan: latestChat + 1)
          .orderBy("lastUpdatedMillis", descending: false)
          .snapshots();

      snapshot.listen((event) {
        if (controller.isClosed) return;
        controller.add(event);
      });
    }
  }

  Future updateReadBy(String snippetId, String userId, String messageId,
      String anonymousId) async {
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .doc(messageId)
        .update({
      "readBy": FieldValue.arrayUnion([anonymousId != "" ? anonymousId : uid]),
    });
  }

  Future<String> sendDiscussionMessage(
      String snippetId, String userId, Map<String, dynamic> message) async {
    DocumentReference ref = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .add(message);
    return ref.id;
  }

  Future updateDiscussionUsers(String snippetId, String answerId,
      Map<String, dynamic> discussionUsers) async {
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(answerId)
        .update({
      "discussionUsers": FieldValue.arrayUnion([discussionUsers]),
      "lastUpdated": DateTime.now(),
      "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future addUserToDiscussion(String userId, String snippetId, String answerId,
      String snippetQuestion, String theme, bool isAnonymous) async {
    await userCollection.doc(userId).update({
      "discussions": FieldValue.arrayUnion([
        {
          "snippetId": snippetId,
          "answerId": answerId,
          "snippetQuestion": snippetQuestion,
          "theme": theme,
          "isAnonymous": isAnonymous
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

  Future getDiscussions(String userId, StreamController discStream) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    List<dynamic> discussions = userData["discussions"];

    for (var element in discussions) {
      // DocumentSnapshot snippetData =
      // await currentSnippetsCollection.doc(element["snippetId"]).get();

      DocumentSnapshot answerDoc = await currentSnippetsCollection
          .doc(element["snippetId"])
          .collection("answers")
          .doc(element["answerId"])
          .get();
      if (!answerDoc.exists) {
        //Remove discussion from user's list
        await userCollection.doc(userId).update({
          "discussions": FieldValue.arrayRemove([
            {
              "snippetId": element["snippetId"],
              "answerId": element["answerId"],
              "snippetQuestion": element["snippetQuestion"],
              "theme": element["theme"],
              "isAnonymous": element["isAnonymous"],
            }
          ]),
        });
        await LocalDatabase()
            .deleteChats("${element["snippetId"]}-${element["answerId"]}");

        continue;
      }
      Stream snippetData = currentSnippetsCollection
          .doc(element["snippetId"])
          .collection("answers")
          .doc(element["answerId"])
          .collection("discussion")
          .orderBy("date", descending: true)
          .limit(1)
          .snapshots();
      snippetData.listen((event) async {
        Map<String, dynamic> answerData =
            answerDoc.data() as Map<String, dynamic>;

        //Check if discussion is already in the list

        Map<String, dynamic> discussionsData = {};
        Map<String, dynamic> lastMessage = {};
        if (event.docs.isEmpty) {
          lastMessage = {
            "message": "No messages",
            "date": DateTime.now(),
            "senderId": "",
            "senderDisplayName": "",
            "readBy": [],
          };
        } else {
          lastMessage = event.docs[0].data() as Map<String, dynamic>;
        }
        discussionsData = {
          "snippetQuestion": element["snippetQuestion"],
          "answerUser": answerData["displayName"],
          "lastMessage": lastMessage,
          "snippetId": element["snippetId"],
          "answerId": element["answerId"],
          "theme": element["theme"],
          "answerResponse": answerData["answer"],
          "discussionUsers": answerData["discussionUsers"],
          "isAnonymous": element["isAnonymous"],
        };

        discStream.add(discussionsData);
      });
    }
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

  StreamSubscription userDataStream(StreamController streamController) {
    Stream stream = userCollection.doc(uid).snapshots();

    StreamSubscription streamListen = stream.listen((event) async {
      //if user is logged out, end stream

      await HelperFunctions.saveUserDataSF(jsonEncode(event.data()));

      streamController.add(event.data());
    }, onDone: () {});
    //On Auth State change end stream
    return streamListen;
  }

  Future updateUserDescription(String description) async {
    await userCollection.doc(uid).update({
      "description": description,
    });
  }

  Stream getUserDataStream() {
    Stream stream = userCollection.doc(uid).snapshots();
    return stream;
  }

  Future getBlankOfTheWeek(StreamController<Map<String, dynamic>> controller,
      int? lastUpdated) async {
    Stream snapshot;
    if (lastUpdated == null) {
      snapshot = botwCollection.doc("currentBlank").snapshots();
      snapshot.listen((event) {
        DocumentSnapshot snapshot = event;
        snapshot.data();
        controller.add(snapshot.data() as Map<String, dynamic>);
      });
    } else {
      snapshot = botwCollection
          .where("lastUpdatedMillis", isGreaterThan: lastUpdated)
          .snapshots();
      snapshot.listen((event) {
        //Get the first document
        if (event.docs.isNotEmpty) {
          DocumentSnapshot snapshot = event.docs[0];

          controller.add(snapshot.data() as Map<String, dynamic>);
        }
      });
    }
  }

  Future<Map<String, dynamic>?> getBlankOfTheWeekData(int? LastUpdated) async {
    DocumentSnapshot snapshot;
    if (LastUpdated == null) {
      snapshot = await botwCollection.doc("currentBlank").get();
    } else {
      snapshot = await botwCollection
          .where("lastUpdatedMillis", isGreaterThan: LastUpdated)
          .get()
          .then((value) => value.docs[0]);
    }
    if (!snapshot.exists) {
      return null;
    }
    return snapshot.data() as Map<String, dynamic>;
  }

  Future updateUsersBOTWAnswer(Map<String, dynamic> answer) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    String mondayString = "${monday.month}-${monday.day}-${monday.year}";
    if (userData["botwStatus"]["date"] != mondayString) {
      await userCollection.doc(uid).update({
        "botwStatus": {
          "date": mondayString,
          "hasAnswered": true,
          "hasSeenResults": false,
        },
        "votesLeft": 3,
      });
    }
    answer["displayName"] = userData["fullname"];

    await botwCollection.doc("currentBlank").set({
      "answers": {
        uid: answer,
      },
      "lastUpdated": DateTime.now(),
      "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  Future updateBOTWAnswer(Map<String, dynamic> answer) async {
    //Get user data
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    answer["displayName"] = userData["fullname"];

    await botwCollection.doc("currentBlank").set({
      "answers": {
        answer["userId"]: answer,
      },
      "lastUpdated": DateTime.now(),
      "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  Future updateUserVotesLeft(int votesLeft) async {
    await userCollection.doc(uid).update({
      "votesLeft": votesLeft,
    });
  }

  Future<List<Map<String, dynamic>>> getSuggestedFriends() async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    List<dynamic> friendsList = userData["friends"];

    List<String> friendsIds =
        friendsList.map((e) => e["userId"].toString()).toList();
    List<dynamic> mutualFriends = [];
    for (var element in friendsList) {
      Map<String, dynamic> friendData = (await getUserData(element["userId"]))!;
      List<dynamic> friendFriends = friendData["friends"];
      //get list where friendsFriends in friendsList

      mutualFriends = mutualFriends + friendFriends;
    }
    //Count the number of times each friend appears
    List<Map<String, dynamic>> mutualFriendsWithCount = [];
    for (var element in mutualFriends) {
      if (friendsIds.contains(element["userId"]) ||
          element["userId"] == userData["uid"]) {
        continue;
      }
      if (mutualFriendsWithCount.any((e) => e["userId"] == element["userId"])) {
        int index = mutualFriendsWithCount
            .indexWhere((e) => e["userId"] == element["userId"]);
        mutualFriendsWithCount[index]["count"] =
            mutualFriendsWithCount[index]["count"] + 1;
      } else {
        mutualFriendsWithCount.add({
          "userId": element["userId"],
          "displayName": element["displayName"],
          "username": element["username"],
          "count": 1,
        });
      }
    }
    //Remove mutualFriends with count less than 2
    mutualFriendsWithCount.removeWhere((element) => element["count"] < 2);
    //Sort the list by the number of times each friend appears

    return mutualFriendsWithCount;
  }

  Future<List<dynamic>> getDiscussionUsers(
      String snippetId, String answerId) async {
    DocumentSnapshot snapshot = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(answerId)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data["discussionUsers"] as List<dynamic>;
  }

  Future updateUserFCMToken(String FCMToken) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await userCollection.doc(uid).update({
      "FCMToken": FCMToken,
    });

    List<dynamic> friends = userData["friends"];
    List<String> friendsIds =
        friends.map((e) => e["userId"].toString()).toList();
    for (var id in friendsIds) {
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": FCMToken,
          }
        ]),
      });
    }
    List<dynamic> friendRequests = userData["friendRequests"];
    List<String> friendRequestsIds =
        friendRequests.map((e) => e["userId"].toString()).toList();
    for (var id in friendRequestsIds) {
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": FCMToken,
          }
        ]),
      });
    }
    List<dynamic> outgoingRequests = userData["outgoingRequests"];
    List<String> outgoingRequestsIds =
        outgoingRequests.map((e) => e["userId"].toString()).toList();
    for (var id in outgoingRequestsIds) {
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": FCMToken,
          }
        ]),
      });
    }
  }

  Future<Stream> getDiscussionLastMessages(
      String snippetId, String answerId, DateTime latestMessage) async {
    return currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(answerId)
        .collection("discussion")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> shareFeedback(String feedback) async {
    await FirebaseFirestore.instance.collection("feedback").add({
      "feedback": feedback,
      "date": DateTime.now(),
      "userId": uid,
    });
  }

  Future<List<Map<String, dynamic>>> getSnippetsList(
      int? lastUpdated, int? lastRecieved) async {
    QuerySnapshot snapshot;
    List<Map<String, dynamic>> snippets = [];
    if (lastUpdated == null) {
      snapshot = await currentSnippetsCollection.get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        data["snippetId"] = element.id;
        data["lastRecieved"] = data["lastRecieved"].toDate();
        data["lastUpdated"] = data["lastUpdated"].toDate();
        data["answered"] = data["answered"].contains(uid);
        snippets.add(data);
      }
    } else {
      snapshot = await currentSnippetsCollection
          .where("lastRecievedMillis", isGreaterThan: lastUpdated)
          .get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        data["snippetId"] = element.id;
        data["lastRecieved"] = data["lastRecieved"].toDate();
        data["lastUpdated"] = data["lastUpdated"].toDate();
        data["answered"] = data["answered"].contains(uid);
        snippets.add(data);
      }
      QuerySnapshot snapshot2 = await currentSnippetsCollection
          .where("lastUpdatedMillis", isGreaterThan: lastUpdated)
          .where("answered", arrayContains: uid)
          .get();
      for (var element in snapshot2.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        data["snippetId"] = element.id;
        data["lastRecieved"] = data["lastRecieved"].toDate();
        data["lastUpdated"] = data["lastUpdated"].toDate();
        data["answered"] = data["answered"].contains(uid);
        //Check if snippet is already in the list
        if (!snippets
            .any((element) => element["snippetId"] == data["snippetId"])) {
          snippets.add(data);
        } else {
          //Update the snippet in the list
          int index = snippets.indexWhere(
              (element) => element["snippetId"] == data["snippetId"]);
          snippets[index] = data;
        }
      }
    }
    return snippets;
  }

  Future<List<Map<String, dynamic>>> getSnippetResponses(
      String snippetId, int? lastUpdated, bool isAnonymous) async {
    QuerySnapshot snapshot;
    List<String> friendsList = [];
    if (!isAnonymous) {
      friendsList = await getFriendsList();
    }
    if (friendsList.isEmpty && !isAnonymous) {
      return [];
    }
    if (lastUpdated == null) {
      print("Getting all responses");
      if (isAnonymous) {
        snapshot = await currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .get();
      } else {
        snapshot = await currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .where("uid", whereIn: friendsList)
            .get();
      }
    } else {
      print("Getting new responses where lastUpdated > ${lastUpdated + 1}");
      if (isAnonymous) {
        snapshot = await currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .where("lastUpdatedMillis", isGreaterThan: lastUpdated + 1)
            .get();
      } else {
        snapshot = await currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .where("uid", whereIn: friendsList)
            .where("lastUpdatedMillis", isGreaterThan: lastUpdated + 1)
            .get();
      }
    }
    List<Map<String, dynamic>> responses = [];
    for (var element in snapshot.docs) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      data["answerId"] = element.id;
      data["date"] = data["date"].toDate();
      data["lastUpdated"] = data["lastUpdated"].toDate();
      responses.add(data);
    }
    return responses;
  }

  Future<void> addBacklog(Map<String, dynamic> snippet) async {
    await FirebaseFirestore.instance.collection("backlog").add(snippet);
  }

  Future<String> changeUserEmail(
      String oldEmail, String newEmail, String password) async {
    String res = await Auth().changeEmail(oldEmail, newEmail, password);
    if (res != "Done") {
      return res;
    }
    await userCollection.doc(uid).update({
      "email": newEmail,
    });
    //Update local user data
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    userData["email"] = newEmail;
    await HelperFunctions.saveUserDataSF(jsonEncode(userData));

    return res;
  }

  Future<bool> changeUserDisplayNameAndOrUserName(
      String? displayName, String? username) async {
    if (username != null) {
      bool usernameExists = await checkUsername(username);
      if (usernameExists) {
        return false;
      }
    }

    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();

    await userCollection.doc(uid).update({
      "fullname": displayName ?? userData["fullname"],
      "username": username ?? userData["username"],
      "searchKey": displayName != null
          ? displayName.toLowerCase()
          : userData["searchKey"],
    });

    String oldUsername = userData["username"];
    String oldDisplayName = userData["fullname"];
    if (username != null) {
      //Delete old username from usernames collection
      await publicCollection.doc("usernames").update({
        "usernames": FieldValue.arrayRemove([oldUsername]),
      });
      //Add new username to usernames collection
      await publicCollection.doc("usernames").update({
        "usernames": FieldValue.arrayUnion([username]),
      });
    }

    //Update local user data
    userData["fullname"] = displayName ?? userData["fullname"];
    userData["username"] = username ?? userData["username"];
    await HelperFunctions.saveUserDataSF(jsonEncode(userData));

    //Update BOTW answers
    DocumentSnapshot botwSnapshot =
        await botwCollection.doc("currentBlank").get();
    Map<String, dynamic> botwData = botwSnapshot.data() as Map<String, dynamic>;
    if (botwData["answers"].containsKey(uid)) {
      botwData["answers"][uid]["displayName"] =
          displayName ?? userData["fullname"];
      botwData["answers"][uid]["username"] = username ?? userData["username"];
      await botwCollection.doc("currentBlank").set({
        "answers": botwData["answers"],
        "lastUpdated": DateTime.now(),
        "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
      }, SetOptions(merge: true));
    }

    List<dynamic> friends = userData["friends"];
    List<String> friendsIds =
        friends.map((e) => e["userId"].toString()).toList();
    for (var id in friendsIds) {
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": oldDisplayName,
            "username": oldUsername,
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": displayName ?? userData["fullname"],
            "username": username ?? userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
    }
    List<dynamic> friendRequests = userData["friendRequests"];
    List<String> friendRequestsIds =
        friendRequests.map((e) => e["userId"].toString()).toList();
    for (var id in friendRequestsIds) {
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": oldDisplayName,
            "username": oldUsername,
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": displayName ?? userData["fullname"],
            "username": username ?? userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
    }
    List<dynamic> outgoingRequests = userData["outgoingRequests"];
    List<String> outgoingRequestsIds =
        outgoingRequests.map((e) => e["userId"].toString()).toList();
    for (var id in outgoingRequestsIds) {
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": oldDisplayName,
            "username": oldUsername,
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": displayName ?? userData["fullname"],
            "username": username ?? userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
    }
    return true;
  }

  Future<String?> deleteAccount(String email, String password) async {
    print("deleting account");
    String? res = await Auth().reauthenticateUser(email, password);
    if (res != null) {
      return res;
    }
    print("past auth");
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();

    List<dynamic> friends = userData["friends"];
    List<String> friendsIds =
        friends.map((e) => e["userId"].toString()).toList();
    for (var id in friendsIds) {
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
    }
    List<dynamic> friendRequests = userData["friendRequests"];
    List<String> friendRequestsIds =
        friendRequests.map((e) => e["userId"].toString()).toList();
    for (var id in friendRequestsIds) {
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
    }
    List<dynamic> outgoingRequests = userData["outgoingRequests"];
    List<String> outgoingRequestsIds =
        outgoingRequests.map((e) => e["userId"].toString()).toList();
    for (var id in outgoingRequestsIds) {
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData["fullname"],
            "username": userData["username"],
            "FCMToken": userData["FCMToken"],
          }
        ]),
      });
    }
    //Get current snippets where user answered
    QuerySnapshot snapshot = await currentSnippetsCollection
        .where("answered", arrayContains: userData["uid"])
        .get();
    //For each, delete discussion chats and then answer
    for (var doc in snapshot.docs) {
      QuerySnapshot chats = await doc.reference
          .collection("answers")
          .doc(uid!)
          .collection("discussion")
          .get();
      for (var chat in chats.docs) {
        await chat.reference.delete();
      }
      await doc.reference.collection("answers").doc(uid!).delete();
    }
    //Delete doc
    await userCollection.doc(uid!).delete();
    await Auth().deleteAccount();
    return null;
  }

  Future<void> removeOutgoingFriendRequest(
      Map<String, dynamic> request, Map<String, dynamic> userData) async {
    await userCollection.doc(userData["uid"]).update({
      "outgoingRequests": FieldValue.arrayRemove([request]),
    });
    await userCollection.doc(request["userId"]).update({
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": userData["uid"],
          "displayName": userData["fullname"],
          "username": userData["username"],
          "FCMToken": userData["FCMToken"],
        }
      ]),
    });
  }

  Future<void> removeFriendRequest(
      Map<String, dynamic> request, Map<String, dynamic> userData) async {
    await userCollection.doc(userData["uid"]).update({
      "friendRequests": FieldValue.arrayRemove([request]),
    });
    await userCollection.doc(request["userId"]).update({
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": userData["uid"],
          "displayName": userData["fullname"],
          "username": userData["username"],
          "FCMToken": userData["FCMToken"],
        }
      ]),
    });
  }

  Future<void> removeFriendFix(
      Map<String, dynamic> friend, Map<String, dynamic> userData) async {
    await userCollection.doc(userData["uid"]).update({
      "friends": FieldValue.arrayRemove([friend]),
    });
  }
}
