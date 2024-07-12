import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/friend_tile.dart';
import 'package:snippets/widgets/friends_count.dart';

import '../api/auth.dart';
import '../widgets/custom_app_bar.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final bool showNavBar;
  final bool showBackButton;
  const ProfilePage(
      {super.key,
      this.uid = "",
      this.showNavBar = true,
      this.showBackButton = false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = "";
  bool isCurrentUser = false;
  bool isFriends = false;
  bool sentFriendRequest = false;
  bool hasFriendRequest = false;
  int numberOfFriends = 0;
  int numberOfMutualFriends = 0;
  Map<String, dynamic> profileData = {};
  List<Map<String, dynamic>> mutualFriends = [];

  TextEditingController descriptionController = TextEditingController();

  void getProfileData() async {
    String userDisplayName = "";
    bool currentUser = false;
    if (widget.uid == "") {
      userDisplayName = (await HelperFunctions.getUserDisplayNameFromSF())!;
      currentUser = true;
      Map<String, dynamic> viewerData =
          (await HelperFunctions.getUserDataFromSF());
      setState(() {
        profileData = viewerData;
        numberOfFriends = viewerData["friends"].length;
      });
    } else if (widget.uid == FirebaseAuth.instance.currentUser!.uid) {
      currentUser = true;
      Map<String, dynamic> viewerData =
          (await HelperFunctions.getUserDataFromSF());
      setState(() {
        profileData = viewerData;
        numberOfFriends = viewerData["friends"].length;
      });
    } else {
      Map<String, dynamic> viewerData =
          (await Database(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserData(widget.uid));
      setState(() {
        profileData = viewerData;
        numberOfFriends = viewerData["friends"].length;
      });
      Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
      List<dynamic> friendsList = userData["friends"];
      int mutualFriends = 0;
      List<Map<String, dynamic>> mutualFriendsList = [];
      for (dynamic friend in friendsList) {
        for (dynamic friend2 in viewerData["friends"]) {
          if (friend["userId"] == friend2["userId"]) {
            mutualFriends++;
            mutualFriendsList.add(friend);
          }
        }
      }
      setState(() {
        numberOfMutualFriends = mutualFriends;
        this.mutualFriends = mutualFriendsList;
      });
      userDisplayName = viewerData["fullname"];

      bool areFriends = false;
      for (dynamic friend in friendsList) {
        String friendId = friend["userId"];
        print("friend: $friendId , widget.uid: ${widget.uid}");
        print(FirebaseAuth.instance.currentUser!.uid);
        if (friend["userId"] == widget.uid) {
          print("are friends");
          areFriends = true;
          break;
        }
      }
      if (areFriends) {
        setState(() {
          isFriends = true;
        });
      } else {
        List<dynamic> outgoingFriendRequests = userData["outgoingRequests"];
        bool friendRequest = false;
        for (dynamic request in outgoingFriendRequests) {
          if (request["userId"] == widget.uid) {
            friendRequest = true;
            break;
          }
        }
        if (friendRequest) {
          setState(() {
            sentFriendRequest = true;
          });
        }

        List<dynamic> friendRequests = userData["friendRequests"];
        bool hasRequest = false;
        for (dynamic request in friendRequests) {
          if (request["userId"] == widget.uid) {
            hasRequest = true;
            break;
          }
        }
        if (hasRequest) {
          setState(() {
            hasFriendRequest = true;
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        displayName = userDisplayName;
        isCurrentUser = currentUser;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  void logout() async {
    await Auth().signOut();
    Navigator.of(context).pushReplacement(
      CustomPageRoute(
        builder: (BuildContext context) {
          return const WelcomePage();
        },
      ),
    );
  }

  void showFriendsPopup() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: ColorSys.background,
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
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const Text("Friends",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          )),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                            itemCount: profileData["friends"].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FriendTile(
                                    displayName: profileData["friends"][index]
                                        ["displayName"],
                                    uid: profileData["friends"][index]
                                        ["userId"],
                                    username: profileData["friends"][index]
                                        ["username"]),
                              );
                            }),
                      ),
                    ],
                  )));
        });
  }

  void showMutualFriendsPopup() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: ColorSys.background,
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
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const Text("Mutual Friends",
                          style: TextStyle(
                            color: Colors.white,
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
                                    displayName: mutualFriends[index]
                                        ["displayName"],
                                    uid: mutualFriends[index]["userId"],
                                    username: mutualFriends[index]["username"]),
                              );
                            }),
                      ),
                    ],
                  )));
        });
  }

  void sendFriendRequest() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .sendFriendRequest(widget.uid, displayName, profileData["username"],
            profileData["FCMToken"]);

    setState(() {
      sentFriendRequest = true;
    });
  }

  void removeFriend() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .removeFriend(widget.uid, displayName, profileData["username"]);
    setState(() {
      isFriends = false;
    });
  }

  void cancelFriendRequest() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .cancelFriendRequest(widget.uid, displayName, profileData["username"]);
    setState(() {
      sentFriendRequest = false;
    });
  }

  void acceptFriendRequest() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .acceptFriendRequest(widget.uid, displayName, profileData["username"],
            profileData["FCMToken"]);
    setState(() {
      hasFriendRequest = false;
      sentFriendRequest = false;
      isFriends = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: isCurrentUser ? "Your Profile" : "$displayName ",
          showBackButton: widget.showBackButton,
          onBackButtonPressed: () {
            Navigator.of(context).pop();
          },
          showSettingsButton: isCurrentUser,
          onSettingsButtonPressed: () {
            showModalBottomSheet<void>(
                context: context,
                backgroundColor: ColorSys.background,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                  ),
                ),
                builder: (BuildContext context) {
                  return SizedBox(
                      height: 200,
                      child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      print("Log Out");
                                      logout();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorSys.primarySolid,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        shadowColor: ColorSys.primary),
                                    child: const Text("Log Out",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      descriptionController.text =
                                          profileData["description"];
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return showDiscriptionPopup();
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorSys.primarySolid,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        shadowColor: ColorSys.primary),
                                    child: const Text("Edit Description",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))),
                              ),
                            ],
                          )));
                });
          },
        ),
      ),
      bottomNavigationBar: widget.showNavBar
          ? const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: CustomNavBar(pageIndex: 0),
            )
          : null,
      backgroundColor: const Color(0xFF232323),
      body: Stack(
        children: [
          const BackgroundTile(),
          Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        //Write three sentences of filler text here
                        profileData["description"] ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FriendsCount(
                    isCurrentUser: isCurrentUser,
                    friends: numberOfFriends,
                    mutualFriends: numberOfMutualFriends,
                    onFriendsButtonPressed: showFriendsPopup,
                    onMutualFriendsButtonPressed: showMutualFriendsPopup,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!isCurrentUser)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            if (isFriends) {
                              removeFriend();
                            } else {
                              if (hasFriendRequest) {
                                acceptFriendRequest();
                                return;
                              }
                              if (sentFriendRequest) {
                                cancelFriendRequest();
                                return;
                              }

                              sendFriendRequest();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFriends ||
                                    sentFriendRequest ||
                                    hasFriendRequest
                                ? Colors.transparent
                                : ColorSys.primary,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(
                                    color: ColorSys.primarySolid, width: 2)),
                          ),
                          child: Text(isFriends
                              ? "Unfriend"
                              : hasFriendRequest
                                  ? "Accept Friend Request"
                                  : sentFriendRequest
                                      ? "Friend Request Sent"
                                      : "Add Friend")),
                    )
                  ],
                ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget showDiscriptionPopup() {
    return AlertDialog(
      backgroundColor: ColorSys.background,
      title: Text("Profile's Description",
          style: TextStyle(color: ColorSys.primary)),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            const Text(
                "Enter a short description about yourself. This will be visible to other users.",
                style: TextStyle(color: Colors.white)),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: descriptionController,
              maxLines: 7,
              decoration: textInputDecoration.copyWith(
                hintText: 'Description',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorSys.primary,
          ),
          onPressed: () async {
            setState(() {
              profileData["description"] = descriptionController.text;
            });

            await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                .updateUserDescription(descriptionController.text);
            Navigator.of(context).pop();
          },
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
