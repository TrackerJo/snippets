import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/templates/colorsSys.dart';

import '../api/database.dart';
import 'helper_functions.dart';

class CommentTile extends StatefulWidget {
  final String displayName;
  final String comment;
  // final int commentCount;
  // final List<dynamic> likes;
  final String userId;
  final String snippetId;
  const CommentTile(
      {super.key,
      required this.displayName,
      required this.comment,
      // required this.commentCount,
      // required this.likes,
      required this.userId,
      required this.snippetId});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool userHasLiked = false;
  int likes = 0;
  bool canLike = true;
  bool isCurrentUser = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.userId == FirebaseAuth.instance.currentUser!.uid) {
      setState(() {
        isCurrentUser = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Color(0xD185FFBD),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [ColorSys.secondary, Color(0xD185FFBD)],
          ),
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
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isCurrentUser) return;
                        nextScreen(
                          context,
                          ProfilePage(
                            uid: widget.userId,
                            showNavBar: false,
                            showBackButton: true,
                          ),
                        );
                      },
                      child: Text(
                        widget.displayName + " Commented",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!isCurrentUser)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz)),
                      )
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Text(
                widget.comment,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              // Row(
              //   children: [
              //     IconButton(
              //       icon: const Icon(Icons.comment),
              //       onPressed: () {},
              //     ),
              //     Text(widget.commentCount.toString()),
              //     // IconButton(
              //     //   icon: Icon(Icons.favorite,
              //     //       color: userHasLiked ? Colors.red : Colors.black),
              //     //   onPressed: () {
              //     //     if (!canLike) return;
              //     //     if (!userHasLiked) {
              //     //       likeResponse();
              //     //     } else {
              //     //       unlikeResponse();
              //     //     }
              //     //   },
              //     // ),
              //     // Text(likes.toString()),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
