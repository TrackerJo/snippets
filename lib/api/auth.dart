import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/main.dart';

import '../helper/helper_function.dart';
import 'fb_database.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loginWithEmailandPassword(String email, String password) async {
    try {
      User user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      var userInfoMap = await FBDatabase(uid: user.uid).getUserData(user.uid);
      await HelperFunctions.saveUserNameSF(userInfoMap["username"]);
      await HelperFunctions.saveUserDisplayNameSF(userInfoMap["fullname"]);
      await HelperFunctions.saveUserEmailSF(userInfoMap["email"]);
      await HelperFunctions.saveUserDataSF(jsonEncode(userInfoMap));
      await PushNotifications().initNotifications();
      await PushNotifications().subscribeToTopic("all");

      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "user-not-found":
          return "No user found with that email.";

        case "invalid-credential":
          return "Incorrect email or password";

        default:
          return e.message;
      }
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.message;
    }
  }

  //Register
  Future registerUserWithEmailandPassword(String fullName, String email,
      String password, String username, PhoneNumber? phoneNumber) async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      await FBDatabase(uid: user.uid)
          .savingUserData(fullName, email, username, phoneNumber);
      await HelperFunctions.saveUserNameSF(username);
      await HelperFunctions.saveUserDisplayNameSF(fullName);
      await HelperFunctions.saveUserEmailSF(email);
      
      await PushNotifications().subscribeToTopic("all");
      return true;
    } on FirebaseAuthException catch (e) {

      return e.message;
    }
  }

  //Signout
  Future signOut() async {
    try {
      // router.pushReplacement("/login");
      await HelperFunctions.saveUserDisplayNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserDataSF("");
      await PushNotifications().unsubscribeFromTopic("all");
      //Clear widgetData
      WidgetKit.removeItem("botwData", "group.kazoom_snippets");
      WidgetKit.removeItem("snippetsData", "group.kazoom_snippets");
      WidgetKit.removeItem("snippetsResponsesData", "group.kazoom_snippets");

      WidgetKit.reloadAllTimelines();
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  void listenToAuthState(StreamController streamController) {
    StreamSubscription stream = const Stream.empty().listen((event) {});
    if (FirebaseAuth.instance.currentUser != null) {
      stream = FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
          .userDataStream(streamController);
    }

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {

        // router.pushReplacement("/login");
        stream.cancel();
      } else {

        stream = FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
            .userDataStream(streamController);
      }
    });
  }
}
