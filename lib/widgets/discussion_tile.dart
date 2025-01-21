import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/response_tile.dart';

class DiscussionTile extends StatelessWidget {
  final String snippetId;
  final String discussionId;
  final String question;
  final String answerUser;
  final String lastMessageSender;
  final String lastMessage;
  final bool hasBeenRead;
  final String answerResponse;
  final String theme;
  final bool isAnonymous;

  const DiscussionTile(
      {super.key,
      required this.snippetId,
      required this.discussionId,
      required this.question,
      required this.answerUser,
      required this.answerResponse,
      required this.lastMessageSender,
      required this.lastMessage,
      required this.hasBeenRead,
      required this.isAnonymous,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
          elevation: 10,
          shadowColor: styling.theme == "christmas"
              ? styling.green
              : styling.primaryDark,
          borderRadius: BorderRadius.circular(12),
          child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: ShapeDecoration(
                gradient: styling.getSnippetGradient(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: ListTile(
                  title: Text("$answerUser - $question",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: styling.theme == "colorful-light"
                              ? styling.primaryDark
                              : Colors.black)),
                  subtitle: Text(
                      "${lastMessageSender == "" ? "" : "$lastMessageSender: "}$lastMessage",
                      style: TextStyle(
                          fontSize: 12,
                          color: styling.theme == "colorful-light"
                              ? styling.primaryDark
                              : Colors.black)),
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

                    // navigate to discussion page
                    nextScreen(
                        context,
                        DiscussionPage(
                          responseTile: ResponseTile(
                            displayName: answerUser,
                            response: answerResponse,
                            userId: discussionId,
                            snippetId: snippetId,
                            question: question,
                            reports: 0,
                            reportIds: [],
                            theme: theme,
                            isAnonymous: isAnonymous,
                            isDisplayOnly: true,
                          ),
                          theme: theme,
                        ));
                  },
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: styling.theme == "colorful-light"
                          ? styling.primaryDark
                          : Colors.black),
                  leading: //Make a blue dot
                      !hasBeenRead && lastMessageSender != ""
                          ? Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: styling.theme == "christmas"
                                      ? styling.red
                                      : styling.primary,
                                  borderRadius: BorderRadius.circular(50)))
                          : null))),
    );
  }
}
