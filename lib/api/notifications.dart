import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/find_profile_page.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/question_page.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/response_tile.dart';

class PushNotifications {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<String> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    return (token != null) ? token : "";
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    String? fcmToken = await _firebaseMessaging.getToken()!;
    print("FCM Token: $fcmToken");
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) async {
    print("Handling message");
    if (message == null) {
      return;
    }
    //Check if user is logged in
    bool isSignedIn = await Auth().isUserLoggedIn();
    if (!isSignedIn) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        CustomPageRoute(
          builder: (BuildContext context) {
            return const WelcomePage();
          },
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      navigatorKey.currentState?.pushAndRemoveUntil(
        CustomPageRoute(
          builder: (BuildContext context) {
            return HomePage();
          },
        ),
        (Route<dynamic> route) => false,
      );
      if (message.data['type'] == "question") {
        navigatorKey.currentState?.push(
          CustomPageRoute(
            builder: (BuildContext context) {
              return QuestionPage(
                snippetId: message.data['snippetId'],
                theme: message.data['theme'],
                question: message.data['question'],
              );
            },
          ),
        );
      } else if (message.data['type'] == "response") {
        navigatorKey.currentState?.pushAndRemoveUntil(
          CustomPageRoute(
            builder: (BuildContext context) {
              return HomePage();
            },
          ),
          (Route<dynamic> route) => false,
        );
      } else if (message.data['type'] == "discussion") {
        navigatorKey.currentState?.push(
          CustomPageRoute(
            builder: (BuildContext context) {
              return DiscussionPage(
                  responseTile: ResponseTile(
                    displayName: message.data['responseName'],
                    response: message.data['response'],
                    userId: message.data["responseId"],
                    snippetId: message.data['snippetId'],
                    question: message.data['snippetQuestion'],
                    theme: message.data['theme'],
                    discussionUsers: message.data['discussionUsers'],
                    isDisplayOnly: true,
                  ),
                  theme: message.data['theme']);
            },
          ),
        );
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

    // FirebaseMessaging.onMessage.listen((message) {
    //   handleMessage(message);
    // });
  }

  void subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
    print("Subscribed to $topic");
  }

  void unsubscribeFromTopic(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future sendNotification(
      {required String title,
      required String body,
      required List<String> targetIds,
      required Map<String, dynamic> data}) async {
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
