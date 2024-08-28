
import 'dart:async';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/botw_results_page.dart';
import 'package:snippets/pages/create_account_page.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/onboarding_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/pages/question_page.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/pages/swipe_pages.dart';
import 'package:snippets/pages/voting_page.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/providers/card_provider.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/response_tile.dart';

import 'firebase_options.dart';
const String appGroupId = 'group.kazoom_snippets';           
const String iOSWidgetName = 'Snippets_Widgets';
// final navigatorKey = GlobalKey<NavigatorState>();
final userStreamController = StreamController.broadcast();

class Answer {
  final String answer;
  final String uid;
  final String displayName;

  Answer(this.answer, this.uid, this.displayName);

  Answer.fromJson(Map<String, dynamic> json)
      : answer = json['answer'],
        uid = json['uid'],
        displayName = json['displayName'];

  Map<String, dynamic> toJson() => {
        'answer': answer,
        'uid': uid,
        'displayName': displayName,
      };

}

class WidgetData {
  final String text;
  final List<Answer> answers;

  WidgetData(this.text, {this.answers = const []});

  WidgetData.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        answers = (json['answers'] as List)
            .map((e) => Answer.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        'text': text,
        'answers': answers.map((e) => e.toJson()).toList(),
      };
}

AppDb localDb = AppDb();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  if(message.data["type"] == "widget-botw"){
    Map<String, dynamic> data = WidgetData(message.data["blank"].split(" of")[0], answers: []).toJson();
    print("NEW BOTW: $data");
      WidgetKit.setItem(
        'botwData',
        jsonEncode(data),
        'group.kazoom_snippets');
      WidgetKit.reloadAllTimelines();
  } else if(message.data["type"] == "widget-question"){
    Map<String, dynamic> oldSnippets = json.decode(await WidgetKit.getItem('snippetsData', 'group.kazoom_snippets'));
    List<String> questions = oldSnippets["questions"].cast<String>();
    List<String> ids = oldSnippets["ids"].cast<String>();
    List<String> indexes = oldSnippets["indexes"].cast<String>();
    List<bool> isAnonymous = oldSnippets["isAnonymous"].cast<bool>();
    int index = questions.indexOf(message.data["question"]);
    if(index == -1) {
      questions.add(message.data["question"]);
      ids.add(message.data["id"]);
      indexes.add(message.data["index"]);
      isAnonymous.add(message.data["snippetType"] == "anonymous");
    } else {
      questions[index] = message.data["question"];
      ids[index] = message.data["id"];
      indexes[index] = message.data["index"];
      isAnonymous[index] = message.data["snippetType"] == "anonymous";
    }
    Map<String, dynamic> snippetData = {
      "questions": questions,
      "ids": ids,
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
    List<Map<String, dynamic>> oldAnswers = oldBOTW["answers"].cast<Map<String, dynamic>>();
    //Check if answer already exists
    Map<String, dynamic>? oldAnswer = oldAnswers.firstWhere((element) => element["userId"] == message.data["uid"], orElse: () => {});
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
    //Check if other responses are unanswered
    for(var response in oldResponses) {
      if(response.split("|")[3] == message.data["snippetId"] && response.split("|")[6] == "false") {
        oldResponses[oldResponses.indexOf(response)] = "${response.split("|")[0]}|${response.split("|")[1]}|${response.split("|")[2]}|${response.split("|")[3]}|${response.split("|")[4]}|${response.split("|")[5]}|true";
      }
    }
    oldResponses.add(responseString);
    WidgetKit.setItem(
      'snippetsResponsesData',
      jsonEncode(oldResponses),
      'group.kazoom_snippets');
    WidgetKit.reloadAllTimelines();
  }
} 

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

List<Map<String, dynamic>> createDiscussionUsersList(String discussionUsers) {
    print("DISCUSSION USERS");
    print(discussionUsers);
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

  String createDiscussionUsersString(List<dynamic> discussionUsers) {
    String users = "";
    for (var value in discussionUsers) {
      users += "|${value["userId"]}^${value["FCMToken"]}";
    }
    return users;
   
  }

final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __)  {
          
            return const SwipePages();
          
        }, 
        
        
      ),
      GoRoute(path:"/login", builder: (_, __) {
        return const WelcomePage();
      }),
      GoRoute(path: '/welcome/:uid/:toProfile', builder: (_, __) {
        return WelcomePage(
          uid: __.pathParameters['uid']!,
          toProfile: __.pathParameters['toProfile'] == 'true',
        );
      }),
      GoRoute(path: '/createAccount/:uid/:toProfile', builder: (_, __) {
        return CreateAccountPage(
          uid: __.pathParameters['uid']!,
          toProfile: __.pathParameters['toProfile'] == 'true',
        );
      }),

      GoRoute(path: '/onBoarding/:uid/:toProfile', builder: (_, __) {
        return OnBoardingPage(
          uid: __.pathParameters['uid']!,
          toProfile: __.pathParameters['toProfile'] == 'true',
        );
      }),
      GoRoute(path: '/onBoarding/:visited', builder: (_, __) {
        return OnBoardingPage(

          alreadyOnboarded: __.pathParameters['visited'] == 'true',
        );
      }),
      GoRoute(path: "/home/discussion", builder: (context, state) {
           

            return  DiscussionPage(responseTile: ResponseTile(
                    displayName: state.uri.queryParameters['displayName']!,
                    response: state.uri.queryParameters['response']!,
                    userId: state.uri.queryParameters['userId']!,
                    snippetId: state.uri.queryParameters['snippetId']!,
                    question: state.uri.queryParameters['snippetQuestion']!,
                    theme: state.uri.queryParameters['theme']!,

                    isDisplayOnly: state.uri.queryParameters['isDisplayOnly'] == 'true',
                    isAnonymous:state.uri.queryParameters['snippetType'] == 'anonymous' ,

                  ), theme: state.uri.queryParameters['theme']!);

            } ),
      GoRoute(
            path: '/home/index/:index',
            builder: (context, state) => SwipePages(
              initialIndex: int.parse(state.pathParameters['index']!),
            ),
          ),
        GoRoute(
            path: '/home/widget',
            builder: (context, state) => SwipePages(
              initialIndex: int.parse(state.uri.queryParameters['index']!),
            ),
          ),
          
      GoRoute(
        path: '/friendLink',
        builder: (context, state) => ProfilePage(
          uid: state.uri.queryParameters['uid']!,
          isFriendLink: true,
        ),
      ),
      GoRoute(path: '/home', builder: (_, __) => const SwipePages(), routes: [
         GoRoute(path: "discussion/widget", builder: (context, state) {
           

            return  DiscussionPage(responseTile: ResponseTile(
                    displayName: state.uri.queryParameters['displayName']!,
                    response: state.uri.queryParameters['response']!,
                    userId: state.uri.queryParameters['userId']!,
                    snippetId: state.uri.queryParameters['snippetId']!,
                    question: state.uri.queryParameters['snippetQuestion']!,
                    theme: "blue",

                    isDisplayOnly: true,
                    isAnonymous:state.uri.queryParameters['snippetType'] == 'anonymous' ,

                  ), theme:"blue");

            } ),
        GoRoute(
            path: 'profile/widget',
            builder: (context, state) => ProfilePage(uid: state.uri.queryParameters['uid']!,
            showBackButton: true,),
          ),
          GoRoute(
            path: 'friendLink',
            builder: (context, state) => ProfilePage(
              uid: state.uri.queryParameters['uid']!,
            ),
          ),
          GoRoute(
            path: 'widget/question',
            builder: (context, state) => QuestionPage(
              snippetId: state.uri.queryParameters['id']!,
              theme: "blue",
              question: state.uri.queryParameters['question']!.replaceAll("~", "?"),
              type: state.uri.queryParameters['type']!,
            ),
          ),
          GoRoute(
            path: 'question/:id/:theme/:question/:type',
            builder: (context, state) => QuestionPage(
              snippetId: state.pathParameters['id']!,
              theme: state.pathParameters['theme']!,
              question: state.pathParameters['question']!.replaceAll("~", "?"),
              type: state.pathParameters['type']!,
            ),
          ),
          GoRoute(
            path: 'voting',
            builder: (context, state) => const VotingPage(),
          ),
          
          GoRoute(
            path: 'responses/:id/:theme/:question/:type',
            builder: (context, state) => ResponsesPage(snippetId: state.pathParameters['id']!,
            theme: state.pathParameters['theme']!,
            question: state.pathParameters['question']!,
            isAnonymous: state.pathParameters['type']! == "anonymous",),

          ),
          GoRoute(
            path: 'profile/:uid',
            builder: (context, state) => ProfilePage(uid: state.pathParameters['uid']!,
            showBackButton: true,),
          ),
          
          
          GoRoute(path: 'results',
          builder: (context, state) {
            return const BotwResultsPage();

            } 
          ),
        ],),

    ],
);

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  
  bool isSignedIn = false;
  getUserLoggedInState() async {
    
    bool status = await Auth().isUserLoggedIn();
    if(status){
      await PushNotifications().initNotifications();
    }
    // await LocalDatabase().clearChats();
    Auth().listenToAuthState(userStreamController);

    setState(() {
      isSignedIn = status;
      
    });
    if (!status) {
      router.go('/login');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInState();
    WidgetsBinding.instance.addObserver(this);
  }

  bool compareAnswerList(List<Map<String, dynamic>> l1, List<Map<String, dynamic>> l2) {
    if (l1.length != l2.length) {
      print("Lengths are different");
      return false;
    }
    for (var i = 0; i < l1.length; i++) {
      if (l1[i]["answer"] != l2[i]["answer"] || l1[i]["userId"] != l2[i]["userId"] || l1[i]["displayName"] != l2[i]["displayName"]) {
        print("Answers are different");
        return false;
      }
    }
    print("Lists are the same");
    return true;
  }

  bool compareQuestionsAndIDs(Map<String,dynamic> oldData, Map<String,dynamic> newData) {
    if(oldData["questions"].length != newData["questions"].length) {
      return false;
    }
    if(oldData["ids"].length != newData["ids"].length) {
      return false;
    }
    if(oldData["indexes"].length != newData["indexes"].length) {
      return false;
    }
    if(oldData["isAnonymous"].length != newData["isAnonymous"].length) {
      return false;
    }
    for (var i = 0; i < oldData["questions"].length; i++) {
      if (oldData["questions"][i] != newData["questions"][i] || oldData["ids"][i] != newData["ids"][i]) {
        return false;
      }
      if(oldData["indexes"][i] != newData["indexes"][i]) {
        return false;
      }
      if(oldData["isAnonymous"][i] != newData["isAnonymous"][i]) {
        return false;
      }
      
    }
    return true;
  }

  bool compareResponsesList(List<String> l1, List<String> l2) {
    if (l1.length != l2.length) {
      print("Lengths are different");
      return false;
    }
    for (var i = 0; i < l1.length; i++) {
      if (l1[i] != l2[i]) {
        print("Answers are different");
        return false;
      }
    }
    print("Lists are the same");
    return true;
  }

   @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:

        print("app in resumed");
        //Check if user is logged in
        bool status = await Auth().isUserLoggedIn();
        if(!status) {
          return;
        }
        Map<String, dynamic> botwData = await Database().getBOTW();
        List<Answer> answers = [];
        var answersData = botwData["answers"];
      if (answersData is List) {
        for (var answer in answersData) {
          answers.add(Answer(answer["answer"], answer["userId"], answer["displayName"]));
        }
      } else if (answersData is Map) {
        for (var answer in answersData.values) {
          answers.add(Answer(answer["answer"], answer["userId"], answer["displayName"]));
        }
      }
        Map<String, dynamic> data = WidgetData(botwData["blank"].split(" of")[0], answers: answers).toJson();
        print("NEW BOTW: $data");
        if(await WidgetKit.getItem('botwData', 'group.kazoom_snippets') == null) {
          WidgetKit.setItem(
            'botwData',
            jsonEncode(data),
            'group.kazoom_snippets');
          WidgetKit.reloadAllTimelines();
        } else {
          Map<String,dynamic> oldBOTW = json.decode(await WidgetKit.getItem('botwData', 'group.kazoom_snippets'));
          print("OLD BOTW: $oldBOTW");
          List<Map<String, dynamic>> newAnswers = [];
          for (var answer in data["answers"]) {
            newAnswers.add({
              "answer": answer["answer"],
              "uid": answer["uid"],
              "displayName": answer["displayName"],
            });
          }
          List<Map<String, dynamic>> oldAnswers = [];
          for (var answer in oldBOTW["answers"]) {
            oldAnswers.add({
              "answer": answer["answer"],
              "uid": answer["uid"],
              "displayName": answer["displayName"],
            });
          }
          

          if(oldBOTW["text"] != data["text"] || !compareAnswerList(oldAnswers, newAnswers) ) {
            WidgetKit.setItem(
              'botwData',
              jsonEncode(data),
              'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
          }
        }

        List<Map<String, dynamic>> snippets = await Database().getSnippetsList();
        Map<String, dynamic> snippetData = {
          "questions": snippets.map((e) => e["question"]).toList(),
          "ids": snippets.map((e) => e["snippetId"]).toList(),
          "indexes": snippets.map((e) => e["index"]).toList(),
          "isAnonymous": snippets.map((e) => e["type"] == "anonymous").toList(),
        };
        if(await WidgetKit.getItem('snippetsData', 'group.kazoom_snippets') == null) {
          WidgetKit.setItem(
            'snippetsData',
            jsonEncode(snippetData),
            'group.kazoom_snippets');
          WidgetKit.reloadAllTimelines();
        } else {
          Map<String, dynamic> oldSnippets = json.decode(await WidgetKit.getItem('snippetsData', 'group.kazoom_snippets'));
          if(!compareQuestionsAndIDs(oldSnippets, snippetData)) {

            WidgetKit.setItem(
              'snippetsData',
              jsonEncode(snippetData),
              'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
          }
        }

        List<Map<String, dynamic>> snippetResponses = await Database().getSnippetsResponses();
        List<String> responseStrings = [];
        List<String> unansweredQuestions = [];

        for (var response in snippetResponses) {
          if(unansweredQuestions.contains(response["snippetId"])) {
            continue;
          }
         

          responseStrings.add("${response["displayName"]}|${snippets.firstWhere((e) => e["snippetId"] == response["snippetId"])["question"]}|${response["answer"]}|${response["snippetId"]}|${response["uid"]}|${snippets.firstWhere((e) => e["snippetId"] == response["snippetId"])["type"] == "anonymous"}|${snippets.firstWhere((e) => e["snippetId"] == response["snippetId"])["answered"]}");
          if(snippets.firstWhere((e) => e["snippetId"] == response["snippetId"])["answered"] == false) {
            unansweredQuestions.add(response["snippetId"]);
          }
        }
        print("RESPONSE STRINGS: $responseStrings");
        if(await WidgetKit.getItem('snippetsResponsesData', 'group.kazoom_snippets') == null) {
          WidgetKit.setItem(
            'snippetsResponsesData',
            jsonEncode({"responses": responseStrings}),
            'group.kazoom_snippets');
          WidgetKit.reloadAllTimelines();
        } else {
          Map<String, dynamic> oldResponsesMap = json.decode(await WidgetKit.getItem('snippetsResponsesData', 'group.kazoom_snippets'));
          List<String> oldResponses = oldResponsesMap["responses"].cast<String>();
          if(!compareResponsesList(oldResponses, responseStrings)) {
            WidgetKit.setItem(
              'snippetsResponsesData',
              jsonEncode({"responses": responseStrings}),
              'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
          }
        }


        
        
        await LocalDatabase().deleteOldResponse();
        if (await FlutterAppBadgeControl.isAppBadgeSupported()) {
         await  FlutterAppBadgeControl.removeBadge();
        HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('setNotificationCount')
        .call({
          'count': 0,
          'fcmToken': await PushNotifications().getDeviceToken(),
        });
          print(result.data);
         print("badge removed");
        }

        //Check if FCM token changed
        String deviceToken = await PushNotifications().getDeviceToken();
        Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
        print("DEVICE TOKEN: $deviceToken");
        print("USER DATA Token: ${userData}");
        if (userData['FCMToken'] != deviceToken) {
          //Update FCM token
          await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).updateUserFCMToken(deviceToken);
          //Subscribe to topic
          await PushNotifications().subscribeToTopic("all");
        }

        break;
      case AppLifecycleState.inactive:
        print("app in inactive");

        break;
      case AppLifecycleState.paused:
        print("app in paused");

        break;
      case AppLifecycleState.detached:
        print("app in detached");

        break;
      case AppLifecycleState.hidden:
        print("app in hidden");

        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: ChangeNotifierProvider(
        create: (context) => CardProvider(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          // home: isSignedIn ? const SwipePages() : const WelcomePage(),
          // navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}
