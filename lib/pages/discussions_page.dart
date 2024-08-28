import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:snippets/api/fb_database.dart';


import 'package:snippets/widgets/discussion_tile.dart';

class DiscussionsPage extends StatefulWidget {
  final int index;
  const DiscussionsPage({super.key, required this.index});

  @override
  State<DiscussionsPage> createState() => _DiscussionsPageState();
}

class _DiscussionsPageState extends State<DiscussionsPage> {
  List<Map<String,dynamic>> discussions = [];
  List<Map<String,dynamic>> oldDiscussions = [];
  StreamSubscription? discSub;
  bool isLoading = false;

  void getDiscussions() async {

    
    setState(() {
      isLoading = true;
    });
    StreamController discStream = StreamController();
    
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDiscussions(FirebaseAuth.instance.currentUser!.uid, discStream);
      setState(() {
        discussions = [];
      });
    discSub = discStream.stream.listen((discussionsMap) {
      if (mounted) {
      setState(() {
        // discussions.add(discussionsMap);
        if(discussions.any((element) => element["snippetId"] == discussionsMap["snippetId"] && element["answerId"] == discussionsMap["answerId"])) {
          //Get one that exists
          var existing = discussions.firstWhere((element) => element["snippetId"] == discussionsMap["snippetId"] && element["answerId"] == discussionsMap["answerId"]);
          print("REMOVING");
          discussionsMap["snippetQuestion"] = existing["snippetQuestion"];
          discussionsMap["isAnonymous"] = existing["isAnonymous"];
          discussions.removeWhere((element) => element["snippetId"] == discussionsMap["snippetId"] && element["answerId"] == discussionsMap["answerId"]);

          // discussions.add(existing);
        }

        
        discussions.add(discussionsMap);
        //Sort by last message
        discussions.sort((a, b) {
          var aTime = a["lastMessage"]["date"];
          var bTime = b["lastMessage"]["date"];
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
      if(!mounted) {
        discSub?.cancel();
        return;
      };
      if(widget.index != 2) {
        discSub?.cancel();
        // discussions = [];
        // setState(() {});
        return;
      };
      print("INDEX CHANGED to ${widget.index}");
      

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
      
      backgroundColor: const Color(0xFF232323),
      body: isLoading ? ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                if(oldDiscussions == [] || oldDiscussions.isEmpty) 
            const Text("No discussions yet", style: TextStyle(color: Colors.white, fontSize: 20)),
          if(oldDiscussions == [] || oldDiscussions.isEmpty)
            const SizedBox(height: 20),
          if(oldDiscussions == [] || oldDiscussions.isEmpty)
            const Text("Join a discussion by sending a message in a discussion", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center, ),
           
              ],
            ),
          ),
               
                
          for (var discussion in oldDiscussions)
            if(discussion["snippetId"] != null && discussion["answerId"] != null && discussion["snippetQuestion"] != null && discussion["answerUser"] != null && discussion["lastMessage"] != null )
            DiscussionTile(
              snippetId: discussion["snippetId"],
              discussionId: discussion["answerId"],
              question: discussion["snippetQuestion"],
              answerUser: discussion["answerUser"],
              lastMessageSender: discussion["lastMessage"]
                  ["senderDisplayName"],
              lastMessage: discussion["lastMessage"]["message"],
              hasBeenRead: discussion["lastMessage"]["readBy"]
                  .contains(FirebaseAuth.instance.currentUser!.uid),
              theme: "blue",
              answerResponse: discussion["answerResponse"],
              isAnonymous: discussion["isAnonymous"],

            )
        ],
      ) : ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                if(discussions == [] || discussions.isEmpty) 
            const Text("No discussions yet", style: TextStyle(color: Colors.white, fontSize: 20)),
          if(discussions == [] || discussions.isEmpty)
            const SizedBox(height: 20),
          if(discussions == [] || discussions.isEmpty)
            const Text("Join a discussion by sending a message in a discussion", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center, ),
           
              ],
            ),
          ),
               
                
          for (var discussion in discussions)
            if(discussion["snippetId"] != null && discussion["answerId"] != null && discussion["snippetQuestion"] != null && discussion["answerUser"] != null && discussion["lastMessage"] != null )
            DiscussionTile(
              snippetId: discussion["snippetId"],
              discussionId: discussion["answerId"],
              question: discussion["snippetQuestion"],
              answerUser: discussion["answerUser"],
              lastMessageSender: discussion["lastMessage"]
                  ["senderDisplayName"],
              lastMessage: discussion["lastMessage"]["message"],
              hasBeenRead: discussion["lastMessage"]["readBy"]
                  .contains(FirebaseAuth.instance.currentUser!.uid),
              theme: "blue",
              answerResponse: discussion["answerResponse"],
              isAnonymous: discussion["isAnonymous"],


            )
        ],
      ),
    );
  }
}
