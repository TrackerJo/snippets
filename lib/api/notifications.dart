import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/pages/question_page.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/pages/swipe_pages.dart';
import 'package:snippets/pages/voting_page.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/response_tile.dart';

class PushNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<String> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    return (token != null) ? token : "";
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    String? fcmToken = await _firebaseMessaging.getToken();
    print("FCM Token: $fcmToken");
    initPushNotifications();
  }

  void handleInAppMessage(RemoteMessage? message) async {
    print("Handling in app message");
    if (message == null) {
      return;
    }
    String currentPage = (await HelperFunctions.getOpenedPageFromSF())!;
    print("Current Page: $currentPage");

    if(message.data['type'] == "question" && currentPage == "snippets") {
      return;
      
    }

    if(message.data['type'] == "snippetAnswered" && currentPage == "responses") {
      return;
    }

    if(message.data['type'] == "discussion" && currentPage.split("-")[0] == "discussion" && currentPage.split("-")[1] == message.data['snippetId'] && currentPage.split("-")[2] == message.data['responseId']) {
      return;
    }

    HapticFeedback.vibrate();
    
    showOverlayNotification((context) {
          return Card(
            color: ColorSys.secondarySolid,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ListTile(
              onTap: () {
                OverlaySupportEntry.of(context)!.dismiss();
                handleMessage(message);
              },
              leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset("assets/icon/icon.png")),
              title: Text(message.data['title']),
              subtitle: Text(message.data['body']),
              trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    OverlaySupportEntry.of(context)!.dismiss();
                  }),
            ),
          );
        }, duration: Duration(milliseconds: 6000));
  }

  void handleMessage(RemoteMessage? message) async {
    print("Handling message");
    if (message == null) {
      return;
    }
    

    //Check if user is logged in
    bool isSignedIn = await Auth().isUserLoggedIn();
    if (!isSignedIn) {
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //   CustomPageRoute(
      //     builder: (BuildContext context) {
      //       return const WelcomePage();
      //     },
      //   ),
      //   (Route<dynamic> route) => false,
      // );
      router.push("/");
    } else {
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //   CustomPageRoute(
      //     builder: (BuildContext context) {
      //       return const SwipePages();
      //     },
      //   ),
      //   (Route<dynamic> route) => false,
      // );
      // router.push("/home/swipe/1");
      if (message.data['type'] == "question") {
        // navigatorKey.currentState?.push(
        //   CustomPageRoute(
        //     builder: (BuildContext context) {
        //       return QuestionPage(
        //         snippetId: message.data['snippetId'],
        //         theme: message.data['theme'],
        //         question: message.data['question'],
        //       );
        //     },
        //   ),
        // );
        router.push("/home/question/${message.data['snippetId']}/${message.data['theme']}/${message.data['question']}");
      } else if (message.data['type'] == "discussion") {
        print("Discussion");

      
        // navigatorKey.currentState?.push(
        //   CustomPageRoute(
        //     builder: (BuildContext context) {
        //       return DiscussionPage(
        //           responseTile: ResponseTile(
        //             displayName: message.data['responseName'],
        //             response: message.data['response'],
        //             userId: message.data["responseId"],
        //             snippetId: message.data['snippetId'],
        //             question: message.data['snippetQuestion'],
        //             theme: message.data['theme'],
        //             discussionUsers: discussionUsers,
        //             isDisplayOnly: true,
        //           ),
        //           theme: message.data['theme']);
        //     },
        //   ),
        // );
        router.push("/home/discussion?displayName=${message.data['responseName']}&response=${message.data['response']}&userId=${message.data['responseId']}&snippetId=${message.data['snippetId']}&snippetQuestion=${message.data['snippetQuestion']}&theme=${message.data['theme']}&discussionUsers=${message.data['discussionUsers']}&isDisplayOnly=true");

      } else if (message.data['type'] == "friendRequest" ||
          message.data['type'] == "friendRequestAccepted") {
          
        // navigatorKey.currentState?.push(
        //   CustomPageRoute(
        //     builder: (BuildContext context) {
        //       return ProfilePage(
        //         uid: message.data['userId'],
        //         showNavBar: false,
        //       );
        //     },
        //   ),
        // );
        router.push("/home/profile/${message.data['userId']}");
      } else if (message.data['type'] == "snippetAnswered") {

        //Check if user answered the snippet
        bool hasResponded = await Database(uid: FirebaseAuth.instance.currentUser!.uid).didUserAnswerSnippet(message.data['snippetId']);
        if(hasResponded) {
          // navigatorKey.currentState?.push(
          //   CustomPageRoute(
          //     builder: (BuildContext context) {
          //       return ResponsesPage(
          //         question: message.data['question'],
          //         snippetId: message.data['snippetId'],
          //         theme: message.data['theme'],

          //       );
          //     },
          //   ),
          // );
          router.push("/home/responses/${message.data['snippetId']}/${message.data['theme']}/${message.data['question']}");
        }
        } else if(message.data['type'] == "botw") {
          // navigatorKey.currentState?.pushAndRemoveUntil(
          //   CustomPageRoute(
          //     builder: (BuildContext context) {
          //       return const SwipePages(
          //         initialIndex: 0,
          //       );
          //     },
          //   ),
          //   (Route<dynamic> route) => false,
          // );
          router.pushReplacement("/home/0");
        }
        else if(message.data['type'] == "reminderToVoteBOTW" || message.data['type'] == "botw voting"){
          // navigatorKey.currentState?.pushAndRemoveUntil(
          //   CustomPageRoute(
          //     builder: (BuildContext context) {
          //       return const VotingPage();
          //     },
          //   ),
          //   (Route<dynamic> route) => false,
          // );
          router.push("/home/voting");
        } else if(message.data['type'] == "endVotingBOTW"){
          router.push("/home/results");
        } else if(message.data['type'] == "viewUserProfile"){
          router.push("/home/profile/${message.data['userId']}");
        }
        else {
          // navigatorKey.currentState?.push(
          //   CustomPageRoute(
          //     builder: (BuildContext context) {
          //       return QuestionPage(question: message.data['question'],
          //         snippetId: message.data['snippetId'],
          //         theme: message.data['theme'],);
          //     },
          //   ),
          // );
          router.push( "/home/1");
      }
    }
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      handleMessage(message);
    });

    FirebaseMessaging.onMessage.listen((message) {
      handleInAppMessage(message);
    });
  }

  Future subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print("Subscribed to $topic");
  }

  Future unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  String createDiscussionUsersString(List<dynamic> discussionUsers) {
    String users = "";
    for (var value in discussionUsers) {
      users += "|${value["userId"]}^${value["FCMToken"]}";
    }
    return users;
   
  }
  
  List<Map<String, dynamic>> createDiscussionUsersList(String discussionUsers) {
    List<Map<String, dynamic>> users = [];
    List<String> userStrings = discussionUsers.split("|");
    for (var user in userStrings) {
      List<String> userParts = user.split("^");
      if(userParts.length == 2) {
        
        
        users.add({
          "userId": userParts[0],
          "FCMToken": userParts[1]
        });
      }
    }
    return users;
  }

  Future sendNotification(
      {required String title,
      required String body,
      required List<String> targetIds,
      required Map<String, dynamic> data}) async {
        print("Sending notification");
        print(data);
        print(targetIds);
        if(data["type"] == "discussion") {
          data["discussionUsers"] = createDiscussionUsersString(data["discussionUsers"]);
        }
    HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('sendNotifications')
        .call({
      "title": title,
      "body": body,
      "targetIds": targetIds,
      "data": data,
    });
    return result.data;
  }
}
