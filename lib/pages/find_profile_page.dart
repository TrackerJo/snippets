import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/profile_tile.dart';


class FindProfilePage extends StatefulWidget {
  final int index;
  const FindProfilePage({super.key, required this.index});

  @override
  State<FindProfilePage> createState() => _FindProfilePageState();
}

class _FindProfilePageState extends State<FindProfilePage> {
  String profileName = "";
  Stream? profileStream;

  List<Map<String, dynamic>> suggestedFriends = [];
  int maxResults = 1;
  int numberOfResults = 0;


  void getData() async {
    

    List<Map<String, dynamic>> mutual = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).getSuggestedFriends();
    if(!mounted) return;
    setState(() {
      if(!mounted) return;
      suggestedFriends = mutual;

    });
        

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  //Run function when widget.index changes
    @override
    void didUpdateWidget(covariant FindProfilePage oldWidget) {

      super.didUpdateWidget(oldWidget);
      if(!mounted) return;
      if(widget.index != 3) return;

      getData();
    }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
       
        backgroundColor: const Color(0xFF232323),
        body: Column(

          children: [
            // const BackgroundTile(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        
                      },
                      decoration: textInputDecoration.copyWith(
                        hintText: "Enter Profile Name",
                        fillColor: const Color.fromARGB(255, 156, 225, 255),
                        
                      ),
                      onChanged: (value) async {
                        if (value == "") {
                          setState(() {
                            profileName = "";
                            profileStream = null;
                          });
                          return;
                        }
                        var stream = await FBDatabase(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                      .searchUsers(value, maxResults);
                        setState(() {
                          profileName = value;
                          profileStream = stream;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            if( profileName !="")
            Expanded(child: profileList()),
            if( profileName =="")
            const SizedBox(height: 20),
             if( profileName =="")
            const Text(
                        "Suggested Friends",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
            ),
             if( profileName == "")
            const SizedBox(height: 20),
             if( profileName == "")
            Expanded(child: suggestedFriendsList()),
            if( profileName != "")
            const SizedBox(height: 20),
            if( profileName != "" && maxResults = numberOfResults)
            TextButton(
              onPressed: () {
                
                var stream = await FBDatabase(
                        uid: FirebaseAuth.instance.currentUser!.uid)
                .searchUsers(value, maxResults + 3);
                  setState(() {
                    profileStream = stream;
                  });
                  setState(() {
                  maxResults += 3;
                });
              },
              child: const Text("View More"),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder profileList() {
    return StreamBuilder(
      stream: profileStream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (profileName == "") {
          return const Center();
        }
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length != null) {
            if (snapshot.data.docs.length != 0) {
              setState(() {
                numberOfResults = snapshot.data.docs.length;
              });
              
              return 
                  ListView.builder(
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
                            child: ProfileTile(
                              displayName: snapshot.data.docs[index]["fullname"],
                              uid: snapshot.data.docs[index]["uid"],
                              username: snapshot.data.docs[index]["username"],
                              // isWinner: isWinner,
                              // groupId: widget.groupId,
                              // userName: userName,
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
          return const Center(
              //     child: CircularProgressIndicator(
              //   color: Theme.of(context).primaryColor,
              // ));
              );
        }
      },
    );
  }

  ListView suggestedFriendsList() {
    return ListView.builder(
        itemCount: suggestedFriends.length,
        shrinkWrap: true,

        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfileTile(
              displayName: suggestedFriends[index]["displayName"],
              uid: suggestedFriends[index]["userId"],
              username: suggestedFriends[index]["username"],
              mutualFriends: suggestedFriends[index]["count"],
            ),
          );
        });
  }
}
