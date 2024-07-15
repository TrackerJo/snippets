import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussions_page.dart';
import 'package:snippets/pages/find_profile_page.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';

class SwipePages extends StatefulWidget {
  const SwipePages({super.key});

  @override
  State<SwipePages> createState() => _SwipePagesState();
}

class _SwipePagesState extends State<SwipePages> {
  PageController pageController = PageController(initialPage: 1);
  TextEditingController descriptionController = TextEditingController();
  Map<String, dynamic> userData = {};
  int selectedIndex = 1;
  List<String> pageTitles = ["Profile", "Snippets", "Discussions", "Find Profile"];
  StreamSubscription userStreamSub = const Stream.empty().listen((event) {});

  void getData()async{
    userStreamSub = userStreamController.stream.listen((event) {
      setState(() {
        userData = event;

      });
    });
    userData = await HelperFunctions.getUserDataFromSF();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    userStreamSub.cancel();
    super.dispose();
  }

   Future logout() async {
    await Auth().signOut();
    Navigator.of(context).pushReplacement(
      CustomPageRoute(
        builder: (BuildContext context) {
          return const WelcomePage();
        },
      ),
    );
  }

  showDiscriptionPopup(BuildContext context) {
    return showDialog(
      context: context,

      barrierDismissible: false,
      builder: (BuildContext context) {

      return GestureDetector(
         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          
          child: AlertDialog(
            backgroundColor: ColorSys.background,
            
            title: Text("Profile's Description",
                style: TextStyle(color: ColorSys.primary)),
            content: SizedBox(
              width: 300,
              height: 300,
              child: Column(
                children: [
                  const Text(
                      "Enter a short description about yourself. This will be visible to other users.",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onTap: () => HapticFeedback.selectionClick(),
                    controller: descriptionController,
                    maxLines: 7,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Description',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSys.primary,
                ),
                onPressed: () async {
                  setState(() {
                    userData["description"] = descriptionController.text;
                  });
          
                  await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateUserDescription(descriptionController.text);
                  Navigator.of(context).pop();
                },
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
      }
    );
  }

  void onSettingsButtonPressed() {
   showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: ColorSys.background,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return SizedBox(
                        height: 200,
                        child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        print("Log Out");
                                        logout();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.primarySolid,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primary),
                                      child: const Text("Log Out",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15))),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        descriptionController.text =
                                            userData["description"];
                                        showDiscriptionPopup(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.primarySolid,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primary),
                                      child: const Text("Edit Description",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15))),
                                ),
                              ],
                            )));
                  });
            
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: pageTitles[selectedIndex],
          showSettingsButton: selectedIndex == 0,
          onSettingsButtonPressed: onSettingsButtonPressed,
        
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomNavBar(pageIndex: selectedIndex, pageController: pageController, ),
      ),
      body: PageView(
        controller: pageController,
        allowImplicitScrolling: true,

        onPageChanged: (int index) {
          setState(() {
            selectedIndex = index;
            print(selectedIndex);
          });
        },
        children: <Widget>[
          const ProfilePage(
            showNavBar: false,
            showAppBar: false,
          ),
          const HomePage(),
          const DiscussionsPage(),
          const FindProfilePage(),
        ],
      ),
    );
  }
}