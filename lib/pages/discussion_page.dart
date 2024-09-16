
import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/message_tile.dart';
import 'package:snippets/widgets/response_tile.dart';

import '../api/fb_database.dart';

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
    isAnonymous: false,
  );

  bool showResponseTile = true;

  final ScrollController _scrollController = ScrollController();
  Stream<QuerySnapshot>? chats;
  List<dynamic> discussionUsers = [];
  StreamController combinedChats = StreamController();
  TextEditingController messageController = TextEditingController();
  String displayName = "";
  String email = "";
  String username = "";
  bool canSend = true;
  String anonymousId = "";

  //Generate messageId of 9 random digits
  

  void getDiscussion() async {
      List<Map<String, dynamic>> snippets = await Database().getSnippetsList();
    bool snippetExists = snippets.any((e) => e["snippetId"] == widget.responseTile.snippetId);
    if(!snippetExists){
      router.pushReplacement("/");
    }

    if(widget.responseTile.isAnonymous){
      anonymousId = await HelperFunctions.getAnonymousIDFromSF() ?? "";
    }
    await HelperFunctions.saveOpenedPageSF("discussion-${widget.responseTile.snippetId}-${widget.responseTile.userId}");
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();

    if (mounted) {
      setState(() {
        displayName = userData['fullname'];
        email = userData['email'];
        username = userData['username'];
      });
    }
    List<dynamic> dUsers = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDiscussionUsers(widget.responseTile.snippetId, widget.responseTile.userId);
    if (mounted) {
      setState(() {
        discussionUsers = dUsers;
      });
    }

    Chat? latestChat = await LocalDatabase().getMostRecentChat("${widget.responseTile.snippetId}-${widget.responseTile.userId}");
    DateTime? latestChatDate = latestChat?.date;

    latestChatDate = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).loadDiscussion(widget.responseTile.snippetId, widget.responseTile.userId, latestChatDate);
    var discussion = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDiscussion(
            widget.responseTile.snippetId, widget.responseTile.userId, latestChatDate);
    
      var localChats = await LocalDatabase().getChats("${widget.responseTile.snippetId}-${widget.responseTile.userId}");
      localChats.listen((event) {
        if(combinedChats.isClosed) return;

        
        combinedChats.add(event);
      });
      discussion.listen((event) async{
        if(combinedChats.isClosed) return;

        
        if(event.docs.isNotEmpty){
          

          //Go through each chat and add to local database
          for (var i = 0; i < event.docs.length; i++) {
            Map<String, dynamic> data = event.docs[i].data() as Map<String, dynamic>;
           

            Map<String, dynamic> chatMessageMap = {
                "messageId": event.docs[i].id,
              "message": data['message'],
              "senderUsername": data['senderUsername'],
              "senderId": data['senderId'],
              "senderDisplayName": data['senderDisplayName'],
              "date": data['date'].toDate(),
              "readBy": data['readBy'].join(","),
              "chatId": "${widget.responseTile.snippetId}-${widget.responseTile.userId}",
              "snippetId": widget.responseTile.snippetId

            };
            await LocalDatabase().insertChat(chatMessageMap);
            
          }
         

        }

      });
    
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
        isAnonymous: widget.responseTile.isAnonymous,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    combinedChats.close();
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
            showPreviewButton: true,
            onPreviewButtonPressed: () {
              HapticFeedback.mediumImpact();
              setState(() {
                showResponseTile = !showResponseTile;
              });
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
                    if (showResponseTile)
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorSys.blueGreenGradient.colors[0],

                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayTile.isAnonymous ? "Anonymous" : displayTile.displayName,
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
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                ),
                                child: Text(
                                  "A: ${displayTile.response}",
                                  style: const TextStyle(
                                    color: Colors.white,
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
                Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: ColorSys.blueGreenGradient.colors[0],
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
                    color:ColorSys.blueGreenGradient.colors[0],
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
        stream: combinedChats.stream,
        builder: (context, AsyncSnapshot snapshot) {

          // return Container();
          return snapshot.hasData
              ? ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  itemBuilder: (context, index) {

                    DateTime date = snapshot
                            .data[snapshot.data.length - index - 1].date;


                   if (snapshot.data[snapshot.data.length - index - 1].senderUsername != username && index == 0) {
                      if (!snapshot.data[snapshot.data.length - index - 1].readBy.split(',').contains(FirebaseAuth.instance.currentUser!.uid)) {
                        snapshot.data[snapshot.data.length - index - 1].readBy.split(',').add(FirebaseAuth.instance.currentUser!.uid);
                        FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateReadBy(
                                widget.responseTile.snippetId,
                                widget.responseTile.userId,
                                snapshot.data[snapshot.data.length - index - 1].messageId, anonymousId);
                      }
                    }

                    return MessageTile(
                        message: snapshot.data
                                [snapshot.data.length - index - 1].message,
                        sender: snapshot.data
                                [snapshot.data.length - index - 1].senderDisplayName,
                        sentByMe: displayTile.isAnonymous ? anonymousId ==
                            snapshot.data
                                    [snapshot.data.length - index - 1].senderId: username ==
                            snapshot.data
                                    [snapshot.data.length - index - 1].senderUsername,
                        theme: widget.theme,
                        senderId: snapshot.data
                                    [snapshot.data.length - index - 1].senderId,
                        time: date
                            );
                  })
              : Container();
        });
  }

  void sendMessage() async {
    if(!canSend){
      return;
    }
    if (messageController.text.isNotEmpty) {
      setState(() {
        canSend = false;
      });
      HapticFeedback.mediumImpact();
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "senderUsername": displayTile.isAnonymous? "anonymous" :username,
        "senderId": displayTile.isAnonymous ? anonymousId : FirebaseAuth.instance.currentUser!.uid,
        "senderDisplayName":displayTile.isAnonymous ? "Anonymous" : displayName,
        "date": DateTime.now(),
        "readBy": [displayTile.isAnonymous ? anonymousId : FirebaseAuth.instance.currentUser!.uid],
        "snippetId": widget.responseTile.snippetId
      };


      Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
      Map<String, dynamic> userMap = {
        "userId": displayTile.isAnonymous ? anonymousId : FirebaseAuth.instance.currentUser!.uid,
        "FCMToken": userData['FCMToken'],
      };

      List<dynamic> users = discussionUsers;
      if (!isUserInDiscussion()) {

        users.add(userMap);

        await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
            .updateDiscussionUsers(widget.responseTile.snippetId,
                widget.responseTile.userId, userMap);
        await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
            .addUserToDiscussion(
                FirebaseAuth.instance.currentUser!.uid,
                widget.responseTile.snippetId,
                widget.responseTile.userId,
                widget.responseTile.question,
                widget.theme, displayTile.isAnonymous);
       
      } else if (FirebaseAuth.instance.currentUser!.uid == widget.responseTile.userId) {
       //Check if has discussion in data
        List<dynamic> userDiscussions = userData['discussions'];
        bool hasDiscussion = userDiscussions.any((element) => element['snippetId'] == widget.responseTile.snippetId && element['answerId'] == widget.responseTile.userId);
        if(!hasDiscussion){
          await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
            .addUserToDiscussion(
                FirebaseAuth.instance.currentUser!.uid,
                widget.responseTile.snippetId,
                widget.responseTile.userId,
                widget.responseTile.question,
                widget.theme, displayTile.isAnonymous);
          
        }
      }

     String id = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
          .sendDiscussionMessage(widget.responseTile.snippetId,
              widget.responseTile.userId, chatMessageMap);
      chatMessageMap['messageId'] = id;
      chatMessageMap["readBy"] = chatMessageMap["readBy"].join(',');
      chatMessageMap["chatId"] = "${widget.responseTile.snippetId}-${widget.responseTile.userId}";
      await LocalDatabase().insertChat(chatMessageMap);
      // var url = Uri.https('us-central1-snippets2024.cloudfunctions.net',
      //     '/sendDiscussionNotification');
      var snippetId = widget.responseTile.snippetId;
      var responseId = widget.responseTile.userId;
      var snippetQuestion = widget.responseTile.question;
      var responseName = displayTile.isAnonymous ? "Anonymous" : widget.responseTile.displayName;
      var senderName = displayTile.isAnonymous ? "Anonymous" : displayName;
      var message = messageController.text;

      var targetIds = getDiscussionUsersFCMToken(users);

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
      setState(() {
        canSend = true;
      });
      
      //Scroll to the bottom of the list
      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  bool isUserInDiscussion() {
    bool isUserInDiscussion = false;

    for (Map<String, dynamic> element in discussionUsers) {
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
