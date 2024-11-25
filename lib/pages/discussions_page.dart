import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:snippets/api/fb_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';

import 'package:snippets/widgets/discussion_tile.dart';

class DiscussionsPage extends StatefulWidget {
  final int index;
  const DiscussionsPage({super.key, required this.index});

  @override
  State<DiscussionsPage> createState() => _DiscussionsPageState();
}

class _DiscussionsPageState extends State<DiscussionsPage> {
  List<DiscussionFull> discussions = [];
  List<DiscussionFull> oldDiscussions = [];
  StreamSubscription? discSub;
  bool isLoading = false;
  String anonymousId = "";

  void getDiscussions() async {
    if (!mounted) return;

    String? anonId = await HelperFunctions.getAnonymousIDFromSF();
    if (anonId != null) {
      anonymousId = anonId;
    }
    StreamController<DiscussionFull> discStream = StreamController();

    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDiscussions(FirebaseAuth.instance.currentUser!.uid, discStream);
    if (!mounted) return;
    setState(() {
      discussions = [];
    });
    discSub = discStream.stream.listen((discussionsMap) {
      if (mounted) {
        setState(() {
          // discussions.add(discussionsMap);
          if (discussions.any((element) =>
              element.snippetId == discussionsMap.snippetId &&
              element.answerId == discussionsMap.answerId)) {
            //Get one that exists
            var existing = discussions.firstWhere((element) =>
                element.snippetId == discussionsMap.snippetId &&
                element.answerId == discussionsMap.answerId);

            discussionsMap.snippetQuestion = existing.snippetQuestion;
            discussionsMap.isAnonymous = existing.isAnonymous;
            discussions.removeWhere((element) =>
                element.snippetId == discussionsMap.snippetId &&
                element.answerId == discussionsMap.answerId);

            // discussions.add(existing);
          }

          discussions.add(discussionsMap);
          //Sort by last message
          discussions.sort((a, b) {
            var aTime = a.lastMessage.date;
            var bTime = b.lastMessage.date;
            //Chech type of aTime and bTime

            if (a.lastMessage.message == "No messages" &&
                b.lastMessage.message == "No messages") {
              //Rank b higher
              return 0;
            } else if (b.lastMessage.message == "No messages") {
              //Rank a higher
              return -1;
            } else if (a.lastMessage.message == "No messages") {
              //Rank b higher
              return 1;
            }

            return bTime.compareTo(aTime);
          });
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDiscussions();
  }

  @override
  void didUpdateWidget(covariant DiscussionsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) {
      discSub?.cancel();
      return;
    }
    if (widget.index != 2) {
      discSub?.cancel();
      // discussions = [];
      // setState(() {});
      return;
    }

    setState(() {
      isLoading = true;
      oldDiscussions = discussions;
      discussions = [];
    });
    getDiscussions();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    discSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoading
          ? ListView(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      if (oldDiscussions == [] || oldDiscussions.isEmpty)
                        const Text("No discussions yet",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      if (oldDiscussions == [] || oldDiscussions.isEmpty)
                        const SizedBox(height: 20),
                      if (oldDiscussions == [] || oldDiscussions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "Join a discussion by sending a message in a discussion",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                for (var discussion in oldDiscussions)
                  DiscussionTile(
                    snippetId: discussion.snippetId,
                    discussionId: discussion.answerId,
                    question: discussion.snippetQuestion,
                    answerUser: discussion.answerDisplayName,
                    lastMessageSender: discussion.lastMessage.senderDisplayName,
                    lastMessage: discussion.lastMessage.message,
                    hasBeenRead: discussion.lastMessage.readBy.contains(
                        discussion.isAnonymous
                            ? anonymousId
                            : FirebaseAuth.instance.currentUser!.uid),
                    theme: "blue",
                    answerResponse: discussion.answer,
                    isAnonymous: discussion.isAnonymous,
                  )
              ],
            )
          : ListView(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      if (discussions == [] || discussions.isEmpty)
                        const Text("No discussions yet",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      if (discussions == [] || discussions.isEmpty)
                        const SizedBox(height: 20),
                      if (discussions == [] || discussions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "Join a discussion by sending a message in a discussion",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                for (var discussion in discussions)
                  DiscussionTile(
                    snippetId: discussion.snippetId,
                    discussionId: discussion.answerId,
                    question: discussion.snippetQuestion,
                    answerUser: discussion.answerDisplayName,
                    lastMessageSender: discussion.lastMessage.senderDisplayName,
                    lastMessage: discussion.lastMessage.message,
                    hasBeenRead: discussion.lastMessage.readBy.contains(
                        discussion.isAnonymous
                            ? anonymousId
                            : FirebaseAuth.instance.currentUser!.uid),
                    theme: "blue",
                    answerResponse: discussion.answer,
                    isAnonymous: discussion.isAnonymous,
                  )
              ],
            ),
    );
  }
}
