import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/api/remote_config.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/app_badge.dart';

import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/botw_results_page.dart';
import 'package:snippets/pages/create_account_page.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/forgot_password_page.dart';
import 'package:snippets/pages/no_wifi_page.dart';
import 'package:snippets/pages/onboarding_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/pages/question_page.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/pages/swipe_pages.dart';
import 'package:snippets/pages/update_page.dart';
import 'package:snippets/pages/voting_page.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/providers/card_provider.dart';

import 'package:snippets/widgets/response_tile.dart';

import 'firebase_options.dart';

const String appGroupId = 'group.kazoom_snippets';
const String iOSWidgetName = 'Snippets_Widgets';
// final navigatorKey = GlobalKey<NavigatorState>();

final StreamController<User> currentUserStream =
    StreamController<User>.broadcast();

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
        answers =
            (json['answers'] as List).map((e) => Answer.fromJson(e)).toList();

  Map<String, dynamic> toJson() => {
        'text': text,
        'answers': answers.map((e) => e.toJson()).toList(),
      };
}

AppDb localDb = AppDb();
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // print("Snippets: Handling a background message: ${message.messageId}");
//   // // If you're going to use other Firebase services in the background, such as Firestore,
//   // // make sure you call `initializeApp` before using other Firebase services.
//   //   await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );

//   // if(message.data["type"] == "widget-botw"){

//   //   Map<String, dynamic> data = WidgetData(message.data["blank"].split(" of")[0], answers: []).toJson();

//   //     WidgetKit.setItem(
//   //       'botwData',
//   //       jsonEncode(data),
//   //       'group.kazoom_snippets');
//   //     WidgetKit.reloadAllTimelines();
//   //     await AppBadge.addBadge(1);
//   // } else if(message.data["type"] == "widget-question"){

//   //   Map<String, dynamic> oldSnippets = json.decode(await WidgetKit.getItem('snippetsData', 'group.kazoom_snippets'));

//   //   List<String> questions = oldSnippets["questions"].cast<String>();

//   //   List<String> ids = oldSnippets["ids"].cast<String>();

//   //   List<bool> hasAnswereds = oldSnippets["hasAnswereds"].cast<bool>();

//   //   List<int> indexes = oldSnippets["indexes"].cast<int>();

//   //   List<bool> isAnonymous = oldSnippets["isAnonymous"].cast<bool>();

//   //     dynamic indexData = message.data["index"];
//   //     if(indexData is String) {
//   //       indexData = int.parse(indexData);
//   //     }
//   //   int index = indexes.indexOf(indexData);

//   //   if(index == -1) {

//   //     questions.add(message.data["question"]);
//   //     ids.add(message.data["snippetId"]);

//   //     indexes.add(indexData);
//   //     isAnonymous.add(message.data["snippetType"] == "anonymous");
//   //     hasAnswereds.add(false);

//   //   } else {
//   //     //Old question
//   //     String oldId = ids[index];
//   //     //Delete old responses
//   //     Map<String, dynamic> oldResponsesMap = json.decode(await WidgetKit.getItem('snippetsResponsesData', 'group.kazoom_snippets'));
//   //     List<String> oldResponses = oldResponsesMap["responses"].cast<String>();
//   //     List<String> newResponses = [];
//   //     for (var response in oldResponses) {
//   //       if(response.split("|")[3] == oldId) {
//   //         continue;
//   //       }
//   //       newResponses.add(response);
//   //     }
//   //     oldResponsesMap["responses"] = newResponses;
//   //     WidgetKit.setItem(
//   //       'snippetsResponsesData',
//   //       jsonEncode(oldResponsesMap),
//   //       'group.kazoom_snippets');
//   //     questions[index] = message.data["question"];
//   //     ids[index] = message.data["snippetId"];

//   //     indexes[index] = indexData;
//   //     isAnonymous[index] = message.data["snippetType"] == "anonymous";
//   //     hasAnswereds[index] = false;
//   //   }
//   //   Map<String, dynamic> snippetData = {
//   //     "questions": questions,
//   //     "ids": ids,
//   //     "hasAnswereds": hasAnswereds,
//   //     "indexes": indexes,
//   //     "isAnonymous": isAnonymous,
//   //   };

//   //   WidgetKit.setItem(
//   //     'snippetsData',
//   //     jsonEncode(snippetData),
//   //     'group.kazoom_snippets');
//   //   WidgetKit.reloadAllTimelines();
//   //   await AppBadge.addBadge(1);

//   // } else if(message.data["type"] == "widget-botw-answer"){
//   //   Map<String, dynamic> oldBOTW = json.decode(await WidgetKit.getItem('botwData', 'group.kazoom_snippets'));
//   //   Map<String, dynamic> answer = {
//   //     "answer": message.data["answer"],
//   //     "uid": message.data["uid"],
//   //     "displayName": message.data["displayName"],
//   //   };
//   //   List<Map<String, dynamic>> oldAnswers = oldBOTW["answers"].cast<Map<String, dynamic>>();
//   //   //Check if answer already exists
//   //   Map<String, dynamic>? oldAnswer = oldAnswers.firstWhere((element) => element["uid"] == message.data["uid"], orElse: () => {});
//   //   if(oldAnswer.isEmpty) {
//   //     oldAnswers.add(answer);
//   //   } else {
//   //     oldAnswers[oldAnswers.indexOf(oldAnswer)] = answer;
//   //   }
//   //   oldBOTW["answers"] = oldAnswers;
//   //   WidgetKit.setItem(
//   //     'botwData',
//   //     jsonEncode(oldBOTW),
//   //     'group.kazoom_snippets');
//   //   WidgetKit.reloadAllTimelines();

//   // } else if(message.data["type"] == "widget-snippet-response"){
//   //   Map<String, dynamic> oldResponsesMap = json.decode(await WidgetKit.getItem('snippetsResponsesData', 'group.kazoom_snippets'));
//   //   List<String> oldResponses = oldResponsesMap["responses"].cast<String>();
//   //   String responseString = "${message.data["displayName"]}|${message.data["question"]}|${message.data["response"]}|${message.data["snippetId"]}|${message.data["userId"]}|${message.data["snippetType"] == "anonymous"}|${message.data["answered"]}";
//   //   if(oldResponses.contains(responseString)) {
//   //     return;
//   //   }
//   //   //Check if other responses are unanswered
//   //   for(var response in oldResponses) {
//   //     if(response.split("|")[3] == message.data["snippetId"] && response.split("|")[6] == "false" ) {
//   //       oldResponses[oldResponses.indexOf(response)] = "${response.split("|")[0]}|${response.split("|")[1]}|${response.split("|")[2]}|${response.split("|")[3]}|${response.split("|")[4]}|${response.split("|")[5]}|true";
//   //     }
//   //   }
//   //   oldResponses.add(responseString);
//   //   WidgetKit.setItem(
//   //     'snippetsResponsesData',
//   //     jsonEncode(oldResponses),
//   //     'group.kazoom_snippets');
//   //   WidgetKit.reloadAllTimelines();
//   //   await AppBadge.addBadge(1);
//   // } else if(message.data["type"] == "notification") {
//   //   await AppBadge.addBadge(1);

//   // }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

List<DiscussionUser> createDiscussionUsersList(String discussionUsers) {
  List<DiscussionUser> users = [];
  List<String> userStrings = discussionUsers.split("|");
  for (var user in userStrings) {
    List<String> userParts = user.split("^");
    if (userParts.length == 2) {
      users.add(DiscussionUser(FCMToken: userParts[1], userId: userParts[0]));
    }
  }
  return users;
}

String createDiscussionUsersString(List<DiscussionUser> discussionUsers) {
  String users = "";
  for (var value in discussionUsers) {
    users += "|${value.userId}^${value.FCMToken}";
  }
  return users;
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) {
        return const SwipePages();
      },
    ),
    GoRoute(
      path: '/update/:isLoggedIn',
      builder: (_, __) {
        return UpdatePage(
          isLoggedIn: __.pathParameters["isLoggedIn"] == "true",
        );
      },
    ),
    GoRoute(
      path: '/nowifi',
      builder: (_, __) {
        return const NoWifiPage();
      },
    ),
    GoRoute(
        path: "/login",
        builder: (_, __) {
          return const WelcomePage();
        }),
    GoRoute(
        path: '/welcome/:uid/:toProfile',
        builder: (_, __) {
          return WelcomePage(
            uid: __.pathParameters['uid']!,
            toProfile: __.pathParameters['toProfile'] == 'true',
          );
        }),
    GoRoute(
        path: '/forgotPassword/:uid/:toProfile',
        builder: (_, __) {
          return ForgotPasswordPage(
            uid: __.pathParameters['uid']!,
            toProfile: __.pathParameters['toProfile'] == 'true',
          );
        }),
    GoRoute(
        path: '/createAccount/:uid/:toProfile',
        builder: (_, __) {
          return CreateAccountPage(
            uid: __.pathParameters['uid']!,
            toProfile: __.pathParameters['toProfile'] == 'true',
          );
        }),
    GoRoute(
        path: '/onBoarding/:uid/:toProfile',
        builder: (_, __) {
          return OnBoardingPage(
            uid: __.pathParameters['uid']!,
            toProfile: __.pathParameters['toProfile'] == 'true',
          );
        }),
    GoRoute(
        path: '/onBoarding/:visited',
        builder: (_, __) {
          return OnBoardingPage(
            alreadyOnboarded: __.pathParameters['visited'] == 'true',
          );
        }),
    GoRoute(
        path: "/home/discussion",
        builder: (context, state) {
          return DiscussionPage(
              responseTile: ResponseTile(
                displayName: state.uri.queryParameters['displayName']!,
                response: state.uri.queryParameters['response']!,
                userId: state.uri.queryParameters['userId']!,
                snippetId: state.uri.queryParameters['snippetId']!,
                question: state.uri.queryParameters['snippetQuestion']!
                    .replaceAll("~", "?"),
                theme: state.uri.queryParameters['theme']!,
                isDisplayOnly:
                    state.uri.queryParameters['isDisplayOnly'] == 'true',
                isAnonymous:
                    state.uri.queryParameters['snippetType'] == 'anonymous',
              ),
              theme: state.uri.queryParameters['theme']!);
        }),
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
    GoRoute(
      path: '/home',
      builder: (_, __) => const SwipePages(),
      routes: [
        GoRoute(
            path: "discussion/widget",
            builder: (context, state) {
              return DiscussionPage(
                  responseTile: ResponseTile(
                    displayName: state.uri.queryParameters['displayName']!,
                    response: state.uri.queryParameters['response']!,
                    userId: state.uri.queryParameters['userId']!,
                    snippetId: state.uri.queryParameters['snippetId']!,
                    question: state.uri.queryParameters['snippetQuestion']!
                        .replaceAll("~", "?"),
                    theme: "blue",
                    isDisplayOnly: true,
                    isAnonymous:
                        state.uri.queryParameters['snippetType'] == 'anonymous',
                  ),
                  theme: "blue");
            }),
        GoRoute(
          path: 'profile/widget',
          builder: (context, state) => ProfilePage(
            uid: state.uri.queryParameters['uid']!,
            showBackButton: true,
          ),
        ),
        GoRoute(
          path: 'friendLink',
          builder: (context, state) => ProfilePage(
            uid: state.uri.queryParameters['uid']!,
          ),
        ),
        GoRoute(
          path: 'question/widget',
          builder: (context, state) => QuestionPage(
            snippetId: state.uri.queryParameters['id']!,
            theme: "blue",
            question:
                state.uri.queryParameters['question']!.replaceAll("~", "?"),
            type: state.uri.queryParameters['type']!,
          ),
        ),
        GoRoute(
          path: 'responses/widget',
          builder: (context, state) => ResponsesPage(
            snippetId: state.uri.queryParameters['id']!,
            theme: "blue",
            question: state.uri.queryParameters['question']!,
            isAnonymous: state.uri.queryParameters['type']! == "anonymous",
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
          builder: (context, state) => ResponsesPage(
            snippetId: state.pathParameters['id']!,
            theme: state.pathParameters['theme']!,
            question: state.pathParameters['question']!,
            isAnonymous: state.pathParameters['type']! == "anonymous",
          ),
        ),
        GoRoute(
          path: 'profile/:uid',
          builder: (context, state) => ProfilePage(
            uid: state.pathParameters['uid']!,
            showBackButton: true,
          ),
        ),
        GoRoute(
            path: 'results',
            builder: (context, state) {
              return const BotwResultsPage();
            }),
      ],
    ),
  ],
);

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  final connectionChecker = InternetConnectionChecker();
  late StreamSubscription<InternetConnectionStatus> subscription;

  bool isSignedIn = false;
  getUserLoggedInState() async {
    int updateLocalDB = await HelperFunctions.getLocalDatabaseUpdateSF();
    if (updateLocalDB < 16) {
      print("Deleting local database");
      await LocalDatabase().deleteDB();
      await HelperFunctions.saveLocalDatabaseUpdateSF(16);
    }

    bool status = await Auth().isUserLoggedIn();
    if (status) {
      await PushNotifications().initNotifications();
    }
    // await LocalDatabase().clearChats();

    setState(() {
      isSignedIn = status;
    });
    if (!status) {
      router.go('/login');
    }
    Auth().listenToAuthState(currentUserStream);
    bool needsUpdate = await RemoteConfig().checkUpdates();
    if (needsUpdate) {
      //Show update dialog
      router.go('/update/$status');
    } else if (await HelperFunctions.getOpenedPageFromSF() == "update") {
      router.go('/');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subscription = connectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) async {
        if (status == InternetConnectionStatus.connected) {
          //Check if on /nowifi
          String? currentPage = await HelperFunctions.getOpenedPageFromSF();
          if (currentPage == "nowifi") {
            bool status = await Auth().isUserLoggedIn();
            if (!status) {
              router.go('/login');
            } else {
              router.go('/');
            }
          }
        } else {
          router.pushReplacement("/nowifi");
        }
      },
    );
    getUserLoggedInState();
    WidgetsBinding.instance.addObserver(this);
  }

  bool compareAnswerList(
      List<Map<String, dynamic>> l1, List<Map<String, dynamic>> l2) {
    if (l1.length != l2.length) {
      return false;
    }
    for (var i = 0; i < l1.length; i++) {
      if (l1[i]["answer"] != l2[i]["answer"] ||
          l1[i]["userId"] != l2[i]["userId"] ||
          l1[i]["displayName"] != l2[i]["displayName"]) {
        return false;
      }
    }

    return true;
  }

  bool compareQuestionsAndIDs(
      Map<String, dynamic> oldData, Map<String, dynamic> newData) {
    if (oldData["snippets"].length != newData["snippets"].length) {
      return false;
    }

    for (var i = 0; i < oldData["snippets"].length; i++) {
      if (oldData["snippets"][i] != newData["snippets"][i]) {
        return false;
      }
    }
    return true;
  }

  bool compareResponsesList(List<String> l1, List<String> l2) {
    if (l1.length != l2.length) {
      return false;
    }
    for (var i = 0; i < l1.length; i++) {
      if (l1[i] != l2[i]) {
        return false;
      }
    }

    return true;
  }

  Future fixUserData(User dataToFix) async {
    List<UserMini> friends = dataToFix.friends;
    List<UserMini> friendRequests = dataToFix.friendRequests;
    List<UserMini> outgoingRequests = dataToFix.outgoingFriendRequests;
    List<String> friendIds = friends.map((e) => e.userId).toList();
    print(friendIds);
    print("Fixing user data");
    //Check if has any friend requests that are in friends list
    for (UserMini request in friendRequests) {
      if (friendIds.contains(request.userId)) {
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .removeFriendRequest(request, dataToFix);
      }
    }

    //Check if has any outgoing requests that are in friends list
    for (UserMini request in outgoingRequests) {
      print("Checking outgoing requests");
      print("Request: $request");
      if (friendIds.contains(request.userId)) {
        print("Removing request");
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .removeOutgoingFriendRequest(request, dataToFix);
      }
    }

    //Check for duplicate friends
    List<String> readIds = [];
    List<UserMini> requestsToRemove = [];
    for (var i = 0; i < friendIds.length; i++) {
      String id = friendIds[i];
      if (readIds.contains(id)) {
        requestsToRemove.add(friends[readIds.indexOf(id)]);
        readIds[readIds.indexOf(id)] = "removed";
        readIds.add(id);
      } else {
        readIds.add(id);
      }
    }

    for (UserMini request in requestsToRemove) {
      await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
          .removeFriendFix(request, dataToFix);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        bool isConnected = await InternetConnectionChecker().hasConnection;
        if (isConnected) {
          //Check if on /nowifi
          String? currentPage = await HelperFunctions.getOpenedPageFromSF();
          if (currentPage == "nowifi") {
            bool status = await Auth().isUserLoggedIn();
            if (!status) {
              router.go('/login');
              return;
            } else {
              router.go('/');
            }
          }
        } else {
          router.pushReplacement("/nowifi");
          return;
        }
        //Check if user is logged in
        bool status = await Auth().isUserLoggedIn();
        bool needsUpdate = await RemoteConfig().checkUpdates();
        if (needsUpdate) {
          //Show update dialog
          router.go('/update/$status');
        } else if (await HelperFunctions.getOpenedPageFromSF() == "update") {
          router.go('/');
        }
        if (!status) {
          return;
        }
        BOTW botwData = await Database().getBOTW();
        List<Answer> answers = [];
        var answersData = botwData.answers;

        for (var answer in answersData.values) {
          answers.add(Answer(answer.answer, answer.userId, answer.displayName));
        }
        print("BOTW DATA");
        print(botwData);
        Map<String, dynamic> data =
            WidgetData(botwData.blank.split(" of")[0], answers: answers)
                .toJson();

        if (await WidgetKit.getItem('botwData', 'group.kazoom_snippets') ==
            null) {
          WidgetKit.setItem(
              'botwData', jsonEncode(data), 'group.kazoom_snippets');
          WidgetKit.reloadAllTimelines();
        } else {
          Map<String, dynamic> oldBOTW = json.decode(
              await WidgetKit.getItem('botwData', 'group.kazoom_snippets'));

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

          if (oldBOTW["text"] != data["text"] ||
              !compareAnswerList(oldAnswers, newAnswers)) {
            WidgetKit.setItem(
                'botwData', jsonEncode(data), 'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
          }
        }

        List<Snippet> snippets = await Database().getSnippetsList();
        List<Map<String, dynamic>> snippetsData = [];
        List<Snippet> removedSnippets = [];
        for (var snippet in snippets) {
          Map<String, dynamic> snippetData = snippet.toMap();
          int index = snippets.indexOf(snippet);
          if (snippet.type == "anonymous") {
            DateTime now = DateTime.now();
            DateTime lastRecieved =
                DateTime.fromMillisecondsSinceEpoch(snippet.lastRecievedMillis);
            snippetData["removalDate"] = DateFormat("yyyy-MM-dd HH:mm:ss")
                .format(lastRecieved.add(const Duration(days: 1)));
            if (now.isAfter(lastRecieved.add(const Duration(days: 1)))) {
              removedSnippets.add(snippet);
            }
          } else if (snippet.type == "custom") {
            DateTime now = DateTime.now();
            DateTime lastRecieved =
                DateTime.fromMillisecondsSinceEpoch(snippet.lastRecievedMillis);
            snippetData["removalDate"] = DateFormat("yyyy-MM-dd HH:mm:ss")
                .format(lastRecieved.add(const Duration(days: 1)));
            if (now.isAfter(lastRecieved.add(const Duration(days: 1)))) {
              removedSnippets.add(snippet);
            }
          } else {
            snippetData["removalDate"] = "None";
          }
          snippetsData.add(snippetData);
        }
        for (var rSnippet in removedSnippets) {
          snippets.remove(rSnippet);
          snippetsData.remove(snippetsData
              .firstWhere((e) => e["snippetId"] == rSnippet.snippetId));
          await LocalDatabase().deleteSnippetById(rSnippet.snippetId);
        }
        List<String> snippetStrings = [];
        for (var snippet in snippetsData) {
          snippetStrings.add(
              "${snippet["question"]}|${snippet["snippetId"]}|${snippet["index"]}|${snippet["type"]}|${snippet["answered"] ? "true" : "false"}|${snippet["removalDate"]}");
        }

        if (await WidgetKit.getItem('snippetsData', 'group.kazoom_snippets') ==
            null) {
          print("NULL SNIPPETS");

          WidgetKit.setItem(
              'snippetsData',
              jsonEncode({
                "snippets": snippetStrings,
              }),
              'group.kazoom_snippets');
          WidgetKit.reloadAllTimelines();
        } else {
          Map<String, dynamic> oldSnippets = json.decode(
              await WidgetKit.getItem('snippetsData', 'group.kazoom_snippets'));

          if (!compareQuestionsAndIDs(oldSnippets, {
            "snippets": snippetStrings,
          })) {
            WidgetKit.setItem(
                'snippetsData',
                jsonEncode({
                  "snippets": snippetStrings,
                }),
                'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
          }
        }

        List<SnippetResponse> snippetResponses =
            await Database().getSnippetsResponses();
        List<String> responseStrings = [];
        List<String> unansweredQuestions = [];

        for (var response in snippetResponses) {
          if (unansweredQuestions.contains(response.snippetId)) {
            continue;
          }
          if (response.userId == auth.FirebaseAuth.instance.currentUser!.uid) {
            continue;
          }

          responseStrings.add(
              "${response.displayName}|${snippets.firstWhere((e) => e.snippetId == response.snippetId).question}|${response.answer}|${response.snippetId}|${response.userId}|${snippets.firstWhere((e) => e.snippetId == response.snippetId).type}|${snippets.firstWhere((e) => e.snippetId == response.snippetId).answered ? "true" : "false"}");
          if (snippets
                  .firstWhere((e) => e.snippetId == response.snippetId)
                  .answered ==
              false) {
            unansweredQuestions.add(response.snippetId);
          }
        }

        if (await WidgetKit.getItem(
                'snippetsResponsesData', 'group.kazoom_snippets') ==
            null) {
          WidgetKit.setItem(
              'snippetsResponsesData',
              jsonEncode({
                "responses": responseStrings,
              }),
              'group.kazoom_snippets');
          WidgetKit.reloadAllTimelines();
        } else {
          Map<String, dynamic> oldResponsesMap = json.decode(
              await WidgetKit.getItem(
                  'snippetsResponsesData', 'group.kazoom_snippets'));
          List<String> oldResponses =
              oldResponsesMap["responses"].cast<String>();
          print("OLD RESPONSES");
          print(oldResponses);
          print("NEW RESPONSES");
          print(responseStrings);
          if (!compareResponsesList(oldResponses, responseStrings)) {
            WidgetKit.setItem(
                'snippetsResponsesData',
                jsonEncode({
                  "responses": responseStrings,
                }),
                'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
          }
        }

        await LocalDatabase().deleteOldResponse();
        // await AppBadge.resetBadge();
        //Check if on IOS
        if (Platform.isIOS) {
          AppBadge.resetBadge();
          WidgetKit.setItem("badgeCount", 0, 'group.kazoom_snippets');
        }
        int numCachedResponses = await LocalDatabase().numberOfResponses();
        int numCachedSnippets = await LocalDatabase().numberOfSnippets();
        print("Cached responses: $numCachedResponses");
        print("Cached snippets: $numCachedSnippets");

        //Check if FCM token changed
        String deviceToken = await PushNotifications().getDeviceToken();
        User userData = await Database()
            .getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
        fixUserData(userData);

        if (userData.FCMToken != deviceToken) {
          //Update FCM token
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .updateUserFCMToken(deviceToken);
          //Subscribe to topic
          await PushNotifications().subscribeToTopic("all");
        }

        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    currentUserStream.close();
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
