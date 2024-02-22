import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/profile_tile.dart';

import '../widgets/custom_app_bar.dart';

class FindProfilePage extends StatefulWidget {
  const FindProfilePage({super.key});

  @override
  State<FindProfilePage> createState() => _FindProfilePageState();
}

class _FindProfilePageState extends State<FindProfilePage> {
  String profileName = "";
  Stream? profileStream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Search"),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomNavBar(pageIndex: 2),
      ),
      backgroundColor: Color(0xFF232323),
      body: Stack(
        children: [
          BackgroundTile(),
          Center(
              child: Column(children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: "Enter Profile Name",
                      ),
                      onChanged: (value) async {
                        if (value == "") {
                          setState(() {
                            profileName = "";
                            profileStream = null;
                          });
                          return;
                        }
                        var stream = await Database(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .searchUsers(value);
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
            const SizedBox(height: 20),
            profileList(),
          ])),
        ],
      ),
    );
  }

  StreamBuilder profileList() {
    return StreamBuilder(
      stream: profileStream,
      builder: (context, AsyncSnapshot snapshot) {
        //Make checks
        if (profileName == "") {
          return Center();
        }
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length != null) {
            if (snapshot.data.docs.length != 0) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                    clipBehavior: Clip.none,
                    itemCount: snapshot.data.docs.length,
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
                        child: ProfileTile(
                          displayName: snapshot.data.docs[index]["fullname"],
                          uid: snapshot.data.docs[index]["uid"],
                          username: snapshot.data.docs[index]["username"],
                          // isWinner: isWinner,
                          // groupId: widget.groupId,
                          // userName: userName,
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
              //     child: CircularProgressIndicator(
              //   color: Theme.of(context).primaryColor,
              // ));
              );
        }
      },
    );
  }
}
