
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/message_tile.dart';
import 'package:snippets/widgets/response_tile.dart';

import '../api/database.dart';

class DiscussionPage extends StatefulWidget {
  final ResponseTile responseTile;
  final String theme;

  const DiscussionPage(
      {super.key, required this.responseTile, required this.theme});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  ResponseTile displayTile = const ResponseTile(
    displayName: "",
    snippetId: "",
    response: "",
    userId: "",
    question: "",
    theme: "",
    discussionUsers: [],
  );

  final ScrollController _scrollController = ScrollController();
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String displayName = "";
  String email = "";
  String username = "";

  void getDiscussion() async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    print(userData);
    if (mounted) {
      setState(() {
        displayName = userData['fullname'];
        email = userData['email'];
        username = userData['username'];
      });
    }
    var discussion = await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDiscussion(
            widget.responseTile.snippetId, widget.responseTile.userId);
    if (mounted) {
      setState(() {
        chats = discussion;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDiscussion();
    setState(() {
      displayTile = ResponseTile(
        displayName: widget.responseTile.displayName,
        snippetId: widget.responseTile.snippetId,
        response: widget.responseTile.response,
        userId: widget.responseTile.userId,
        isDisplayOnly: true,
        question: widget.responseTile.question,
        theme: widget.responseTile.theme,
        discussionUsers: widget.responseTile.discussionUsers,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "Discussion",
            showBackButton: true,
            theme: widget.theme,
            onBackButtonPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
            
        backgroundColor: ColorSys.background,
        body: Stack(
          children: [
            const BackgroundTile(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.theme == "sunset"
                                ? ColorSys.sunsetGradient.colors[1]
                                : widget.theme == "sunrise"
                                    ? ColorSys.sunriseGradient.colors[0]
                                    : widget.theme == "blue"
                                        ? ColorSys.blueGreenGradient.colors[0]
                                        : ColorSys.purpleBlueGradient.colors[0],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayTile.displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                ),
                                child: Text(
                                  "Q: ${displayTile.question}",
                                
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "A: ${displayTile.response}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                Expanded(child: chatMessages()),
                Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.theme == "sunset"
                ? ColorSys.sunsetGradient.colors[1]
                : widget.theme == "sunrise"
                    ? ColorSys.sunriseBarGradient.colors[0]
                    : widget.theme == "blue"
                        ? ColorSys.blueGreenGradient.colors[0]
                        : ColorSys.purpleBlueGradient.colors[0],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  onTap: () {
                    HapticFeedback.selectionClick();
                  },
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    //  Rounded Top corners
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  sendMessage();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: widget.theme == "sunset"
                        ? ColorSys.sunsetBarGradient.colors[1]
                        : widget.theme == "sunrise"
                            ? ColorSys.sunriseBarGradient.colors[1]
                            : widget.theme == "blue"
                                ? ColorSys.blueGreenGradient.colors[0]
                                : ColorSys.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
                //Chat Messages
              ],
            ),
          ],
        ),
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data.docs.length,
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  itemBuilder: (context, index) {
                    print(snapshot
                            .data.docs[snapshot.data.docs.length - index - 1]
                        ['message']);

                    if (snapshot.data
                                    .docs[snapshot.data.docs.length - index - 1]
                                ['senderUsername'] !=
                            username &&
                        index == 0) {
                      if (!snapshot.data
                          .docs[snapshot.data.docs.length - index - 1]['readBy']
                          .contains(FirebaseAuth.instance.currentUser!.uid)) {
                        snapshot
                            .data
                            .docs[snapshot.data.docs.length - index - 1]
                                ['readBy']
                            .add(FirebaseAuth.instance.currentUser!.uid);
                        Database(uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateReadBy(
                                widget.responseTile.snippetId,
                                widget.responseTile.userId,
                                snapshot
                                    .data
                                    .docs[snapshot.data.docs.length - index - 1]
                                    .id);
                      }
                    }

                    return MessageTile(
                        message: snapshot.data
                                .docs[snapshot.data.docs.length - index - 1]
                            ['message'],
                        sender: snapshot.data
                                .docs[snapshot.data.docs.length - index - 1]
                            ['senderDisplayName'],
                        sentByMe: username ==
                            snapshot.data
                                    .docs[snapshot.data.docs.length - index - 1]
                                ['senderUsername'],
                        theme: widget.theme,
                        time: snapshot.data
                            .docs[snapshot.data.docs.length - index - 1]['date']
                            .toDate());
                  })
              : Container();
        });
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "senderUsername": username,
        "senderId": FirebaseAuth.instance.currentUser!.uid,
        "senderDisplayName": displayName,
        "date": DateTime.now(),
        "readBy": [FirebaseAuth.instance.currentUser!.uid]
      };

      print(displayTile.discussionUsers);
      Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
      Map<String, dynamic> userMap = {
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "FCMToken": userData['FCMToken'],
      };
      print(userMap);
      List<dynamic> users = displayTile.discussionUsers;
      if (!isUserInDiscussion()) {
        print("Adding user to discussion");
        users.add(userMap);

        await Database(uid: FirebaseAuth.instance.currentUser!.uid)
            .updateDiscussionUsers(widget.responseTile.snippetId,
                widget.responseTile.userId, userMap);
        await Database(uid: FirebaseAuth.instance.currentUser!.uid)
            .addUserToDiscussion(
                FirebaseAuth.instance.currentUser!.uid,
                widget.responseTile.snippetId,
                widget.responseTile.userId,
                widget.responseTile.question,
                widget.theme);
      }

      await Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .sendDiscussionMessage(widget.responseTile.snippetId,
              widget.responseTile.userId, chatMessageMap);
      // var url = Uri.https('us-central1-snippets2024.cloudfunctions.net',
      //     '/sendDiscussionNotification');
      var snippetId = widget.responseTile.snippetId;
      var responseId = widget.responseTile.userId;
      var snippetQuestion = widget.responseTile.question;
      var responseName = widget.responseTile.displayName;
      var senderName = displayName;
      var message = messageController.text;
      print(users);
      var targetIds = getDiscussionUsersFCMToken(users);
      print(targetIds);
      setState(() {
        messageController.clear();
      });
      await PushNotifications().sendNotification(
          title: "$responseName - $snippetQuestion",
          body: "$senderName: $message",
          targetIds: targetIds,
          data: {
            "snippetId": snippetId,
            "responseId": responseId,
            "snippetQuestion": snippetQuestion,
            "responseName": responseName,
            "senderName": senderName,
            "message": message,
            "response": widget.responseTile.response,
            "theme": widget.theme,
            "discussionUsers": users,
            "type": "discussion"
          });

      
      //Scroll to the bottom of the list
      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  bool isUserInDiscussion() {
    bool isUserInDiscussion = false;
    print(displayTile.discussionUsers);
    for (Map<String, dynamic> element in displayTile.discussionUsers) {
      if (element['userId'] as String ==
          FirebaseAuth.instance.currentUser!.uid) {
        isUserInDiscussion = true;
      }
    }
    return isUserInDiscussion;
  }

  List<String> getDiscussionUsersFCMToken(List<dynamic> users) {
    List<String> FCMToken = [];
    for (var element in users) {
      if (element['userId'] != FirebaseAuth.instance.currentUser!.uid) {
        FCMToken.add(element['FCMToken']);
      }
    }
    return FCMToken;
  }
}
