import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/onboarding_page.dart';
import 'package:snippets/pages/welcome_page.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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

class _MainAppState extends State<MainApp> {
  bool isSignedIn = false;
  getUserLoggedInState() async {
    String deviceToken = await PushNotifications().getDeviceToken();
    print("######### DEVICE TOKEN #########");
    print(deviceToken);
    bool status = await Auth().isUserLoggedIn();
    setState(() {
      isSignedIn = status;
    });
    if (status) {
      Map<String, dynamic> userData =
          await Database(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserData(FirebaseAuth.instance.currentUser!.uid);
      await HelperFunctions.saveUserDataSF(jsonEncode(userData));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isSignedIn ? const HomePage() : WelcomePage(),
      navigatorKey: navigatorKey,
    );
  }
}
