import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/profile_tile.dart';

class FindProfilePage extends StatefulWidget {
  final int index;
  const FindProfilePage({super.key, required this.index});

  @override
  State<FindProfilePage> createState() => _FindProfilePageState();
}

class _FindProfilePageState extends State<FindProfilePage> {
  String profileName = "";
  Stream<List<User>>? profileStream;

  List<Map<String, dynamic>> suggestedFriends = [];

  void getData() async {
    List<Map<String, dynamic>> mutual =
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .getSuggestedFriends();
    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      suggestedFriends = mutual;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  //Run function when widget.index changes
  @override
  void didUpdateWidget(covariant FindProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) return;
    if (widget.index != 3) return;

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF232323),
        body: Column(
          children: [
            // const BackgroundTile(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                      decoration: textInputDecoration.copyWith(
                        hintText: "Enter Profile Name",
                        fillColor: const Color.fromARGB(255, 156, 225, 255),
                      ),
                      onChanged: (value) async {
                        if (value == "") {
                          setState(() {
                            profileName = "";
                            profileStream = null;
                          });
                          return;
                        }
                        Stream<List<User>> stream = await FBDatabase(
                                uid:
                                    auth.FirebaseAuth.instance.currentUser!.uid)
                            .searchUsers(value);
                        setState(() {
                          profileName = value;
                          profileStream = stream;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (profileName != "") Expanded(child: profileList()),
            if (profileName == "") const SizedBox(height: 20),
            if (profileName == "")
              const Text(
                "Suggested Friends",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            if (profileName == "") const SizedBox(height: 20),
            if (profileName == "") Expanded(child: suggestedFriendsList()),
          ],
        ),
      ),
    );
  }

  StreamBuilder profileList() {
    return StreamBuilder(
      stream: profileStream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (profileName == "") {
          return const Center();
        }
        if (snapshot.hasData) {
          if (snapshot.data!.length != null) {
            if (snapshot.data.length != 0) {
              return ListView.builder(
                  clipBehavior: Clip.none,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    //int reverseIndex = snapshot.data.docs.length - index - 1;
                    // bool isWinner = false;
                    // DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                    //     .getIsWinner(
                    //         getId(snapshot.data["games"][reverseIndex]),
                    //         widget.groupId,
                    //         userName)
                    //     .then((value) {
                    //   setState(() {
                    //     isWinner = value;
                    //   });
                    // });
                    User user = snapshot.data[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProfileTile(
                        displayName: user.displayName,
                        uid: user.userId,
                        username: user.username,
                        // isWinner: isWinner,
                        // groupId: widget.groupId,
                        // userName: userName,
                      ),
                    );
                  });
            } else {
              return const Center();
            }
          } else {
            return const Center();
          }
        } else {
          return const Center(
              //     child: CircularProgressIndicator(
              //   color: Theme.of(context).primaryColor,
              // ));
              );
        }
      },
    );
  }

  ListView suggestedFriendsList() {
    return ListView.builder(
        itemCount: suggestedFriends.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfileTile(
              displayName: suggestedFriends[index]["displayName"],
              uid: suggestedFriends[index]["userId"],
              username: suggestedFriends[index]["username"],
              mutualFriends: suggestedFriends[index]["count"],
            ),
          );
        });
  }
}
