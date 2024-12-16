import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/api/remote_config.dart';
import 'package:snippets/constants.dart';

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

  Future savingUserData(String fullName, String email, String username) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    User newUser = User(
      FCMToken: await PushNotifications().getDeviceToken(),
      description: "Hey there! I'm using Snippets.",
      displayName: fullName,
      email: email,
      friends: [],
      friendRequests: [],
      outgoingFriendRequests: [],
      discussions: [],
      userId: uid!,
      snippetsRespondedTo: 0,
      messagesSent: 0,
      discussionsStarted: 0,
      username: username,
      searchKey: fullName.toLowerCase(),
      votesLeft: 3,
      botwStatus: BOTWStatus(
        date: "",
        hasAnswered: false,
        hasSeenResults: false,
      ),
      lastUpdatedMillis: timestamp,
    );
    await userCollection.doc(uid).set(newUser.toMap());
    await LocalDatabase().addUserData(newUser, timestamp);

    DocumentSnapshot snapshot = await publicCollection.doc("usernames").get();
    List<dynamic> usernames = snapshot["usernames"];
    usernames.add(username);
    await publicCollection.doc("usernames").update({
      "usernames": usernames,
    });
  }

  Future<User?> getUserData(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    return User.fromMap(userData);
  }

  Future<User?> getCurrentUserData(String uid, int? lastUpdatedMillis) async {
    if (lastUpdatedMillis == null) {
      DocumentSnapshot snapshot = await userCollection.doc(uid).get();
      if (!snapshot.exists) {
        return null;
      }
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      return User.fromMap(userData);
    }
    QuerySnapshot snapshot = await userCollection
        .where("uid", isEqualTo: uid)
        .where("lastUpdatedMillis", isGreaterThan: lastUpdatedMillis)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    Map<String, dynamic> userData =
        snapshot.docs[0].data() as Map<String, dynamic>;
    return User.fromMap(userData);
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

  Future<Stream<User>?> getUserStream(String userId) async {
    //Check if doc exists

    try {
      Stream snapshot = userCollection.doc(userId).snapshots();
      Stream<User> userStream = snapshot.map((event) {
        return User.fromMap(event.data() as Map<String, dynamic>);
      });

      return userStream;
    } on FirebaseException catch (_) {
      //Check if doc doesn't exist
      return null;
    }
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
          .listen((event) async {
        if (mainController.isClosed) return;
        List<Snippet> snippets = [];
        for (var element in event.docs) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          data["snippetId"] = element.id;
          String id = auth.FirebaseAuth.instance.currentUser!.uid;
          if (data["type"] == "anonymous") {
            id = await HelperFunctions.getAnonymousIDFromSF() ?? "";
          }
          data["answered"] = data["answered"].contains(id);
          snippets.add(Snippet.fromMap(data));
        }
        controller.add(snippets);
      });
      return;
    }
    currentSnippetsCollection.snapshots().listen((event) async {
      if (mainController.isClosed) return;
      List<Snippet> snippets = [];
      for (var element in event.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        data["snippetId"] = element.id;
        String id = auth.FirebaseAuth.instance.currentUser!.uid;
        if (data["type"] == "anonymous") {
          id = await HelperFunctions.getAnonymousIDFromSF() ?? "";
        }
        data["answered"] = data["answered"].contains(id);
        snippets.add(Snippet.fromMap(data));
      }

      controller.add(snippets);
    });
  }

  Future submitAnswer(String snippetId, String answer, String question,
      String theme, String? id) async {
    User userData = await Database().getUserData(uid!);
    DateTime now = DateTime.now();
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(id ?? uid)
        .set({
      "answer": answer,
      "displayName": id == null ? userData.displayName : "Anonymous",
      "uid": id ?? uid,
      "discussionUsers": id == null
          ? [
              {
                "userId": uid,
                "FCMToken": userData.FCMToken,
              }
            ]
          : [],
      "date": now,
      "lastUpdated": now,
      "lastUpdatedMillis": now.millisecondsSinceEpoch,
    });
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
        "snippetsRespondedTo": FieldValue.increment(1),
        "lastUpdatedMillis": now.millisecondsSinceEpoch,
      });
      // await LocalDatabase().addDiscussionToUser(
      //     uid!,
      //     Discussion(
      //         answerId: uid!,
      //         isAnonymous: false,
      //         snippetId: snippetId,
      //         snippetQuestion: question),
      //     now.millisecondsSinceEpoch);
    }

    //Add uid to snippet's answered list

    await currentSnippetsCollection.doc(snippetId).update({
      "answered": FieldValue.arrayUnion([id ?? uid]),
      "lastUpdated": now,
      "lastUpdatedMillis": now.millisecondsSinceEpoch,
    });

    //Send notification to user's friends

    if (id == null) {
      List<UserMini> friendsList = userData.friends;
      List<String> friendsFCMTokens =
          friendsList.map((e) => e.FCMToken).toList();
      List<NotificationText> possibleNotifications =
          await RemoteConfig(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getPossibleSnippetResponseNotifications();
      if (possibleNotifications.isEmpty) {
        possibleNotifications = [
          NotificationText(
              title: "Look who answered a snippet!",
              body: "{displayName} answered the snippet: {question}"),
          NotificationText(
              title: "New snippet response!",
              body: "{displayName} answered the snippet: {question}"),
        ];
      }
      int randomIndex = Random().nextInt(possibleNotifications.length);
      NotificationText notification = possibleNotifications[randomIndex];
      String notificationTitle = notification.title
          .replaceAll("{displayName}", userData.displayName)
          .replaceAll("{question}", question);
      String notificationBody = notification.body
          .replaceAll("{displayName}", userData.displayName)
          .replaceAll("{question}", question);

      PushNotifications().sendNotification(
          title: notificationTitle,
          body: notificationBody,
          thread: "snippet-$snippetId",
          targetIds: [
            ...friendsFCMTokens,
          ],
          data: {
            "type": "snippetAnswered",
            "snippetId": snippetId,
            "question": question.replaceAll("?", "~"),
            "theme": "blue",
            "snippetType": id != null ? "anonymous" : "normal",
            "displayName": userData.displayName,
            "uid": userData.userId,
            "response": answer,
            "answered": "false",
          });
    }
    if (Platform.isIOS) {
      if (await WidgetKit.getItem(
              'snippetsResponsesData', 'group.kazoom_snippets') ==
          null) {
        List<String> oldResponses = [];
        String responseString =
            "${userData.displayName}|$question|$answer|$snippetId|${id ?? uid}|${id != null ? "anonymous" : "normal"}|${true}";
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
            "${userData.displayName}|$question|$answer|$snippetId|${id ?? uid}|${id != null ? "anonymous" : "normal"}|${true}";
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
  }

  Future<List<String>> getFriendsList() async {
    User userData = await Database().getUserData(uid!);
    List<UserMini> friendsList = userData.friends;
    //Map each element to a string
    return friendsList.map((e) => e.userId).toList();
  }

  Future<List<UserMini>> getFriendsListMap() async {
    User userData = await Database().getUserData(uid!);

    return userData.friends;
  }

  Future<void> getResponsesList(
      String snippetId,
      int? date,
      bool getFriends,
      List<String> friendsToGet,
      bool isAnonymous,
      StreamController<List<SnippetResponse>> controller) async {
    //Then the rest of the responses from friends
    List<String> friendsList = [];
    if (!isAnonymous) {
      friendsList = await getFriendsList();
    }
    if (date == null) {
      if (friendsList.isEmpty && !isAnonymous) {
        return;
      }
      List<Stream<QuerySnapshot>> streams = [];
      if (isAnonymous) {
        Stream<QuerySnapshot> querySnapshot = currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .snapshots();
        streams.add(querySnapshot);
      } else {
        if (friendsList.isEmpty) {
          return;
        }
        List<List<String>> chunks = [];
        for (var i = 0; i < friendsList.length; i += 30) {
          chunks.add(
            friendsList.sublist(
              i,
              i + 30 > friendsList.length ? friendsList.length : i + 30,
            ),
          );
        }

        // Create stream for each chunk
        List<Stream<QuerySnapshot>> chunkStreams = chunks.map((chunk) {
          return currentSnippetsCollection
              .doc(snippetId)
              .collection("answers")
              .where("uid", whereIn: chunk)
              .snapshots();
        }).toList();
        streams.addAll(chunkStreams);
      }

      for (var stream in streams) {
        stream.listen((event) {
          if (controller.isClosed) return;
          List<SnippetResponse> responses = [];
          for (var element in event.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            data["snippetId"] = snippetId;
            responses.add(SnippetResponse.fromMap(data));
          }

          controller.add(responses);
        });
      }
    }
    if (getFriends && !isAnonymous) {
      List<Stream<QuerySnapshot>> streams = [];
      List<List<String>> chunks = [];
      for (var i = 0; i < friendsToGet.length; i += 30) {
        chunks.add(
          friendsToGet.sublist(
            i,
            i + 30 > friendsToGet.length ? friendsToGet.length : i + 30,
          ),
        );
      }

      // Create stream for each chunk
      List<Stream<QuerySnapshot>> chunkStreams = chunks.map((chunk) {
        return currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .where("uid", whereIn: chunk)
            .snapshots();
      }).toList();
      streams.addAll(chunkStreams);

      for (var stream in streams) {
        stream.listen((event) {
          if (controller.isClosed) return;
          List<SnippetResponse> responses = [];
          for (var element in event.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            data["snippetId"] = snippetId;
            responses.add(SnippetResponse.fromMap(data));
          }
          controller.add(responses);
        });
      }
    }
    List<Stream<QuerySnapshot>> streams = [];
    if (isAnonymous) {
      Stream<QuerySnapshot> querySnapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .where("lastUpdatedMillis", isGreaterThan: date)
          .snapshots();
      streams.add(querySnapshot);
    } else {
      if (friendsList.isEmpty) {
        return;
      }
      List<List<String>> chunks = [];
      for (var i = 0; i < friendsList.length; i += 30) {
        chunks.add(
          friendsList.sublist(
            i,
            i + 30 > friendsList.length ? friendsList.length : i + 30,
          ),
        );
      }

      // Create stream for each chunk
      List<Stream<QuerySnapshot>> chunkStreams = chunks.map((chunk) {
        return currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .where("uid", whereIn: chunk)
            .where("lastUpdatedMillis", isGreaterThan: date)
            .snapshots();
      }).toList();

      streams.addAll(chunkStreams);
    }

    for (var stream in streams) {
      stream.listen((event) {
        if (controller.isClosed) return;
        List<SnippetResponse> responses = [];
        for (var element in event.docs) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          data["snippetId"] = snippetId;
          responses.add(SnippetResponse.fromMap(data));
        }
        controller.add(responses);
      });
    }
  }

  Future<SnippetResponse> getSnippetResponse(
      String snippetId, String userId) async {
    DocumentSnapshot snapshot = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data["snippetId"] = snippetId;
    return SnippetResponse.fromMap(data);
  }

  Future<SnippetResponse?> getSnippetResponseLatest(
      String snippetId, String userId, int lastUpdatedMillis) async {
    QuerySnapshot snapshot = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .where("uid", isEqualTo: userId)
        .where("lastUpdatedMillis", isGreaterThan: lastUpdatedMillis)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    Map<String, dynamic> data = snapshot.docs[0].data() as Map<String, dynamic>;
    data["snippetId"] = snippetId;
    return SnippetResponse.fromMap(data);
  }

  Future sendFriendRequest(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    User userData = await Database().getUserData(uid!);
    int lastUpdated = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(friendUid).update({
      "friendRequests": FieldValue.arrayUnion(
        [
          {
            "userId": uid,
            "FCMToken": userData.FCMToken,
            "displayName": userData.displayName,
            "username": userData.username,
          }
        ],
      ),
      "lastUpdatedMillis": lastUpdated,
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
      "lastUpdatedMillis": lastUpdated,
    });

    await LocalDatabase().addOutgoingFriendToUser(
        uid!,
        UserMini(
          userId: friendUid,
          displayName: friendDisplayName,
          username: friendUsername,
          FCMToken: friendFCMToken,
        ),
        lastUpdated);

    PushNotifications().sendNotification(
        title: "New friend request!",
        body: "${userData.displayName} wants to be your friend!",
        thread: "friend",
        targetIds: [
          friendFCMToken
        ],
        data: {
          "type": "friendRequest",
          "userId": uid,
          "displayName": userData.displayName,
          "username": userData.username,
          "FCMToken": userData.FCMToken,
        });
  }

  Future acceptFriendRequest(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    User userData = await Database().getUserData(uid!);
    int lastUpdated = DateTime.now().millisecondsSinceEpoch;
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
      ]),
      "lastUpdatedMillis": lastUpdated,
    });

    await LocalDatabase().addFriendToUser(
        uid!,
        UserMini(
          userId: friendUid,
          displayName: friendDisplayName,
          username: friendUsername,
          FCMToken: friendFCMToken,
        ),
        lastUpdated);
    // await LocalDatabase()
    //     .removeOutgoingFriendFromUser(uid!, friendUid, lastUpdated);

    await userCollection.doc(friendUid).update({
      "friends": FieldValue.arrayUnion([
        {
          "userId": uid,
          "displayName": userData.displayName,
          "username": userData.username,
          "FCMToken": userData.FCMToken,
        }
      ]),
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": userData.displayName,
          "username": userData.username,
          "FCMToken": userData.FCMToken,
        }
      ]),
      "lastUpdatedMillis": lastUpdated,
    });

    PushNotifications().sendNotification(
        title: "Friend request accepted!",
        body: "${userData.displayName} accepted your friend request!",
        thread: "friend",
        targetIds: [
          friendFCMToken
        ],
        data: {
          "type": "friendRequestAccepted",
          "userId": uid,
          "displayName": userData.displayName,
          "username": userData.username,
        });
  }

  Future declineFriendRequest(String friendUid, String friendFCMToken,
      String friendDisplayName, String friendUsername) async {
    User userData = await Database().getUserData(uid!);
    int lastUpdated = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(uid).update({
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "FCMToken": friendFCMToken,
          "displayName": friendDisplayName,
          "username": friendUsername,
        }
      ]),
      "lastUpdatedMillis": lastUpdated,
    });

    await LocalDatabase()
        .removeIncomingFriendRequestFromUser(uid!, friendUid, lastUpdated);

    await userCollection.doc(friendUid).update({
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": userData.displayName,
          "username": userData.username,
          "FCMToken": userData.FCMToken,
        }
      ]),
      "lastUpdatedMillis": lastUpdated,
    });
  }

  Future removeFriend(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    User userData = await Database().getUserData(uid!);
    int lastUpdated = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(uid).update({
      "friends": FieldValue.arrayRemove([
        {
          "userId": friendUid,
          "displayName": friendDisplayName,
          "username": friendUsername,
          "FCMToken": friendFCMToken,
        }
      ]),
      "lastUpdatedMillis": lastUpdated,
    });

    await LocalDatabase().removeFriendFromUser(uid!, friendUid, lastUpdated);

    await userCollection.doc(friendUid).update({
      "friends": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": userData.displayName,
          "username": userData.username,
          "FCMToken": userData.FCMToken,
        }
      ]),
      "lastUpdatedMillis": lastUpdated,
    });
  }

  Future<bool> checkFriendRequest(String friendUid) async {
    User userData = await Database().getUserData(uid!);
    List<UserMini> friendRequests = userData.friendRequests;
    for (var element in friendRequests) {
      if (element.userId == friendUid) {
        return true;
      }
    }
    return false;
  }

  Future cancelFriendRequest(String friendUid, String friendDisplayName,
      String friendUsername, String friendFCMToken) async {
    User userData = await Database().getUserData(uid!);
    int lastUpdated = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(friendUid).update({
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "FCMToken": userData.FCMToken,
          "displayName": userData.displayName,
          "username": userData.username,
        }
      ]),
      "lastUpdatedMillis": lastUpdated,
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
      "lastUpdatedMillis": lastUpdated,
    });

    await LocalDatabase()
        .removeOutgoingFriendFromUser(uid!, friendUid, lastUpdated);
  }

  Future<Stream<List<User>>> searchUsers(String search) async {
    //Order alphabetically
    Stream<List<User>> snapshot = userCollection
        .where("searchKey", isGreaterThanOrEqualTo: search.toLowerCase())
        .where("searchKey",
            isLessThanOrEqualTo: "${search.toLowerCase()}\uf8ff")
        .snapshots()
        .map((event) {
      List<User> users = [];
      for (var element in event.docs) {
        users.add(User.fromMap(element.data() as Map<String, dynamic>));
      }
      return users;
    });

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
          "readBy": data['readBy'],
          "discussionId": "$snippetId-$userId",
          "snippetId": snippetId,
          "lastUpdatedMillis": data['lastUpdatedMillis']
        };
        await LocalDatabase().insertChat(Message.fromMap(chatMessageMap));
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
          "readBy": data['readBy'],
          "discussionId": "$snippetId-$userId",
          "snippetId": snippetId,
          "lastUpdatedMillis": data['lastUpdatedMillis']
        };
        await LocalDatabase().insertChat(Message.fromMap(chatMessageMap));
      }
    }
  }

  Future getDiscussion(String snippetId, String userId, int? latestChat,
      StreamController<List<Message>> controller) async {
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
        List<Message> messages = [];
        for (var element in event.docs) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;

          Map<String, dynamic> chatMessageMap = {
            "messageId": element.id,
            "message": data['message'],
            "senderUsername": data['senderUsername'],
            "senderId": data['senderId'],
            "senderDisplayName": data['senderDisplayName'],
            "date": data['date'].toDate(),
            "readBy": data['readBy'],
            "discussionId": "$snippetId-$userId",
            "snippetId": snippetId,
            "lastUpdatedMillis": data['lastUpdatedMillis']
          };
          messages.add(Message.fromMap(chatMessageMap));
        }
        controller.add(messages);
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
        List<Message> messages = [];
        for (var element in event.docs) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;

          Map<String, dynamic> chatMessageMap = {
            "messageId": element.id,
            "message": data['message'],
            "senderUsername": data['senderUsername'],
            "senderId": data['senderId'],
            "senderDisplayName": data['senderDisplayName'],
            "date": data['date'].toDate(),
            "readBy": data['readBy'],
            "discussionId": "$snippetId-$userId",
            "snippetId": snippetId,
            "lastUpdatedMillis": data['lastUpdatedMillis']
          };
          messages.add(Message.fromMap(chatMessageMap));
        }
        controller.add(messages);
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
      String snippetId, String userId, Message message) async {
    DocumentReference ref = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .add(message.toMap());

    //Update messagesSent count
    await userCollection.doc(uid).update({
      "messagesSent": FieldValue.increment(1),
    });
    return ref.id;
  }

  Future updateDiscussionUsers(
      String snippetId, String answerId, DiscussionUser discussionUsers) async {
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(answerId)
        .update({
      "discussionUsers": FieldValue.arrayUnion([discussionUsers.toMap()]),
      "lastUpdated": DateTime.now(),
      "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future addUserToDiscussion(
      String userId,
      String snippetId,
      String answerId,
      String snippetQuestion,
      String theme,
      bool isAnonymous,
      bool createdDiscussion) async {
    int lastUpdatedMillis = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(userId).update({
      "discussions": FieldValue.arrayUnion([
        {
          "snippetId": snippetId,
          "answerId": answerId,
          "snippetQuestion": snippetQuestion,
          "theme": theme,
          "isAnonymous": isAnonymous
        },
      ]),
      "discussionsStarted":
          createdDiscussion ? FieldValue.increment(1) : FieldValue.increment(0),
      "lastUpdatedMillis": lastUpdatedMillis,
    });

//Update user's discussion list in the local database

    await LocalDatabase().addDiscussionToUser(
        uid!,
        Discussion(
            answerId: userId,
            isAnonymous: isAnonymous,
            snippetId: snippetId,
            snippetQuestion: snippetQuestion),
        lastUpdatedMillis);
  }

  Future getDiscussions(
      String userId, StreamController<DiscussionFull> discStream) async {
    User userData = await Database().getUserData(uid!);
    List<Discussion> discussions = userData.discussions;

    for (var element in discussions) {
      // DocumentSnapshot snippetData =
      // await currentSnippetsCollection.doc(element["snippetId"]).get();

      DocumentSnapshot answerDoc = await currentSnippetsCollection
          .doc(element.snippetId)
          .collection("answers")
          .doc(element.answerId)
          .get();
      if (!answerDoc.exists) {
        int lastUpdatedMillis = DateTime.now().millisecondsSinceEpoch;
        //Remove discussion from user's list

        await userCollection.doc(userId).update({
          "discussions": FieldValue.arrayRemove([
            {
              "snippetId": element.snippetId,
              "answerId": element.answerId,
              "snippetQuestion": element.snippetQuestion,
              "isAnonymous": element.isAnonymous,
              "theme": "blue"
            }
          ]),
          "lastUpdatedMillis": lastUpdatedMillis,
        });
        await LocalDatabase().removeDiscussionFromUser(
            userId,
            Discussion(
                answerId: element.answerId,
                isAnonymous: element.isAnonymous,
                snippetId: element.snippetId,
                snippetQuestion: element.snippetQuestion),
            lastUpdatedMillis);
        await LocalDatabase()
            .deleteChats("${element.snippetId}-${element.answerId}");

        continue;
      }
      Stream snippetData = currentSnippetsCollection
          .doc(element.snippetId)
          .collection("answers")
          .doc(element.answerId)
          .collection("discussion")
          .orderBy("date", descending: true)
          .limit(1)
          .snapshots();
      snippetData.listen((event) async {
        Map<String, dynamic> answerData =
            answerDoc.data() as Map<String, dynamic>;
        Message lastMessage;

        //Check if discussion is already in the list

        DiscussionFull discussionsData;

        if (event.docs.isEmpty) {
          lastMessage = Message(
            message: "No messages",
            date: DateTime.now(),
            senderId: "",
            senderDisplayName: "",
            readBy: [],
            senderUsername: "",
            messageId: "",
            snippetId: "",
            lastUpdatedMillis: 0,
            discussionId: "",
          );
        } else {
          Map<String, dynamic> data =
              event.docs[0].data() as Map<String, dynamic>;
          Map<String, dynamic> chatMessageMap = {
            "messageId": event.docs[0].id,
            "message": data['message'],
            "senderUsername": data['senderUsername'],
            "senderId": data['senderId'],
            "senderDisplayName": data['senderDisplayName'],
            "date": data['date'].toDate(),
            "readBy": data['readBy'],
            "discussionId": "${element.snippetId}-$userId",
            "snippetId": element.snippetId,
            "lastUpdatedMillis": data['lastUpdatedMillis']
          };
          lastMessage = Message.fromMap(chatMessageMap);
        }
        List<DiscussionUser> discussionUsers = [];
        for (var element in answerData["discussionUsers"]) {
          discussionUsers.add(DiscussionUser.fromMap(element));
        }
        discussionsData = DiscussionFull(
          snippetQuestion: element.snippetQuestion,
          answerDisplayName: answerData["displayName"],
          lastMessage: lastMessage,
          snippetId: element.snippetId,
          answerId: element.answerId,
          answer: answerData["answer"],
          discussionUsers: discussionUsers,
          isAnonymous: element.isAnonymous,
        );
        // discussionsData = {
        //   "snippetQuestion": element["snippetQuestion"],
        //   "answerUser": answerData["displayName"],
        //   "lastMessage": lastMessage,
        //   "snippetId": element["snippetId"],
        //   "answerId": element["answerId"],
        //   "theme": element["theme"],
        //   "answerResponse": answerData["answer"],
        //   "discussionUsers": answerData["discussionUsers"],
        //   "isAnonymous": element["isAnonymous"],
        // };

        discStream.add(discussionsData);
      });
    }
  }

  Future<Message> getLastDiscussionMessage(
      String snippetId, String userId) async {
    QuerySnapshot snapshot = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(userId)
        .collection("discussion")
        .orderBy("date", descending: true)
        .limit(1)
        .get();
    Map<String, dynamic> data = snapshot.docs[0].data() as Map<String, dynamic>;
    Map<String, dynamic> chatMessageMap = {
      "messageId": snapshot.docs[0].id,
      "message": data['message'],
      "senderUsername": data['senderUsername'],
      "senderId": data['senderId'],
      "senderDisplayName": data['senderDisplayName'],
      "date": data['date'].toDate(),
      "readBy": data['readBy'],
      "discussionId": "$snippetId-$userId",
      "snippetId": snippetId,
      "lastUpdatedMillis": data['lastUpdatedMillis']
    };
    return Message.fromMap(chatMessageMap);
  }

  Future updateUserDescription(String description) async {
    int lastUpdated = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(uid).update({
      "description": description,
      "lastUpdatedMillis": lastUpdated,
    });
    await LocalDatabase().updateUserDescription(uid!, description, lastUpdated);
  }

  Stream<User> getUserDataStream() {
    Stream<User> stream = userCollection.doc(uid).snapshots().map((event) {
      return User.fromMap(event.data() as Map<String, dynamic>);
    });
    return stream;
  }

  Future getBlankOfTheWeek(
      StreamController<BOTW> controller, int? lastUpdated) async {
    Stream snapshot;

    snapshot = botwCollection.doc("currentBlank").snapshots();
    snapshot.listen((event) {
      DocumentSnapshot snapshot = event;
      snapshot.data();

      controller.add(BOTW.fromMap(snapshot.data() as Map<String, dynamic>));
    });
  }

  Future<BOTW?> getBlankOfTheWeekData(int? LastUpdated) async {
    DocumentSnapshot? snapshot;
    if (LastUpdated == null) {
      snapshot = await botwCollection.doc("currentBlank").get();
    } else {
      snapshot = await botwCollection
          .where("lastUpdatedMillis", isGreaterThan: LastUpdated)
          .get()
          .then((value) => value.docs.isNotEmpty ? value.docs[0] : null);
    }
    if (snapshot == null) {
      return null;
    }
    return BOTW.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future updateUsersBOTWAnswer(BOTWAnswer answer) async {
    User userData = await Database().getUserData(uid!);
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    String mondayString = "${monday.month}-${monday.day}-${monday.year}";
    if (userData.botwStatus.date != mondayString) {
      int lastUpdated = DateTime.now().millisecondsSinceEpoch;
      await userCollection.doc(uid).update({
        "botwStatus": {
          "date": mondayString,
          "hasAnswered": true,
          "hasSeenResults": false,
        },
        "votesLeft": 3,
        "lastUpdatedMillis": lastUpdated,
      });

      await LocalDatabase().updateUserBOTWStatus(
          uid!,
          BOTWStatus(
              date: mondayString, hasAnswered: true, hasSeenResults: false),
          lastUpdated);
      await LocalDatabase().updateUserVotes(uid!, 3, lastUpdated);
    }
    answer.displayName = userData.displayName;

    await botwCollection.doc("currentBlank").set({
      "answers": {
        uid: answer.toMap(),
      },
      "lastUpdated": DateTime.now(),
      "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  Future updateBOTWAnswer(BOTWAnswer answer) async {
    //Get user data

    await botwCollection.doc("currentBlank").set({
      "answers": {
        answer.userId: answer.toMap(),
      },
      "lastUpdated": DateTime.now(),
      "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  Future updateUserVotesLeft(int votesLeft) async {
    int lastUpdated = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(uid).update({
      "votesLeft": votesLeft,
      "lastUpdatedMillis": lastUpdated,
    });
    await LocalDatabase().updateUserVotes(uid!, votesLeft, lastUpdated);
  }

  Future<List<Map<String, dynamic>>> getSuggestedFriends() async {
    User userData = await Database().getUserData(uid!);
    List<UserMini> friendsList = userData.friends;

    List<String> friendsIds = friendsList.map((e) => e.userId).toList();
    List<UserMini> mutualFriends = [];
    for (var element in friendsList) {
      User friendData = (await getUserData(element.userId))!;
      List<UserMini> friendFriends = friendData.friends;
      //get list where friendsFriends in friendsList

      mutualFriends = mutualFriends + friendFriends;
    }
    //Count the number of times each friend appears
    List<Map<String, dynamic>> mutualFriendsWithCount = [];
    for (var element in mutualFriends) {
      if (friendsIds.contains(element.userId) ||
          element.userId == userData.userId) {
        continue;
      }
      if (mutualFriendsWithCount.any((e) => e["userId"] == element.userId)) {
        int index = mutualFriendsWithCount
            .indexWhere((e) => e["userId"] == element.userId);
        mutualFriendsWithCount[index]["count"] =
            mutualFriendsWithCount[index]["count"] + 1;
      } else {
        mutualFriendsWithCount.add({
          "userId": element.userId,
          "displayName": element.displayName,
          "username": element.username,
          "count": 1,
        });
      }
    }
    //Remove mutualFriends with count less than 2
    mutualFriendsWithCount.removeWhere((element) => element["count"] < 2);
    //Sort the list by the number of times each friend appears
    mutualFriendsWithCount.sort((a, b) => b["count"].compareTo(a["count"]));

    return mutualFriendsWithCount;
  }

  Future<List<DiscussionUser>> getDiscussionUsers(
      String snippetId, String answerId) async {
    DocumentSnapshot snapshot = await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(answerId)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    data["snippetId"] = snippetId;
    SnippetResponse response = SnippetResponse.fromMap(data);
    return response.discussionUsers;
  }

  Future updateUserFCMToken(String FCMToken) async {
    User userData = await Database().getUserData(uid!);
    int lastUpdated = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(uid).update({
      "FCMToken": FCMToken,
      "lastUpdatedMillis": lastUpdated,
    });
    await LocalDatabase().updateUserFCMToken(uid!, FCMToken, lastUpdated);

    List<UserMini> friends = userData.friends;
    List<String> friendsIds = friends.map((e) => e.userId).toList();
    for (var id in friendsIds) {
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": FCMToken,
          }
        ]),
        "lastUpdatedMillis": lastUpdated,
      });
    }
    List<UserMini> friendRequests = userData.friendRequests;
    List<String> friendRequestsIds =
        friendRequests.map((e) => e.userId).toList();
    for (var id in friendRequestsIds) {
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": FCMToken,
          }
        ]),
        "lastUpdatedMillis": lastUpdated,
      });
    }
    List<UserMini> outgoingRequests = userData.outgoingFriendRequests;
    List<String> outgoingRequestsIds =
        outgoingRequests.map((e) => e.userId).toList();
    for (var id in outgoingRequestsIds) {
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": FCMToken,
          }
        ]),
        "lastUpdatedMillis": lastUpdated,
      });
    }
  }

  Future<void> shareFeedback(String feedback) async {
    await FirebaseFirestore.instance.collection("feedback").add({
      "feedback": feedback,
      "date": DateTime.now(),
      "userId": uid,
    });
  }

  Future<List<Snippet>> getSnippetsList(
      int? lastUpdated, int? lastRecieved) async {
    QuerySnapshot snapshot;
    List<Snippet> snippets = [];
    if (lastUpdated == null) {
      snapshot = await currentSnippetsCollection.get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        data["snippetId"] = element.id;
        data["lastRecieved"] = data["lastRecieved"].toDate();
        data["lastUpdated"] = data["lastUpdated"].toDate();
        String id = auth.FirebaseAuth.instance.currentUser!.uid;
        if (data["type"] == "anonymous") {
          id = await HelperFunctions.getAnonymousIDFromSF() ?? "";
        }
        data["answered"] = data["answered"].contains(id);
        snippets.add(Snippet.fromMap(data));
      }
    } else {
      snapshot = await currentSnippetsCollection
          .where("lastRecievedMillis", isGreaterThan: lastRecieved! + 1)
          .get();
      for (var element in snapshot.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        data["snippetId"] = element.id;
        data["lastRecieved"] = data["lastRecieved"].toDate();
        data["lastUpdated"] = data["lastUpdated"].toDate();
        String id = auth.FirebaseAuth.instance.currentUser!.uid;
        if (data["type"] == "anonymous") {
          id = await HelperFunctions.getAnonymousIDFromSF() ?? "";
        }
        data["answered"] = data["answered"].contains(id);
        snippets.add(Snippet.fromMap(data));
      }
      QuerySnapshot snapshot2 = await currentSnippetsCollection
          .where("lastUpdatedMillis", isGreaterThan: lastUpdated + 1)
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
            .any((element) => element.snippetId == data["snippetId"])) {
          snippets.add(Snippet.fromMap(data));
        } else {
          //Update the snippet in the list
          int index = snippets
              .indexWhere((element) => element.snippetId == data["snippetId"]);

          snippets[index] = Snippet.fromMap(data);
        }
      }
    }
    return snippets;
  }

  Future<List<SnippetResponse>> getSnippetResponses(
      String snippetId, int? lastUpdated, bool isAnonymous) async {
    if (lastUpdated == null && isAnonymous) {
      QuerySnapshot snapshot = await currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .get();
      return _processAnswerSnapshot(snapshot, snippetId);
    } else if (isAnonymous) {
      QuerySnapshot snapshot = await currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .where("lastUpdatedMillis", isGreaterThan: lastUpdated! + 1)
          .get();

      return _processAnswerSnapshot(snapshot, snippetId);
    }
    // Get friends list and handle empty case
    List<String> friendsList = await getFriendsList();
    if (friendsList.isEmpty) return [];

    // Split friends list into chunks of 30
    List<List<String>> chunks = [];
    for (var i = 0; i < friendsList.length; i += 30) {
      chunks.add(
        friendsList.sublist(
          i,
          i + 30 > friendsList.length ? friendsList.length : i + 30,
        ),
      );
    }

    // Query each chunk and combine results
    List<SnippetResponse> allAnswers = [];
    for (var chunk in chunks) {
      QuerySnapshot snapshot;
      if (lastUpdated == null) {
        snapshot = await currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .where("uid", whereIn: chunk)
            .get();
      } else {
        snapshot = await currentSnippetsCollection
            .doc(snippetId)
            .collection("answers")
            .where("uid", whereIn: chunk)
            .where("lastUpdatedMillis", isGreaterThan: lastUpdated + 1)
            .get();
      }
      allAnswers.addAll(_processAnswerSnapshot(snapshot, snippetId));
    }

    return allAnswers;
  }

  List<SnippetResponse> _processAnswerSnapshot(
      QuerySnapshot snapshot, String snippetId) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data["answerId"] = doc.id;
      data["date"] = data["date"].toDate();
      data["lastUpdated"] = data["lastUpdated"].toDate();

      data["snippetId"] = snippetId;
      return SnippetResponse.fromMap(data);
    }).toList();
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
    int lastUpdatedMillis = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(uid).update({
      "email": newEmail,
      "lastUpdatedMillis": lastUpdatedMillis,
    });
    //Update local user data
    User userData = await Database().getUserData(uid!);
    userData.email = newEmail;
    await LocalDatabase().updateUserData(userData, lastUpdatedMillis);

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

    User userData = await Database().getUserData(uid!);
    int lastUpdatedMillis = DateTime.now().millisecondsSinceEpoch;

    await userCollection.doc(uid).update({
      "fullname": displayName ?? userData.displayName,
      "username": username ?? userData.username,
      "searchKey":
          displayName != null ? displayName.toLowerCase() : userData.searchKey,
      "lastUpdatedMillis": lastUpdatedMillis,
    });

    String oldUsername = userData.username;
    String oldDisplayName = userData.displayName;
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
    userData.displayName = displayName ?? userData.displayName;
    userData.username = username ?? userData.username;
    await LocalDatabase().updateUserData(userData, lastUpdatedMillis);

    //Update BOTW answers
    DocumentSnapshot botwSnapshot =
        await botwCollection.doc("currentBlank").get();
    Map<String, dynamic> botwData = botwSnapshot.data() as Map<String, dynamic>;
    if (botwData["answers"].containsKey(uid)) {
      botwData["answers"][uid]["displayName"] =
          displayName ?? userData.displayName;
      botwData["answers"][uid]["username"] = username ?? userData.username;
      await botwCollection.doc("currentBlank").set({
        "answers": botwData["answers"],
        "lastUpdated": DateTime.now(),
        "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
      }, SetOptions(merge: true));
    }

    List<UserMini> friends = userData.friends;
    List<String> friendsIds = friends.map((e) => e.userId).toList();
    for (var id in friendsIds) {
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": oldDisplayName,
            "username": oldUsername,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": displayName ?? userData.displayName,
            "username": username ?? userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
        "lastUpdatedMillis": lastUpdatedMillis,
      });
    }
    List<UserMini> friendRequests = userData.friendRequests;
    List<String> friendRequestsIds =
        friendRequests.map((e) => e.userId).toList();
    for (var id in friendRequestsIds) {
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": oldDisplayName,
            "username": oldUsername,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": displayName ?? userData.displayName,
            "username": username ?? userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
        "lastUpdatedMillis": lastUpdatedMillis,
      });
    }
    List<UserMini> outgoingRequests = userData.outgoingFriendRequests;
    List<String> outgoingRequestsIds =
        outgoingRequests.map((e) => e.userId).toList();
    for (var id in outgoingRequestsIds) {
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": oldDisplayName,
            "username": oldUsername,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayUnion([
          {
            "userId": uid,
            "displayName": displayName ?? userData.displayName,
            "username": username ?? userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
        "lastUpdatedMillis": lastUpdatedMillis,
      });
    }
    return true;
  }

  Future<String?> deleteAccount(String email, String password) async {
    String? res = await Auth().reauthenticateUser(email, password);
    if (res != null) {
      return res;
    }

    User userData = await Database().getUserData(uid!);

    List<UserMini> friends = userData.friends;
    List<String> friendsIds = friends.map((e) => e.userId).toList();
    for (var id in friendsIds) {
      await userCollection.doc(id).update({
        "friends": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
    }
    List<UserMini> friendRequests = userData.friendRequests;
    List<String> friendRequestsIds =
        friendRequests.map((e) => e.userId).toList();
    for (var id in friendRequestsIds) {
      await userCollection.doc(id).update({
        "friendRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
    }
    List<UserMini> outgoingRequests = userData.outgoingFriendRequests;
    List<String> outgoingRequestsIds =
        outgoingRequests.map((e) => e.userId).toList();
    for (var id in outgoingRequestsIds) {
      await userCollection.doc(id).update({
        "outgoingRequests": FieldValue.arrayRemove([
          {
            "userId": uid,
            "displayName": userData.displayName,
            "username": userData.username,
            "FCMToken": userData.FCMToken,
          }
        ]),
      });
    }
    //Get current snippets where user answered
    QuerySnapshot snapshot = await currentSnippetsCollection
        .where("answered", arrayContains: userData.userId)
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
      UserMini request, User userData) async {
    int lastUpdatedMillis = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(userData.userId).update({
      "outgoingRequests": FieldValue.arrayRemove([request.toMap()]),
      "lastUpdatedMillis": lastUpdatedMillis,
    });
    await userCollection.doc(request.userId).update({
      "friendRequests": FieldValue.arrayRemove([
        {
          "userId": userData.userId,
          "displayName": userData.displayName,
          "username": userData.username,
          "FCMToken": userData.FCMToken,
        }
      ]),
      "lastUpdatedMillis": lastUpdatedMillis,
    });
    await LocalDatabase()
        .removeOutgoingFriendFromUser(uid!, request.userId, lastUpdatedMillis);
  }

  Future<void> removeFriendRequest(UserMini request, User userData) async {
    int lastUpdatedMillis = DateTime.now().millisecondsSinceEpoch;
    await userCollection.doc(userData.userId).update({
      "friendRequests": FieldValue.arrayRemove([request.toMap()]),
      "lastUpdatedMillis": lastUpdatedMillis,
    });
    await userCollection.doc(request.userId).update({
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": userData.userId,
          "displayName": userData.displayName,
          "username": userData.username,
          "FCMToken": userData.FCMToken,
        }
      ]),
      "lastUpdatedMillis": lastUpdatedMillis,
    });

    await LocalDatabase().removeIncomingFriendRequestFromUser(
        uid!, request.userId, lastUpdatedMillis);
  }

  Future<void> removeFriendFix(UserMini friend, User userData) async {
    await userCollection.doc(userData.userId).update({
      "friends": FieldValue.arrayRemove([friend.toMap()]),
      "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
    });
  }

  StreamSubscription userDataStream(StreamController streamController) {
    Stream stream = userCollection.doc(uid).snapshots();

    StreamSubscription streamListen = stream.listen((event) async {
      User userData = User.fromMap(event.data() as Map<String, dynamic>);
      await LocalDatabase()
          .updateUserData(userData, userData.lastUpdatedMillis);

      streamController.add(userData);
    }, onDone: () {});
    //On Auth State change end stream
    return streamListen;
  }

  Future<void> removeOldDiscussions(
      User userData, List<Snippet> snippets) async {
    List<Discussion> discussions = userData.discussions;
    List<String> snippetIds = snippets.map((e) => e.snippetId).toList();

    List<Discussion> discussionsToRemove = [];
    for (var element in discussions) {
      if (!snippetIds.contains(element.snippetId)) {
        discussionsToRemove.add(element);
      }
    }
    for (var element in discussionsToRemove) {
      await userCollection.doc(uid).update({
        "discussions": FieldValue.arrayRemove([
          {
            "snippetId": element.snippetId,
            "answerId": element.answerId,
            "snippetQuestion": element.snippetQuestion,
            "isAnonymous": element.isAnonymous,
            "theme": "blue"
          }
        ]),
        "lastUpdatedMillis": DateTime.now().millisecondsSinceEpoch,
      });
      await LocalDatabase().removeDiscussionFromUser(
          uid!,
          Discussion(
              answerId: element.answerId,
              isAnonymous: element.isAnonymous,
              snippetId: element.snippetId,
              snippetQuestion: element.snippetQuestion),
          DateTime.now().millisecondsSinceEpoch);
      await LocalDatabase()
          .deleteChats("${element.snippetId}-${element.answerId}");
    }
  }
}
