import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/local_database.dart';
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
  final bool isAnonymous;
  final List<String> userDiscussionUsers;
  const ResponsesPage(
      {super.key,
      required this.snippetId,
      this.userResponse = "~~~",
      this.userDiscussionUsers = const ["SSSS"],
      required this.question,
      required this.theme,
      required this.isAnonymous});

  @override
  State<ResponsesPage> createState() => _ResponsesPageState();
}

class _ResponsesPageState extends State<ResponsesPage> {
  Stream? responsesListStream;
  String userDisplayName = "";
  String userResponse = "";
  List<dynamic> discussionUsers = [];
  StreamController responsesStream = StreamController();

  List<String> toStringList(List<dynamic> oldList) {
    List<String> newList = [];
    for (var item in oldList) {
      newList.add(item["userId"]);
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
    SnipResponse? latestResponse = await LocalDatabase().getLatestResponse(widget.snippetId);
    DateTime? latestResDate = latestResponse?.date;
    print("Latest response date: $latestResDate");
    List<String> newFriends = [];
    List<String> removedFriends = [];
    List<String> friends = [];
    if(!widget.isAnonymous) {
      Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
      friends = toStringList(userData["friends"]);
      List<String> responsesIDs = await LocalDatabase().getCachedResponsesIDs(widget.snippetId);
      
  
      if(!compareLists(friends, responsesIDs)){
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
    }
     var responsesList =
        await Database(uid: FirebaseAuth.instance.currentUser!.uid)
            .getResponsesList(widget.snippetId, latestResDate, newFriends.isNotEmpty, newFriends, widget.isAnonymous);
    var localResponses = await LocalDatabase().getResponses(widget.snippetId, friends, widget.isAnonymous);

    localResponses.listen((event) {
      if(responsesStream.isClosed) return;
      responsesStream.add(event);
    });
    responsesList.listen((event) {
      if(responsesStream.isClosed) return;
      print("Firebase response");

        if(event.docs.isNotEmpty){


          //Go through each chat and add to local database
          for (var i = 0; i < event.docs.length; i++) {
            Map<String, dynamic> data = event.docs[i].data() as Map<String, dynamic>;
           
            print("Adding chat to local database ${data['answer']}");
            Map<String, dynamic> responseMap = {
              "snippetId": widget.snippetId,
              "uid": data["uid"],
              "displayName": data["displayName"],
              "answer": data["answer"],
              "date": data["date"].toDate(),
              
              
            };
            LocalDatabase().addResponse(responseMap);
            
          }
         

        }
    });
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
      if(widget.isAnonymous) {
        return;
      }
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    responsesStream.close();
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
      stream: responsesStream.stream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (snapshot.hasData) {
          if (snapshot.data!.length != null) {
            if (snapshot.data.length + 1 != 0) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      itemCount: snapshot.data.length + 1,
                      itemBuilder: (context, index) {
                        print("INDEX $index");
                        if (index == 0 ) {
                          if(widget.isAnonymous){
                            return SizedBox();
                          }
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
                              isAnonymous: widget.isAnonymous,
                            ),
                          );
                        }
                        index -= 1;
                        // if (snapshot.data.docs[0] == "EMPTY") {
                        //   return const Center(
                        //     child: Text("No responses yet"),
                        //   );
                        // }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ResponseTile(
                              question: widget.question,
                              response: snapshot.data[index].answer,
                              displayName: snapshot.data[index].displayName,
                              snippetId: widget.snippetId,
                              theme: widget.theme,
                              userId: snapshot.data[index].uid,
                              isAnonymous: widget.isAnonymous,
                              
                              ),
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
