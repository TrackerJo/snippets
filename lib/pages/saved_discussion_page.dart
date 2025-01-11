import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/message_tile.dart';
import 'package:snippets/widgets/response_tile.dart';

import '../api/fb_database.dart';

class SavedDiscussionPage extends StatefulWidget {
  final SavedResponse savedResponse;

  const SavedDiscussionPage({super.key, required this.savedResponse});

  @override
  State<SavedDiscussionPage> createState() => _SavedDiscussionPageState();
}

class _SavedDiscussionPageState extends State<SavedDiscussionPage> {
  bool showResponseTile = true;

  final ScrollController _scrollController = ScrollController();

  List<SavedMessage> messages = [];
  //Generate messageId of 9 random digits

  void getDiscussion() async {
    bool showDisplayTile = await HelperFunctions.getShowDisplayTileSF();
    if (!showDisplayTile) {
      setState(() {
        showResponseTile = false;
      });
    }

    await HelperFunctions.saveOpenedPageSF(
        "saved-discussion-${widget.savedResponse.responseId}");
    List<SavedMessage> savedMessages =
        await Database().getSavedMessages(widget.savedResponse.responseId);
    if (mounted) {
      setState(() {
        messages = savedMessages;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDiscussion();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          BackgroundTile(),
          Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(
                title: "Discussion",
                showBackButton: true,
                theme: "purple",
                onBackButtonPressed: () {
                  Navigator.pop(context, true);
                },
                showPreviewButton: true,
                onPreviewButtonPressed: () async {
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
                    showResponseTile = !showResponseTile;
                  });
                },
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showResponseTile)
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: styling.theme == "colorful-light"
                                      ? Colors.white
                                      : styling.theme == "christmas"
                                          ? styling.green
                                          : styling.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 300,
                                      ),
                                      child: Text(
                                        "Q: ${widget.savedResponse.question}",
                                        style: TextStyle(
                                          color:
                                              styling.theme == "colorful-light"
                                                  ? styling.secondaryDark
                                                  : Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 300,
                                      ),
                                      child: Text(
                                        "A: ${widget.savedResponse.answer}",
                                        style: TextStyle(
                                          color:
                                              styling.theme == "colorful-light"
                                                  ? styling.secondaryDark
                                                  : Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                      ],
                    ),
                    Expanded(child: chatMessages()),

                    //Chat Messages
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  chatMessages() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        scrollDirection: Axis.vertical,
        reverse: true,
        itemBuilder: (context, index) {
          SavedMessage message = messages[messages.length - index - 1];
          DateTime date = message.date;

          return MessageTile(
              message: message.message,
              sender: message.senderDisplayName,
              sentByMe: auth.FirebaseAuth.instance.currentUser!.uid ==
                  message.senderId,
              senderId: message.senderId,
              time: date);
        });
  }
}
