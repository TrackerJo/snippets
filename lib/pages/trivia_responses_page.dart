import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

import 'package:snippets/widgets/response_tile.dart';
import 'package:snippets/widgets/trivia_overview_tile.dart';

class TriviaResponsesPage extends StatefulWidget {
  final String snippetId;
  final String userResponse;
  final String question;
  final List<String> userDiscussionUsers;
  const TriviaResponsesPage({
    super.key,
    required this.snippetId,
    this.userResponse = "~~~",
    this.userDiscussionUsers = const ["SSSS"],
    required this.question,
  });

  @override
  State<TriviaResponsesPage> createState() => _TriviaResponsesPageState();
}

class _TriviaResponsesPageState extends State<TriviaResponsesPage> {
  String userDisplayName = "";
  String userResponse = "";
  List<dynamic> discussionUsers = [];
  StreamController responsesStream = StreamController();
  List<String> bestFriends = [];
  List<OptionData> options = [];
  List<OptionData> baseOptions = [];
  String correctAnswer = "";
  List<String> toStringList(List<UserMini> oldList) {
    List<String> newList = [];
    for (var item in oldList) {
      newList.add(item.userId);
    }
    return newList;
  }

  bool compareLists(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (var item in list1) {
      if (!list2.contains(item)) {
        return false;
      }
    }
    return true;
  }

  void getResponsesList() async {
    await HelperFunctions.saveOpenedPageSF("responses-${widget.snippetId}");
    List<Snippet> snippets = await Database().getSnippetsList();
    bool snippetExists = snippets.any((e) => e.snippetId == widget.snippetId);
    if (!snippetExists) {
      router.pushReplacement("/");
    }
    List<OptionData> options = [];
    Snippet currentSnippet =
        snippets.firstWhere((e) => e.snippetId == widget.snippetId);
    for (var option in currentSnippet.options) {
      options.add(OptionData(option: option, occurrence: 0));
    }
    if (!mounted) return;
    setState(() {
      if (!mounted) return;
      baseOptions = options;
      correctAnswer = currentSnippet.correctAnswer;
    });

    List<String> newFriends = [];
    List<String> removedFriends = [];
    List<String> friends = [];
    User userData = await Database().getCurrentUserData();
    setState(() {
      bestFriends = userData.bestFriends;
    });
    friends = toStringList(userData.friends);
    friends.add(auth.FirebaseAuth.instance.currentUser!.uid);
    List<String> responsesIDs =
        await LocalDatabase().getCachedResponsesIDs(widget.snippetId);

    if (!compareLists(friends, responsesIDs)) {
      for (var item in friends) {
        if (!responsesIDs.contains(item)) {
          newFriends.add(item);
        }
      }
      for (var item in responsesIDs) {
        if (!friends.contains(item)) {
          removedFriends.add(item);
        }
      }
      for (var friend in removedFriends) {
        LocalDatabase().removeResponse(widget.snippetId, friend);
      }
    }

    friends.remove(auth.FirebaseAuth.instance.currentUser!.uid);
    StreamController<List<SnippetResponse>> responsesList = StreamController();
    await Database().getSnippetResponses(responsesList, widget.snippetId, false,
        newFriends.isNotEmpty, newFriends, friends);

    responsesList.stream.listen((event) {
      if (responsesStream.isClosed) return;

      //Check for duplicates
      List<SnippetResponse> newResponses = [];
      List<String> responseIDs = [];
      for (var response in event) {
        if (!responseIDs.contains(response.userId)) {
          responseIDs.add(response.userId);
          newResponses.add(response);
        } else {
          LocalDatabase().removeResponse(widget.snippetId, response.userId);
        }
      }

      newResponses.sort((a, b) {
        bool ABestFriend =
            userData.bestFriends.any((friend) => friend == a.userId);
        bool BBestFriend =
            userData.bestFriends.any((friend) => friend == b.userId);
        if (ABestFriend == BBestFriend) {
          return 0;
        } else if (ABestFriend && !BBestFriend) {
          return -1;
        } else if (!ABestFriend && BBestFriend) {
          return 1;
        } else {
          return 0;
        }
      });
      List<OptionData> options = [...baseOptions];
      for (var res in newResponses) {
        //update occurance in options
        options.firstWhere((e) => e.option == res.answer).occurrence += 1;
      }
      options.firstWhere((e) => e.option == userResponse).occurrence += 1;
      setState(() {
        this.options = options;
      });

      responsesStream.add(newResponses);
    });
  }

  void getUserDisplayName() async {
    User userData = await Database().getCurrentUserData();
    if (mounted) {
      setState(() {
        userDisplayName = userData.displayName;
      });
    }
    if (widget.userResponse != "~~~") {
      setState(() {
        userResponse = widget.userResponse;
        discussionUsers = widget.userDiscussionUsers;
      });
    } else {
      SnippetResponse response = (await Database().getSnippetResponse(
          widget.snippetId, auth.FirebaseAuth.instance.currentUser!.uid));
      if (mounted) {
        setState(() {
          userResponse = response.answer;
          discussionUsers = response.discussionUsers;
        });
      }
    }
  }

  List<String> dynmicListToStringList(List<dynamic> oldList) {
    List<String> newList = [];
    for (var item in oldList) {
      newList.add(item.toString());
    }
    return newList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResponsesList();
    getUserDisplayName();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    responsesStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: "Responses",
              theme: "purple",
              showBackButton: true,
              onBackButtonPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    responsesList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  responsesList() {
    return StreamBuilder(
      stream: responsesStream.stream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (snapshot.hasData) {
          if (snapshot.data!.length != null) {
            if (snapshot.data.length + 2 != 0) {
              return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      itemCount: snapshot.data.length + 2,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TriviaOverviewTile(
                                  correctAnswer: correctAnswer,
                                  options: options));
                        }
                        if (index == 1) {
                          // return the header
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ResponseTile(
                              question: widget.question,
                              response: userResponse,
                              displayName: userDisplayName,
                              snippetId: widget.snippetId,
                              userId:
                                  auth.FirebaseAuth.instance.currentUser!.uid,
                              isDisplayOnly: false,
                              theme: "blue",
                              isTrivia: true,
                              isCorrect: userResponse == correctAnswer,
                              isAnonymous: false,
                            ),
                          );
                        }
                        index -= 2;

                        SnippetResponse response = snapshot.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ResponseTile(
                              question: widget.question,
                              response: response.answer,
                              displayName: response.displayName,
                              snippetId: widget.snippetId,
                              theme: "blue",
                              userId: response.userId,
                              isAnonymous: false,
                              isTrivia: true,
                              isCorrect: response.answer == correctAnswer,
                              isBestFriend:
                                  bestFriends.contains(response.userId)),
                        );
                      }));
            } else {
              return const Center(
                child: Text("No responses yet"),
              );
            }
          } else {
            return const Center(
              child: Text("No responses yet"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color:
                styling.theme == "christmas" ? styling.green : styling.primary,
          ));
        }
      },
    );
  }
}