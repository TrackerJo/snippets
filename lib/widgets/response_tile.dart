import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/templates/colorsSys.dart';

import 'helper_functions.dart';

class ResponseTile extends StatefulWidget {
  final String displayName;
  final String response;
  final String question;
  final String userId;
  final String snippetId;
  final bool isDisplayOnly;
  final void Function()? goToComments;
  final String theme;
  final List<dynamic> discussionUsers;
  const ResponseTile(
      {super.key,
      required this.displayName,
      required this.response,
      required this.userId,
      required this.snippetId,
      required this.question,
      required this.theme,
      this.isDisplayOnly = false,
      required this.discussionUsers,
      this.goToComments});

  @override
  State<ResponseTile> createState() => _ResponseTileState();
}

class _ResponseTileState extends State<ResponseTile> {
  bool userHasLiked = false;
  int likes = 0;
  bool canLike = true;
  bool isCurrentUser = false;

  void checkIfUserHasLiked() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfUserHasLiked();
    setState(() {});
    if (widget.userId == FirebaseAuth.instance.currentUser!.uid) {
      setState(() {
        isCurrentUser = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: widget.theme == "sunset"
          ? ColorSys.sunset
          : widget.theme == "sunrise"
              ? ColorSys.sunriseGradient.colors[0]
              : widget.theme == "blue"
                  ? ColorSys.blueGreenGradient.colors[0]
                  : ColorSys.primary,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: ShapeDecoration(
          gradient: widget.theme == "sunset"
              ? ColorSys.sunsetGradient
              : widget.theme == "sunrise"
                  ? ColorSys.sunriseGradient
                  : widget.theme == "blue"
                      ? ColorSys.blueGreenGradient
                      : ColorSys.purpleBlueGradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35,
                // width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isCurrentUser) return;
                        nextScreen(
                          context,
                          ProfilePage(
                            uid: widget.userId,
                            showNavBar: false,
                            showBackButton: true,
                          ),
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 175,
                        child: Text(
                          widget.isDisplayOnly
                              ? "${widget.displayName}'s Response"
                              : widget.displayName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (!isCurrentUser)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz, size: 20, color: Colors.black)),
                      )
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              Text(
                widget.response,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              if (widget.isDisplayOnly) const SizedBox(height: 10),
              if (!widget.isDisplayOnly)
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.theme == "sunset"
                            ? Color.fromARGB(255, 255, 157, 29)
                            : widget.theme == "sunrise"
                                ? ColorSys.sunriseGradient.colors[1]
                                : widget.theme == "blue"
                                    ? ColorSys.secondarySolid
                                    : ColorSys.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        if (widget.isDisplayOnly) return;
                        nextScreen(
                            context,
                            DiscussionPage(
                              responseTile: widget,
                              theme: widget.theme,
                            ));
                      },
                      child:  Text("Open Discussion", style: TextStyle(color: widget.theme == "sunset"
                            ? Colors.white
                            : widget.theme == "sunrise"
                                ? Colors.white
                                : widget.theme == "blue"
                                    ? Colors.blueAccent
                                    : Colors.white)),
                    ),

                    // IconButton(
                    //   icon: Icon(Icons.favorite,
                    //       color: userHasLiked ? Colors.red : Colors.black),
                    //   onPressed: () {
                    //     if (!canLike) return;
                    //     if (!userHasLiked) {
                    //       likeResponse();
                    //     } else {
                    //       unlikeResponse();
                    //     }
                    //   },
                    // ),
                    // Text(likes.toString()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
