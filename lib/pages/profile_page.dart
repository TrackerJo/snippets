import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/botw_results_page.dart';

import 'package:snippets/pages/voting_page.dart';

import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/botw_tile.dart';

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
      this.isFriendLink = false

      });

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
  Map<String, dynamic> profileData = {};
  Map<String, dynamic> blankOfTheWeek = {};
  List<Map<String, dynamic>> mutualFriends = [];
  StreamSubscription userStreamSub = const Stream.empty().listen((event) {});
  StreamSubscription blankStreamSub = const Stream.empty().listen((event) {});
  StreamSubscription userStreamSub2 = const Stream.empty().listen((event) {});
  StreamController botwStreamController = StreamController();

  

  String editDescription = "";

  

  void checkForBlankOfTheWeek(String uid) async {
    

    Stream blankStream = await Database().getBOTWStream(botwStreamController);
    blankStreamSub = blankStream.listen((event) {
      if(botwStreamController.isClosed) return;
      Map<String, dynamic> data = event;

      if (data.isEmpty) {
        return;
      }
      Map<String, dynamic> answers = data["answers"];
      if (!answers.containsKey(uid)) {
        data["answers"][uid] = {
          "answer": "",
          "displayName": displayName,
          "userId": uid,
          "votes": 0,
          "voters": [],
          "FCMToken": profileData["FCMToken"]
          
          };
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
      userStreamSub = userStreamController.stream.listen((event) {
        if (event == null) {
          return;
        }
        setState(() {
          profileData = event;
          numberOfFriends = profileData["friends"].length;
          userDisplayName = profileData["fullname"];
          Map<String, dynamic> newBlankofTheWeek = blankOfTheWeek;
          print(newBlankofTheWeek);
          if (newBlankofTheWeek.isNotEmpty && newBlankofTheWeek["answers"].containsKey(profileData["uid"] )) {
            newBlankofTheWeek["answers"][profileData["uid"]] = {
              "answer": newBlankofTheWeek["answers"][profileData["uid"]]["answer"],
              "displayName": profileData["fullname"],
              "userId": profileData["uid"],
              "votes": newBlankofTheWeek["answers"][profileData["uid"]]["votes"],
              "voters": newBlankofTheWeek["answers"][profileData["uid"]]["voters"],
              "FCMToken": profileData["FCMToken"]
            };
          }
          blankOfTheWeek = newBlankofTheWeek;
          

        });
      });

      currentUser = true;
      Map<String, dynamic> viewerData =
          (await HelperFunctions.getUserDataFromSF());
      userDisplayName = viewerData["fullname"];
      setState(() {
        profileData = viewerData;
        numberOfFriends = viewerData["friends"].length;
      });

    } else if (widget.uid == FirebaseAuth.instance.currentUser!.uid) {
      currentUser = true;
      userStreamSub = userStreamController.stream.listen((event) {
        if (event == null) {
          return;
        }
        setState(() {
          profileData = event;
          numberOfFriends = profileData["friends"].length;
          userDisplayName = profileData["fullname"];
        });
      });
      Map<String, dynamic> viewerData =
          (await HelperFunctions.getUserDataFromSF());
      setState(() {
        profileData = viewerData;
        numberOfFriends = viewerData["friends"].length;
      });

    } else {
      Stream viewerDataStream = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
          .getUserStream(widget.uid);
      userStreamSub = viewerDataStream.listen((event) async {

        Map<String, dynamic> viewerData = event.data() as Map<String, dynamic>;
        setState(() {
          profileData = viewerData;
          numberOfFriends = viewerData["friends"].length;
          userDisplayName = viewerData["fullname"];
        });
        setState(() {
          profileData = viewerData;
          numberOfFriends = viewerData["friends"].length;
        });
        
      });
      userStreamSub2 = userStreamController.stream.listen((event) {
        if (event == null) {
          return;
        }

          Map<String, dynamic> userData = event as Map<String, dynamic>;
          List<dynamic> friendsList = userData["friends"];
          int mutualFriends = 0;
          List<Map<String, dynamic>> mutualFriendsList = [];
          for (dynamic friend in friendsList) {
            for (dynamic friend2 in profileData["friends"]) {
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
          userDisplayName = profileData["fullname"];

          bool areFriends = false;
          for (dynamic friend in friendsList) {


            if (friend["userId"] == widget.uid) {

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
            } else {
              setState(() {
                sentFriendRequest = false;
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
            } else {
              setState(() {
                hasFriendRequest = false;
              });
            }
          }
        });
      
      Map<String, dynamic> viewerData =
          (await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
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


        if (friend["userId"] == widget.uid) {

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
        } else {
          setState(() {
            sentFriendRequest = false;
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
    checkForBlankOfTheWeek(profileData["uid"]);
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

  void showFriendsPopup() {
    HapticFeedback.mediumImpact();
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
     HapticFeedback.mediumImpact();
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

  Future sendFriendRequest() async {
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .sendFriendRequest(widget.uid, displayName, profileData["username"],
            profileData["FCMToken"]);

    setState(() {
      sentFriendRequest = true;
    });
  }

  Future removeFriend() async {
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .removeFriend(widget.uid, displayName, profileData["username"], profileData["FCMToken"]);
    setState(() {
      isFriends = false;
    });
  }

  Future cancelFriendRequest() async {
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .cancelFriendRequest(widget.uid, displayName, profileData["username"], profileData["FCMToken"]);
    setState(() {
      sentFriendRequest = false;
    });
  }

  Future acceptFriendRequest() async {
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
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
    return GestureDetector(
       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        
        appBar: widget.showAppBar ? PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            fixRight: true,
            title: isCurrentUser ? "Your Profile" : displayName,
            showBackButton: widget.showBackButton || widget.isFriendLink,
            onBackButtonPressed: () {
              HapticFeedback.mediumImpact();

              if (widget.isFriendLink) {
                // Navigator.of(context).pop();
                router.go('/home');
                
              } else {
                Navigator.of(context).pop();
              }
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
                                        editDescription =
                                            profileData["description"];
                                        showDiscriptionPopup(context);
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
        ) : null,

        backgroundColor: const Color(0xFF232323),
        body: gotData ? Stack(
          children: [
            const BackgroundTile(),
            SingleChildScrollView(
              child: Column(
                // shrinkWrap: true,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      if(profileData["description"] != null && profileData["description"] != "")
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            //Write three sentences of filler text here
                            profileData["description"] ?? "",
                            style: const TextStyle(
                              color: Colors.white,
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
                        onMutualFriendsButtonPressed: showMutualFriendsPopup,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (!isCurrentUser)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading ?  CircularProgressIndicator( color: ColorSys.primary,) 
                        : SizedBox(
                          width: 250,
                          child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                HapticFeedback.mediumImpact();
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFriends ||
                                        sentFriendRequest ||
                                        hasFriendRequest
                                    ? Colors.transparent
                                    : ColorSys.primaryDark,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                        color: ColorSys.primaryDark, width: 3)),
                              ),
                              child: Text(isFriends
                                  ? "Unfriend"
                                  : hasFriendRequest
                                      ? "Accept Friend Request"
                                      : sentFriendRequest
                                          ? "Friend Request Sent"
                                          : "Add Friend", style: TextStyle(color: isFriends || sentFriendRequest || hasFriendRequest ? Colors.white : Colors.white))),
                        )
                      ],
                    ),
                  if(!isCurrentUser)
                    const SizedBox(height: 20),
              
                  if(blankOfTheWeek.isNotEmpty)
                    BOTWTile(blank: blankOfTheWeek["blank"], answer:blankOfTheWeek["answers"][profileData["uid"]] , isCurrentUser: isCurrentUser, status: blankOfTheWeek["status"],),
                 if(blankOfTheWeek.isNotEmpty && blankOfTheWeek["status"] == "voting" && isCurrentUser)
                    const SizedBox(height: 20),
                  if(blankOfTheWeek.isNotEmpty && blankOfTheWeek["status"] == "voting" && isCurrentUser)
                    ElevatedButton(onPressed: () {
                      HapticFeedback.mediumImpact();
                      nextScreen(context, VotingPage(blank: blankOfTheWeek,));
                    },style: elevatedButtonDecoration ,child: const Text(
                      "Vote",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
               
                  if(blankOfTheWeek.isNotEmpty && blankOfTheWeek["status"] == "done" && isCurrentUser)
                    const SizedBox(height: 20),
                  if(blankOfTheWeek.isNotEmpty && blankOfTheWeek["status"] == "done" && isCurrentUser)
                    ElevatedButton(onPressed: () {
                      nextScreen(context, BotwResultsPage(answers: blankOfTheWeek["answers"]));
                    },style: elevatedButtonDecoration ,child: const Text(
                      "View Results",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                ],
              ),
            ),
          ],
        ) : const SizedBox(),
      ),
    );
  }

  showDiscriptionPopup(BuildContext context) {
    return showDialog(
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {

      return GestureDetector(
         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          
          child: AlertDialog(
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
                  TextFormField(
                    initialValue: editDescription,
                    maxLines: 7,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Description',
                      counterStyle: const TextStyle(color: Colors.white),

                    ),
                    onChanged: (value) => editDescription = value,
                    maxLength: 125,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                    profileData["description"] = editDescription;
                  });
          
                  await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateUserDescription(editDescription);
                  Navigator.of(context).pop();
                },
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
      }
    );
  }
}
