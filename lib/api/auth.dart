import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:snippets/api/notifications.dart';

import '../helper/helper_function.dart';
import 'database.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loginWithEmailandPassword(String email, String password) async {
    try {
      User user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      var userInfoMap = await Database(uid: user.uid).getUserData(user.uid);
      await HelperFunctions.saveUserNameSF(userInfoMap["username"]);
      await HelperFunctions.saveUserDisplayNameSF(userInfoMap["fullname"]);
      await HelperFunctions.saveUserEmailSF(userInfoMap["email"]);
      await HelperFunctions.saveUserDataSF(jsonEncode(userInfoMap));

      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "user-not-found":
          return "No user found with that email.";

        case "INVALID_LOGIN_CREDENTIALS":
          return "Incorrect email or password";

        default:
          return e.message;
      }
    }
  }

  //Register
  Future registerUserWithEmailandPassword(String fullName, String email,
      String password, String username, PhoneNumber? phoneNumber) async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      await Database(uid: user.uid)
          .savingUserData(fullName, email, username, phoneNumber);
      await HelperFunctions.saveUserNameSF(username);
      await HelperFunctions.saveUserDisplayNameSF(fullName);
      await HelperFunctions.saveUserEmailSF(email);
      PushNotifications().subscribeToTopic("all");
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserDisplayNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  void listenToAuthState() {
    StreamSubscription stream = const Stream.empty().listen((event) {});
    if (FirebaseAuth.instance.currentUser != null) {
      stream = Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .userDataStream();
    }

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print("Cancelling");
        stream.cancel();
      } else {
        print("Starting");
        stream = Database(uid: FirebaseAuth.instance.currentUser!.uid)
            .userDataStream();
      }
    });
  }
}
