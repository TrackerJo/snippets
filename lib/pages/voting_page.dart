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
  List<BOTWAnswer> pastAnswers = [];

  List<BOTWAnswer> getAnswers(
      Map<String, BOTWAnswer> answers, User profileData) {
    List<BOTWAnswer> listAnswers = [];

    answers.forEach((key, value) {
      if (key == profileData.userId) return;

      listAnswers.add(value);
    });
    //randomize the list
    listAnswers.shuffle();
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
        .getCurrentUserData();

    setState(() {
      profileData = data;
      votesLeft = data.votesLeft;
      votedAnswers = getVotedBOTW(nblank.answers, data);
      answers = getAnswers(nblank.answers, data);

      pastAnswers = [...votedAnswers];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
                showVotesButton: true,
                fixLeft: true,
                onVotesButtonPressed: () async {
                  String hapticFeedback =
                      await HelperFunctions.getHapticFeedbackSF();
                  if (hapticFeedback == "normal") {
                    HapticFeedback.mediumImpact();
                  } else if (hapticFeedback == "light") {
                    HapticFeedback.lightImpact();
                  } else if (hapticFeedback == "heavy") {
                    HapticFeedback.heavyImpact();
                  }
                  viewVotedSheet();
                },
                onHelpButtonPressed: () async {
                  String hapticFeedback =
                      await HelperFunctions.getHapticFeedbackSF();
                  if (hapticFeedback == "normal") {
                    HapticFeedback.mediumImpact();
                  } else if (hapticFeedback == "light") {
                    HapticFeedback.lightImpact();
                  } else if (hapticFeedback == "heavy") {
                    HapticFeedback.heavyImpact();
                  }
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
                  Expanded(
                    child: buildCards(context),
                  ),
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

  void viewVotedSheet() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                child: Stack(
                  children: [
                    BackgroundTile(
                      rounded: true,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(children: [
                          Text(
                            "Voted for",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 40),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: votedAnswers.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BOTWVotingCard(
                                    answer: votedAnswers[index],
                                    votedFor: true,
                                    onVote: (didVote) {
                                      setState(() {
                                        if (didVote) {
                                          votesLeft -= 1;
                                          votedAnswers.add(votedAnswers[index]);
                                        } else {
                                          votesLeft += 1;
                                          votedAnswers
                                              .remove(votedAnswers[index]);
                                        }
                                      });
                                      this.setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ])),
                  ],
                ));
          });
        });
  }

  void showVotingHelp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Voting help"),
            content: const Text(
                "Vote for the best three answers. You have three votes. To vote click on the heart or just the tile. Answers you have voted for will have a filled heart. You can also view answers voted for by clicking on the icon next to the help button."),
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
    // List<BOTWAnswer> answers = provider.answers;

    return answers.isEmpty
        ? Column(
            children: [
              Text("No answers",
                  style:
                      TextStyle(color: styling.backgroundText, fontSize: 20)),
            ],
          )
        : answers.isNotEmpty
            ? ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BOTWVotingCard(
                      answer: answers[index],
                      votedFor: votedAnswers.contains(answers[index]),
                      onVote: (didVote) async {
                        String hapticFeedback =
                            await HelperFunctions.getHapticFeedbackSF();
                        if (hapticFeedback == "normal") {
                          HapticFeedback.mediumImpact();
                        } else if (hapticFeedback == "light") {
                          HapticFeedback.lightImpact();
                        } else if (hapticFeedback == "heavy") {
                          HapticFeedback.heavyImpact();
                        }
                        if (votesLeft == 0 && didVote) {
                          showOutOfVotes();
                          return;
                        }
                        setState(() {
                          if (didVote) {
                            votesLeft -= 1;
                            votedAnswers.add(answers[index]);
                          } else {
                            votesLeft += 1;
                            votedAnswers.remove(answers[index]);
                          }
                        });
                      },
                    ),
                  );
                },
              )
            : Container(
                child: Column(
                  children: [
                    Text("No answers",
                        style: TextStyle(
                            color: styling.backgroundText, fontSize: 20)),
                  ],
                ),
              );
  }
}
