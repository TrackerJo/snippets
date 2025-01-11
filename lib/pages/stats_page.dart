import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';

import 'package:snippets/constants.dart';
import 'package:snippets/main.dart';

import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/stats_tile.dart';

class StatsPage extends StatefulWidget {
  final bool isCurrentUser;
  final String userId;
  const StatsPage(
      {super.key, required this.isCurrentUser, required this.userId});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  User? userData;

  void getUserData() async {
    if (widget.isCurrentUser) {
      User user = await Database().getCurrentUserData();
      setState(() {
        userData = user;
      });
      currentUserStream.stream.listen((event) {

        if (!mounted) return;
        setState(() {
          if (!mounted) return;
          userData = event;

        });
      });
    } else {
      User user = await Database().getUserData(widget.userId);
      setState(() {
        userData = user;
      });
    }
  }

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          BackgroundTile(),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: CustomAppBar(
                  title: "Stats",
                  theme: "purple",
                  showBackButton: true,
                  fixRight: false,
                  onBackButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: userData == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: styling.theme == "christmas"
                            ? styling.green
                            : styling.primary,
                      ),
                    )
                  : ListView(children: [
                      const SizedBox(height: 10),
                      StatsTile(
                          title: "Snippets Answered",
                          description:
                              "Number of snippets user has responded to",
                          value: userData!.snippetsRespondedTo.toString()),
                      StatsTile(
                          title: "Trivia Points",
                          description:
                              "Number of trivia snippets user has answered correctly",
                          value: userData!.triviaPoints.toString()),
                      StatsTile(
                          title: "Discussions Started",
                          description:
                              "Number of discussions where you were the first to chat",
                          value: userData!.discussionsStarted.toString()),
                      StatsTile(
                          title: "Messages Sent",
                          description: "Number of messages sent in discussions",
                          value: userData!.messagesSent.toString()),
                      StatsTile(
                          title: "#1 Snippet of the Week",
                          description:
                              "Number of times user's snippet of the week has been #1",
                          value: userData!.topBOTW.toString()),
                      StatsTile(
                          title: "Current Streak",
                          description:
                              "Number of days in a row user has responded to a snippet",
                          value: userData!.streak.toString()),
                      StatsTile(
                          title: "Longest Streak",
                          description:
                              "Longest number of days in a row user has responded to a snippet",
                          value: userData!.longestStreak.toString()),
                    ])),
        ],
      ),
    );
  }
}
