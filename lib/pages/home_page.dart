
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:snippets/api/local_database.dart';
import 'package:snippets/helper/helper_function.dart';

import 'package:snippets/widgets/snippet_tile.dart';

import '../api/fb_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? currentSnippetsStream;

  StreamController snippetsStreamController = StreamController();
  StreamController localController = StreamController();
  StreamController firebaseController = StreamController();
  


  void getCurrentSnippets() async {
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    await HelperFunctions.saveOpenedPageSF("snippets");
    Snippet? latestSnippet = await LocalDatabase().getMostRecentSnippet();
    DateTime? latestSnippetDate = latestSnippet?.lastRecieved;
    

    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
            .getCurrentSnippets(latestSnippetDate, firebaseController, snippetsStreamController);

    
    await LocalDatabase().getSnippets(localController, snippetsStreamController);
    localController.stream.listen((event) async {
      if(snippetsStreamController.isClosed) return;

      //Check for duplicates
      List<Snippet> localSnippets = event as List<Snippet>;
      List<String> read = [];
        List<String> duplicates = []; // List to collect IDs of duplicates

      for (var element in localSnippets) {
        //Check if is anonymous
        if(element.type == "anonymous"){
          DateTime lastRecieved = element.lastRecieved;
          DateTime now = DateTime.now();
          if(now.difference(lastRecieved).inDays > 1){
            await LocalDatabase().deleteSnippetById(element.snippetId);
            duplicates.add(element.snippetId); // Collect duplicate IDs
          }
        }
        if(read.contains(element.snippetId)){

          await LocalDatabase().deleteSnippetById(element.snippetId);
          duplicates.add(element.snippetId); // Collect duplicate IDs
        } else {
          read.add(element.snippetId);
        }

      }
      localSnippets.removeWhere((element) => duplicates.contains(element.snippetId));

      
      snippetsStreamController.add(localSnippets);
    });
    firebaseController.stream.listen((event) async {
      if(snippetsStreamController.isClosed) return;

      
      if(event.docs.isNotEmpty){
        

        //Go through each chat and add to local database
        for (var i = 0; i < event.docs.length; i++) {
          Map<String, dynamic> data = event.docs[i].data() as Map<String, dynamic>;
          String id = userData["uid"];
          if(data["type"] == "anonymous"){
            id = await HelperFunctions.getAnonymousIDFromSF() ?? "";

          }
          

          Map<String, dynamic> snippetMap = {
            "snippetId": event.docs[i].id,
            "lastRecieved":  data["lastRecieved"].toDate(),
            "question": data["question"],
            "answered": data["answered"].contains(id),
            "theme":  data["theme"],
            "index":  data["index"],
            "type": data["type"]
             
          };
          await LocalDatabase().addSnippet(snippetMap);
          
        }
        

      }

    });
  
   
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getCurrentSnippets();

  }

  @override
  void dispose() {
    super.dispose();
    snippetsStreamController.close();
    firebaseController.close();
    localController.close();

  }

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          // appBar: PreferredSize(
          //   preferredSize: const Size.fromHeight(kToolbarHeight),
          //   child: CustomAppBar(
          //     title: 'Snippets',
          //     showFriendsButton: true,
          //     onFriendsButtonPressed: () {
          //       HapticFeedback.mediumImpact();
          //       nextScreen(context, const FriendsPage());
          //     },
          //     hasFriendRequests: hasFriendRequests,
          //   ),
          // ),
          // bottomNavigationBar: const PreferredSize(
          //   preferredSize: Size.fromHeight(kToolbarHeight),
          //   child: CustomNavBar(pageIndex: 1),
          // ),
          backgroundColor: const Color(0xFF232323),
          body:
              Column(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     var url = Uri.https(
                  //         'us-central1-snippets2024.cloudfunctions.net',
                  //         '/sendDiscussionNotifications');
                  //     var snippetId = "NK7CwyZi0YlyGCX5VTdz";
                  //     var responseId = "r8mcsQblJVcvjTQsvzHUkJHW8MJ3";
                  //     var snippetQuestion = "Favorite Breakfast?";
                  //     var responseName = "Jake Nash";
                  //     var senderName = "Bill Kemme";
                  //     var message = "I love pancakes!";
                  //     var targetIds = [
                  //       "fJBU2wkmSpOq2ncRPqddqI:APA91bG6Br4xor46lU-1FyMh-HkGQmoBobYB_cSyh5_ByqVW9-n9ks3qLXrgj8mhafQ2eK7X5o9tEEpl_-cI0H4z85GiaIX_vmAvtz3PS07gp1z6-f73Ex_CDdFKEMsXugjCKaCxSKTl"
                  //     ];
                  //     try {
                  //       HttpsCallableResult result = await FirebaseFunctions
                  //           .instance
                  //           .httpsCallable('sendDiscussionNotificationsCall')
                  //           .call({
                  //         "snippetId": snippetId,
                  //         "responseId": responseId,
                  //         "snippetQuestion": snippetQuestion,
                  //         "responseName": responseName,
                  //         "senderName": senderName,
                  //         "message": message,
                  //         "targetIds": targetIds,
                  //         "response": "widget.responseTile.response",
                  //         "theme": "widget.theme",
                  //       });
                  //       print(result.data);
                  //     } catch (e) {
                  //       print(e);
                  //     }
                  //   },
                  //   child: Text("Send notification via API"),
                  // ),
                  Expanded(child: snippetsList()),
                ],
              ),
      
          ),
    );
  }

  StreamBuilder snippetsList() {
    return StreamBuilder(
      stream: snippetsStreamController.stream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (snapshot.hasData) {
          if (snapshot.data!.length != null) {
            if (snapshot.data.length != 0) {
              return ListView.builder(
                    clipBehavior: Clip.none,
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
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

                          question: snapshot.data[index].question,
                          theme: snapshot.data[index].theme,
                          type: snapshot.data[index].type,
                          
                          snippetId: snapshot.data[index].snippetId,
                          isAnswered: snapshot.data[index].answered
                        ),
                      );
                    });
              
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
