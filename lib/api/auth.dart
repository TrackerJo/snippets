import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/api/notifications.dart';
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
      await PushNotifications().subscribeToTopic("all");

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

      print("Step 2");
      await PushNotifications().unsubscribeFromTopic("all");
      print("Step 3");
      //Clear widgetData
      WidgetKit.removeItem("botwData", "group.kazoom_snippets");
      WidgetKit.removeItem("snippetsData", "group.kazoom_snippets");
      WidgetKit.removeItem("snippetsResponsesData", "group.kazoom_snippets");

      WidgetKit.reloadAllTimelines();
      print("Step 3.5");
      await LocalDatabase().clearDB();
      print("Step 4");
      await _auth.signOut();
      print("Step 5");
      router.pushReplacement("/login");
      print("Signed out");
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteAccount() async {
    await PushNotifications().unsubscribeFromTopic("all");
    //Clear widgetData
    WidgetKit.removeItem("botwData", "group.kazoom_snippets");
    WidgetKit.removeItem("snippetsData", "group.kazoom_snippets");
    WidgetKit.removeItem("snippetsResponsesData", "group.kazoom_snippets");

    WidgetKit.reloadAllTimelines();
    await LocalDatabase().clearDB();
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<bool> isUserLoggedIn() async {
    User? user = _auth.currentUser;
    // return false;
    return user != null;
  }

  Future<String?> reauthenticateUser(String email, String password) async {
    print("authing");
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
        print("Reloading user data");
        stream = FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
            .userDataStream(streamController);
      }
    });
  }
}
