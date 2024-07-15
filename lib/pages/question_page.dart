import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/helper_functions.dart';

import '../api/database.dart';

class QuestionPage extends StatefulWidget {
  final String question;
  final String snippetId;
  final String theme;
  const QuestionPage(
      {super.key,
      required this.question,
      required this.snippetId,
      required this.theme});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String answer = "";

  void submitAnswer() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .submitAnswer(widget.snippetId, answer, widget.question, widget.theme);
    // Navigator.of(context).pop();
    //Go to responses page
    Navigator.of(context).pop();
    nextScreen(
        context,
        ResponsesPage(
            snippetId: widget.snippetId,
            userResponse: answer,
            userDiscussionUsers: [FirebaseAuth.instance.currentUser!.uid],
            question: widget.question,
            theme: widget.theme));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: widget.question,
          theme: widget.theme,
          showBackButton: true,
          onBackButtonPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFF232323),
      body: Stack(
        children: [
          const BackgroundTile(),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 100,
                  child: TextFormField(
                    maxLines: 5,
                    decoration: textInputDecoration.copyWith(
                        hintText: "Enter Answer",
                        fillColor: widget.theme == "sunset"
                            ? ColorSys.sunset
                            : widget.theme == "sunrise"
                                ? ColorSys.sunriseGradient.colors[0]
                                : widget.theme == "blue"
                                    ? ColorSys.secondarySolid
                                    : ColorSys.primarySolid),
                    onChanged: (value) => {
                      setState(() {
                        answer = value;
                      })
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => {
                    submitAnswer(),
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shadowColor: widget.theme == "sunset"
                        ? ColorSys.sunset
                        : widget.theme == "sunrise"
                            ? ColorSys.sunriseGradient.colors[0]
                            : widget.theme == "blue"
                                ? ColorSys.secondarySolid
                                : ColorSys.primarySolid,
                    minimumSize: const Size(150, 50),
                    backgroundColor: widget.theme == "sunset"
                        ? ColorSys.sunset
                        : widget.theme == "sunrise"
                            ? ColorSys.sunriseGradient.colors[0]
                            : widget.theme == "blue"
                                ? ColorSys.secondarySolid
                                : ColorSys.primarySolid,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
