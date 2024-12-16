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
import 'package:snippets/pages/no_wifi_page.dart';
import 'package:snippets/pages/settings_page.dart';
import 'package:snippets/pages/update_page.dart';

import 'package:snippets/pages/voting_page.dart';

import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/botw_tile.dart';
import 'package:snippets/widgets/custom_page_route.dart';

import 'package:snippets/widgets/friend_tile.dart';
import 'package:snippets/widgets/friends_count.dart';
import 'package:snippets/widgets/helper_functions.dart';

import '../api/auth.dart';
import '../widgets/custom_app_bar.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final bool showNavBar;
  final bool showBackButton;
  final bool showAppBar;
  final bool isFriendLink;

  const ProfilePage(
      {super.key,
      this.uid = "",
      this.showNavBar = true,
      this.showBackButton = false,
      this.showAppBar = true,
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
      setState(() {
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


        setState(() {
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
      User viewerData = await Database()
          .getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
      userDisplayName = viewerData.displayName;
      if (!mounted) return;
      setState(() {
        profileData = viewerData;
        numberOfFriends = viewerData.friends.length;
      });
    } else if (widget.uid == auth.FirebaseAuth.instance.currentUser!.uid) {
      currentUser = true;
      currentUserStream.stream.listen((event) {


        setState(() {
          profileData = event;
          numberOfFriends = profileData.friends.length;
          userDisplayName = profileData.displayName;
        });
      });
      User viewerData = (await Database().getUserData(widget.uid));
      setState(() {
        profileData = viewerData;
        numberOfFriends = viewerData.friends.length;
      });
    } else {
      Stream? viewerDataStream =
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getUserStream(widget.uid);
      if (viewerDataStream == null) {
        setState(() {
          userExists = false;
        });
        return;
      }
      userStreamSub = viewerDataStream.listen((event) async {
        if (event == null) {
          setState(() {
            userExists = false;
          });
          return;
        }
        User viewerData = event;
        setState(() {
          profileData = viewerData;
          numberOfFriends = viewerData.friends.length;
          userDisplayName = viewerData.displayName;
        });
        setState(() {
          profileData = viewerData;
          numberOfFriends = viewerData.friends.length;
        });
      });

      currentUserStream.stream.listen((event) {
        User userData = event;
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
        if (areFriends) {
          setState(() {
            isFriends = true;
          });
        } else {
          setState(() {
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
          if (friendRequest) {
            setState(() {
              sentFriendRequest = true;
            });
          } else {
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
          if (hasRequest) {
            setState(() {
              hasFriendRequest = true;
            });
          } else {
            setState(() {
              hasFriendRequest = false;
            });
          }
        }
      });

      User? viewerData =
          (await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getUserData(widget.uid));
      if (viewerData == null) {
        setState(() {
          userExists = false;
        });
        return;
      }
      fixUserData(viewerData);
      setState(() {
        profileData = viewerData;
        numberOfFriends = viewerData.friends.length;
      });
      User userData = await Database()
          .getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
      List<UserMini> friendsList = userData.friends;
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
      setState(() {
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
      if (areFriends) {
        setState(() {
          isFriends = true;
        });
      } else {
        setState(() {
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
        if (friendRequest) {
          setState(() {
            sentFriendRequest = true;
          });
        } else {
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
        if (hasRequest) {
          setState(() {
            hasFriendRequest = true;
          });
        } else {
          setState(() {
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
                                        username: profileData
                                            .friends[index].username),
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

    setState(() {
      sentFriendRequest = true;
    });
  }

  Future removeFriend() async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .removeFriend(widget.uid, displayName, profileData.username,
            profileData.FCMToken);
    setState(() {
      isFriends = false;
    });
  }

  Future cancelFriendRequest() async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .cancelFriendRequest(widget.uid, displayName, profileData.username,
            profileData.FCMToken);
    setState(() {
      sentFriendRequest = false;
    });
  }

  Future acceptFriendRequest() async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .acceptFriendRequest(widget.uid, displayName, profileData.username,
            profileData.FCMToken);
    setState(() {
      hasFriendRequest = false;
      sentFriendRequest = false;
      isFriends = true;
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
                              ? "Your Profile"
                              : displayName,
                      showBackButton:
                          widget.showBackButton || widget.isFriendLink,
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
                                const SizedBox(height: 20),
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
                                                    setState(() {
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
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        return;
                                                      }
                                                      if (sentFriendRequest) {
                                                        await cancelFriendRequest();
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        return;
                                                      }

                                                      await sendFriendRequest();
                                                    }
                                                    setState(() {
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
