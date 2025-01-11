import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/question_page.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helper_functions.dart';

class SnippetTile extends StatefulWidget {
  // final bool isAnswered;

  final String question;

  final String snippetId;
  final bool isAnswered;
  final String theme;
  final String type;
  const SnippetTile({
    super.key,
    required this.question,
    required this.snippetId,
    required this.isAnswered,
    this.theme = "blue",
    required this.type,
  });

  @override
  State<SnippetTile> createState() => _SnippetTileState();
}

class _SnippetTileState extends State<SnippetTile> {
  TextEditingController answerController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showAnonymousInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Anonymous Snippets"),
          content: const Text(
              "Your response will be completely anonymous to everyone and will be public, not just to your friends. Anonymous snippets are signified by their black gradient as a background."),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await HelperFunctions.saveSeenAnonymousSnippetSF(true);

                Navigator.of(context).pop();
              },
              child: const Text("I understand"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print("Post frame callback home page ${mounted}");
    });
    return VisibilityDetector(
      key: Key(widget.snippetId),
      onVisibilityChanged: (info) async {
        if (info.visibleFraction > 0 && widget.type == "anonymous") {
          bool hasSeenAnonymous =
              await HelperFunctions.checkIfSeenAnonymousSnippetSF();
          ;

          if (!hasSeenAnonymous) {
            showAnonymousInfoDialog(context);
          }
        }
      },
      child: Material(
        elevation: 10,
        shadowColor: widget.type == "anonymous"
            ? styling.getBlackGradient().colors[0]
            : styling.getSnippetGradient().colors[1],
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: ShapeDecoration(
            gradient: widget.type == "anonymous"
                ? styling.getBlackGradient()
                : styling.getSnippetGradient(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: ListTile(
            onTap: () async {
              if (!widget.isAnswered) {
                //Remove focus from textfield
                FocusScope.of(context).unfocus();
              } else {
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
                  ResponsesPage(
                    snippetId: widget.snippetId,
                    question: widget.question,
                    theme: widget.theme,
                    isAnonymous: widget.type == "anonymous",
                  ),
                );
              }
            },
            trailing: isLoading
                ? CircularProgressIndicator(
                    color: styling.theme == "christmas"
                        ? styling.red
                        : styling.primaryDark,
                  )
                : IconButton(
                    icon: !widget.isAnswered
                        ? Icon(Icons.send,
                            color: styling.theme == "colorful-light"
                                ? widget.type == "anonymous"
                                    ? Colors.white
                                    : styling.primary
                                : styling.theme == "christmas"
                                    ? styling.red
                                    : Colors.black)
                        : Icon(Icons.arrow_forward_ios,
                            color: styling.theme == "colorful-light"
                                ? widget.type == "anonymous"
                                    ? Colors.white
                                    : styling.primary
                                : styling.theme == "christmas"
                                    ? styling.red
                                    : Colors.black),
                    onPressed: () async {
                      // show options
                      String hapticFeedback =
                          await HelperFunctions.getHapticFeedbackSF();
                      if (hapticFeedback == "normal") {
                        HapticFeedback.mediumImpact();
                      } else if (hapticFeedback == "light") {
                        HapticFeedback.lightImpact();
                      } else if (hapticFeedback == "heavy") {
                        HapticFeedback.heavyImpact();
                      }
                      if (!widget.isAnswered) {
                        if (answerController.text.isEmpty) {
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        if (widget.type == "anonymous") {
                          String anonymousID =
                              await HelperFunctions.saveAnonymouseIDSF();
                          await FBDatabase(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .submitAnswer(
                                  widget.snippetId,
                                  answerController.text.trim(),
                                  widget.question,
                                  widget.theme,
                                  "anonymous",
                                  "",
                                  anonymousID);
                        } else {
                          await FBDatabase(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .submitAnswer(
                                  widget.snippetId,
                                  answerController.text.trim(),
                                  widget.question,
                                  widget.theme,
                                  "normal",
                                  "",
                                  null);
                        }
                        setState(() {
                          isLoading = false;
                        });

                        // Navigator.of(context).pop();
                        //Go to responses page
                        // nextScreen(
                        //     context,
                        //     ResponsesPage(
                        //       snippetId: widget.snippetId,
                        //       userResponse: answerController.text,
                        //       userDiscussionUsers: [
                        //         FirebaseAuth.instance.currentUser!.uid
                        //       ],
                        //       question: widget.question,
                        //       theme: widget.theme,
                        //       isAnonymous: widget.type == "anonymous",
                        //     ));
                        setState(() {
                          answerController.clear();
                        });
                      } else {
                        // nextScreen(
                        //     context,
                        //     QuestionPage(
                        //       snippetId: widget.snippetId,
                        //       question: widget.question,
                        //       theme: widget.theme,
                        //       type: widget.type,
                        //     ));

                        nextScreen(
                          context,
                          ResponsesPage(
                            snippetId: widget.snippetId,
                            question: widget.question,
                            theme: widget.theme,
                            isAnonymous: widget.type == "anonymous",
                          ),
                        );
                      }
                    },
                  ),
            title: Text(
              widget.question,
              style: TextStyle(
                color: styling.theme == "colorful-light"
                    ? widget.type == "anonymous"
                        ? Colors.white
                        : styling.primaryDark
                    : styling.theme == "christmas" && widget.type == "anonymous"
                        ? Colors.white
                        : Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            subtitle: !widget.isAnswered
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        onTap: () async {
                          String hapticFeedback =
                              await HelperFunctions.getHapticFeedbackSF();
                          if (hapticFeedback == "normal") {
                            HapticFeedback.mediumImpact();
                          } else if (hapticFeedback == "light") {
                            HapticFeedback.lightImpact();
                          } else if (hapticFeedback == "heavy") {
                            HapticFeedback.heavyImpact();
                          }
                        },
                        maxLines: null,
                        controller: answerController,
                        style: TextStyle(
                            color: styling.theme == "colorful-light"
                                ? Colors.white
                                : styling.theme == "christmas"
                                    ? Colors.white
                                    : Colors.black),
                        decoration: styling.textInputDecoration().copyWith(
                              hintText: "Enter answer here",
                              hintStyle: TextStyle(
                                color: styling.theme == "colorful-light"
                                    ? Colors.white
                                    : styling.theme == "christmas"
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              //Border color: color: ColorSys.primarySolid,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              fillColor: styling.theme == "christmas"
                                  ? styling.red
                                  : styling.primaryInput,

                              //   borderRadius: BorderRadius.circular(20.0),
                              //   borderSide: BorderSide(
                              //     color: ColorSys.primarySolid,
                              //     width: 20,
                              //   ),
                              // ),
                            )),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
