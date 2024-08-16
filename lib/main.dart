
import 'dart:async';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
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

// final navigatorKey = GlobalKey<NavigatorState>();
final userStreamController = StreamController.broadcast();

AppDb localDb = AppDb();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


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
        path: '/friendLink',
        builder: (context, state) => ProfilePage(
          uid: state.uri.queryParameters['uid']!,
          isFriendLink: true,
        ),
      ),
      GoRoute(path: '/home', builder: (_, __) => const SwipePages(), routes: [
          GoRoute(
            path: 'friendLink',
            builder: (context, state) => ProfilePage(
              uid: state.uri.queryParameters['uid']!,
            ),
          ),
          GoRoute(
            path: 'question/:id/:theme/:question/:type',
            builder: (context, state) => QuestionPage(
              snippetId: state.pathParameters['id']!,
              theme: state.pathParameters['theme']!,
              question: state.pathParameters['question']!,
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
        if (userData['fcmToken'] != deviceToken) {
          //Update FCM token
          await Database(uid: FirebaseAuth.instance.currentUser!.uid).updateUserFCMToken(deviceToken);
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
