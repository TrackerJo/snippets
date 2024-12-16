import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

import 'fb_database.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loginWithEmailandPassword(String email, String password) async {
    try {
      User user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      await PushNotifications().initNotifications();
      List<String> topics = await HelperFunctions.getTopicNotifications();
      for (String topic in topics) {
        await PushNotifications().subscribeToTopic(topic);
      }

      return true;
    } on FirebaseAuthException catch (e) {
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

      await FBDatabase(uid: user.uid).savingUserData(fullName, email, username);
      await HelperFunctions.addTopicNotification("all");
      await HelperFunctions.addTopicNotification("botw");
      await HelperFunctions.addTopicNotification("snippets");
      await HelperFunctions.addAllowedNotification("friend");
      await HelperFunctions.addAllowedNotification("discussion");
      await HelperFunctions.addAllowedNotification("snippets");
      await HelperFunctions.addAllowedNotification("botw");
      await HelperFunctions.addAllowedNotification("snippetResponse");

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Signout
  Future signOut() async {
    try {
      // router.pushReplacement("/login");
      List<String> topics = await HelperFunctions.getTopicNotifications();
      for (String topic in topics) {
        await PushNotifications().unsubscribeFromTopic(topic);
      }

      //Clear widgetData
      if (Platform.isIOS) {
        WidgetKit.removeItem("botwData", "group.kazoom_snippets");
        WidgetKit.removeItem("snippetsData", "group.kazoom_snippets");
        WidgetKit.removeItem("snippetsResponsesData", "group.kazoom_snippets");
        WidgetKit.reloadAllTimelines();
      }

      await LocalDatabase().clearDB();

      await _auth.signOut();

      router.pushReplacement("/login");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> deleteAccount() async {
    List<String> topics = await HelperFunctions.getTopicNotifications();
    for (String topic in topics) {
      await PushNotifications().unsubscribeFromTopic(topic);
    }
    //Clear widgetData
    if (Platform.isIOS) {
      WidgetKit.removeItem("botwData", "group.kazoom_snippets");
      WidgetKit.removeItem("snippetsData", "group.kazoom_snippets");
      WidgetKit.removeItem("snippetsResponsesData", "group.kazoom_snippets");

      WidgetKit.reloadAllTimelines();
    }
    await LocalDatabase().clearDB();
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<bool> isUserLoggedIn() async {
    User? user = _auth.currentUser;
    // return false;
    return user != null;
  }

  Future<String?> reauthenticateUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        return "Incorrect password";
      }
      return e.message ?? "An error occurred";
    }
    return null;
  }

  Future<String> changePassword(
      String email, String oldPassword, String newPassword) async {
    //First reauthenticate the user
    try {
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: oldPassword));
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        return "Incorrect password";
      }
      return e.message ?? "An error occurred";
    }
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    return "Done";
  }

  Future<String> changeEmail(
      String oldEmail, String newEmail, String currentPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: oldEmail, password: currentPassword));
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        return "Incorrect password";
      }
      return e.message ?? "An error occurred";
    }
    await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(newEmail);
    return "Done";
  }

  void listenToAuthState(StreamController streamController) async {
    await HelperFunctions.saveListenedToUserSF(true);
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
