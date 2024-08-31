import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:phone_input/phone_input_package.dart';
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

  Future<Map<String, dynamic>> getUserData(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    return snapshot.data() as Map<String, dynamic>;
  }

  Future<bool> didUserAnswerSnippet(String snippetId) async {
    DocumentSnapshot snapshot = await currentSnippetsCollection.doc(snippetId).get();
    List<dynamic> answeredSnippets = snapshot["answered"];
    if (answeredSnippets.contains(uid)) {
      return true;
    } else {
      return false;
    }
  }

  Future<Stream> getUserStream(String userId) async {
    Stream snapshot = userCollection.doc(userId).snapshots();
    return snapshot;
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

    getCurrentSnippets(DateTime? latestSnippetDate, StreamController controller, StreamController mainController) async {
    if(latestSnippetDate != null){
      latestSnippetDate = latestSnippetDate.add(Duration(seconds: 10));
      currentSnippetsCollection.where("lastRecieved", isGreaterThan: latestSnippetDate).snapshots().listen((event) {
        if(mainController.isClosed) return;
        controller.add(event);
      });
      return;
    }
      currentSnippetsCollection.snapshots().listen((event) {
        if(mainController.isClosed) return;
        controller.add(event);
    });


  }

  Future submitAnswer(String snippetId, String answer, String question, String theme, String? id) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .doc(id ?? uid)
        .set({
      "answer": answer,
      "displayName": id == null ? await HelperFunctions.getUserDisplayNameFromSF() : "Anonymous",
      "uid": id ?? uid,
      "discussionUsers": [

      ],
      "date": DateTime.now(),
      "lastUpdated": DateTime.now(),
    });
    LocalDatabase().answerSnippet(snippetId);

    //Update user's discussion list
    if(id == null) {
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
    });


    //Send notification to user's friends
    if(id != null) {
      return;
    }

    List<dynamic> friendsList = userData["friends"];
    List<dynamic> friendsFCMTokens = friendsList.map((e) => e["FCMToken"]).toList();
     PushNotifications().sendNotification(
          title: "${userData["fullname"]} just responded to a snippet!",
          body: "Tap here to view response",
          targetIds: [
            ...friendsFCMTokens,
          ],
          data: {
            "type": "snippetAnswered",
            "snippetId": snippetId,
            "question": question,
            "theme": theme,
            "snippetType": id != null ? "anonymous" : "normal"
          });
          PushNotifications().sendTokenData( [
              ...friendsFCMTokens,
            ], {
              "type": "widget-snippet-response",
              "snippetId": snippetId,
              "question": question,
              "theme": "blue",
              "snippetType": id != null ? "anonymous" : "normal",
              "displayName": userData["fullname"],
              "uid": userData["uid"],
              "response": answer,
          });
          if(await WidgetKit.getItem('snippetsResponsesData', 'group.kazoom_snippets') == null) {
            List<String> oldResponses = [];
            String responseString = "${userData["fullname"]}|${question}|${answer}|${snippetId}|${id ?? uid}|${id != null}|${true}";
            if(oldResponses.contains(responseString)) {
              return;
            }
            oldResponses.add(responseString);
            WidgetKit.setItem(
              'snippetsResponsesData',
              jsonEncode({"responses": oldResponses}),
              'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
          } else {
 Map<String, dynamic> oldResponsesMap = json.decode(await WidgetKit.getItem('snippetsResponsesData', 'group.kazoom_snippets'));
    List<String> oldResponses = oldResponsesMap["responses"].cast<String>();
            String responseString = "${userData["fullname"]}|${question}|${answer}|${snippetId}|${id ?? uid}|${id != null}|${true}";
            if(oldResponses.contains(responseString)) {
              return;
            }
            oldResponses.add(responseString);
            WidgetKit.setItem(
              'snippetsResponsesData',
              jsonEncode({"responses": oldResponses}),
              'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
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

  Future<Stream> getResponsesList(String snippetId, DateTime? date, bool getFriends, List<String> friendsToGet, bool isAnonymous) async {
    //Then the rest of the responses from friends
    List<String> friendsList = [];
    if(!isAnonymous){
      friendsList = await getFriendsList();

    }   
    if(date == null) {
      if(friendsList.isEmpty && !isAnonymous) {
        return Stream.empty();
      }
      Stream querySnapshot;
      if(isAnonymous){
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

      return querySnapshot;
    }
    if(getFriends && !isAnonymous) {

      Stream querySnapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .where("uid", whereIn: friendsToGet)
          .snapshots();

      return querySnapshot;
    }
     Stream querySnapshot;
    if(isAnonymous) {
      querySnapshot = currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .where("date", isGreaterThan: date)
        .snapshots();
    } else {
      querySnapshot = currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .where("uid", whereIn: friendsList)
        .where("date", isGreaterThan: date)
        .snapshots(); 
    }
    


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
          "FCMToken": friendFCMToken,
        }
      ]),
    });

    PushNotifications().sendNotification(
        title: "$displayName just sent you a friend request!",
        body: "Tap here to view request.",
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
    String userFCMToken = await PushNotifications().getDeviceToken();
    String username = (await HelperFunctions.getUserNameFromSF())!;

    await userCollection.doc(friendUid).update({
      "friends": FieldValue.arrayUnion([
        {
          "userId": uid,
          "displayName": displayName,
          "username": username,
          "FCMToken": userFCMToken,
        }
      ]),
      "outgoingRequests": FieldValue.arrayRemove([
        {
          "userId": uid,
          "displayName": displayName,
          "username": username,
          "FCMToken": userFCMToken,
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
          "userId": uid,
          "displayName": displayName,
          "username": username,
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
          "FCMToken": await PushNotifications().getDeviceToken(),
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
      String friendUid, String friendDisplayName, String friendUsername, String friendFCMToken) async {
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
          "displayName": await HelperFunctions.getUserDisplayNameFromSF(),
          "username": await HelperFunctions.getUserNameFromSF(),
          "FCMToken": await PushNotifications().getDeviceToken(),
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

  Future cancelFriendRequest(
      String friendUid, String friendDisplayName, String friendUsername, String friendFCMToken) async {
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
          "FCMToken": friendFCMToken,
        }
      ]),
    });
  }

  Future<Stream> searchUsers(String search) async {
    Stream snapshot = userCollection
        .where("searchKey", isGreaterThanOrEqualTo: search.toLowerCase())
        .where("searchKey",
            isLessThanOrEqualTo: "${search.toLowerCase()}\uf8ff")
        .snapshots();

    return snapshot;
  }

  Future<DateTime?> loadDiscussion(String snippetId, String userId, DateTime? latestChat) async {
    if(latestChat == null) {
      QuerySnapshot snapshot = await currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .doc(userId)
          .collection("discussion")
          .orderBy("date", descending: false)
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
              "chatId": "${snippetId}-${userId}",
              "snippetId": snippetId

            };
           await LocalDatabase().insertChat(chatMessageMap);
      }
      if(snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.last["date"].toDate();
    } else {
      //add one millisecond to the latest chat
      QuerySnapshot snapshot = await currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .doc(userId)
          .collection("discussion")
          .where("date", isGreaterThan: latestChat)
          .orderBy("date", descending: false)
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
              "chatId": "${snippetId}-${userId}",
              "snippetId": snippetId

            };
           await LocalDatabase().insertChat(chatMessageMap);
      }
      if(snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.last["date"].toDate();
    }
  }

  Future<Stream<QuerySnapshot>> getDiscussion(
      String snippetId, String userId, DateTime? latestChat) async {
        if(latestChat == null) {

          Stream<QuerySnapshot> snapshot = currentSnippetsCollection
              .doc(snippetId)
              .collection("answers")
              .doc(userId)
              .collection("discussion")
              .orderBy("date", descending: false)
              .snapshots();

          return snapshot;
        } else {
          //add one millisecond to the latest chat

          Stream<QuerySnapshot> snapshot = currentSnippetsCollection
              .doc(snippetId)
              .collection("answers")
              .doc(userId)
              .collection("discussion")
              .where("date", isGreaterThan: latestChat)
              .orderBy("date", descending: false)
              .snapshots();

          return snapshot;
        }
  }

  Future updateReadBy(String snippetId, String userId, String messageId, String anonymousId) async {
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
          "isAnonymous" : isAnonymous
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
        await LocalDatabase().deleteChats("${element["snippetId"]}-${element["answerId"]}");

        continue;
      }
      Stream snippetData = currentSnippetsCollection.doc(element["snippetId"]).collection("answers").doc(element["answerId"]).collection("discussion").orderBy("date", descending: true).limit(1).snapshots();
      snippetData.listen((event) async {
        Map<String, dynamic> answerData = answerDoc.data() as Map<String, dynamic>;

        //Check if discussion is already in the list
        
        Map<String, dynamic> discussionsData = {};
        Map<String, dynamic> lastMessage = {};
        if(event.docs.isEmpty) {
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
    }, onDone: () {

    });
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

 

  Future getBlankOfTheWeek(StreamController<Map<String, dynamic>> controller, DateTime? lastUpdated) async {
    Stream snapshot;
    if(lastUpdated == null) {
      snapshot = botwCollection.doc("currentBlank").snapshots();
      snapshot.listen((event) {
        DocumentSnapshot snapshot = event;
        snapshot.data();
        controller.add( snapshot.data() as Map<String, dynamic>);
      });
    } else {
      snapshot = botwCollection.where("lastUpdated", isGreaterThan: lastUpdated).snapshots();
      snapshot.listen((event) {
        //Get the first document
        if(event.docs.isNotEmpty) {
          DocumentSnapshot snapshot = event.docs[0];

          controller.add(snapshot.data() as Map<String, dynamic>);
        }
      });
    }
    


  
  }

  Future<Map<String,dynamic>?> getBlankOfTheWeekData(DateTime? LastUpdated) async {
    DocumentSnapshot snapshot;
    if(LastUpdated == null) {
      snapshot = await botwCollection.doc("currentBlank").get();
    } else {
      snapshot = await botwCollection.where("lastUpdated", isGreaterThan: LastUpdated).get().then((value) => value.docs[0]);
    }
    if(!snapshot.exists) {
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

    await botwCollection.doc("currentBlank").set({
      "answers": {
        uid: answer,

      },
      "lastUpdated": DateTime.now(),
    }, SetOptions(merge: true));
  }

  Future updateBOTWAnswer(Map<String, dynamic> answer) async {
    

    await botwCollection.doc("currentBlank").set({
      "answers": {
        answer["userId"]: answer,

      },
      "lastUpdated": DateTime.now(),
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

    List<String> friendsIds = friendsList.map((e) => e["userId"].toString()).toList();
    List<dynamic> mutualFriends = [];
    for (var element in friendsList) {
      Map<String, dynamic> friendData = await getUserData(element["userId"]);
      List<dynamic> friendFriends = friendData["friends"];
      //get list where friendsFriends in friendsList

      mutualFriends = mutualFriends + friendFriends;

    }
    //Count the number of times each friend appears
    List<Map<String, dynamic>> mutualFriendsWithCount = [];
    for (var element in mutualFriends) {
      if(friendsIds.contains(element["userId"]) || element["userId"] == userData["uid"]) {
        continue;

      }
      if(mutualFriendsWithCount.any((e) => e["userId"] == element["userId"])) {
        int index = mutualFriendsWithCount.indexWhere((e) => e["userId"] == element["userId"]);
        mutualFriendsWithCount[index]["count"] = mutualFriendsWithCount[index]["count"] + 1;
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

  Future<List<dynamic>> getDiscussionUsers(String snippetId, String answerId) async {
    DocumentSnapshot snapshot = await currentSnippetsCollection.doc(snippetId).collection("answers").doc(answerId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data["discussionUsers"] as List<dynamic>;

  }

  Future updateUserFCMToken(String FCMToken) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await userCollection.doc(uid).update({
      "FCMToken": FCMToken,
    });
    
    List<dynamic> friends = userData["friends"];
    List<String> friendsIds = friends.map((e) => e["userId"].toString()).toList();
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
    List<String> friendRequestsIds = friendRequests.map((e) => e["userId"].toString()).toList();
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
    List<dynamic> outgoingRequests = userData["outgoingRequests"];
    List<String> outgoingRequestsIds = outgoingRequests.map((e) => e["userId"].toString()).toList();
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
  }

  Future<Stream> getDiscussionLastMessages(String snippetId, String answerId, DateTime latestMessage) async {
    return currentSnippetsCollection.doc(snippetId).collection("answers").doc(answerId).collection("discussion").orderBy("date", descending: true).limit(1).snapshots();

  }

  Future<void> shareFeedback(String feedback) async {
    await FirebaseFirestore.instance.collection("feedback").add({
      "feedback": feedback,
      "date": DateTime.now(),
      "userId": uid,
    });
  }

  Future<List<Map<String, dynamic>>> getSnippetsList(DateTime? lastUpdated) async {
    QuerySnapshot snapshot;
    if(lastUpdated == null) {
      snapshot = await currentSnippetsCollection.get();
    } else {
      snapshot = await currentSnippetsCollection.where("lastRecieved", isGreaterThan: lastUpdated).get();
    }
    List<Map<String, dynamic>> snippets = [];
    for (var element in snapshot.docs) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      data["snippetId"] = element.id;
      data["lastRecieved"] = data["lastRecieved"].toDate();
      data["answered"] = data["answered"].contains(uid);
      snippets.add(data);
    }
    return snippets;
  }

  Future<List<Map<String, dynamic>>> getSnippetResponses(String snippetId, DateTime? lastUpdated, bool isAnonymous) async {
    QuerySnapshot snapshot;
    List<String> friendsList = [];
    if(!isAnonymous){
      friendsList = await getFriendsList();

    }   
    if(friendsList.isEmpty && !isAnonymous) {
      return [];
    }
    if(lastUpdated == null) {
      if(isAnonymous){
        snapshot = await currentSnippetsCollection.doc(snippetId).collection("answers").get();
      } else {
        snapshot = await currentSnippetsCollection.doc(snippetId).collection("answers").where("uid", whereIn: friendsList).get();
      }
      
    } else {
      if(isAnonymous) {
        snapshot = await currentSnippetsCollection.doc(snippetId).collection("answers").where("date", isGreaterThan: lastUpdated).get();
      } else {
        snapshot = await currentSnippetsCollection.doc(snippetId).collection("answers").where("uid", whereIn: friendsList).where("date", isGreaterThan: lastUpdated).get();
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



}
