import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/providers/card_provider.dart';

class BOTWVotingCard extends StatefulWidget {
  // final bool isAnswered;

  final BOTWAnswer answer;
  final bool votedFor;
  final Function(bool) onVote;

  const BOTWVotingCard({
    super.key,
    required this.answer,
    required this.votedFor,
    required this.onVote,
  });

  @override
  State<BOTWVotingCard> createState() => _BOTWVotingCardState();
}

class _BOTWVotingCardState extends State<BOTWVotingCard> {
  TextEditingController answerController = TextEditingController();
  bool isEditting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        child: buildCard(),
      );

  Widget buildCard() => Material(
        elevation: 10,
        shadowColor:
            styling.theme == "christmas" ? styling.green : styling.primaryDark,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: ShapeDecoration(
            gradient: styling.getPurpleBlueGradient(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: ListTile(
            onTap: () async {
              String haptic = await HelperFunctions.getHapticFeedbackSF();
              if (haptic == "light") {
                HapticFeedback.lightImpact();
              } else if (haptic == "medium") {
                HapticFeedback.mediumImpact();
              } else if (haptic == "heavy") {
                HapticFeedback.heavyImpact();
              }
              widget.onVote(!widget.votedFor);
            },
            trailing: IconButton(
                onPressed: () async {
                  String haptic = await HelperFunctions.getHapticFeedbackSF();
                  if (haptic == "light") {
                    HapticFeedback.lightImpact();
                  } else if (haptic == "medium") {
                    HapticFeedback.mediumImpact();
                  } else if (haptic == "heavy") {
                    HapticFeedback.heavyImpact();
                  }
                  widget.onVote(!widget.votedFor);
                },
                icon: Icon(
                  widget.votedFor
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: styling.theme == "colorful-light"
                      ? styling.primaryDark
                      : Colors.black,
                )),
            title: Text(
              widget.answer.displayName,
              style: TextStyle(
                color: styling.theme == "colorful-light"
                    ? styling.primaryDark
                    : Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
            subtitle: Text(widget.answer.answer,
                style: TextStyle(
                    color: styling.theme == "colorful-light"
                        ? styling.primaryDark
                        : Colors.black,
                    fontSize: 16)),
          ),
        ),
      );
}
