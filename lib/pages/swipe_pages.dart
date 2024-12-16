import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/constants.dart';

import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussions_page.dart';
import 'package:snippets/pages/find_profile_page.dart';
import 'package:snippets/pages/friends_page.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/modify_profile_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/pages/settings_page.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/bullet_list.dart';

import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/widget_gradient_tile.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class SwipePages extends StatefulWidget {
  final int initialIndex;
  const SwipePages({super.key, this.initialIndex = 1});

  @override
  State<SwipePages> createState() => _SwipePagesState();
}

class _SwipePagesState extends State<SwipePages> {
  PageController pageController = PageController(initialPage: 1);
  TextEditingController descriptionController = TextEditingController();
  User userData = User.empty();
  int selectedIndex = 1;
  List<String> pageTitles = ["Profile", "Snippets", "Discussions", "Search"];
  bool hasFriendRequests = false;
  bool hasAnsweredBOTW = false;
  String editDescription = "";
  bool loggedIn = false;
  bool isSigningOut = false;
  bool seenUpdateDialog = false;

  StreamController<User> userStreamController = StreamController();

  void getData() async {
    bool status = await Auth().isUserLoggedIn();

    if (!status) {
      router.pushReplacement("/login");
      return;
    }
    setState(() {
      loggedIn = status;
    });
    await HelperFunctions.saveOpenedPageSF("snippets");
    currentUserStream.stream.listen((event) {
      DateTime now = DateTime.now();
      DateTime monday = now.subtract(Duration(days: now.weekday - 1));
      String mondayString = "${monday.month}-${monday.day}-${monday.year}";
      //Get time in EST
      tz.initializeTimeZones();
      // Set the EST time zone using the 'America/New_York' IANA time zone identifier
      var estLocation = tz.getLocation('America/New_York');
      // Get the current time in EST
      var nowInEst = tz.TZDateTime.now(estLocation);
      if (!mounted) return;
      setState(() {
        userData = event;
        hasFriendRequests = userData.friendRequests.isNotEmpty;

        if (userData.botwStatus.hasAnswered &&
            userData.botwStatus.date == mondayString &&
            now.weekday < 6) {
          //Check if date is sat or sun
          hasAnsweredBOTW = true;
        } else if (userData.botwStatus.hasAnswered &&
            userData.botwStatus.date == mondayString) {
          if (now.weekday == 6 && nowInEst.hour >= 9) {
            if (userData.votesLeft != 0) {
              hasAnsweredBOTW = false;
            } else {
              hasAnsweredBOTW = true;
            }
          } else if (now.weekday == 6 && nowInEst.hour < 9) {
            hasAnsweredBOTW = true;
          } else if (now.weekday == 7) {
            if (nowInEst.hour < 15) {
              if (userData.votesLeft != 0) {
                hasAnsweredBOTW = false;
              } else {
                hasAnsweredBOTW = true;
              }
            } else {
              if (userData.botwStatus.hasSeenResults) {
                hasAnsweredBOTW = true;
              } else {
                hasAnsweredBOTW = false;
              }
            }
          }
        } else {
          hasAnsweredBOTW = false;
        }
      });
    });
    userData = await Database()
        .getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    String mondayString = "${monday.month}-${monday.day}-${monday.year}";
    //Get time in EST
    tz.initializeTimeZones();
    // Set the EST time zone using the 'America/New_York' IANA time zone identifier
    var estLocation = tz.getLocation('America/New_York');
    // Get the current time in EST
    var nowInEst = tz.TZDateTime.now(estLocation);
    if (!mounted) return;
    setState(() {
      if (!mounted) return;

      hasFriendRequests = userData.friendRequests.isNotEmpty;
      if (userData.botwStatus.hasAnswered &&
          userData.botwStatus.date == mondayString &&
          now.weekday < 6) {
        //Check if date is sat or sun
        hasAnsweredBOTW = true;
      } else if (userData.botwStatus.hasAnswered &&
          userData.botwStatus.date == mondayString) {
        if (now.weekday == 6 && nowInEst.hour >= 9) {
          if (userData.votesLeft != 0) {
            hasAnsweredBOTW = false;
          } else {
            hasAnsweredBOTW = true;
          }
        } else if (now.weekday == 6 && nowInEst.hour < 9) {
          hasAnsweredBOTW = true;
        } else if (now.weekday == 7) {
          if (nowInEst.hour < 15) {
            if (userData.votesLeft != 0) {
              hasAnsweredBOTW = false;
            } else {
              hasAnsweredBOTW = true;
            }
          } else {
            if (userData.botwStatus.hasSeenResults) {
              hasAnsweredBOTW = true;
            } else {
              hasAnsweredBOTW = false;
            }
          }
        }
      } else {
        hasAnsweredBOTW = false;
      }
    });
  }

  @override
  void initState() {
    getData();
    pageController = PageController(initialPage: widget.initialIndex);
    setState(() {
      selectedIndex = widget.initialIndex;
    });
    super.initState();
  }

  @override
  void dispose() {
    userStreamController.close();
    super.dispose();
  }

  void onSettingsButtonPressed() async {
    String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
    if (hapticFeedback == "normal") {
      HapticFeedback.mediumImpact();
    } else if (hapticFeedback == "light") {
      HapticFeedback.lightImpact();
    } else if (hapticFeedback == "heavy") {
      HapticFeedback.heavyImpact();
    }
    nextScreen(context, const SettingsPage());
  }

  void viewUpdateSheet() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor:
            styling.theme == "christmas" ? styling.green : styling.secondary,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(children: [
                    Text(
                      "What's New?",
                      style: const TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    Text(
                      "Version 1.0.13",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          BulletList(
                            [
                              "Added a christmas themed splash screen",
                            ],
                          )
                        ],
                      ),
                    )
                  ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("Post frame callback");
      int lastSeenUpdate = await HelperFunctions.getSeenUpdateDialogSF();
      if (lastSeenUpdate < 14 && !seenUpdateDialog) {
        setState(() {
          seenUpdateDialog = true;
        });
        viewUpdateSheet();
        await HelperFunctions.saveSeenUpdateDialogSF(14);
      }
    });
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: pageTitles[selectedIndex],
              showSettingsButton: selectedIndex == 0,
              onSettingsButtonPressed: onSettingsButtonPressed,
              showFriendsButton: selectedIndex == 1,
              hasFriendRequests: hasFriendRequests,
              onFriendsButtonPressed: () async {
                String hapticFeedback =
                    await HelperFunctions.getHapticFeedbackSF();
                if (hapticFeedback == "normal") {
                  HapticFeedback.mediumImpact();
                } else if (hapticFeedback == "light") {
                  HapticFeedback.lightImpact();
                } else if (hapticFeedback == "heavy") {
                  HapticFeedback.heavyImpact();
                }
                Navigator.of(context).push(
                  CustomPageRoute(
                    builder: (BuildContext context) {
                      return const FriendsPage();
                    },
                  ),
                );
              },
              index: selectedIndex,
              showShareButton: selectedIndex == 0,
              onShareButtonPressed: () async {
                String hapticFeedback =
                    await HelperFunctions.getHapticFeedbackSF();
                if (hapticFeedback == "normal") {
                  HapticFeedback.mediumImpact();
                } else if (hapticFeedback == "light") {
                  HapticFeedback.lightImpact();
                } else if (hapticFeedback == "heavy") {
                  HapticFeedback.heavyImpact();
                }

                await Share.share(
                    "https://snippets2024.web.app/friendLink?name=${userData.displayName.replaceAll(" ", "%20")}&uid=${userData.userId}",
                    subject: "Share your profile with friends");
              },
            ),
          ),
          bottomNavigationBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomNavBar(
                pageIndex: selectedIndex,
                pageController: pageController,
                hasAnsweredBOTW: hasAnsweredBOTW),
          ),
          body: !loggedIn
              ? Center(
                  child: CircularProgressIndicator(
                    color: styling.theme == "christmas"
                        ? styling.green
                        : styling.primary,
                  ),
                )
              : Stack(
                  children: [
                    PageView(
                      controller: pageController,
                      allowImplicitScrolling: true,
                      onPageChanged: (int index) async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (index == 0) {
                          await HelperFunctions.saveOpenedPageSF("profile");
                        } else if (index == 1) {
                          await HelperFunctions.saveOpenedPageSF("snippets");
                        } else if (index == 2) {
                          await HelperFunctions.saveOpenedPageSF("discussions");
                        } else if (index == 3) {
                          await HelperFunctions.saveOpenedPageSF("search");
                        }
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      children: <Widget>[
                        const ProfilePage(
                          showNavBar: false,
                          showAppBar: false,
                        ),
                        const HomePage(),
                        DiscussionsPage(
                          index: selectedIndex,
                        ),
                        FindProfilePage(
                          index: selectedIndex,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
