import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/templates/colorsSys.dart';

import '../helper/helper_function.dart';
import '../pages/question_page.dart';
import 'helper_functions.dart';

class SnippetTile extends StatefulWidget {
  // final bool isAnswered;
  final String questionType;
  final String question;
  final String timeLeft;
  final String snippetId;
  final bool isAnswered;
  final String theme;
  const SnippetTile({
    super.key,
    required this.questionType,
    required this.question,
    required this.timeLeft,
    required this.snippetId,
    required this.isAnswered,
    required this.theme,
  });

  @override
  State<SnippetTile> createState() => _SnippetTileState();
}

class _SnippetTileState extends State<SnippetTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: widget.theme == "sunset"
          ? ColorSys.sunset
          : widget.theme == "sunrise"
              ? ColorSys.sunriseGradient.colors[1]
              : widget.theme == "blue"
                  ? ColorSys.blueGreenGradient.colors[1]
                  : ColorSys.purpleBlueGradient.colors[1],
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
        child: ListTile(
          onTap: () => {
            if (!widget.isAnswered)
              {
                nextScreen(
                  context,
                  QuestionPage(
                      question: widget.question,
                      snippetId: widget.snippetId,
                      theme: widget.theme),
                ),
              }
            else
              {
                nextScreen(
                  context,
                  ResponsesPage(
                      snippetId: widget.snippetId,
                      question: widget.question,
                      theme: widget.theme),
                ),
              }
          },
          trailing: CircleAvatar(
            backgroundColor: widget.isAnswered
                ? const Color.fromARGB(225, 56, 255, 76)
                : const Color.fromARGB(225, 255, 52, 52),
            child: widget.questionType == 'stranger'
                ? Image.asset("assets/stranger_icon.png", scale: 1.75)
                : const Icon(
                    Icons.question_answer,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
          ),
          title: Text(
            widget.question,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontFamily: 'Inknut Antiqua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          subtitle: Text(
            "Time Left: ${widget.timeLeft}",
            style: const TextStyle(
              color: Color.fromARGB(119, 12, 12, 12),
              fontSize: 15,
              fontFamily: 'Inknut Antiqua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}
