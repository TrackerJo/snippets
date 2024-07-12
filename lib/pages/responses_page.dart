import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/discussion_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/response_tile.dart';

class ResponsesPage extends StatefulWidget {
  final String snippetId;
  final String userResponse;
  final String question;
  final String theme;
  final List<String> userDiscussionUsers;
  const ResponsesPage(
      {super.key,
      required this.snippetId,
      this.userResponse = "~~~",
      this.userDiscussionUsers = const ["SSSS"],
      required this.question,
      required this.theme});

  @override
  State<ResponsesPage> createState() => _ResponsesPageState();
}

class _ResponsesPageState extends State<ResponsesPage> {
  Stream? responsesListStream;
  String userDisplayName = "";
  String userResponse = "";
  List<dynamic> discussionUsers = [];

  void getResponsesList() async {
    var responsesList =
        await Database(uid: FirebaseAuth.instance.currentUser!.uid)
            .getResponsesList(widget.snippetId);
    if (mounted) {
      setState(() {
        responsesListStream = responsesList;
      });
    }
  }

  void getUserDisplayName() async {
    String displayName = (await HelperFunctions.getUserDisplayNameFromSF())!;

    if (mounted) {
      setState(() {
        userDisplayName = displayName;
      });
    }
    if (widget.userResponse != "~~~") {
      setState(() {
        userResponse = widget.userResponse;
        discussionUsers = widget.userDiscussionUsers;
      });
    } else {
      Map<String, dynamic> response =
          (await Database(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserResponse(widget.snippetId));
      if (mounted) {
        setState(() {
          userResponse = response["answer"];
          discussionUsers = response["discussionUsers"];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Responses",
          theme: widget.theme,
          showBackButton: true,
          onBackButtonPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: ColorSys.background,
      body: Stack(
        children: [
          const BackgroundTile(),
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
    );
  }

  responsesList() {
    return StreamBuilder(
      stream: responsesListStream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (snapshot.hasData) {
          if (snapshot.data == "EMPTY") {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ResponseTile(
                question: widget.question,
                response: userResponse,
                displayName: userDisplayName,
                snippetId: widget.snippetId,
                userId: FirebaseAuth.instance.currentUser!.uid,
                isDisplayOnly: false,
                theme: widget.theme,
                discussionUsers: discussionUsers,
              ),
            );
          }
          if (snapshot.data!.docs.length != null) {
            if (snapshot.data.docs.length + 1 != 0) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      itemCount: snapshot.data.docs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // return the header
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ResponseTile(
                              question: widget.question,
                              response: userResponse,
                              displayName: userDisplayName,
                              snippetId: widget.snippetId,
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              isDisplayOnly: false,
                              theme: widget.theme,
                              discussionUsers: discussionUsers,
                            ),
                          );
                        }
                        index -= 1;
                        if (snapshot.data.docs[0] == "EMPTY") {
                          return const Center(
                            child: Text("No responses yet"),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ResponseTile(
                              question: widget.question,
                              response: snapshot.data.docs[index]["answer"],
                              displayName: snapshot.data.docs[index]
                                  ["displayName"],
                              snippetId: widget.snippetId,
                              theme: widget.theme,
                              userId: snapshot.data.docs[index]["uid"],
                              discussionUsers: snapshot.data.docs[index]
                                  ["discussionUsers"],
                              goToComments: () async {
                                bool refresh = await Navigator.of(context).push(
                                    CustomPageRoute(
                                        builder: (BuildContext context) {
                                  return DiscussionPage(
                                    theme: widget.theme,
                                    responseTile: ResponseTile(
                                      response: snapshot.data.docs[index]
                                          ["answer"],
                                      displayName: snapshot.data.docs[index]
                                          ["displayName"],
                                      snippetId: widget.snippetId,
                                      userId: snapshot.data.docs[index]["uid"],
                                      question: widget.question,
                                      isDisplayOnly: true,
                                      theme: widget.theme,
                                      discussionUsers: snapshot.data.docs[index]
                                          ["discussionUsers"],
                                    ),
                                  );
                                }));
                                if (refresh) {
                                  getResponsesList();
                                }
                              }),
                        );
                      }));
            } else {
              return const Center();
            }
          } else {
            return const Center();
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }
}
