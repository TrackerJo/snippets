import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/botw_results_page.dart';
import 'package:snippets/pages/modify_profile_page.dart';
import 'package:snippets/pages/no_wifi_page.dart';
import 'package:snippets/pages/saved_responses_page.dart';
import 'package:snippets/pages/settings_page.dart';
import 'package:snippets/pages/stats_page.dart';
import 'package:snippets/pages/update_page.dart';

import 'package:snippets/pages/voting_page.dart';

import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/botw_tile.dart';
import 'package:snippets/widgets/custom_page_route.dart';

import 'package:snippets/widgets/friend_tile.dart';
import 'package:snippets/widgets/friends_count.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/saved_response_tile.dart';
import 'package:snippets/widgets/setting_tile.dart';

import '../api/auth.dart';
import '../widgets/custom_app_bar.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final bool showNavBar;
  final bool showBackButton;
  final bool showAppBar;
  final bool isFriendLink;
  final int? index;

  const ProfilePage(
      {super.key,
      this.uid = "",
      this.showNavBar = true,
      this.showBackButton = false,
      this.showAppBar = true,
      this.index,
      this.isFriendLink = false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = "";

  bool isCurrentUser = false;
  bool isLoading = false;
  bool gotData = false;
  bool isFriends = false;
  bool sentFriendRequest = false;
  bool hasFriendRequest = false;
  int numberOfFriends = 0;
  int numberOfMutualFriends = 0;
  User profileData = User.empty();
  BOTW blankOfTheWeek = BOTW.empty();
  List<UserMini> mutualFriends = [];
  StreamSubscription userStreamSub = const Stream.empty().listen((event) {});
  StreamSubscription blankStreamSub = const Stream.empty().listen((event) {});
  StreamSubscription userStreamSub2 = const Stream.empty().listen((event) {});
  StreamController<BOTW> botwStreamController = StreamController();
  bool isBestFriend = false;
  String editDescription = "";
  bool userExists = true;

  void checkForBlankOfTheWeek(String uid) async {
    Stream blankStream = await Database().getBOTWStream(botwStreamController);
    blankStreamSub = blankStream.listen((event) {
      if (botwStreamController.isClosed) return;
      BOTW data = event;

      Map<String, BOTWAnswer> answers = data.answers;
      if (!answers.containsKey(uid)) {
        data.answers[uid] = BOTWAnswer(
            FCMToken: profileData.FCMToken,
            answer: "",
            displayName: displayName,
            userId: uid,
            voters: [],
            votes: 0);
      }
      if (!mounted) return;
      setState(() {
        if (!mounted) return;
        blankOfTheWeek = data;
      });
    });
  }

  void getProfileData() async {
    bool status = await Auth().isUserLoggedIn();
    if (!status && widget.uid != "") {
      router.go('/welcome/${widget.uid}/true');
    } else if (!status) {
      router.go('/login');
    }

    String userDisplayName = "";
    bool currentUser = false;
    if (widget.uid == "") {
      userStreamSub = currentUserStream.stream.listen((event) {
        event.friends.sort((a, b) {
          bool ABestFriend =
              event.bestFriends.any((friend) => friend == a.userId);
          bool BBestFriend =
              event.bestFriends.any((friend) => friend == b.userId);
          if (ABestFriend == BBestFriend) {
            return 0;
          } else if (ABestFriend && !BBestFriend) {
            return -1;
          } else if (!ABestFriend && BBestFriend) {
            return 1;
          } else {
            return 0;
          }
        });
        if (!mounted) return;
        setState(() {
          if (!mounted) return;
          profileData = event;
          numberOfFriends = profileData.friends.length;
          userDisplayName = profileData.displayName;
          BOTW newBlankofTheWeek = blankOfTheWeek;

          if (newBlankofTheWeek.answers.containsKey(profileData.userId)) {
            newBlankofTheWeek.answers[profileData.userId] = BOTWAnswer(
                FCMToken: profileData.FCMToken,
                answer: newBlankofTheWeek.answers[profileData.userId]!.answer,
                displayName: profileData.displayName,
                userId: profileData.userId,
                voters: newBlankofTheWeek.answers[profileData.userId]!.voters,
                votes: newBlankofTheWeek.answers[profileData.userId]!.votes);
          }
          blankOfTheWeek = newBlankofTheWeek;
        });
      });

      currentUser = true;
      User viewerData = await Database().getCurrentUserData();
      userDisplayName = viewerData.displayName;

      viewerData.friends.sort((a, b) {
        bool ABestFriend =
            viewerData.bestFriends.any((friend) => friend == a.userId);
        bool BBestFriend =
            viewerData.bestFriends.any((friend) => friend == b.userId);
        if (ABestFriend == BBestFriend) {
          return 0;
        } else if (ABestFriend && !BBestFriend) {
          return -1;
        } else if (!ABestFriend && BBestFriend) {
          return 1;
        } else {
          return 0;
        }
      });
      if (!mounted) return;
      setState(() {
        if (!mounted) return;
        profileData = viewerData;
        numberOfFriends = viewerData.friends.length;
      });
    } else if (widget.uid == auth.FirebaseAuth.instance.currentUser!.uid) {
      currentUser = true;
      currentUserStream.stream.listen((event) {
        event.friends.sort((a, b) {
          bool ABestFriend =
              event.bestFriends.any((friend) => friend == a.userId);
          bool BBestFriend =
              event.bestFriends.any((friend) => friend == b.userId);
          if (ABestFriend == BBestFriend) {
            return 0;
          } else if (ABestFriend && !BBestFriend) {
            return -1;
          } else if (!ABestFriend && BBestFriend) {
            return 1;
          } else {
            return 0;
          }
        });
        if (!mounted) return;
        setState(() {
          if (!mounted) return;
          profileData = event;
          numberOfFriends = profileData.friends.length;
          userDisplayName = profileData.displayName;
        });
      });
      User viewerData = (await Database().getCurrentUserData());

      viewerData.friends.sort((a, b) {
        bool ABestFriend =
            viewerData.bestFriends.any((friend) => friend == a.userId);
        bool BBestFriend =
            viewerData.bestFriends.any((friend) => friend == b.userId);
        if (ABestFriend == BBestFriend) {
          return 0;
        } else if (ABestFriend && !BBestFriend) {
          return -1;
        } else if (!ABestFriend && BBestFriend) {
          return 1;
        } else {
          return 0;
        }
      });
      if (!mounted) return;
      setState(() {
        if (!mounted) return;
        profileData = viewerData;
        numberOfFriends = viewerData.friends.length;
      });
    } else {
      await Database().updateUserStreak(widget.uid);
      Stream? viewerDataStream =
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getUserStream(widget.uid);
      if (viewerDataStream == null) {
        if (!mounted) return;
        setState(() {
          if (!mounted) return;
          userExists = false;
        });
        return;
      }
      userStreamSub = viewerDataStream.listen((event) async {
        if (event == null) {
          if (!mounted) return;
          setState(() {
            if (!mounted) return;
            userExists = false;
          });
          return;
        }
        User viewerData = event;
        if (!mounted) return;
        setState(() {
          if (!mounted) return;
          profileData = viewerData;
          numberOfFriends = viewerData.friends.length;
          userDisplayName = viewerData.displayName;
        });

        setState(() {
          if (!mounted) return;
          profileData = viewerData;
          numberOfFriends = viewerData.friends.length;
        });
      });

      currentUserStream.stream.listen((event) {
        User userData = event;
        if (!mounted) return;
        setState(() {
          if (!mounted) return;
          print("USERBESTFRIENDS: ${userData.bestFriends}");
          isBestFriend =
              userData.bestFriends.any((friend) => friend == widget.uid);
        });
        List<UserMini> friendsList = userData.friends;
        int mutualFriends = 0;
        List<UserMini> mutualFriendsList = [];
        for (UserMini friend in friendsList) {
          for (UserMini friend2 in profileData.friends) {
            if (friend.userId == friend2.userId) {
              mutualFriends++;
              mutualFriendsList.add(friend);
            }
          }
        }
        if (!mounted) return;
        setState(() {
          if (!mounted) return;
          numberOfMutualFriends = mutualFriends;
          this.mutualFriends = mutualFriendsList;
        });
        userDisplayName = profileData.displayName;

        bool areFriends = false;
        for (UserMini friend in friendsList) {
          if (friend.userId == widget.uid) {
            areFriends = true;
            break;
          }
        }
        if (!mounted) return;
        if (areFriends) {
          setState(() {
            if (!mounted) return;
            isFriends = true;
          });
        } else {
          setState(() {
            if (!mounted) return;
            isFriends = false;
          });
          List<UserMini> outgoingFriendRequests =
              userData.outgoingFriendRequests;

          bool friendRequest = false;
          for (UserMini request in outgoingFriendRequests) {
            if (request.userId == widget.uid) {
              friendRequest = true;
              break;
            }
          }
          if (!mounted) return;
          if (friendRequest) {
            if (!mounted) return;
            setState(() {
              sentFriendRequest = true;
            });
          } else {
            if (!mounted) return;
            setState(() {
              sentFriendRequest = false;
            });
          }

          List<UserMini> friendRequests = userData.friendRequests;

          bool hasRequest = false;
          for (UserMini request in friendRequests) {
            if (request.userId == widget.uid) {
              hasRequest = true;
              break;
            }
          }
          if (!mounted) return;
          if (hasRequest) {
            setState(() {
              if (!mounted) return;
              hasFriendRequest = true;
            });
          } else {
            setState(() {
              if (!mounted) return;
              hasFriendRequest = false;
            });
          }
        }
      });

      User? viewerData =
          (await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getUserData(widget.uid));
      if (viewerData == null) {
        if (!mounted) return;
        setState(() {
          if (!mounted) return;
          userExists = false;
        });
        return;
      }

      fixUserData(viewerData);
      if (!mounted) return;
      setState(() {
        if (!mounted) return;
        profileData = viewerData;
        numberOfFriends = viewerData.friends.length;
      });

      User userData = await Database().getCurrentUserData();
      List<UserMini> friendsList = userData.friends;
      if (!mounted) return;
      setState(() {
        if (!mounted) return;
        print("USERBESTFRIENDS: ${userData.bestFriends}");
        print(widget.uid);
        isBestFriend =
            userData.bestFriends.any((friend) => friend == widget.uid);
        print(isBestFriend);
      });
      int mutualFriends = 0;
      List<UserMini> mutualFriendsList = [];
      for (UserMini friend in friendsList) {
        for (UserMini friend2 in viewerData.friends) {
          if (friend.userId == friend2.userId) {
            mutualFriends++;
            mutualFriendsList.add(friend);
          }
        }
      }
      if (!mounted) return;
      setState(() {
        if (!mounted) return;
        numberOfMutualFriends = mutualFriends;
        this.mutualFriends = mutualFriendsList;
      });
      userDisplayName = viewerData.displayName;

      bool areFriends = false;
      for (dynamic friend in friendsList) {
        if (friend.userId == widget.uid) {
          areFriends = true;
          break;
        }
      }
      if (!mounted) return;
      if (areFriends) {
        setState(() {
          if (!mounted) return;
          isFriends = true;
        });
      } else {
        setState(() {
          if (!mounted) return;
          isFriends = false;
        });
        List<UserMini> outgoingFriendRequests = userData.outgoingFriendRequests;
        bool friendRequest = false;
        for (UserMini request in outgoingFriendRequests) {
          if (request.userId == widget.uid) {
            friendRequest = true;
            break;
          }
        }
        if (!mounted) return;
        if (friendRequest) {
          setState(() {
            if (!mounted) return;
            sentFriendRequest = true;
          });
        } else {
          setState(() {
            if (!mounted) return;
            sentFriendRequest = false;
          });
        }

        List<UserMini> friendRequests = userData.friendRequests;
        bool hasRequest = false;
        for (UserMini request in friendRequests) {
          if (request.userId == widget.uid) {
            hasRequest = true;
            break;
          }
        }
        if (!mounted) return;
        if (hasRequest) {
          setState(() {
            if (!mounted) return;
            hasFriendRequest = true;
          });
        } else {
          setState(() {
            if (!mounted) return;
            hasFriendRequest = false;
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        displayName = userDisplayName;
        isCurrentUser = currentUser;
        gotData = true;
      });
    }
    checkForBlankOfTheWeek(profileData.userId);
    bool seenFavorites = await HelperFunctions.getSeenFavoritesSF();
    if (!isCurrentUser && isFriends && !seenFavorites) {
      await Future.delayed(const Duration(milliseconds: 100));
      showFavortiesDialog(context);
    }

    bool seenStreaks = await HelperFunctions.getSeenStreaksSF();
    if (!seenStreaks && !isCurrentUser) {
      await Future.delayed(const Duration(milliseconds: 100));
      showStreaksDialog(context);
    }
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.index != 0) {
      // discussions = [];
      // setState(() {});
      return;
    }

    HelperFunctions.getSeenStreaksSF().then((seenStreaks) {
      if (!seenStreaks) {
        showStreaksDialog(context);
      }
    });
  }

  Future fixUserData(User dataToFix) async {
    List<UserMini> friends = dataToFix.friends;
    List<UserMini> friendRequests = dataToFix.friendRequests;
    List<UserMini> outgoingRequests = dataToFix.outgoingFriendRequests;
    List<String> friendIds = friends.map((e) => e.userId).toList();

    //Check if has any friend requests that are in friends list
    for (UserMini request in friendRequests) {
      if (friendIds.contains(request.userId)) {
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .removeFriendRequest(request, dataToFix);
      }
    }

    //Check if has any outgoing requests that are in friends list
    for (UserMini request in outgoingRequests) {
      if (friendIds.contains(request.userId)) {
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .removeOutgoingFriendRequest(request, dataToFix);
      }
    }

    //Check for duplicate friends
    List<String> readIds = [];
    List<UserMini> requestsToRemove = [];
    for (var i = 0; i < friendIds.length; i++) {
      String id = friendIds[i];
      if (readIds.contains(id)) {
        requestsToRemove.add(friends[readIds.indexOf(id)]);
        readIds[readIds.indexOf(id)] = "removed";
        readIds.add(id);
      } else {
        readIds.add(id);
      }
    }

    for (UserMini request in requestsToRemove) {
      await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
          .removeFriendFix(request, dataToFix);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  void logout() async {
    router.pushReplacement('/login');

    //Stop listening to the user stream
    userStreamSub.cancel();
    blankStreamSub.cancel();
    userStreamSub2.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userStreamSub.cancel();
    blankStreamSub.cancel();
    userStreamSub2.cancel();
    botwStreamController.close();
  }

  void showFriendsPopup() async {
    String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
    if (hapticFeedback == "normal") {
      HapticFeedback.mediumImpact();
    } else if (hapticFeedback == "light") {
      HapticFeedback.lightImpact();
    } else if (hapticFeedback == "heavy") {
      HapticFeedback.heavyImpact();
    }
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
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  BackgroundTile(
                    rounded: true,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text("Friends",
                              style: TextStyle(
                                color: styling.backgroundText,
                                fontSize: 30,
                              )),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                                itemCount: profileData.friends.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FriendTile(
                                      displayName: profileData
                                          .friends[index].displayName,
                                      uid: profileData.friends[index].userId,
                                      username:
                                          profileData.friends[index].username,
                                      isBestFriend: isCurrentUser
                                          ? profileData.bestFriends.any(
                                              (friend) =>
                                                  friend ==
                                                  profileData
                                                      .friends[index].userId)
                                          : false,
                                    ),
                                  );
                                }),
                          ),
                        ],
                      )),
                ],
              ));
        });
  }

  void showMutualFriendsPopup() async {
    String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
    if (hapticFeedback == "normal") {
      HapticFeedback.mediumImpact();
    } else if (hapticFeedback == "light") {
      HapticFeedback.lightImpact();
    } else if (hapticFeedback == "heavy") {
      HapticFeedback.heavyImpact();
    }
    showModalBottomSheet<void>(
        context: context,
        backgroundColor:
            Colors.transparent, //styling.background, //Colors.transparent,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  BackgroundTile(
                    rounded: true,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text("Mutual Friends",
                              style: TextStyle(
                                color: styling.backgroundText,
                                fontSize: 30,
                              )),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                                itemCount: mutualFriends.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FriendTile(
                                        displayName:
                                            mutualFriends[index].displayName,
                                        uid: mutualFriends[index].userId,
                                        username:
                                            mutualFriends[index].username),
                                  );
                                }),
                          ),
                        ],
                      )),
                ],
              ));
        });
  }

  Future sendFriendRequest() async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .sendFriendRequest(widget.uid, displayName, profileData.username,
            profileData.FCMToken);
    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      sentFriendRequest = true;
    });
  }

  Future removeFriend() async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .removeFriend(widget.uid, displayName, profileData.username,
            profileData.FCMToken);
    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      isFriends = false;
    });
  }

  Future cancelFriendRequest() async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .cancelFriendRequest(widget.uid, displayName, profileData.username,
            profileData.FCMToken);
    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      sentFriendRequest = false;
    });
  }

  Future acceptFriendRequest() async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .acceptFriendRequest(widget.uid, displayName, profileData.username,
            profileData.FCMToken);
    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      hasFriendRequest = false;
      sentFriendRequest = false;
      isFriends = true;
    });
  }

  void showFavortiesDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Best Friends"),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "You can set a user as a best friend by tapping on the star icon ",
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.star_outline, size: 16),
                  ),
                  TextSpan(
                    text:
                        " on their profile. Best friends will be shown at the top of your friends list and their responses will be shown first in the snippet responses page. Users can't see if you've set them as a best friend.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await HelperFunctions.saveSeenFavoritesSF(true);
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  void showStreaksDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Snippet Streaks"),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Snippet streaks greater than 2 are shown on the top of the screen next to the flame icon (🔥). A streak can be started by answering at least one snippet every day!",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await HelperFunctions.saveSeenStreaksSF(true);
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          if (widget.showAppBar) BackgroundTile(),
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: widget.showAppBar
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: CustomAppBar(
                      fixRight: true,
                      title: !userExists
                          ? "User Doesn't Exist"
                          : isCurrentUser
                              ? "Your Profile${profileData.streak > 2 ? " • ${profileData.streak}🔥" : ""}"
                              : "$displayName${profileData.streak > 2 ? " • ${profileData.streak}🔥" : ""}",
                      showBackButton:
                          widget.showBackButton || widget.isFriendLink,
                      showBestFriendButton: !isCurrentUser && isFriends,
                      isBestFriend: isBestFriend,
                      onBestFriendButtonPressed: () async {
                        String hapticFeedback =
                            await HelperFunctions.getHapticFeedbackSF();
                        if (hapticFeedback == "normal") {
                          HapticFeedback.mediumImpact();
                        } else if (hapticFeedback == "light") {
                          HapticFeedback.lightImpact();
                        } else if (hapticFeedback == "heavy") {
                          HapticFeedback.heavyImpact();
                        }
                        if (isBestFriend) {
                          print("REMOVING BEST FRIEND");
                          await Database().removeBestFriend(profileData.userId);
                          if (!mounted) return;
                          setState(() {
                            if (!mounted) return;
                            isBestFriend = false;
                          });
                        } else {
                          print("ADDING BEST FRIEND");
                          await Database().addBestFriend(profileData.userId);
                          if (!mounted) return;
                          setState(() {
                            if (!mounted) return;
                            isBestFriend = true;
                          });
                        }
                      },
                      onBackButtonPressed: () async {
                        String hapticFeedback =
                            await HelperFunctions.getHapticFeedbackSF();
                        if (hapticFeedback == "normal") {
                          HapticFeedback.mediumImpact();
                        } else if (hapticFeedback == "light") {
                          HapticFeedback.lightImpact();
                        } else if (hapticFeedback == "heavy") {
                          HapticFeedback.heavyImpact();
                        }

                        if (widget.isFriendLink) {
                          // Navigator.of(context).pop();
                          router.go('/home');
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      showSettingsButton: isCurrentUser,
                      onSettingsButtonPressed: () async {
                        String? hapticFeedback =
                            await HelperFunctions.getHapticFeedbackSF();
                        if (hapticFeedback == "normal") {
                          HapticFeedback.mediumImpact();
                        } else if (hapticFeedback == "light") {
                          HapticFeedback.lightImpact();
                        } else if (hapticFeedback == "heavy") {
                          HapticFeedback.heavyImpact();
                        }
                        nextScreen(context, SettingsPage());
                      },
                    ),
                  )
                : null,
            backgroundColor: Colors.transparent,
            body: !userExists
                ? Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Account doesnt exist anymore :(",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              router.pushReplacement("/");
                            },
                            style: styling.elevatedButtonDecoration(),
                            child: Text(
                              "Go Back Home",
                              style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.primaryDark
                                      : Colors.black,
                                  fontSize: 16),
                            ))
                      ],
                    ),
                  )
                : gotData &&
                        blankOfTheWeek.answers.containsKey(profileData.userId)
                    ? Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              // shrinkWrap: true,
                              children: [
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    if (profileData.description != "")
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            //Write three sentences of filler text here
                                            profileData.description ?? "",
                                            style: TextStyle(
                                              color: styling.backgroundText,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    FriendsCount(
                                      isCurrentUser: isCurrentUser,
                                      friends: numberOfFriends,
                                      mutualFriends: numberOfMutualFriends,
                                      onFriendsButtonPressed: showFriendsPopup,
                                      onMutualFriendsButtonPressed:
                                          showMutualFriendsPopup,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (!isCurrentUser)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator(
                                              color:
                                                  styling.theme == "christmas"
                                                      ? styling.green
                                                      : styling.primary,
                                            )
                                          : SizedBox(
                                              width: 250,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (!mounted) return;
                                                    setState(() {
                                                      if (!mounted) return;
                                                      isLoading = true;
                                                    });
                                                    String hapticFeedback =
                                                        await HelperFunctions
                                                            .getHapticFeedbackSF();
                                                    if (hapticFeedback ==
                                                        "normal") {
                                                      HapticFeedback
                                                          .mediumImpact();
                                                    } else if (hapticFeedback ==
                                                        "light") {
                                                      HapticFeedback
                                                          .lightImpact();
                                                    }
                                                    if (isFriends) {
                                                      await removeFriend();
                                                    } else {
                                                      if (hasFriendRequest) {
                                                        await acceptFriendRequest();
                                                        if (!mounted) return;
                                                        setState(() {
                                                          if (!mounted) return;
                                                          isLoading = false;
                                                        });
                                                        return;
                                                      }
                                                      if (sentFriendRequest) {
                                                        if (!mounted) return;
                                                        await cancelFriendRequest();
                                                        if (!mounted) return;
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        return;
                                                      }

                                                      await sendFriendRequest();
                                                    }
                                                    if (!mounted) return;
                                                    setState(() {
                                                      if (!mounted) return;
                                                      isLoading = false;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: isFriends ||
                                                            sentFriendRequest ||
                                                            hasFriendRequest
                                                        ? Colors.transparent
                                                        : styling.theme ==
                                                                "christmas"
                                                            ? styling.green
                                                            : styling
                                                                .primaryDark,
                                                    elevation: 10,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        side: BorderSide(
                                                            color: styling
                                                                        .theme ==
                                                                    "christmas"
                                                                ? styling.green
                                                                : styling
                                                                    .primaryDark,
                                                            width: 3)),
                                                  ),
                                                  child: Text(
                                                      isFriends
                                                          ? "Unfriend"
                                                          : hasFriendRequest
                                                              ? "Accept Friend Request"
                                                              : sentFriendRequest
                                                                  ? "Friend Request Sent"
                                                                  : "Add Friend",
                                                      style: TextStyle(
                                                          color: isFriends ||
                                                                  sentFriendRequest ||
                                                                  hasFriendRequest
                                                              ? styling
                                                                  .backgroundText
                                                              : styling
                                                                  .backgroundText))),
                                            )
                                    ],
                                  ),
                                if (!isCurrentUser) const SizedBox(height: 20),
                                BOTWTile(
                                  blank: blankOfTheWeek.blank,
                                  answer: blankOfTheWeek
                                      .answers[profileData.userId]!,
                                  isCurrentUser: isCurrentUser,
                                  status: blankOfTheWeek.status,
                                ),
                                if (blankOfTheWeek.status ==
                                        BOTWStatusType.voting &&
                                    isCurrentUser)
                                  const SizedBox(height: 20),
                                if (blankOfTheWeek.status ==
                                        BOTWStatusType.voting &&
                                    isCurrentUser)
                                  ElevatedButton(
                                      onPressed: () async {
                                        String hapticFeedback =
                                            await HelperFunctions
                                                .getHapticFeedbackSF();
                                        if (hapticFeedback == "normal") {
                                          HapticFeedback.mediumImpact();
                                        } else if (hapticFeedback == "light") {
                                          HapticFeedback.lightImpact();
                                        } else if (hapticFeedback == "heavy") {
                                          HapticFeedback.heavyImpact();
                                        }
                                        nextScreen(
                                            context,
                                            VotingPage(
                                              blank: blankOfTheWeek,
                                            ));
                                      },
                                      style: styling.elevatedButtonDecoration(),
                                      child: Text(
                                        "Vote",
                                        style: TextStyle(
                                            color: styling.theme ==
                                                    "colorful-light"
                                                ? styling.primaryDark
                                                : Colors.black,
                                            fontSize: 16),
                                      )),
                                if (blankOfTheWeek.status ==
                                        BOTWStatusType.done &&
                                    isCurrentUser)
                                  const SizedBox(height: 20),
                                if (blankOfTheWeek.status ==
                                        BOTWStatusType.done &&
                                    isCurrentUser)
                                  ElevatedButton(
                                      onPressed: () async {
                                        String hapticFeedback =
                                            await HelperFunctions
                                                .getHapticFeedbackSF();
                                        if (hapticFeedback == "normal") {
                                          HapticFeedback.mediumImpact();
                                        } else if (hapticFeedback == "light") {
                                          HapticFeedback.lightImpact();
                                        } else if (hapticFeedback == "heavy") {
                                          HapticFeedback.heavyImpact();
                                        }

                                        nextScreen(
                                            context,
                                            BotwResultsPage(
                                                answers:
                                                    blankOfTheWeek.answers));
                                      },
                                      style: styling.elevatedButtonDecoration(),
                                      child: Text(
                                        "View Results",
                                        style: TextStyle(
                                            color: styling.theme ==
                                                    "colorful-light"
                                                ? styling.primaryDark
                                                : Colors.black,
                                            fontSize: 16),
                                      )),
                                if (blankOfTheWeek.previousAnswers.isNotEmpty &&
                                    isCurrentUser)
                                  const SizedBox(height: 20),
                                if (blankOfTheWeek.previousAnswers.isNotEmpty &&
                                    isCurrentUser)
                                  ElevatedButton(
                                      onPressed: () async {
                                        String hapticFeedback =
                                            await HelperFunctions
                                                .getHapticFeedbackSF();
                                        if (hapticFeedback == "normal") {
                                          HapticFeedback.mediumImpact();
                                        } else if (hapticFeedback == "light") {
                                          HapticFeedback.lightImpact();
                                        } else if (hapticFeedback == "heavy") {
                                          HapticFeedback.heavyImpact();
                                        }

                                        nextScreen(
                                            context,
                                            BotwResultsPage(
                                                answers: blankOfTheWeek
                                                    .previousAnswers,
                                                isLastWeek: true));
                                      },
                                      style: styling.elevatedButtonDecoration(),
                                      child: Text(
                                        "View Last Week's Results",
                                        style: TextStyle(
                                            color: styling.theme ==
                                                    "colorful-light"
                                                ? styling.primaryDark
                                                : Colors.black,
                                            fontSize: 16),
                                      )),
                                ...[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SettingTile(
                                    setting: "Saved Responses",
                                    onTap: () => {
                                      nextScreen(
                                          context,
                                          SavedResponsesPage(
                                            userId: profileData.userId,
                                            isCurrentUser: isCurrentUser,
                                          ))
                                    },
                                  ),
                                ],
                                SettingTile(
                                  setting: "Stats",
                                  onTap: () => {
                                    nextScreen(
                                        context,
                                        StatsPage(
                                          userId: profileData.userId,
                                          isCurrentUser: isCurrentUser,
                                        ))
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
