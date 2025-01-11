import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/question_page.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/pages/trivia_responses_page.dart';
import 'package:snippets/widgets/trivia_option_tile.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helper_functions.dart';

class TriviaTile extends StatefulWidget {
  // final bool isAnswered;

  final String question;

  final String snippetId;
  final bool isAnswered;
  final List<String> options;
  final String correctAnswer;
  const TriviaTile(
      {super.key,
      required this.question,
      required this.snippetId,
      required this.isAnswered,
      required this.options,
      required this.correctAnswer});

  @override
  State<TriviaTile> createState() => _TriviaTileState();
}

class _TriviaTileState extends State<TriviaTile> {
  TextEditingController answerController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showTriviaInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Trivia Snippets"),
          content: const Text(
              "Choose from the options and open the responses page to see the correct answer!"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await HelperFunctions.saveSeenTriviaSnippetSF(true);

                Navigator.of(context).pop();
              },
              child: const Text("Okay"),
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
        if (info.visibleFraction > 0) {
          bool seenTrivia = await HelperFunctions.getSeenTriviaSnippetSF();
          ;

          if (!seenTrivia) {
            showTriviaInfoDialog(context);
          }
        }
      },
      child: Material(
        elevation: 10,
        shadowColor: styling.getTriviaGradient().colors[1],
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: ShapeDecoration(
            gradient: styling.getTriviaGradient(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: ListTile(
            onTap: () async {
              if (!widget.isAnswered) {
                //Remove focus from textfield
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
                  TriviaResponsesPage(
                    snippetId: widget.snippetId,
                    question: widget.question,
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
                : widget.isAnswered
                    ? IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                            color: styling.theme == "colorful-light"
                                ? Colors.white
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
                            TriviaResponsesPage(
                              snippetId: widget.snippetId,
                              question: widget.question,
                            ),
                          );
                        },
                      )
                    : null,
            title: Text(
              widget.question,
              style: TextStyle(
                color: styling.theme == "colorful-light"
                    ? Colors.white
                    : Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            subtitle: !widget.isAnswered && !isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0, // Horizontal spacing between children
                      runSpacing: 8.0, // Vertical spacing between runs
                      children: [
                        for (int i = 0; i < widget.options.length; i++)
                          TriviaOptionTile(
                              option: widget.options[i],
                              onClick: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await FBDatabase(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .submitAnswer(
                                        widget.snippetId,
                                        widget.options[i],
                                        widget.question,
                                        "blue",
                                        "trivia",
                                        widget.correctAnswer,
                                        null);
                                setState(() {
                                  isLoading = false;
                                });
                              }),
                      ],
                    ))
                : null,
          ),
        ),
      ),
    );
  }
}
