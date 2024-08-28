import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/helper_functions.dart';

import '../api/fb_database.dart';

class QuestionPage extends StatefulWidget {
  final String question;
  final String snippetId;
  final String theme;
  final String type;
  const QuestionPage(
      {super.key,
      required this.question,
      required this.snippetId,
      required this.theme,
      required this.type});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String answer = "";

  void savePage() async {
    await HelperFunctions.saveOpenedPageSF("question-${widget.snippetId}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    savePage();
  }

  void showAnonymousInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Anonymous Snippets"),
          content: const Text("Your response will be completely anonymous to everyone and will be public, not just to your friends."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                String anonymousID = await HelperFunctions.saveAnonymouseIDSF();
                  await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
                    .submitAnswer(widget.snippetId, answer, widget.question, widget.theme, anonymousID);
              },
              child: const Text("I understand"),
            ),
          ],
        );
      },
    );
  }

  void submitAnswer() async {
    if(widget.type == "anonymous") {
      bool hasSeenAnonymouse = (await HelperFunctions.checkIfSeenAnonymousSnippetSF())!;
      if(!hasSeenAnonymouse) {
        await HelperFunctions.saveSeenAnonymousSnippetSF();
        showAnonymousInfoDialog(context);
      } else {

        String anonymousID = await HelperFunctions.saveAnonymouseIDSF();
        await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
          .submitAnswer(widget.snippetId, answer, widget.question, widget.theme, anonymousID);
      }
    } else {
      await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .submitAnswer(widget.snippetId, answer, widget.question, widget.theme, null);

    }
    
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
            theme: widget.theme,
            isAnonymous: widget.type == "anonymous",));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Snippet",
          theme: widget.theme,
          showBackButton: true,
          fixRight: true,
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
                Text(
                  widget.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inknut Antiqua',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
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
