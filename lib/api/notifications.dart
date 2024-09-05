import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/templates/colorsSys.dart';


class PushNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<String> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    return (token != null) ? token : "";
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.getToken();

    initPushNotifications();
  }

  void handleInAppMessage(RemoteMessage? message) async {

    if (message == null) {
      return;
    }
    if(message.data["type"] == "notification"){
      return;
    }
    if(message.data["type"].contains("widget-")) {

      if(message.data["type"] == "widget-botw"){
        Map<String, dynamic> data = WidgetData(message.data["blank"].split(" of")[0], answers: []).toJson();

          WidgetKit.setItem(
            'botwData',
            jsonEncode(data),
            'group.kazoom_snippets');
          WidgetKit.reloadAllTimelines();
      } else if(message.data["type"] == "widget-question"){
        Map<String, dynamic> oldSnippets = json.decode(await WidgetKit.getItem('snippetsData', 'group.kazoom_snippets'));

        List<String> questions = oldSnippets["questions"].cast<String>();

        List<String> ids = oldSnippets["ids"].cast<String>();

        List<bool> hasAnswereds = oldSnippets["hasAnswereds"].cast<bool>();

        List<int> indexes = oldSnippets["indexes"].cast<int>();

        List<bool> isAnonymous = oldSnippets["isAnonymous"].cast<bool>();

          dynamic indexData = message.data["index"];
          if(indexData is String) {
            indexData = int.parse(indexData);
          } 
        int index = indexes.indexOf(indexData);
        if(index == -1) {
          questions.add(message.data["question"]);
          ids.add(message.data["snippetId"]);
          indexes.add(indexData);
          isAnonymous.add(message.data["snippetType"] == "anonymous");
          hasAnswereds.add(false);
        } else {
          //Old question
          String oldId = ids[index];
          //Delete old responses
          Map<String, dynamic> oldResponsesMap = json.decode(await WidgetKit.getItem('snippetsResponsesData', 'group.kazoom_snippets'));
          List<String> oldResponses = oldResponsesMap["responses"].cast<String>();
          List<String> newResponses = [];
          for (var response in oldResponses) {
            if(response.split("|")[3] == oldId) {
              continue;
            }
            newResponses.add(response);
          }
          oldResponsesMap["responses"] = newResponses;
          WidgetKit.setItem(
            'snippetsResponsesData',
            jsonEncode(oldResponsesMap),
            'group.kazoom_snippets');
          questions[index] = message.data["question"];
          ids[index] = message.data["snippetId"];
          indexes[index] = indexData;
          isAnonymous[index] = message.data["snippetType"] == "anonymous";
          hasAnswereds[index] = false;
        }
        Map<String, dynamic> snippetData = {
          "questions": questions,
          "ids": ids,
          "hasAnswereds": hasAnswereds,
          "indexes": indexes,
          "isAnonymous": isAnonymous,
        };

        WidgetKit.setItem(
          'snippetsData',
          jsonEncode(snippetData),
          'group.kazoom_snippets');
        WidgetKit.reloadAllTimelines();


      } else if(message.data["type"] == "widget-botw-answer"){
        Map<String, dynamic> oldBOTW = json.decode(await WidgetKit.getItem('botwData', 'group.kazoom_snippets'));
        Map<String, dynamic> answer = {
          "answer": message.data["answer"],
          "uid": message.data["uid"],
          "displayName": message.data["displayName"],
          
        };
        List<dynamic> oldAnswersList = oldBOTW["answers"];
        List<Map<String, dynamic>> oldAnswers = [];
        for (var i = 0; i < oldAnswersList.length; i++) {
          oldAnswers.add({
            "answer": oldAnswersList[i]["answer"],
            "uid": oldAnswersList[i]["uid"],
            "displayName": oldAnswersList[i]["displayName"],
          });
        }
        //Check if answer already exists
        Map<String, dynamic>? oldAnswer = oldAnswers.firstWhere((element) => element["uid"] == message.data["uid"], orElse: () => {});
        if(oldAnswer.isEmpty) {
          oldAnswers.add(answer);
        } else {
          oldAnswers[oldAnswers.indexOf(oldAnswer)] = answer;
        }
        oldBOTW["answers"] = oldAnswers;

        WidgetKit.setItem(
          'botwData',
          jsonEncode(oldBOTW),
          'group.kazoom_snippets');
        WidgetKit.reloadAllTimelines();
        

      } else if(message.data["type"] == "widget-snippet-response"){
        Map<String, dynamic> oldResponsesMap = json.decode(await WidgetKit.getItem('snippetsResponsesData', 'group.kazoom_snippets'));
        List<String> oldResponses = oldResponsesMap["responses"].cast<String>();
        String responseString = "${message.data["displayName"]}|${message.data["question"]}|${message.data["response"]}|${message.data["snippetId"]}|${message.data["userId"]}|${message.data["snippetType"] == "anonymous"}|${message.data["answered"]}";
        if(oldResponses.contains(responseString)) {
          return;
        }
        for(var response in oldResponses) {
          if(response.split("|")[3] == message.data["snippetId"] && response.split("|")[6] == "false") {
            oldResponses[oldResponses.indexOf(response)] = "${response.split("|")[0]}|${response.split("|")[1]}|${response.split("|")[2]}|${response.split("|")[3]}|${response.split("|")[4]}|${response.split("|")[5]}|true";
          }
        }
        oldResponses.add(responseString);
        WidgetKit.setItem(
          'snippetsResponsesData',
          jsonEncode({"responses": oldResponses}),
          'group.kazoom_snippets');
        WidgetKit.reloadAllTimelines();
      }
      return;
    }
    //Check if user is logged in
    bool isSignedIn = await Auth().isUserLoggedIn();
    if (!isSignedIn) {
      return;
    }
    String currentPage = (await HelperFunctions.getOpenedPageFromSF())!;


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
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    OverlaySupportEntry.of(context)!.dismiss();
                  }),
            ),
          );
        }, duration: const Duration(milliseconds: 6000));
  }

  void handleMessage(RemoteMessage? message) async {

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
 
        router.push("/home/question/${message.data['snippetId']}/${message.data['theme']}/${message.data['question'].replaceAll("?", "~")}/${message.data['snippetType']}");
      } else if (message.data['type'] == "discussion") {


      
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
        router.push("/home/discussion?displayName=${message.data['responseName']}&response=${message.data['response']}&userId=${message.data['responseId']}&snippetId=${message.data['snippetId']}&snippetQuestion=${message.data['snippetQuestion']}&theme=${message.data['theme']}&discussionUsers=${message.data['discussionUsers']}&snippetType=${message.data['snippetType']}&isDisplayOnly=true");

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
        bool hasResponded = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).didUserAnswerSnippet(message.data['snippetId']);
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
          router.push("/home/responses/${message.data['snippetId']}/${message.data['theme']}/${message.data['question']}/${message.data['snippetType']}");
        }
        } else if(message.data['type'] == "botw" || message.data['type'] == "new-botw") {
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
          router.pushReplacement("/home/index/0");
          
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
      required Map<String, dynamic> data,}) async {

        if(data["type"] == "discussion") {
          data["discussionUsers"] = createDiscussionUsersString(data["discussionUsers"]);
        }
        
        print("Sending notification");
        print(data);
        print(targetIds);
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
