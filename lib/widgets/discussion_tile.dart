import 'package:flutter/material.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/templates/colorsSys.dart';
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
  final List<dynamic> discussionUsers;

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
      required this.discussionUsers,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
          elevation: 10,
          shadowColor: ColorSys.purpleBlueGradient.colors[1],
          borderRadius: BorderRadius.circular(12),
          child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: ShapeDecoration(
                gradient: ColorSys.purpleBlueGradient,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: ListTile(
                  title: Text(answerUser + " - " + question,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(lastMessageSender + ": " + lastMessage),
                  onTap: () {
                    // navigate to discussion page
                    nextScreen(
                        context,
                        DiscussionPage(
                          responseTile: new ResponseTile(
                            displayName: answerUser,
                            response: answerResponse,
                            userId: discussionId,
                            snippetId: snippetId,
                            question: question,
                            theme: theme,
                            discussionUsers: discussionUsers,
                            isDisplayOnly: true,
                          ),
                          theme: theme,
                        ));
                  },
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: //Make a blue dot
                      !hasBeenRead
                          ? Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50)))
                          : null))),
    );
  }
}
