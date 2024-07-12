import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
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
  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> friendRequests = [];
  List<Map<String, dynamic>> outgoingRequests = [];
  int numberOfRequests = 0;

  Future getData() async {
    // Get friends
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    // print("userData");
    List<Map<String, dynamic>> friends = dynamicToMap(userData["friends"]);
    List<Map<String, dynamic>> friendRequests =
        dynamicToMap(userData["friendRequests"]);
    List<Map<String, dynamic>> outgoingRequests =
        dynamicToMap(userData["outgoingRequests"]);
    // Get friend requests
    // Get outgoing requests
    setState(() {
      this.friends = friends;
      this.friendRequests = friendRequests;
      this.outgoingRequests = outgoingRequests;
      numberOfRequests = friendRequests.length;
    });
  }

  List<Map<String, dynamic>> dynamicToMap(List<dynamic> data) {
    List<Map<String, dynamic>> result = [];
    for (dynamic item in data) {
      result.add(Map<String, dynamic>.from(item));
    }
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'Friends',
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
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
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
            displayName: friends[index]["displayName"],
            username: friends[index]["username"],
            uid: friends[index]["userId"],
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
            displayName: friendRequests[index]["displayName"],
            username: friendRequests[index]["username"],
            uid: friendRequests[index]["userId"],
            showCheck: true,
            showX: true,
            onCheckPressed: () async {
              await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                  .acceptFriendRequest(
                      friendRequests[index]["userId"],
                      friendRequests[index]["displayName"],
                      friendRequests[index]["username"],
                      friendRequests[index]["FCMToken"]);
              setState(() {
                friends.add({
                  "displayName": friendRequests[index]["displayName"],
                  "username": friendRequests[index]["username"],
                  "userId": friendRequests[index]["userId"]
                });
                numberOfRequests--;
                friendRequests.removeWhere((element) =>
                    element["userId"] == friendRequests[index]["userId"]);
              });
              //Refresh friend requests
            },
            onXPressed: () async {
              await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                  .declineFriendRequest(
                      friendRequests[index]["userId"],
                      friendRequests[index]["FCMToken"],
                      friendRequests[index]["displayName"],
                      friendRequests[index]["username"]);
              setState(() {
                numberOfRequests--;
                friendRequests.removeWhere((element) =>
                    element["userId"] == friendRequests[index]["userId"]);
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
            displayName: outgoingRequests[index]["displayName"],
            username: outgoingRequests[index]["username"],
            uid: outgoingRequests[index]["userId"],
            showX: true,
            onXPressed: () async {
              await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                  .cancelFriendRequest(
                      outgoingRequests[index]["userId"],
                      outgoingRequests[index]["displayName"],
                      outgoingRequests[index]["username"]);
              setState(() {
                outgoingRequests.removeWhere((element) =>
                    element["userId"] ==
                    outgoingRequests[index]["userId"]);
              });
              //Refresh outgoing requests
            },
          ),
        );
      },
    );
  }
}
