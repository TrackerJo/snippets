import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';

import 'package:snippets/widgets/botw_result_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class BotwResultsPage extends StatefulWidget {
  final Map<String, BOTWAnswer> answers;
  const BotwResultsPage({super.key, this.answers = const {}});

  @override
  State<BotwResultsPage> createState() => _BotwResultsPageState();
}

class _BotwResultsPageState extends State<BotwResultsPage> {
  List<BOTWAnswer> results = [];
  BOTWAnswer userAnswer = BOTWAnswer(
      answer: "No answer",
      displayName: "No display name",
      userId: "No user id",
      FCMToken: "No FCM token",
      voters: [],
      votes: 0);

  List<String> removeEmptyStrings(List<String> list) {
    List<String> newList = [];
    list.forEach((element) {
      if (element != "") {
        newList.add(element);
      }
    });
    return newList;
  }

  void getResults() async {
    Map<String, BOTWAnswer> botwAnswers = widget.answers;
    if (botwAnswers.isEmpty) {
      botwAnswers = (await Database().getBOTW()).answers;
    }
    List<BOTWAnswer> botwResults = [];
    botwAnswers.forEach((key, value) {
      if (key == FirebaseAuth.instance.currentUser!.uid) {
        userAnswer = value;
      }
      botwResults.add(value);
    });
    botwResults.sort((a, b) => removeEmptyStrings(b.voters)
        .length
        .compareTo(removeEmptyStrings(a.voters).length));
    setState(() {
      results = botwResults;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(
                title: "Results",
                showBackButton: true,
                onBackButtonPressed: () async {
                  Navigator.pop(context, true);
                },
              ),
            ),
            backgroundColor: Colors.transparent,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                        child: ListView(
                      children: [
                        if (results.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BOTWResultTile(
                                displayName: results[0].displayName,
                                answer: results[0].answer,
                                votes: removeEmptyStrings(results[0].voters)
                                    .length,
                                ranking: 1,
                                userId: results[0].userId),
                          ),
                        if (results.length > 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BOTWResultTile(
                                displayName: results[1].displayName,
                                answer: results[1].answer,
                                votes: removeEmptyStrings(results[1].voters)
                                    .length,
                                ranking: 2,
                                userId: results[1].userId),
                          ),
                        if (results.length > 2)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BOTWResultTile(
                                displayName: results[2].displayName,
                                answer: results[2].answer,
                                votes: removeEmptyStrings(results[2].voters)
                                    .length,
                                ranking: 3,
                                userId: results[2].userId),
                          ),
                        if (results.indexOf(userAnswer) > 2)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BOTWResultTile(
                                displayName: userAnswer.displayName,
                                answer: userAnswer.answer,
                                votes: removeEmptyStrings(userAnswer.voters)
                                    .length,
                                ranking: results.indexOf(userAnswer) + 1,
                                userId: userAnswer.userId),
                          ),
                      ],
                    ))
                  ]),
            )),
      ],
    );
  }
}
