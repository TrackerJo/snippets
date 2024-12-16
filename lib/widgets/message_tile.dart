import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/widgets/helper_functions.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final DateTime time;
  final String theme;
  final String senderId;

  const MessageTile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.time,
      required this.theme,
      required this.senderId});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String timeSent = "";

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sender.toUpperCase(),
                textAlign: TextAlign.center,
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
                    child: Text(
                      widget.message,
                      softWrap: true,
                      textAlign:
                          widget.sentByMe ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
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
        ),
      ),
    );
  }
}
