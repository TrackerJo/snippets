import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/snippet_tile.dart';

import '../api/database.dart';
import '../widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? currentSnippetsStream;
  Map<String, dynamic>? userData;

  getUserData() async {
    userData = await HelperFunctions.getUserDataFromSF();
    if (mounted) {
      setState(() {
        userData = userData;
      });
    }
  }

  Future<bool> checkIfUserAnswered(String snippetId) async {
    List<dynamic> ans =
        (await Database(uid: FirebaseAuth.instance.currentUser!.uid)
            .getUserData(
                FirebaseAuth.instance.currentUser!.uid))["answeredSnippets"];
    bool isAnswered = ans.contains(snippetId);
    print(isAnswered);
    return isAnswered;
  }

  void getCurrentSnippets() async {
    var currentSnippets =
        await Database(uid: FirebaseAuth.instance.currentUser!.uid)
            .getCurrentSnippets();
    if (mounted) {
      setState(() {
        currentSnippetsStream = currentSnippets;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getCurrentSnippets();
    getUserData();
  }

  String calculateTimeLeft(String endTime) {
    DateFormat inputFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss zzz');
    DateTime endDateTime = inputFormat.parse(endTime);
    DateTime now = DateTime.now();
    Duration difference = endDateTime.difference(now);
    if (difference.inDays > 0) {
      return difference.inDays == 1 ? "1 day" : "${difference.inDays} days";
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? "1 hour" : "${difference.inHours} hours";
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1
          ? "1 minute"
          : "${difference.inMinutes} minutes";
    } else if (difference.inSeconds > 0) {
      return "${difference.inSeconds} seconds";
    }
    return "None";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(title: 'Snippets'),
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomNavBar(pageIndex: 1),
        ),
        backgroundColor: Color(0xFF232323),
        body: Stack(
          children: [
            BackgroundTile(),
            Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 20),
                snippetsList(),
              ],
            ),
          ],
        ));
  }

  StreamBuilder snippetsList() {
    return StreamBuilder(
      stream: currentSnippetsStream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length != null) {
            if (snapshot.data.docs.length != 0) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 175,
                child: ListView.builder(
                    clipBehavior: Clip.none,
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
                        child: SnippetTile(
                          questionType: "stranger",
                          question: snapshot.data.docs[index]["question"],
                          theme: snapshot.data.docs[index]["theme"],
                          timeLeft: calculateTimeLeft(
                              snapshot.data.docs[index]["endTime"]),
                          snippetId: snapshot.data.docs[index].reference.id,
                          isAnswered: snapshot.data.docs[index]["answered"]
                              .contains(FirebaseAuth.instance.currentUser!.uid),
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