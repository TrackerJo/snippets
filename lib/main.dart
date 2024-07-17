
import 'dart:async';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/pages/discussion_page.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotifications().initNotifications();

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
        builder: (_, __)  {
          
            return const WelcomePage();
          
        }, 
        
        
      ),
      GoRoute(path: '/home', builder: (_, __) => const SwipePages(), routes: [
          GoRoute(
            path: 'friendLink',
            builder: (context, state) => ProfilePage(
              uid: state.uri.queryParameters['uid']!,
            ),
          ),
          GoRoute(
            path: 'question/:id/:theme/:question',
            builder: (context, state) => QuestionPage(
              snippetId: state.pathParameters['id']!,
              theme: state.pathParameters['theme']!,
              question: state.pathParameters['question']!,
            ),
          ),
          GoRoute(
            path: 'voting',
            builder: (context, state) => const VotingPage(),
          ),
          GoRoute(
            path: 'swipe/:index',
            builder: (context, state) => SwipePages(
              initialIndex: int.parse(state.pathParameters['index']!),
            ),
          ),
          GoRoute(
            path: 'responses/:id/:theme/:question',
            builder: (context, state) => ResponsesPage(snippetId: state.pathParameters['id']!,
            theme: state.pathParameters['theme']!,
            question: state.pathParameters['question']!),

          ),
          GoRoute(
            path: 'profile/:uid',
            builder: (context, state) => ProfilePage(uid: state.pathParameters['uid']!),
          ),
          GoRoute(path: 'discussion/:data',
          builder: (context, state) {
            final data = state.pathParameters['data']!;
            Map<String, dynamic> decodedData = jsonDecode(data);

            return  DiscussionPage(responseTile: ResponseTile(
                    displayName: decodedData['responseName'],
                    response: decodedData['response'],
                    userId: decodedData["responseId"],
                    snippetId: decodedData['snippetId'],
                    question: decodedData['snippetQuestion'],
                    theme: decodedData['theme'],
                    discussionUsers: decodedData['discussionUsers'],
                    isDisplayOnly: true,
                  ), theme: decodedData['theme']);

            } 
          ),
        ],),

    ],
);

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  
  bool isSignedIn = false;
  getUserLoggedInState() async {
    String deviceToken = await PushNotifications().getDeviceToken();
    print("######### DEVICE TOKEN #########");
    print(deviceToken);
    bool status = await Auth().isUserLoggedIn();

    Auth().listenToAuthState(userStreamController);
    setState(() {
      isSignedIn = status;
      
    });
    if (status) {
      router.go('/home');
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
