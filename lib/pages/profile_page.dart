import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';
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

  void getProfileData() async {
    String userDisplayName = "";
    bool currentUser = false;
    if (widget.uid == "") {
      userDisplayName = (await HelperFunctions.getUserDisplayNameFromSF())!;
      currentUser = true;
    } else if (widget.uid == FirebaseAuth.instance.currentUser!.uid) {
      currentUser = true;
    } else {
      userDisplayName =
          (await Database(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserData(widget.uid))["fullname"];
      List<dynamic> friendsList =
          (await Database(uid: FirebaseAuth.instance.currentUser!.uid)
              .getFriendsList());
      if (friendsList.contains(widget.uid)) {
        setState(() {
          isFriends = true;
        });
      } else {
        bool friendRequest =
            (await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                .checkFriendRequest(widget.uid));
        if (friendRequest) {
          setState(() {
            sentFriendRequest = true;
          });
        }
        Map<String, dynamic> userData =
            (await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                .getUserData(FirebaseAuth.instance.currentUser!.uid));
        List<dynamic> friendRequests = userData["friendRequests"];
        if (friendRequests.contains(widget.uid)) {
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

  void sendFriendRequest() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .sendFriendRequest(widget.uid);

    setState(() {
      sentFriendRequest = true;
    });
  }

  void removeFriend() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .removeFriend(widget.uid);
    setState(() {
      isFriends = false;
    });
  }

  void cancelFriendRequest() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .cancelFriendRequest(widget.uid);
    setState(() {
      sentFriendRequest = false;
    });
  }

  void acceptFriendRequest() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .acceptFriendRequest(widget.uid);
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
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: isCurrentUser ? "Your Profile" : displayName + "'s Profile",
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
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  print("Log Out");
                                  logout();
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        print("Log Out");
                                        logout();
                                      },
                                      child: Text("Log Out"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorSys.primarySolid,
                                      )),
                                ),
                              ),
                            ],
                          )));
                });
          },
        ),
      ),
      bottomNavigationBar: widget.showNavBar
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: CustomNavBar(pageIndex: 0),
            )
          : null,
      backgroundColor: Color(0xFF232323),
      body: Stack(
        children: [
          BackgroundTile(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(Icons.account_circle,
                          color: Colors.white, size: 100),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FriendsCount(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!isCurrentUser)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
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
            ],
          ),
        ],
      ),
    );
  }
}
