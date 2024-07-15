
import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/swipe_pages.dart';
import 'package:snippets/pages/welcome_page.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
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
    if (status) {}
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isSignedIn ? const SwipePages() : const WelcomePage(),
      navigatorKey: navigatorKey,
    );
  }
}
