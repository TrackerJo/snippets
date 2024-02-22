import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/comment_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/response_tile.dart';

import '../api/database.dart';

class CommentsPage extends StatefulWidget {
  final ResponseTile responseTile;
  const CommentsPage({super.key, required this.responseTile});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  Stream? commentsStream;

  TextEditingController commentController = TextEditingController();
  ResponseTile displayTile = ResponseTile(
    displayName: "",
    snippetId: "",
    response: "",
    question: "",
    userId: "",
    theme: "",
  );

  void getComments() async {
    var comments = await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getComments(widget.responseTile.snippetId, widget.responseTile.userId);
    if (mounted) {
      setState(() {
        commentsStream = comments;
      });
    }
  }

  void addComment() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid).addComment(
        widget.responseTile.snippetId,
        commentController.text,
        widget.responseTile.userId);

    setState(() {
      // comment = "";
      commentController.text = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
    setState(() {
      displayTile = ResponseTile(
        displayName: widget.responseTile.displayName,
        snippetId: widget.responseTile.snippetId,
        response: widget.responseTile.response,
        userId: widget.responseTile.userId,
        isDisplayOnly: true,
        question: widget.responseTile.question,
        theme: widget.responseTile.theme,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !Navigator.of(context).userGestureInProgress;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "Discussion",
            showBackButton: true,
            onBackButtonPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        backgroundColor: ColorSys.background,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              displayTile,
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 60,
                decoration: BoxDecoration(
                  // color: ColorSys.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 150,
                      child: TextFormField(
                        // maxLines: 1,
                        // expands: true,
                        decoration: textInputDecoration.copyWith(
                            hintText: "Enter Comment",
                            fillColor: ColorSys.primary),
                        controller: commentController,
                      ),
                    ),
                    IconButton(
                      onPressed: () => {
                        addComment(),
                      },
                      icon: Icon(Icons.send, color: ColorSys.primary),
                    ),
                  ],
                ),
              ),
              commentsList(),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder commentsList() {
    return StreamBuilder(
      stream: commentsStream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length != null) {
            if (snapshot.data.docs.length != 0) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 400,
                child: ListView.builder(
                    shrinkWrap: true,
                    clipBehavior: Clip.hardEdge,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      //int reverseIndex = snapshot.data.docs.length - index - 1;
                      // bool isWinner = false;
                      // DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                      //     .getIsWinner(
                      //         getId(snapshot.data["games"][reverseIndex]),
                      //         widget.groupId,
                      //         userName)
                      //     .then((value) {
                      //   setState(() {
                      //     isWinner = value;
                      //   });
                      // });
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommentTile(
                          comment: snapshot.data.docs[index]["comment"],
                          displayName: snapshot.data.docs[index]["displayName"],
                          userId: snapshot.data.docs[index]["uid"],
                          snippetId: displayTile.snippetId,
                        ),
                      );
                    }),
              );
            } else {
              return Center();
            }
          } else {
            return Center();
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
