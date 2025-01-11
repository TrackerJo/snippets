import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/pages/saved_discussion_page.dart';
import 'package:snippets/templates/styling.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helper_functions.dart';

class SavedResponseTile extends StatefulWidget {
  final SavedResponse savedResponse;
  final bool isCurrentUser;
  final void Function()? changeVisibility;
  final bool isFirst;

  const SavedResponseTile(
      {super.key,
      required this.savedResponse,
      required this.isCurrentUser,
      this.isFirst = false,
      this.changeVisibility});

  @override
  State<SavedResponseTile> createState() => _SavedResponseTileState();
}

class _SavedResponseTileState extends State<SavedResponseTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showSavedResponseDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Saved Responses"),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Responses are now saved automatically. You can view them in here in your profile. You can set them to public ",
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.public, size: 16),
                  ),
                  TextSpan(
                    text: " or private ",
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.lock, size: 16),
                  ),
                  TextSpan(
                    text: " by tapping on the icon on the top right corner.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await HelperFunctions.saveSeenSavedResponseSF(true);
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.savedResponse.responseId),
      onVisibilityChanged: (info) async {
        if (info.visibleFraction > 0 && widget.isFirst) {
          bool hasSeenSavedResponse =
              await HelperFunctions.getSeenSavedResponseSF();

          if (!hasSeenSavedResponse) {
            showSavedResponseDialog(context);
          }
        }
      },
      child: Material(
        elevation: 10,
        shadowColor: styling.getSnippetGradient().colors[0],
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () async {
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
                SavedDiscussionPage(
                  savedResponse: widget.savedResponse,
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
                  Stack(
                    children: [
                      if (widget.isCurrentUser)
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
                                widget.changeVisibility!();
                              },
                              icon: Icon(
                                widget.savedResponse.isPublic
                                    ? Icons.public
                                    : Icons.lock,
                                color: Colors.black,
                              )),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 280,
                                ),
                                child: Text(
                                  "Q: ${widget.savedResponse.question}\nA: ${widget.savedResponse.answer}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: styling.theme == "colorful-light"
                                        ? styling.primaryDark
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${DateFormat('MMMM d, yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.savedResponse.lastUpdated))}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: styling.theme == "colorful-light"
                                      ? styling.primaryDark
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          //
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: IconButton(
                                onPressed: () async {
                                  String hapticFeedback = await HelperFunctions
                                      .getHapticFeedbackSF();
                                  if (hapticFeedback == "normal") {
                                    HapticFeedback.mediumImpact();
                                  } else if (hapticFeedback == "light") {
                                    HapticFeedback.lightImpact();
                                  } else if (hapticFeedback == "heavy") {
                                    HapticFeedback.heavyImpact();
                                  }
                                  nextScreen(
                                      context,
                                      SavedDiscussionPage(
                                        savedResponse: widget.savedResponse,
                                      ));
                                },
                                icon: Icon(Icons.chat_rounded,
                                    size: 25,
                                    color: styling.theme == "colorful-light"
                                        ? styling.primaryDark
                                        : Colors.black)),
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
                      // Align(
                      //     alignment: Alignment.bottomRight,
                      //     child:
                      //     )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
