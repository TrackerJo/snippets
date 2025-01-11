import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/friend_tile.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  String friendsView = "friends";
  List<UserMini> friends = [];
  List<UserMini> friendRequests = [];
  List<UserMini> outgoingRequests = [];
  List<String> bestFriends = [];
  StreamController<User> userStreamController = StreamController();
  int numberOfRequests = 0;

  Stream<User>? userDataStream;

  Future getData() async {
    await HelperFunctions.saveOpenedPageSF("friends");
    // Get friends

    currentUserStream.stream.listen((event) {
      if (!mounted) return;

      User userData = event;

      List<UserMini> friends = userData.friends;
      List<UserMini> friendRequests = userData.friendRequests;
      List<UserMini> outgoingRequests = userData.outgoingFriendRequests;
      setState(() {
        //remove duplicate friend requests
        bestFriends = userData.bestFriends;
        friends.toSet().toList();
        friendRequests.toSet().toList();
        outgoingRequests.toSet().toList();
        List<UserMini> loopedFriends = [];
        List<UserMini> loopedFriendRequests = [];
        List<UserMini> loopedOutgoingRequests = [];
        for (var i = 0; i < friends.length; i++) {
          if (!loopedFriends
              .any((element) => element.userId == friends[i].userId)) {
            loopedFriends.add(friends[i]);
          } else {}
        }
        for (var i = 0; i < friendRequests.length; i++) {
          if (!loopedFriendRequests
              .any((element) => element.userId == friendRequests[i].userId)) {
            loopedFriendRequests.add(friendRequests[i]);
          }
        }
        for (var i = 0; i < outgoingRequests.length; i++) {
          if (!loopedOutgoingRequests
              .any((element) => element.userId == outgoingRequests[i].userId)) {
            loopedOutgoingRequests.add(outgoingRequests[i]);
          }
        }
        loopedFriends.sort((a, b) {
          bool ABestFriend =
              userData.bestFriends.any((friend) => friend == a.userId);
          bool BBestFriend =
              userData.bestFriends.any((friend) => friend == b.userId);
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

        this.friends = loopedFriends;
        this.friendRequests = loopedFriendRequests;
        this.outgoingRequests = loopedOutgoingRequests;
        numberOfRequests = friendRequests.length;
      });
    });
    User userData = await Database()
        .getCurrentUserData();
    List<UserMini> friends = userData.friends;
    List<UserMini> friendRequests = userData.friendRequests;
    List<UserMini> outgoingRequests = userData.outgoingFriendRequests;
    if (!mounted) return;
    setState(() {
      bestFriends = userData.bestFriends;
      friends.toSet().toList();
      friendRequests.toSet().toList();
      outgoingRequests.toSet().toList();
      List<UserMini> loopedFriends = [];
      List<UserMini> loopedFriendRequests = [];
      List<UserMini> loopedOutgoingRequests = [];
      for (var i = 0; i < friends.length; i++) {
        //Check if the friend is already in the list by checking the userId
        if (!loopedFriends
            .any((element) => element.userId == friends[i].userId)) {
          loopedFriends.add(friends[i]);
        } else {}
      }
      for (var i = 0; i < friendRequests.length; i++) {
        if (!loopedFriendRequests
            .any((element) => element.userId == friendRequests[i].userId)) {
          loopedFriendRequests.add(friendRequests[i]);
        }
      }
      for (var i = 0; i < outgoingRequests.length; i++) {
        if (!loopedOutgoingRequests
            .any((element) => element.userId == outgoingRequests[i].userId)) {
          loopedOutgoingRequests.add(outgoingRequests[i]);
        }
      }
      loopedFriends.sort((a, b) {
        bool ABestFriend =
            userData.bestFriends.any((friend) => friend == a.userId);
        bool BBestFriend =
            userData.bestFriends.any((friend) => friend == b.userId);
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

      this.friends = loopedFriends;
      this.friendRequests = loopedFriendRequests;
      this.outgoingRequests = loopedOutgoingRequests;
      // this.friends = friends;
      // this.friendRequests = friendRequests;
      // this.outgoingRequests = outgoingRequests;
      numberOfRequests = friendRequests.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(
                title: 'Friends',
                showBackButton: true,
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
                  Navigator.of(context).pop();
                },
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: styling.theme == "light"
                            ? styling.secondary
                            : styling.theme == "colorful-light"
                                ? styling.primary
                                : styling.theme == "christmas"
                                    ? styling.green
                                    : styling.theme == "colorful"
                                        ? styling.secondaryDark
                                        : Color.fromARGB(207, 56, 56, 56),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3 - 30,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: friendsView == "friends"
                                  ? styling.theme == "colorful-light"
                                      ? Colors.white
                                      : styling.theme == "christmas"
                                          ? styling.green
                                          : styling.secondaryDark
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: TextButton(
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
                            setState(() {
                              friendsView = "friends";
                            });
                          },
                          child: Text(
                            "Friends",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: styling.theme == "colorful-light"
                                  ? Colors.white
                                  : styling.theme == "christmas"
                                      ? styling.green
                                      : styling.secondary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.transparent,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                      Container(
                        height: 70,
                        width: numberOfRequests > 0
                            ? MediaQuery.of(context).size.width / 3 + 10
                            : MediaQuery.of(context).size.width / 3 - 15,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: friendsView == "friendRequests"
                                  ? styling.theme == "colorful-light"
                                      ? Colors.white
                                      : styling.theme == "christmas"
                                          ? styling.green
                                          : styling.secondaryDark
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: TextButton(
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

                            setState(() {
                              friendsView = "friendRequests";
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: numberOfRequests > 0
                                    ? MediaQuery.of(context).size.width / 3 -
                                        15 -
                                        30
                                    : MediaQuery.of(context).size.width / 3 -
                                        40,
                                child: Text(
                                  "Friend Requests",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: styling.theme == "colorful-light"
                                        ? Colors.white
                                        : styling.theme == "christmas"
                                            ? styling.green
                                            : styling.secondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (numberOfRequests > 0)
                                const SizedBox(
                                  width: 5,
                                ),
                              if (numberOfRequests > 0)
                                Container(
                                  decoration: BoxDecoration(
                                    color: styling.theme == "colorful-light"
                                        ? styling.secondaryDark
                                        : styling.theme == "christmas"
                                            ? styling.green
                                            : styling.primaryDark,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      numberOfRequests < 10
                                          ? numberOfRequests.toString()
                                          : "9+",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.transparent,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: friendsView == "outgoingRequests"
                                  ? styling.theme == "colorful-light"
                                      ? Colors.white
                                      : styling.theme == "christmas"
                                          ? styling.green
                                          : styling.secondaryDark
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: TextButton(
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
                            setState(() {
                              friendsView = "outgoingRequests";
                            });
                          },
                          child: Text(
                            "Outgoing Requests",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: styling.theme == "colorful-light"
                                  ? Colors.white
                                  : styling.theme == "christmas"
                                      ? styling.green
                                      : styling.secondary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: friendsView == "friends"
                      ? friendsList()
                      : friendsView == "friendRequests"
                          ? friendRequestsList()
                          : outgoingRequestsList(),
                ),
              ],
            )),
      ],
    );
  }

  Widget friendsList() {
    return ListView.builder(
      itemCount: friends.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FriendTile(
            displayName: friends[index].displayName,
            username: friends[index].username,
            uid: friends[index].userId,
            isBestFriend:
                bestFriends.any((friend) => friend == friends[index].userId),
          ),
        );
      },
    );
  }

  Widget friendRequestsList() {
    return ListView.builder(
      itemCount: friendRequests.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FriendTile(
            displayName: friendRequests[index].displayName,
            username: friendRequests[index].username,
            uid: friendRequests[index].userId,
            showCheck: true,
            showX: true,
            onCheckPressed: () async {
              String hapticFeedback =
                  await HelperFunctions.getHapticFeedbackSF();
              if (hapticFeedback == "normal") {
                HapticFeedback.mediumImpact();
              } else if (hapticFeedback == "light") {
                HapticFeedback.lightImpact();
              } else if (hapticFeedback == "heavy") {
                HapticFeedback.heavyImpact();
              }
              await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
                  .acceptFriendRequest(
                      friendRequests[index].userId,
                      friendRequests[index].displayName,
                      friendRequests[index].username,
                      friendRequests[index].FCMToken);
              if (!mounted) return;
              setState(() {
                // friendRequests.removeWhere((element) =>
                //     element.userId == friendRequests[index].userId);
              });

              //Refresh friend requests
            },
            onXPressed: () async {
              String hapticFeedback =
                  await HelperFunctions.getHapticFeedbackSF();
              if (hapticFeedback == "normal") {
                HapticFeedback.mediumImpact();
              } else if (hapticFeedback == "light") {
                HapticFeedback.lightImpact();
              } else if (hapticFeedback == "heavy") {
                HapticFeedback.heavyImpact();
              }
              await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
                  .declineFriendRequest(
                      friendRequests[index].userId,
                      friendRequests[index].FCMToken,
                      friendRequests[index].displayName,
                      friendRequests[index].username);
              setState(() {
                // friendRequests.removeWhere((element) =>
                //     element.userId == friendRequests[index].userId);
              });

              //Refresh friend requests
            },
          ),
        );
      },
    );
  }

  Widget outgoingRequestsList() {
    return ListView.builder(
      itemCount: outgoingRequests.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FriendTile(
            displayName: outgoingRequests[index].displayName,
            username: outgoingRequests[index].username,
            uid: outgoingRequests[index].userId,
            showX: true,
            onXPressed: () async {
              String hapticFeedback =
                  await HelperFunctions.getHapticFeedbackSF();
              if (hapticFeedback == "normal") {
                HapticFeedback.mediumImpact();
              } else if (hapticFeedback == "light") {
                HapticFeedback.lightImpact();
              } else if (hapticFeedback == "heavy") {
                HapticFeedback.heavyImpact();
              }
              await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
                  .cancelFriendRequest(
                      outgoingRequests[index].userId,
                      outgoingRequests[index].displayName,
                      outgoingRequests[index].username,
                      outgoingRequests[index].FCMToken);
              setState(() {
                // outgoingRequests.removeWhere((element) =>
                //     element.userId == outgoingRequests[index].userId);
              });
              //Refresh outgoing requests
            },
          ),
        );
      },
    );
  }
}
