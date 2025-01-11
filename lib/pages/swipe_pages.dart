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
        print("User data updated");
        userData = event;
        pageTitles[0] =
            "Profile${event.streak > 0 ? " • ${event.streak}🔥" : ""}";
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
    userData = await Database().getCurrentUserData();
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
      pageTitles[0] =
          "Profile${userData.streak > 0 ? " • ${userData.streak}🔥" : ""}";

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
        backgroundColor: Colors.transparent,
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
              child: Stack(
                children: [
                  BackgroundTile(
                    rounded: true,
                    flatBack: true,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(children: [
                        Text(
                          "What's New?",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 40),
                        ),
                        Text(
                          "Version 1.1.1",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView(
                            children: [
                              BulletList(
                                [
                                  "Suggesting Snippets - You can now suggest snippets by going to the snippets page and tapping the lightbulb icon!",
                                  "Saved Responses now show date saved",
                                ],
                              )
                            ],
                          ),
                        )
                      ])),
                ],
              ));
        });
  }

  void showSuggestsSnippetsInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Suggest Snippets",
            ),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "You can now suggest snippets by tapping on the lightbulb icon (",
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.lightbulb_outline, size: 16),
                  ),
                  TextSpan(
                    text: ") on the snippets page.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await HelperFunctions.saveSeenSuggestSnippetSF(true);
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  void showSuggestDialog() {
    TextEditingController questionController = TextEditingController();
    bool isSubmitting = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Suggest a snippet question",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: styling.theme == "christmas"
                  ? styling.green
                  : styling.primary,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      "Suggest a question for a snippet. This is completely anonymous.\n",
                      style: TextStyle(color: Colors.white)),
                  TextField(
                    controller: questionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: styling.textInputDecoration().copyWith(
                        hintText: "Enter your question here",
                        fillColor: styling.theme == "christmas"
                            ? styling.green
                            : styling.secondary,
                        hintStyle: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  if (isSubmitting)
                    CircularProgressIndicator(
                      color: styling.theme == "christmas"
                          ? styling.green
                          : styling.primary,
                    )
                  else
                    ElevatedButton(
                        onPressed: () async {
                          String hapticFeedback =
                              await HelperFunctions.getHapticFeedbackSF();
                          if (hapticFeedback == "normal") {
                            HapticFeedback.mediumImpact();
                          } else if (hapticFeedback == "light") {
                            HapticFeedback.lightImpact();
                          } else if (hapticFeedback == "heavy") {
                            HapticFeedback.heavyImpact();
                          }
                          if (questionController.text.isNotEmpty) {
                            setState(() {
                              isSubmitting = true;
                            });
                            await Database()
                                .suggestSnippet(questionController.text);
                            Navigator.pop(context);
                            questionController.clear();
                            setState(() {
                              isSubmitting = false;
                            });
                          }
                        },
                        style: styling.elevatedButtonDecoration(),
                        child: const Text("Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))),

                  //add a cancel button
                  TextButton(
                      onPressed: () async {
                        String hapticFeedback =
                            await HelperFunctions.getHapticFeedbackSF();
                        if (hapticFeedback == "normal") {
                          HapticFeedback.mediumImpact();
                        } else if (hapticFeedback == "light") {
                          HapticFeedback.lightImpact();
                        } else if (hapticFeedback == "heavy") {
                          HapticFeedback.heavyImpact();
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)))
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("Post frame callback");
      int lastSeenUpdate = await HelperFunctions.getSeenUpdateDialogSF();
      if (lastSeenUpdate < 22 && !seenUpdateDialog) {
        setState(() {
          seenUpdateDialog = true;
        });
        viewUpdateSheet();
        await HelperFunctions.saveSeenUpdateDialogSF(22);
      }
      bool seenSuggestsSnippetsInfo =
          await HelperFunctions.getSeenSuggestSnippetSF();
      if (!seenSuggestsSnippetsInfo) {
        showSuggestsSnippetsInfoDialog(context);
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
              showSuggestSnippetButton: selectedIndex == 1,
              onSuggestSnippetButtonPressed: () async {
                String hapticFeedback =
                    await HelperFunctions.getHapticFeedbackSF();
                if (hapticFeedback == "normal") {
                  HapticFeedback.mediumImpact();
                } else if (hapticFeedback == "light") {
                  HapticFeedback.lightImpact();
                } else if (hapticFeedback == "heavy") {
                  HapticFeedback.heavyImpact();
                }
                showSuggestDialog();
              },
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
                        if (!mounted) return;
                        setState(() {
                          if (!mounted) return;
                          selectedIndex = index;
                        });
                      },
                      children: <Widget>[
                        ProfilePage(
                          showNavBar: false,
                          showAppBar: false,
                          index: selectedIndex,
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
