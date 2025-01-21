import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/widgets/helper_functions.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final DateTime time;
  final String messageId;
  final String senderId;
  final String snippetId;
  final String discussionId;
  final List<String> reportIds;
  final int reports;
  final bool canReport;

  const MessageTile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.time,
      required this.senderId,
      required this.snippetId,
      required this.reportIds,
      required this.messageId,
      required this.discussionId,
      required this.canReport,
      required this.reports});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String timeSent = "";
  bool isCensored = false;

  setTimeSet() {
    setState(() {
      timeSent = DateFormat.jm().format(widget.time);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTimeSet();
    setState(() {
      isCensored = widget.reports >= 3;
      if (widget.reports >= 3) {
        HelperFunctions.getSeenCensoredMessageSF().then((value) {
          if (!value) {
            showCensoreDialog(context);
          }
        });
      }
    });
  }

  void showCensoreDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Censored Text"),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Responses that have been censored due to violoting our community guidelines have a black box covering them. They can be viewed by tapping on the black box.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await HelperFunctions.saveSeenCensoredMessageSF(true);
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  void reportMessage() {
    bool selectingReason = true;
    bool selectedOther = false;
    String reason = "";
    String additionalInfo = "";
    bool isSubmitting = false;
    print("REPORT IDS: ${widget.reportIds}");
    if (widget.reportIds.contains(FirebaseAuth.instance.currentUser!.uid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: const Text("You have already reported this message",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: styling.primary,
              title: const Text("Report Message",
                  style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      "Please select a reason for reporting this message",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reason = "Inappropriate Content";
                          });
                        },
                        child: ListTile(
                          title: const Text("Inappropriate Content",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: "Inappropriate Content",
                            groupValue: reason,
                            fillColor: WidgetStateProperty.all(Colors.white),
                            onChanged: (String? value) {
                              setState(() {
                                reason = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reason = "Bullying";
                          });
                        },
                        child: ListTile(
                          title: const Text("Bullying",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: "Bullying",
                            groupValue: reason,
                            fillColor: WidgetStateProperty.all(Colors.white),
                            onChanged: (String? value) {
                              setState(() {
                                reason = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reason = "Violence, hate or exploitation";
                          });
                        },
                        child: ListTile(
                          title: const Text("Violence, hate or exploitation",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: "Violence, hate or exploitation",
                            groupValue: reason,
                            fillColor: WidgetStateProperty.all(Colors.white),
                            onChanged: (String? value) {
                              setState(() {
                                reason = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reason = "Other";
                          });
                        },
                        child: ListTile(
                          title: const Text("Other",
                              style: TextStyle(color: Colors.white)),
                          leading: Radio(
                            value: "Other",
                            groupValue: reason,
                            fillColor: WidgetStateProperty.all(Colors.white),
                            onChanged: (String? value) {
                              setState(() {
                                reason = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      if (reason == "Other")
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (String value) {
                                additionalInfo = value;
                              },
                              decoration: InputDecoration(
                                hintText:
                                    "Please provide additional information",
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white)),
                ),
                if (isSubmitting)
                  CircularProgressIndicator(
                    color: styling.secondary,
                  )
                else
                  ElevatedButton(
                      onPressed: () async {
                        if (reason == "") {
                          //show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select a reason",
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (reason == "Other" && additionalInfo == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please provide additional information",
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        setState(() {
                          isSubmitting = true;
                        });
                        MessageReport report = MessageReport(
                            message: widget.message,
                            messageId: widget.messageId,
                            reportedUserId: widget.senderId,
                            responseId: widget.discussionId,
                            snippetId: widget.snippetId,
                            reportId: "",
                            date: DateTime.now(),
                            reason: reason,
                            additionalInfo: additionalInfo);
                        await Database().reportMessage(report);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Message Reported",
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ),
                        );
                        setState(() {
                          isSubmitting = false;
                        });
                        Navigator.of(context).pop();
                      },
                      style: styling.elevatedButtonDecorationBlue(),
                      child: const Text("Report",
                          style: TextStyle(color: Colors.white))),
              ],
            );
          });
        });
  }

  void _toggleCensorship() {
    if (widget.reports < 3) return;
    setState(() {
      isCensored = !isCensored;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.sentByMe) return;
        String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
        if (hapticFeedback == "normal") {
          HapticFeedback.mediumImpact();
        } else if (hapticFeedback == "light") {
          HapticFeedback.lightImpact();
        } else if (hapticFeedback == "heavy") {
          HapticFeedback.heavyImpact();
        }
        nextScreen(
          context,
          ProfilePage(
            uid: widget.senderId,
            showNavBar: false,
            showBackButton: true,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 16,
          right: widget.sentByMe ? 16 : 0,
        ),
        alignment:
            widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: widget.sentByMe
              ? const EdgeInsets.only(left: 30)
              : const EdgeInsets.only(right: 30),
          padding:
              const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: widget.sentByMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
              color: styling.theme == "colorful-light"
                  ? Colors.white
                  : widget.sentByMe
                      ? styling.theme == "christmas"
                          ? styling.green
                          : styling.primary
                      : styling.theme == "christmas"
                          ? Colors.white
                          : styling.secondary),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5),
                        child: Text(
                          widget.sender.toUpperCase(),
                          textAlign: widget.sentByMe
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: styling.theme == "colorful-light"
                                  ? widget.sentByMe
                                      ? styling.primaryDark
                                      : styling.secondaryDark
                                  : styling.theme == "christmas"
                                      ? widget.sentByMe
                                          ? Colors.white
                                          : styling.red
                                      : Colors.white,
                              letterSpacing: -0.5),
                        ),
                      ),
                      if (!widget.sentByMe && widget.canReport)
                        const SizedBox(
                          width: 30,
                        )

                      //
                      //   IconButton(
                      //       iconSize: 10,
                      //       onPressed: () {
                      //         reportMessage();
                      //       },
                      //       icon: const Icon(Icons.flag_outlined,
                      //           color: Colors.black, size: 20)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // widget.sentByMe
                      //     ? Container()
                      //     : Text(
                      //         "$timeSent ",
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      // SizedBox(width: widget.sentByMe ? 0 : 10),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: _toggleCensorship,
                                  child: Stack(
                                    children: [
                                      Text(
                                        widget.message,
                                        softWrap: true,
                                        textAlign: widget.sentByMe
                                            ? TextAlign.right
                                            : TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              styling.theme == "colorful-light"
                                                  ? widget.sentByMe
                                                      ? styling.primaryDark
                                                      : styling.secondaryDark
                                                  : styling.theme == "christmas"
                                                      ? widget.sentByMe
                                                          ? Colors.white
                                                          : styling.red
                                                      : Colors.white,
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        opacity: isCensored ? 1.0 : 0.0,
                                        duration: Duration(milliseconds: 500),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            widget.message,
                                            softWrap: true,
                                            textAlign: widget.sentByMe
                                                ? TextAlign.right
                                                : TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // if (!isCensored)
                              //   TextSpan(
                              //     text: widget.response,
                              //     style: TextStyle(
                              //       fontSize: 15,
                              //       color: styling.theme == "colorful-light"
                              //           ? styling.primaryDark
                              //           : Colors.black,
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Text(
                        "${DateFormat.jm().format(widget.time)} ",
                        style: TextStyle(
                          fontSize: 12,
                          color: styling.theme == "colorful-light"
                              ? widget.sentByMe
                                  ? styling.primaryDark
                                  : styling.secondaryDark
                              : styling.theme == "christmas"
                                  ? widget.sentByMe
                                      ? Colors.white
                                      : styling.red
                                  : Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              if (!widget.sentByMe && widget.canReport)
                Positioned(
                  right: -15,
                  top: -15,
                  child: IconButton(
                      iconSize: 10,
                      onPressed: () {
                        reportMessage();
                      },
                      icon: const Icon(Icons.flag_outlined,
                          color: Colors.black, size: 20)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
