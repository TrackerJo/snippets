import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/api/remote_config.dart';
import 'package:snippets/api/storage.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/app_badge.dart';
import 'package:snippets/helper/app_icon_changer.dart';

import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/app_preferences_page.dart';
import 'package:snippets/pages/banned_page.dart';
import 'package:snippets/pages/botw_results_page.dart';
import 'package:snippets/pages/community_guidelines_page.dart';
import 'package:snippets/pages/create_account_page.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/forgot_password_page.dart';
import 'package:snippets/pages/no_wifi_page.dart';
import 'package:snippets/pages/onboarding_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/pages/question_page.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/pages/settings_page.dart';
import 'package:snippets/pages/strikes_page.dart';
import 'package:snippets/pages/swipe_pages.dart';
import 'package:snippets/pages/trivia_responses_page.dart';
import 'package:snippets/pages/update_page.dart';
import 'package:snippets/pages/voting_page.dart';
import 'package:snippets/pages/login_page.dart';
import 'package:snippets/providers/card_provider.dart';
import 'package:snippets/templates/styling.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/response_tile.dart';

import 'firebase_options.dart';

const String appGroupId = 'group.kazoom_snippets';
const String iOSWidgetName = 'Snippets_Widgets';
// final navigatorKey = GlobalKey<NavigatorState>();

final StreamController<User> currentUserStream =
    StreamController<User>.broadcast();

final StreamController<RemoteMessage> onMessageStream =
    StreamController<RemoteMessage>.broadcast();

final StreamController<RemoteMessage> onMessageOpenedAppStream =
    StreamController<RemoteMessage>.broadcast();

final Styling styling = Styling();

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
      path: "/banned",
      builder: (_, __) {
        return const BannedPage();
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
      path: '/strikes/:strikesReceived/:totalStrikes',
      builder: (_, __) {
        List<String> strikesReceived =
            __.pathParameters['strikesReceived']!.split(",");
        int totalStrikes = int.parse(__.pathParameters['totalStrikes']!);
        return StrikesPage(
          strikesReceived: strikesReceived,
          totalStrikes: totalStrikes,
        );
      },
    ),
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
      path: '/guidelines',
      builder: (_, __) {
        return const CommunityGuidelinesPage();
      },
    ),
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
                reports: 0,
                question: state.uri.queryParameters['snippetQuestion']!
                    .replaceAll("Q~Q", "?"),
                theme: state.uri.queryParameters['theme']!,
                reportIds: [],
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
        showAppBar: true,
        isFriendLink: true,
      ),
    ),
    GoRoute(
      path: "/settings",
      builder: (context, state) {
        return const SettingsPage();
      },
    ),
    GoRoute(
        path: "/app_preferences",
        builder: (context, state) {
          return const AppPreferencesPage();
        }),
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
                    reports: 0,
                    snippetId: state.uri.queryParameters['snippetId']!,
                    question: state.uri.queryParameters['snippetQuestion']!
                        .replaceAll("Q~Q", "?"),
                    reportIds: [],
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
            showAppBar: true,
            showBackButton: true,
          ),
        ),
        GoRoute(
          path: 'friendLink',
          builder: (context, state) => ProfilePage(
            uid: state.uri.queryParameters['uid']!,
            showAppBar: true,
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
            options: state.uri.queryParameters['options']!.split("OPT^OPT"),
            correctAnswer: state.uri.queryParameters['correctAnswer']!,
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
          path: 'question/:id/:theme/:question/:type/:options/:correctAnswer',
          builder: (context, state) => QuestionPage(
            snippetId: state.pathParameters['id']!,
            theme: state.pathParameters['theme']!,
            question: state.pathParameters['question']!.replaceAll("~", "?"),
            type: state.pathParameters['type']!,
            options: state.pathParameters['options']!.split("OPT^OPT"),
            correctAnswer: state.pathParameters['correctAnswer']!,
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
          path: 'triviaResponses/:id/:theme/:question/:type',
          builder: (context, state) => TriviaResponsesPage(
            snippetId: state.pathParameters['id']!,
            question: state.pathParameters['question']!,
          ),
        ),
        GoRoute(
          path: 'profile/:uid',
          builder: (context, state) => ProfilePage(
            uid: state.pathParameters['uid']!,
            showAppBar: true,
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

Key refreshKey = UniqueKey();

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  late StreamSubscription<InternetStatus> subscription;

  bool isSignedIn = false;
  getUserLoggedInState() async {
    int updateLocalDB = await HelperFunctions.getLocalDatabaseUpdateSF();
    if (updateLocalDB < 30) {
      await LocalDatabase().deleteDB();
      await HelperFunctions.saveLocalDatabaseUpdateSF(30);
    }
    // bool setNewYearIcon = await HelperFunctions.getSetNewYearIconSF();
    // if (!setNewYearIcon && Platform.isIOS) {
    //   await AppIconChanger.changeIcon("NewYear");

    //   await HelperFunctions.saveSetNewYearIconSF(true);
    // }
    String appIcon = await HelperFunctions.getAppIconSF();
    if (Platform.isAndroid && appIcon != "default") {
      await AppIconChanger.changeIcon("default");
    }

    String theme = await HelperFunctions.getThemeSF();
    if (theme == "christmas") {
      theme = "dark";
      await HelperFunctions.saveThemeSF(theme);
    }
    styling.setTheme(theme);

    bool status = await Auth().isUserLoggedIn();
    if (status) {
      // if (!isUserLoggedIn) {
      //   Auth().signOut();
      //   status = false;
      //   return;
      // }
      await Database()
          .updateUserStreak(auth.FirebaseAuth.instance.currentUser!.uid);
      await PushNotifications().initNotifications();
      List<String> topics = await HelperFunctions.getTopicNotifications();
      if (topics.isEmpty) {
        print("Subscribing to topics");
        await HelperFunctions.addTopicNotification("all");
        await HelperFunctions.addTopicNotification("botw");
        await HelperFunctions.addTopicNotification("snippets");
        await HelperFunctions.addAllowedNotification("friend");
        await HelperFunctions.addAllowedNotification("discussion");
        await HelperFunctions.addAllowedNotification("snippets");
        await HelperFunctions.addAllowedNotification("botw");
        await HelperFunctions.addAllowedNotification("snippetResponse");
        await PushNotifications().subscribeToTopic("all");
        await PushNotifications().subscribeToTopic("botw");
        await PushNotifications().subscribeToTopic("snippets");
        await Storage().changeAllowedNotification("friend", true);
        await Storage().changeAllowedNotification("discussion", true);
        await Storage().changeAllowedNotification("snippetResponse", true);
      }
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
    if (status) {
      User userData = await Database().getCurrentUserData();
      List<String> profileStrikesSaved =
          await HelperFunctions.getProfileStrikesSF();
      if (profileStrikesSaved != userData.profileStrikes) {
        await HelperFunctions.saveProfileStrikesSF(userData.profileStrikes);
        if (userData.profileStrikes.length > profileStrikesSaved.length) {
          List<String> strikesReceived = [];
          for (var i = 0; i < userData.profileStrikes.length; i++) {
            if (i >= profileStrikesSaved.length) {
              strikesReceived.add(userData.profileStrikes[i]);
            }
          }
          router.push(
              "/strikes/${strikesReceived.join(",")}/${userData.profileStrikes.length}");
          return;
        }
      }
      if (userData.profileStrikes.length >= 5) {
        router.push("/banned");
      }
      bool acceptedGuidelines =
          await HelperFunctions.getAcceptedCommunityGuidelinesSF();
      if (!acceptedGuidelines) {
        router.push("/guidelines");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subscription = InternetConnection().onStatusChange.listen(
      (InternetStatus status) async {
        if (status == InternetStatus.connected) {
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

    //Check if has any friend requests that are in friends list
    for (UserMini request in friendRequests) {
      if (friendIds.contains(request.userId)) {
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .removeFriendRequest(request, dataToFix);
      }
    }

    //Check if has any outgoing requests that are in friends list
    for (UserMini request in outgoingRequests) {
      if (friendIds.contains(request.userId)) {
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
        print("APP RESUMED");
        bool isConnected = await InternetConnection().hasInternetAccess;
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

        String theme = await HelperFunctions.getThemeSF();
        styling.setTheme(theme);
        //Check if user is logged in
        bool status = await Auth().isUserLoggedIn();
        if (status) {
          // if (!isUserLoggedIn) {
          //   Auth().signOut();
          //   status = false;
          //   return;
          // }
          bool isListening = await HelperFunctions.getListenedToUserSF();
          print("Is listening: $isListening");
          if (!isListening) {
            Auth().listenToAuthState(currentUserStream);
          }
        }
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
        if (Platform.isIOS) {
          BOTW botwData = await Database().getBOTW();
          List<Answer> answers = [];
          var answersData = botwData.answers;

          for (var answer in answersData.values) {
            answers
                .add(Answer(answer.answer, answer.userId, answer.displayName));
          }

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
        if (Platform.isIOS) {
          if (await WidgetKit.getItem(
                  'snippetsData', 'group.kazoom_snippets') ==
              null) {
            WidgetKit.setItem(
                'snippetsData',
                jsonEncode({
                  "snippets": snippetStrings,
                }),
                'group.kazoom_snippets');
            WidgetKit.reloadAllTimelines();
          } else {
            Map<String, dynamic> oldSnippets = json.decode(
                await WidgetKit.getItem(
                    'snippetsData', 'group.kazoom_snippets'));

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
        }

        if (Platform.isIOS) {
          List<SnippetResponse> snippetResponses =
              await Database().getSnippetsResponses();
          List<String> responseStrings = [];
          List<String> unansweredQuestions = [];

          for (var response in snippetResponses) {
            if (unansweredQuestions.contains(response.snippetId)) {
              continue;
            }
            if (response.userId ==
                auth.FirebaseAuth.instance.currentUser!.uid) {
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

        //Check if FCM token changed
        String deviceToken = await PushNotifications().getDeviceToken();

        User userData = await Database().getCurrentUserData();
        // await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        //     .removeOldDiscussions(userData, snippets);
        fixUserData(userData);
        List<String> profileStrikesSaved =
            await HelperFunctions.getProfileStrikesSF();
        if (profileStrikesSaved != userData.profileStrikes) {
          await HelperFunctions.saveProfileStrikesSF(userData.profileStrikes);
          if (userData.profileStrikes.length > profileStrikesSaved.length) {
            List<String> strikesReceived = [];
            for (var i = 0; i < userData.profileStrikes.length; i++) {
              if (i >= profileStrikesSaved.length) {
                strikesReceived.add(userData.profileStrikes[i]);
              }
            }
            router.push(
                "/strikes/${strikesReceived.join(",")}/${userData.profileStrikes.length}");
          } else if (userData.profileStrikes.length >= 5) {
            router.push("/banned");
          }
        } else if (userData.profileStrikes.length >= 5) {
          router.push("/banned");
        }
        bool acceptedGuidelines =
            await HelperFunctions.getAcceptedCommunityGuidelinesSF();
        if (!acceptedGuidelines) {
          router.push("/guidelines");
        }

        if (userData.FCMToken != deviceToken) {
          //Update FCM token
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .updateUserFCMToken(deviceToken);
          //Subscribe to topic
          List<String> topics = await HelperFunctions.getTopicNotifications();
          for (var topic in topics) {
            await PushNotifications().subscribeToTopic(topic);
          }
          int snippetResponseDelay =
              await HelperFunctions.getSnippetResponseDelaySF();
          await Storage().setUserSnippetResponseDelay(snippetResponseDelay);
        }
        await Database()
            .updateUserStreak(auth.FirebaseAuth.instance.currentUser!.uid);

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
          key: styling.key,
          theme: ThemeData(
            // fontFamily: styling.font,
            textTheme: GoogleFonts.notoSansTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          routerConfig: router,
          // home: isSignedIn ? const SwipePages() : const WelcomePage(),
          // navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}
