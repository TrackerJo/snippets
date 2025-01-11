import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

import 'package:snippets/pages/profile_page.dart';

import 'package:snippets/templates/styling.dart';
import 'package:snippets/widgets/helper_functions.dart';

class BOTWResultTile extends StatefulWidget {
  // final bool isAnswered;

  final String displayName;
  final String answer;
  final int votes;
  final int ranking;
  final String userId;

  const BOTWResultTile(
      {super.key,
      required this.displayName,
      required this.answer,
      required this.votes,
      required this.ranking,
      required this.userId});

  @override
  State<BOTWResultTile> createState() => _BOTWResultTileState();
}

class _BOTWResultTileState extends State<BOTWResultTile> {
  TextEditingController answerController = TextEditingController();
  bool isEditting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: styling.getSnippetGradient().colors[1],
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: ShapeDecoration(
          gradient: styling.getSnippetGradient(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: ListTile(
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
              nextScreen(
                  context,
                  ProfilePage(
                    uid: widget.userId,
                    showNavBar: false,
                    showBackButton: true,
                  ));
            },
            title: Text(
              widget.displayName,
              style: TextStyle(
                color: styling.theme == "colorful-light"
                    ? styling.secondaryDark
                    : Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
              textAlign: TextAlign.center,
            ),
            subtitle: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.answer,
                            style: TextStyle(
                                color: styling.theme == "colorful-light"
                                    ? styling.secondaryDark
                                    : Colors.black,
                                fontSize: 16))),
                  ),
                ),
                Text("Votes: ${widget.votes}",
                    style: TextStyle(
                        color: styling.theme == "colorful-light"
                            ? styling.secondaryDark
                            : Colors.black,
                        fontSize: 16))
              ],
            ),
            trailing: Text("Ranking: ${widget.ranking}",
                style: TextStyle(
                    color: styling.theme == "colorful-light"
                        ? styling.secondaryDark
                        : Colors.black,
                    fontSize: 16))),
      ),
    );
  }
}
