import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/discussion_tile.dart';

class DiscussionsPage extends StatefulWidget {
  const DiscussionsPage({super.key});

  @override
  State<DiscussionsPage> createState() => _DiscussionsPageState();
}

class _DiscussionsPageState extends State<DiscussionsPage> {
  List<Map<String, dynamic>> discussions = [];

  void getDiscussions() async {
    // get discussions from database
    discussions = await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDiscussions(FirebaseAuth.instance.currentUser!.uid);
    if (mounted) {
      setState(() {
        discussions = discussions;
        print(discussions);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDiscussions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Discussions"),
      ),
      bottomNavigationBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomNavBar(pageIndex: 3),
      ),
      backgroundColor: const Color(0xFF232323),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                if(discussions == [] || discussions.isEmpty || discussions == null) 
            Text("No discussions yet", style: TextStyle(color: Colors.white, fontSize: 20)),
          if(discussions == [] || discussions.isEmpty || discussions == null)
            SizedBox(height: 20),
          if(discussions == [] || discussions.isEmpty || discussions == null)
            Text("Join a discussion by sending a message in a discussion", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center, ),
           
              ],
            ),
          ),
               
                
          for (var discussion in discussions)
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
              theme: discussion["theme"],
              answerResponse: discussion["answerResponse"],
              discussionUsers: discussion["discussionUsers"],
            )
        ],
      ),
    );
  }
}
