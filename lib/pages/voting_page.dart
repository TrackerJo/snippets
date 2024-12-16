import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/providers/card_provider.dart';
import 'package:snippets/templates/styling.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/botw_voting_card.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class VotingPage extends StatefulWidget {
  final BOTW? blank;

  const VotingPage({super.key, this.blank});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  List<BOTWAnswer> votedAnswers = [];
  List<BOTWAnswer> answers = [];
  int votesLeft = 3;
  bool hasSavedVotes = true;
  User profileData = User.empty();
  BOTW blank = BOTW.empty();
  List<BOTWAnswer> movedAnswers = [];
  List<BOTWAnswer> skippedAnswers = [];
  List<BOTWAnswer> answersList = [];
  List<BOTWAnswer> pastAnswers = [];

  int mostLinesInAnswer = 0;

  List<BOTWAnswer> getAnswers(
      Map<String, BOTWAnswer> answers, User profileData) {
    List<BOTWAnswer> listAnswers = [];

    answers.forEach((key, value) {
      if (key == profileData.userId) return;
      if (value.voters.contains(profileData.userId)) return;

      listAnswers.add(value);
    });
    return listAnswers;
  }

  List<BOTWAnswer> getVotedBOTW(
      Map<String, BOTWAnswer> answers, User profileData) {
    List<BOTWAnswer> votedBOTW = [];
    answers.forEach((key, value) {
      if (value.voters.contains(profileData.userId)) votedBOTW.add(value);
    });

    return votedBOTW;
  }

  void getData() async {
    bool hasVotedBefore = await HelperFunctions.checkIfVotedBeforeSF();
    if (!hasVotedBefore) {
      await HelperFunctions.saveVotedBeforeSF();
      showVotingHelp();
    }
    BOTW nblank = BOTW.empty();
    if (widget.blank == null) {
      nblank = await Database().getBOTW();

      setState(() {
        blank = nblank;
      });
    } else {
      nblank = widget.blank!;
      setState(() {
        blank = widget.blank!;
      });
    }

    User data = await Database()
        .getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
    final provider = Provider.of<CardProvider>(context, listen: false);
    List<BOTWAnswer> answers = getAnswers(nblank.answers, data);

    provider.setAnswers(answers);
    provider.setOnLike(voteForAnswer);
    provider.setOnDislike(skipAnswer);
    int longestAnswer = 0;
    for (var answer in answers) {
      if (answer.answer.split("").length > longestAnswer) {
        longestAnswer = answer.answer.split("").length;
      }
    }

    setState(() {
      profileData = data;
      votesLeft = data.votesLeft;
      votedAnswers = getVotedBOTW(nblank.answers, data);
      this.answers = [...answers];
      answersList = [...answers];
      pastAnswers = [...votedAnswers];
      mostLinesInAnswer = (longestAnswer / 18).ceil();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void voteForAnswer(BOTWAnswer answer) async {
    if (votesLeft == 0) {
      showOutOfVotes();
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.goBack(answer);
      return;
    }
    String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
    if (hapticFeedback == "normal") {
      HapticFeedback.mediumImpact();
    } else if (hapticFeedback == "light") {
      HapticFeedback.lightImpact();
    } else if (hapticFeedback == "heavy") {
      HapticFeedback.heavyImpact();
    }
    setState(() {
      hasSavedVotes = false;
      movedAnswers.add(answer);
      votedAnswers.add(answer);
      votesLeft--;
    });
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      answers.remove(answer);
      answersList.remove(answer);
    });
  }

  void skipAnswer(BOTWAnswer answer) async {
    String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
    if (hapticFeedback == "normal") {
      HapticFeedback.mediumImpact();
    } else if (hapticFeedback == "light") {
      HapticFeedback.lightImpact();
    } else if (hapticFeedback == "heavy") {
      HapticFeedback.heavyImpact();
    }
    setState(() {
      movedAnswers.add(answer);
      skippedAnswers.add(answer);
    });
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      answersList.remove(answer);
    });
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
                title: "Voting",
                showHelpButton: true,
                onHelpButtonPressed: () {
                  showVotingHelp();
                },
                showBackButton: true,
                onBackButtonPressed: () async {
                  List<BOTWAnswer> removedVotedAnswers = [];
                  for (var answer in pastAnswers) {
                    if (!votedAnswers.contains(answer)) {
                      removedVotedAnswers.add(answer);
                    }
                  }
                  for (var answer in votedAnswers) {
                    if (answer.voters.contains(profileData.userId)) continue;
                    answer.votes += 1;
                    answer.voters
                        .add(auth.FirebaseAuth.instance.currentUser!.uid);
                    await Database().updateBOTWAnswer(answer);

                    // PushNotifications().sendNotification(
                    //     title:
                    //         "${profileData.displayName} voted for your ${blank.blank}",
                    //     body: "Click here to see how many votes it now has!",
                    //     targetIds: [answer.FCMToken],
                    //     data: {"type": "voted"});
                  }
                  for (var answer in removedVotedAnswers) {
                    answer.votes -= 1;
                    answer.voters.remove(profileData.userId);
                    await Database().updateBOTWAnswer(answer);
                  }
                  //update votes left
                  await FBDatabase(
                          uid: auth.FirebaseAuth.instance.currentUser!.uid)
                      .updateUserVotesLeft(votesLeft);
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Best ${blank.blank}",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text("Vote for the best three answers",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Votes left: $votesLeft",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 20)),
                  const SizedBox(height: 20),
                  buildCards(context),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: styling.theme == "christmas"
                                  ? styling.green
                                  : styling.primary.withOpacity(0.5),
                              spreadRadius: 7,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            )
                          ],
                        ),
                        child: IconButton(
                            onPressed: () async {
                              if (movedAnswers.isEmpty) return;
                              String hapticFeedback =
                                  await HelperFunctions.getHapticFeedbackSF();
                              if (hapticFeedback == "normal") {
                                HapticFeedback.mediumImpact();
                              } else if (hapticFeedback == "light") {
                                HapticFeedback.lightImpact();
                              } else if (hapticFeedback == "heavy") {
                                HapticFeedback.heavyImpact();
                              }
                              final provider = Provider.of<CardProvider>(
                                  context,
                                  listen: false);
                              provider.goBack(movedAnswers.last);
                              setState(() {
                                if (votedAnswers.contains(movedAnswers.last)) {
                                  votedAnswers.removeLast();
                                  votesLeft++;
                                }
                                if (skippedAnswers
                                    .contains(movedAnswers.last)) {
                                  skippedAnswers.remove(movedAnswers.last);
                                }
                                answers.add(movedAnswers.last);
                                movedAnswers.removeLast();
                              });
                            },
                            splashColor: styling.theme == "christmas"
                                ? styling.green
                                : styling.primary,
                            icon: const Icon(Icons.rotate_left,
                                color: Colors.white, size: 30)),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: styling.theme == "christmas"
                                  ? styling.green
                                  : styling.primary.withOpacity(0.5),
                              spreadRadius: 7,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            )
                          ],
                        ),
                        child: IconButton(
                            onPressed: () async {
                              String hapticFeedback =
                                  await HelperFunctions.getHapticFeedbackSF();
                              if (hapticFeedback == "normal") {
                                HapticFeedback.mediumImpact();
                              } else if (hapticFeedback == "light") {
                                HapticFeedback.lightImpact();
                              } else if (hapticFeedback == "heavy") {
                                HapticFeedback.heavyImpact();
                              }
                              if (votesLeft == 0) {
                                showOutOfVotes();
                                return;
                              }
                              if (answers.isEmpty) return;
                              final provider = Provider.of<CardProvider>(
                                  context,
                                  listen: false);
                              provider.like();
                            },
                            splashColor: styling.theme == "christmas"
                                ? styling.green
                                : styling.primary,
                            icon: const Icon(Icons.check,
                                color: Colors.white, size: 30)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Answers Voted For",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 20)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: votedAnswers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Material(
                              elevation: 10,
                              shadowColor:
                                  styling.getPurpleBlueGradient().colors[1],
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                  width: 300,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  decoration: ShapeDecoration(
                                    gradient: styling.getPurpleBlueGradient(),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(votedAnswers[index].answer,
                                        style: TextStyle(
                                            color: styling.theme ==
                                                    "colorful-light"
                                                ? styling.primaryDark
                                                : Colors.black,
                                            fontSize: 16)),
                                    subtitle: Text(
                                        votedAnswers[index].displayName,
                                        style: TextStyle(
                                            color: styling.theme ==
                                                    "colorful-light"
                                                ? styling.primaryDark
                                                : Colors.black,
                                            fontSize: 14)),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          String hapticFeedback =
                                              await HelperFunctions
                                                  .getHapticFeedbackSF();
                                          if (hapticFeedback == "normal") {
                                            HapticFeedback.mediumImpact();
                                          } else if (hapticFeedback ==
                                              "light") {
                                            HapticFeedback.lightImpact();
                                          } else if (hapticFeedback ==
                                              "heavy") {
                                            HapticFeedback.heavyImpact();
                                          }
                                          setState(() {
                                            //Add back to answers
                                            final provider =
                                                Provider.of<CardProvider>(
                                                    context,
                                                    listen: false);
                                            provider
                                                .goBack(votedAnswers[index]);
                                            answers.add(votedAnswers[index]);
                                            movedAnswers
                                                .remove(votedAnswers[index]);

                                            votedAnswers.removeAt(index);
                                            votesLeft++;
                                          });
                                        },
                                        splashColor:
                                            styling.theme == "christmas"
                                                ? styling.green
                                                : styling.primary,
                                        icon: Icon(Icons.delete,
                                            color: styling.theme ==
                                                    "colorful-light"
                                                ? styling.primary
                                                : Colors.white,
                                            size: 30)),
                                  ))),
                        );
                      },
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }

  void showOutOfVotes() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Out of votes"),
            content: const Text("You have no votes left"),
            actions: [
              TextButton(
                onPressed: () async {
                  String hapticFeedback =
                      await HelperFunctions.getHapticFeedbackSF();
                  if (hapticFeedback == "normal") {
                    HapticFeedback.mediumImpact();
                  } else if (hapticFeedback == "light") {
                    HapticFeedback.lightImpact();
                  } else if (hapticFeedback == "heavy") {
                    HapticFeedback.heavyImpact();
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  void showVotingHelp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Voting help"),
            content: const Text(
                "Swipe left to see more answers\nSwipe right to vote for answer or click checkmark\nClick the left arrow to undo your last action"),
            actions: [
              TextButton(
                onPressed: () async {
                  String hapticFeedback =
                      await HelperFunctions.getHapticFeedbackSF();
                  if (hapticFeedback == "normal") {
                    HapticFeedback.mediumImpact();
                  } else if (hapticFeedback == "light") {
                    HapticFeedback.lightImpact();
                  } else if (hapticFeedback == "heavy") {
                    HapticFeedback.heavyImpact();
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  Widget buildCards(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    // List<BOTWAnswer> answers = provider.answers;

    return provider.answers.isEmpty
        ? Column(
            children: [
              Text("No more answers",
                  style:
                      TextStyle(color: styling.backgroundText, fontSize: 20)),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    String hapticFeedback =
                        await HelperFunctions.getHapticFeedbackSF();
                    if (hapticFeedback == "normal") {
                      HapticFeedback.mediumImpact();
                    } else if (hapticFeedback == "light") {
                      HapticFeedback.lightImpact();
                    } else if (hapticFeedback == "heavy") {
                      HapticFeedback.heavyImpact();
                    }
                    setState(() {
                      print(skippedAnswers);
                      provider.setAnswers(skippedAnswers);
                      // for (var answer in skippedAnswers) {
                      //   provider.goBack(answer);
                      // }
                      answers = provider.answers;
                      print(provider.answers);
                      skippedAnswers = [];
                    });
                  },
                  style: styling.elevatedButtonDecoration(),
                  child: const Text("View skipped answers",
                      style: TextStyle(color: Colors.white)))
            ],
          )
        : provider.answers.isNotEmpty
            ? Stack(
                children: provider.answers.map((answer) {
                return BOTWVotingCard(
                    displayName: answer.displayName,
                    answer: answer.answer,
                    numberOfLines: mostLinesInAnswer,
                    isSecond: provider.answers.indexOf(answer) ==
                        provider.answers.length - 2,
                    isFront: provider.answers.last == answer);
              }).toList())
            : Container(
                child: Column(
                  children: [
                    Text("No more answers",
                        style: TextStyle(
                            color: styling.backgroundText, fontSize: 20)),
                  ],
                ),
              );
  }
}
