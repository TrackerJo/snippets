import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/templates/styling.dart';

import 'helper_functions.dart';

class TriviaOverviewTile extends StatefulWidget {
  final List<OptionData> options;

  final String correctAnswer;

  const TriviaOverviewTile(
      {super.key, required this.correctAnswer, required this.options});

  @override
  State<TriviaOverviewTile> createState() => _TriviaOverviewTileState();
}

class _TriviaOverviewTileState extends State<TriviaOverviewTile> {
  int totalOccurrences = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalOccurrences =
        widget.options.fold(0, (sum, item) => sum + item.occurrence);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: styling.getSnippetGradient().colors[0],
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: ShapeDecoration(
          gradient: styling.getSnippetGradient(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35,
                // width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 175,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Trivia Responses Overview",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: styling.theme == "colorful-light"
                                  ? styling.primaryDark
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if (!isCurrentUser)
                    //   Align(
                    //     alignment: Alignment.topRight,
                    //     child: IconButton(
                    //         onPressed: () {},
                    //         icon: const Icon(Icons.more_horiz, size: 20, color: Colors.black)),
                    //   )
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                color: styling.theme == "colorful-light"
                    ? styling.primaryDark
                    : Colors.black,
              ),
              if (totalOccurrences != 0)
                Column(
                  children: widget.options.map((option) {
                    double percentage =
                        (option.occurrence / totalOccurrences) * 100;
                    bool isCorrect = option.option == widget.correctAnswer;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.withOpacity(
                                      styling.theme == "chirstmas" ? 0.3 : 0.5)
                                  : const Color.fromRGBO(244, 67, 54, 1)
                                      .withOpacity(styling.theme == "chirstmas"
                                          ? 0.3
                                          : 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: percentage.toInt(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isCorrect
                                          ? Colors.green.withOpacity(
                                              styling.theme == "chirstmas"
                                                  ? 0.3
                                                  : 0.5)
                                          : const Color.fromRGBO(244, 67, 54, 1)
                                              .withOpacity(
                                                  styling.theme == "chirstmas"
                                                      ? 0.3
                                                      : 0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 100 - percentage.toInt(),
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(option.option),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${option.occurrence}'),
                                    ),
                                    // if (isCorrect)
                                    //   Icon(Icons.check, color: Colors.green)
                                    // else
                                    //   Icon(Icons.close, color: Colors.red),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
