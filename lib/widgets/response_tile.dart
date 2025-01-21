import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/constants.dart';
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
  final int reports;
  final List<String> reportIds;

  const ResponseTile(
      {super.key,
      required this.displayName,
      required this.response,
      required this.userId,
      required this.snippetId,
      required this.question,
      required this.theme,
      required this.reportIds,
      required this.reports,
      this.isBestFriend = false,
      this.isDisplayOnly = false,
      this.isTrivia = false,
      this.isCorrect = false,
      required this.isAnonymous});

  @override
  State<ResponseTile> createState() => _ResponseTileState();
}

class _ResponseTileState extends State<ResponseTile> {
  bool isCurrentUser = false;
  bool isCensored = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isCensored = widget.reports >= 3;
      if (widget.reports >= 3) {
        HelperFunctions.getSeenCensoredMessageSF().then((value) {
          if (!value) {
            showCensoreDialog(context);
          }
        });
      }
    });
    if (widget.userId == FirebaseAuth.instance.currentUser!.uid) {
      setState(() {
        isCurrentUser = true;
      });
    }
  }

  void showCensoreDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Censored Text"),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Responses that have been censored due to violoting our community guidelines have a black box covering them. They can be viewed by tapping on the black box.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await HelperFunctions.saveSeenCensoredMessageSF(true);
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  void _toggleCensorship() {
    if (widget.reports < 3) return;
    setState(() {
      isCensored = !isCensored;
    });
  }

  void reportResponse() {
    bool selectingReason = true;
    bool selectedOther = false;
    String reason = "";
    String additionalInfo = "";
    bool isSubmitting = false;
    if (widget.reportIds.contains(FirebaseAuth.instance.currentUser!.uid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: const Text("You have already reported this response",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: styling.primary,
              title: const Text("Report Response",
                  style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      "Please select a reason for reporting this response",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reason = "Inappropriate Content";
                          });
                        },
                        child: ListTile(
                          title: const Text("Inappropriate Content",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: "Inappropriate Content",
                            groupValue: reason,
                            fillColor: WidgetStateProperty.all(Colors.white),
                            onChanged: (String? value) {
                              setState(() {
                                reason = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reason = "Bullying";
                          });
                        },
                        child: ListTile(
                          title: const Text("Bullying",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: "Bullying",
                            groupValue: reason,
                            fillColor: WidgetStateProperty.all(Colors.white),
                            onChanged: (String? value) {
                              setState(() {
                                reason = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reason = "Violence, hate or exploitation";
                          });
                        },
                        child: ListTile(
                          title: const Text("Violence, hate or exploitation",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: "Violence, hate or exploitation",
                            groupValue: reason,
                            fillColor: WidgetStateProperty.all(Colors.white),
                            onChanged: (String? value) {
                              setState(() {
                                reason = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reason = "Other";
                          });
                        },
                        child: ListTile(
                          title: const Text("Other",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: "Other",
                            groupValue: reason,
                            fillColor: WidgetStateProperty.all(Colors.white),
                            onChanged: (String? value) {
                              setState(() {
                                reason = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      if (reason == "Other")
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (String value) {
                                additionalInfo = value;
                              },
                              decoration: InputDecoration(
                                hintText:
                                    "Please provide additional information",
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white)),
                ),
                if (isSubmitting)
                  CircularProgressIndicator(
                    color: styling.secondary,
                  )
                else
                  ElevatedButton(
                      onPressed: () async {
                        if (reason == "") {
                          //show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select a reason",
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (reason == "Other" && additionalInfo == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please provide additional information",
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        setState(() {
                          isSubmitting = true;
                        });
                        ResponseReport report = ResponseReport(
                            responseId: widget.userId,
                            snippetId: widget.snippetId,
                            reportedUserId: widget.userId,
                            response: widget.response,
                            reportId: "",
                            date: DateTime.now(),
                            reason: reason,
                            additionalInfo: additionalInfo);
                        await Database().reportSnippetResonse(report);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Response Reported",
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() {
                          isSubmitting = false;
                        });
                        Navigator.of(context).pop();
                      },
                      style: styling.elevatedButtonDecorationBlue(),
                      child: const Text("Report",
                          style: TextStyle(color: Colors.white))),
              ],
            );
          });
        });
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

                          if (widget.isAnonymous) {
                            return;
                          }
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
                      if (!isCurrentUser && !widget.isTrivia)
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
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

                                reportResponse();
                              },
                              icon: const Icon(Icons.flag_outlined,
                                  size: 20, color: Colors.black)),
                        )
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
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: _toggleCensorship,
                                  child: Stack(
                                    children: [
                                      Text(
                                        widget.response,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              styling.theme == "colorful-light"
                                                  ? styling.primaryDark
                                                  : Colors.black,
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        decoration: BoxDecoration(
                                          color: isCensored
                                              ? Colors.black.withOpacity(1)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          widget.response,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // if (!isCensored)
                              //   TextSpan(
                              //     text: widget.response,
                              //     style: TextStyle(
                              //       fontSize: 15,
                              //       color: styling.theme == "colorful-light"
                              //           ? styling.primaryDark
                              //           : Colors.black,
                              //     ),
                              //   ),
                            ],
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
