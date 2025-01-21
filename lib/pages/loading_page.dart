import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class LoadingPage extends StatefulWidget {
  final isLoggedIn;
  const LoadingPage({super.key, required this.isLoggedIn});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  void load() async {
    await LocalDatabase().deleteDB();

    if (widget.isLoggedIn) {
      Auth().listenToAuthState(currentUserStream);
      User user = await Database()
          .getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
      await LocalDatabase().updateUserData(user, user.lastUpdatedMillis);

      router.pushReplacement("/");
    } else {
      router.pushReplacement("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(
              color: styling.backgroundText,
            ),
          ),
        ),
      ],
    );
  }
}
