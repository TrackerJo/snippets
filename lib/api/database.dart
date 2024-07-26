import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:snippets/api/local_database.dart';

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

    getCurrentSnippets(DateTime? latestSnippetDate, StreamController controller) async {
    if(latestSnippetDate != null){
      latestSnippetDate = latestSnippetDate.add(Duration(seconds: 10));
      currentSnippetsCollection.where("lastRecieved", isGreaterThan: latestSnippetDate).snapshots().listen((event) {
        controller.add(event);
      });
      return;
    }
      currentSnippetsCollection.snapshots().listen((event) {
        controller.add(event);
    });


  }

  Future submitAnswer(String snippetId, String answer, String question, String theme) async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
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
      "date": DateTime.now(),
    });
    LocalDatabase().answerSnippet(snippetId);

    //Update user's discussion list
    await userCollection.doc(uid).update({
      "discussions": FieldValue.arrayUnion([
        {
          "snippetId": snippetId,
          "answerId": uid,
          "snippetQuestion": question,
          "theme": theme,
        }
      ]),
    });
   
    //Add uid to snippet's answered list

    await currentSnippetsCollection.doc(snippetId).update({
      "answered": FieldValue.arrayUnion([uid]),
    });


    //Send notification to user's friends

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
          });
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

  Future<Stream> getResponsesList(String snippetId, DateTime? date, bool getFriends, List<String> friendsToGet) async {
    //Then the rest of the responses from friends
    List<String> friendsList = await getFriendsList();
   
    if(date == null) {
      if(friendsList.isEmpty) {
        return Stream.empty();
      }
      Stream querySnapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .where("uid", whereIn: friendsList)
          .snapshots();

      return querySnapshot;
    }
    if(getFriends) {
      print("Getting friends $friendsToGet");
      Stream querySnapshot = currentSnippetsCollection
          .doc(snippetId)
          .collection("answers")
          .where("uid", whereIn: friendsToGet)
          .snapshots();

      return querySnapshot;
    }
    Stream querySnapshot = currentSnippetsCollection
        .doc(snippetId)
        .collection("answers")
        .where("uid", whereIn: friendsList)
        .where("date", isGreaterThan: date)
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
            }
          ]),
        });
        await LocalDatabase().deleteChats("${element["snippetId"]}-${element["answerId"]}");

        continue;
      }
      Stream snippetData = currentSnippetsCollection.doc(element["snippetId"]).collection("answers").doc(element["answerId"]).collection("discussion").orderBy("date", descending: true).limit(1).snapshots();
      snippetData.listen((event) async {
        Map<String, dynamic> answerData = answerDoc.data() as Map<String, dynamic>;
        print("ANSWER DATA");
        print(answerData);
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
        };
        
        
        print("ADDING DISCUSSION");
        print(discussionsData);
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
      print("Changed");
      print(event.data());
      streamController.add(event.data());
    }, onDone: () {
      print("No longer");
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

 

  Future<Stream> getBlankOfTheWeek() async {
    Stream snapshot = botwCollection.doc("currentBlank").snapshots();
    return snapshot;
  
  }

  Future<Map<String,dynamic>> getBlankOfTheWeekData() async {
    DocumentSnapshot snapshot = await botwCollection.doc("currentBlank").get();
    return snapshot as Map<String, dynamic>;
  
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
    }, SetOptions(merge: true));
  }

  Future updateBOTWAnswer(Map<String, dynamic> answer) async {
    

    await botwCollection.doc("currentBlank").set({
      "answers": {
        answer["userId"]: answer,

      },
    }, SetOptions(merge: true));
  }

  Future updateUserVotesLeft(int votesLeft) async {
    await userCollection.doc(uid).update({
      "votesLeft": votesLeft,
    });
  }

  Future<Map<String, dynamic>> getBotwAnswers() async {
    DocumentSnapshot snapshot = await botwCollection.doc("currentBlank").get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data["answers"];
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
}
