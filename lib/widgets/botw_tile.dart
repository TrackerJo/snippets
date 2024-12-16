import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

class BOTWTile extends StatefulWidget {
  // final bool isAnswered;

  final String blank;
  final BOTWAnswer answer;
  final bool isCurrentUser;
  final BOTWStatusType status;

  const BOTWTile({
    super.key,
    required this.blank,
    required this.isCurrentUser,
    required this.answer,
    required this.status,
  });

  @override
  State<BOTWTile> createState() => _BOTWTileState();
}

class _BOTWTileState extends State<BOTWTile> {
  TextEditingController answerController = TextEditingController();
  bool isEditting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<String> removeEmptyStrings(List<String> list) {
    List<String> newList = [];
    list.forEach((element) {
      if (element != "") {
        newList.add(element);
      }
    });
    return newList;
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
          onTap: () => {},
          title: Text(
            widget.blank,
            style: TextStyle(
              color: styling.theme == "colorful-light"
                  ? styling.primaryDark
                  : Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 0,
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: widget.status == BOTWStatusType.answering &&
                  widget.isCurrentUser &&
                  (widget.answer.answer == "" || isEditting)
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          onTap: () async {
                            String hapticFeedback =
                                await HelperFunctions.getHapticFeedbackSF();
                            if (hapticFeedback == "normal") {
                              HapticFeedback.selectionClick();
                            } else if (hapticFeedback == "light") {
                              HapticFeedback.selectionClick();
                            } else if (hapticFeedback == "heavy") {
                              HapticFeedback.mediumImpact();
                            }
                          },
                          controller: answerController,
                          maxLines: 2,
                          decoration: styling.textInputDecoration().copyWith(
                              hintText: "Enter submission here",
                              fillColor: styling.theme == "christmas"
                                  ? styling.red
                                  : styling.primaryInput
                              //Border color: color: ColorSys.primarySolid,

                              //   borderSide: BorderSide(
                              //     color: ColorSys.primarySolid,
                              //     width: 20,
                              //   ),
                              // ),
                              )),
                    ),
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
                          isEditting = false;
                        });
                        widget.answer.answer = answerController.text.trim();
                        await Database().updateUsersBOTWAnswer(widget.answer);
                      },
                      style: styling.elevatedButtonDecorationPurple(),
                      child: Text(isEditting ? "Save" : "Submit",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black)),
                    ),
                  ],
                )
              : Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 100,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.answer.answer,
                                style: TextStyle(
                                    color: styling.theme == "colorful-light"
                                        ? styling.primaryDark
                                        : Colors.black,
                                    fontSize: 16))),
                      ),
                    ),
                    if (widget.status == BOTWStatusType.answering &&
                        widget.isCurrentUser)
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
                              isEditting = true;
                              answerController.text = widget.answer.answer;
                            });
                          },
                          style: styling.elevatedButtonDecorationPurple(),
                          child: const Text("Edit",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16))),
                    if (widget.status == BOTWStatusType.voting &&
                        widget.isCurrentUser)
                      Text(
                          "Votes: ${removeEmptyStrings(widget.answer.voters).length}",
                          style: TextStyle(
                              color: styling.theme == "colorful-light"
                                  ? styling.primaryDark
                                  : Colors.black,
                              fontSize: 16))
                  ],
                ),
        ),
      ),
    );
  }
}
