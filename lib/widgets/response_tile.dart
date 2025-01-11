import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/templates/styling.dart';

import 'helper_functions.dart';

class ResponseTile extends StatefulWidget {
  final String displayName;
  final String response;
  final String question;
  final String userId;
  final String snippetId;
  final bool isDisplayOnly;
  final bool isAnonymous;
  final bool isBestFriend;
  final String theme;
  final bool isTrivia;
  final bool isCorrect;

  const ResponseTile(
      {super.key,
      required this.displayName,
      required this.response,
      required this.userId,
      required this.snippetId,
      required this.question,
      required this.theme,
      this.isBestFriend = false,
      this.isDisplayOnly = false,
      this.isTrivia = false,
      this.isCorrect = false,
      required this.isAnonymous});

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
      shadowColor: styling.getSnippetGradient().colors[0],
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () async {
          if (widget.isDisplayOnly) return;
          String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
          if (hapticFeedback == "normal") {
            HapticFeedback.mediumImpact();
          } else if (hapticFeedback == "light") {
            HapticFeedback.lightImpact();
          } else if (hapticFeedback == "heavy") {
            HapticFeedback.heavyImpact();
          }
          nextScreen(
              context,
              DiscussionPage(
                responseTile: widget,
                theme: widget.theme,
              ));
        },
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: ShapeDecoration(
            gradient: styling.getSnippetGradient(),
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
                        onTap: () async {
                          if (isCurrentUser) return;
                          String hapticFeedback =
                              await HelperFunctions.getHapticFeedbackSF();
                          if (hapticFeedback == "normal") {
                            HapticFeedback.mediumImpact();
                          } else if (hapticFeedback == "light") {
                            HapticFeedback.lightImpact();
                          } else if (hapticFeedback == "heavy") {
                            HapticFeedback.heavyImpact();
                          }
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (widget.isBestFriend)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.star,
                                      size: 20, color: Colors.black),
                                ),
                              Text(
                                widget.isDisplayOnly
                                    ? "${widget.displayName}'s Response"
                                    : widget.displayName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: styling.theme == "colorful-light"
                                      ? styling.primaryDark
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // if (!isCurrentUser)
                      //   Align(
                      //     alignment: Alignment.topRight,
                      //     child: IconButton(
                      //         onPressed: () {},
                      //         icon: const Icon(Icons.more_horiz, size: 20, color: Colors.black)),
                      //   )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: styling.theme == "colorful-light"
                      ? styling.primaryDark
                      : Colors.black,
                ),
                if (widget.isDisplayOnly) const SizedBox(height: 10),
                if (!widget.isDisplayOnly)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 280,
                        ),
                        child: Text(
                          widget.response,
                          style: TextStyle(
                            fontSize: 15,
                            color: styling.theme == "colorful-light"
                                ? styling.primaryDark
                                : Colors.black,
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: styling.primaryDark,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(32.0),
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     if (widget.isDisplayOnly) return;
                      //     HapticFeedback.mediumImpact();
                      //     nextScreen(
                      //         context,
                      //         DiscussionPage(
                      //           responseTile: widget,
                      //           theme: widget.theme,
                      //         ));
                      //   },
                      //   child: const Text("Open Discussion",
                      //       style: TextStyle(color: Colors.white)),
                      // ),
                      Row(
                        children: [
                          if (widget.isTrivia)
                            CircleAvatar(
                              backgroundColor:
                                  widget.isCorrect ? Colors.green : Colors.red,
                              radius: 10, // Adjust the radius as needed
                            ),
                          IconButton(
                              onPressed: () async {
                                if (widget.isDisplayOnly) return;
                                String hapticFeedback =
                                    await HelperFunctions.getHapticFeedbackSF();
                                if (hapticFeedback == "normal") {
                                  HapticFeedback.mediumImpact();
                                } else if (hapticFeedback == "light") {
                                  HapticFeedback.lightImpact();
                                } else if (hapticFeedback == "heavy") {
                                  HapticFeedback.heavyImpact();
                                }
                                nextScreen(
                                    context,
                                    DiscussionPage(
                                      responseTile: widget,
                                      theme: widget.theme,
                                    ));
                              },
                              icon: Icon(Icons.chat_rounded,
                                  size: 25,
                                  color: styling.theme == "colorful-light"
                                      ? styling.primaryDark
                                      : Colors.black)),
                        ],
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
      ),
    );
  }
}
