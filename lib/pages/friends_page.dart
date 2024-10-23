import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/templates/colorsSys.dart';
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
  StreamController<User> userStreamController = StreamController();
  int numberOfRequests = 0;

  Stream<User>? userDataStream;

  Future getData() async {
    await HelperFunctions.saveOpenedPageSF("friends");
    // Get friends
    print("Getting friends");
    currentUserStream.stream.listen((event) {
      print("Got data");
      print(event);
      User userData = event;
      print(userData);
      List<UserMini> friends = userData.friends;
      List<UserMini> friendRequests = userData.friendRequests;
      List<UserMini> outgoingRequests = userData.outgoingFriendRequests;
      setState(() {
        this.friends = friends;
        this.friendRequests = friendRequests;
        this.outgoingRequests = outgoingRequests;
        numberOfRequests = friendRequests.length;
      });
    });
    User userData = await Database()
        .getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
    List<UserMini> friends = userData.friends;
    List<UserMini> friendRequests = userData.friendRequests;
    List<UserMini> outgoingRequests = userData.outgoingFriendRequests;
    setState(() {
      this.friends = friends;
      this.friendRequests = friendRequests;
      this.outgoingRequests = outgoingRequests;
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
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'Friends',
            showBackButton: true,
            onBackButtonPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: const Color(0xFF232323),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(207, 56, 56, 56),
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
                              ? ColorSys.primary
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          friendsView = "friends";
                        });
                      },
                      child: Text(
                        "Friends",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorSys.primary,
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
                              ? ColorSys.primary
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();

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
                                : MediaQuery.of(context).size.width / 3 - 40,
                            child: Text(
                              "Friend Requests",
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                color: ColorSys.primary,
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
                                color: ColorSys.primary,
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
                              ? ColorSys.primary
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          friendsView = "outgoingRequests";
                        });
                      },
                      child: Text(
                        "Outgoing Requests",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorSys.primary,
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
        ));
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
              HapticFeedback.mediumImpact();
              await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
                  .acceptFriendRequest(
                      friendRequests[index].userId,
                      friendRequests[index].displayName,
                      friendRequests[index].username,
                      friendRequests[index].FCMToken);
              if (!mounted) return;
              setState(() {
                friendRequests.removeWhere((element) =>
                    element.userId == friendRequests[index].userId);
              });

              //Refresh friend requests
            },
            onXPressed: () async {
              HapticFeedback.mediumImpact();
              await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
                  .declineFriendRequest(
                      friendRequests[index].userId,
                      friendRequests[index].FCMToken,
                      friendRequests[index].displayName,
                      friendRequests[index].username);
              setState(() {
                friendRequests.removeWhere((element) =>
                    element.userId == friendRequests[index].userId);
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
              HapticFeedback.mediumImpact();
              await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
                  .cancelFriendRequest(
                      outgoingRequests[index].userId,
                      outgoingRequests[index].displayName,
                      outgoingRequests[index].username,
                      outgoingRequests[index].FCMToken);
              setState(() {
                outgoingRequests.removeWhere((element) =>
                    element.userId == outgoingRequests[index].userId);
              });
              //Refresh outgoing requests
            },
          ),
        );
      },
    );
  }
}
