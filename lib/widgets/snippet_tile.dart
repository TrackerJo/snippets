import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';

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
  TextEditingController answerController = TextEditingController();

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
              {}
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
          trailing: IconButton(
            icon: !widget.isAnswered
                ? Icon(Icons.send)
                : Icon(Icons.arrow_forward_ios),
            onPressed: () async {
              // show options
              if (!widget.isAnswered) {
                await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                    .submitAnswer(widget.snippetId, answerController.text);
                // Navigator.of(context).pop();
                //Go to responses page

                nextScreen(
                    context,
                    ResponsesPage(
                        snippetId: widget.snippetId,
                        userResponse: answerController.text,
                        userDiscussionUsers: [
                          FirebaseAuth.instance.currentUser!.uid
                        ],
                        question: widget.question,
                        theme: widget.theme));
              } else {
                nextScreen(
                  context,
                  ResponsesPage(
                      snippetId: widget.snippetId,
                      question: widget.question,
                      theme: widget.theme),
                );
              }
            },
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
          subtitle: !widget.isAnswered
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: answerController,
                      decoration: textInputDecoration.copyWith(
                          hintText: "Enter answer here")),
                )
              : null,
        ),
      ),
    );
  }
}
