import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussions_page.dart';
import 'package:snippets/pages/find_profile_page.dart';
import 'package:snippets/pages/friends_page.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SwipePages extends StatefulWidget {
  final int initialIndex;
  const SwipePages({super.key, this.initialIndex = 1});

  @override
  State<SwipePages> createState() => _SwipePagesState();
}

class _SwipePagesState extends State<SwipePages> {
  PageController pageController = PageController(initialPage: 1);
  TextEditingController descriptionController = TextEditingController();
  Map<String, dynamic> userData = {};
  int selectedIndex = 1;
  List<String> pageTitles = ["Profile", "Snippets", "Discussions", "Search"];
  StreamSubscription userStreamSub = const Stream.empty().listen((event) {});
  bool hasFriendRequests = false;
  bool hasAnsweredBOTW = false;
  String editDescription = "";
  bool loggedIn = false;

  void getData()async{

    bool status = await Auth().isUserLoggedIn();
    print(status);
    if(!status){
      router.pushReplacement("/login");
      return;
    }
    setState(() {
      loggedIn = status;
    });
    await HelperFunctions.saveOpenedPageSF("snippets");


    userStreamSub = userStreamController.stream.listen((event) {
      if (event == null) {
          return;
        }
      DateTime now = DateTime.now();
      DateTime monday = now.subtract(Duration(days: now.weekday - 1));
      String mondayString = "${monday.month}-${monday.day}-${monday.year}";
      //Get time in EST
      tz.initializeTimeZones();
      // Set the EST time zone using the 'America/New_York' IANA time zone identifier
      var estLocation = tz.getLocation('America/New_York');
      // Get the current time in EST
      var nowInEst = tz.TZDateTime.now(estLocation);

      


      setState(() {
        userData = event;
        hasFriendRequests = userData["friendRequests"].length > 0;
        print("${mondayString == userData["botwStatus"]["date"]}" );
        if(userData["botwStatus"]["hasAnswered"] && userData["botwStatus"]["date"] == mondayString && now.weekday < 6){
          //Check if date is sat or sun
          hasAnsweredBOTW = true;
        } else if(userData["botwStatus"]["hasAnswered"] && userData["botwStatus"]["date"] == mondayString) {
          if(now.weekday == 6 && nowInEst.hour >= 9){
            if(userData["votesLeft"] != 0){
              hasAnsweredBOTW = false;
            } else {
              hasAnsweredBOTW = true;
            }
          } else if(now.weekday == 6 && nowInEst.hour < 9){
            hasAnsweredBOTW = true;
          }else if(now.weekday == 7){
              if(nowInEst.hour < 15){
                if(userData["votesLeft"] != 0){
                hasAnsweredBOTW = false;
              } else {
                hasAnsweredBOTW = true;
              }
            } else {
              if(userData["botwStatus"]["hasSeenResults"]){
                hasAnsweredBOTW = true;
              } else {
                hasAnsweredBOTW = false;
              }
            }
          } 
        } else {
          
          hasAnsweredBOTW = false;

        }

      });
    });
    userData = await HelperFunctions.getUserDataFromSF();
    DateTime now = DateTime.now();
      DateTime monday = now.subtract(Duration(days: now.weekday - 1));
      String mondayString = "${monday.month}-${monday.day}-${monday.year}";
      //Get time in EST
      tz.initializeTimeZones();
      // Set the EST time zone using the 'America/New_York' IANA time zone identifier
      var estLocation = tz.getLocation('America/New_York');
      // Get the current time in EST
      var nowInEst = tz.TZDateTime.now(estLocation);
    setState(() {

        hasFriendRequests = userData["friendRequests"].length > 0;
       if(userData["botwStatus"]["hasAnswered"] && userData["botwStatus"]["date"] == mondayString && now.weekday < 6){
          //Check if date is sat or sun
          hasAnsweredBOTW = true;
        } else if(userData["botwStatus"]["hasAnswered"] && userData["botwStatus"]["date"] == mondayString) {
          if(now.weekday == 6 && nowInEst.hour >= 9){
            if(userData["votesLeft"] != 0){
              hasAnsweredBOTW = false;
            } else {
              hasAnsweredBOTW = true;
            }
          } else if(now.weekday == 6 && nowInEst.hour < 9){
            hasAnsweredBOTW = true;
          }else if(now.weekday == 7){
              if(nowInEst.hour < 15){
                if(userData["votesLeft"] != 0){
                hasAnsweredBOTW = false;
              } else {
                hasAnsweredBOTW = true;
              }
            } else {
              if(userData["botwStatus"]["hasSeenResults"]){
                hasAnsweredBOTW = true;
              } else {
                hasAnsweredBOTW = false;
              }
            }
          } 
        } else {
          
          hasAnsweredBOTW = false;

        }
      });
    
  }

  @override
  void initState() {
    getData();
    pageController = PageController(initialPage: widget.initialIndex);
    setState(() {
      selectedIndex = widget.initialIndex;
    });
    super.initState();
  }

  @override
  void dispose() {
    userStreamSub.cancel();
    super.dispose();
  }

   Future logout() async {
    router.pushReplacement("/login");
    await Auth().signOut();
    
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
                  TextFormField(
                    onTap: () => HapticFeedback.selectionClick(),
                    initialValue: editDescription,
                    maxLines: 7,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Description',
                      counterStyle: TextStyle(color: Colors.white),
                      // counter: Text("Characters: ${editDescription.length}/125", style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        editDescription = value;
                      });
                    },
                    maxLength: 125,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                    userData["description"] = editDescription;
                  });
          
                  await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateUserDescription(editDescription);
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
                        height: 300,
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
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
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
                                        editDescription =
                                            userData["description"];
                                        showDiscriptionPopup(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
                                      child: const Text("Edit Description",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15))),
                                ),
                                 const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        router.push("/onboarding/true");
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
                                      child: const Text("View Onboarding",
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
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: pageTitles[selectedIndex],
          showSettingsButton: selectedIndex == 0,
          onSettingsButtonPressed: onSettingsButtonPressed,
          showFriendsButton: selectedIndex == 1,
          hasFriendRequests: hasFriendRequests,
          onFriendsButtonPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).push(
              CustomPageRoute(
                builder: (BuildContext context) {
                  return const FriendsPage();
                },
              ),
            );

          },
          index: selectedIndex,
          showShareButton: selectedIndex == 0,
          onShareButtonPressed: () async{
            HapticFeedback.mediumImpact();
            await Share.share("https://snippets2024.web.app/friendLink?name=${userData["fullname"].replaceAll(" ", "%20")}&uid=${userData["uid"]}", subject: "Share your profile with friends");
            
          },
        
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomNavBar(pageIndex: selectedIndex, pageController: pageController, hasAnsweredBOTW: hasAnsweredBOTW),
      ),
      body: !loggedIn ? Center(child: CircularProgressIndicator(),) :
      PageView(
        controller: pageController,
        allowImplicitScrolling: true,

        onPageChanged: (int index) async{
          if(index == 0){
            await HelperFunctions.saveOpenedPageSF("profile");
          } else if(index == 1){
            await HelperFunctions.saveOpenedPageSF("snippets");
          } else if(index == 2){
            await HelperFunctions.saveOpenedPageSF("discussions");
          } else if(index == 3){
            await HelperFunctions.saveOpenedPageSF("search");
          }
          setState(() {
            selectedIndex = index;
            print(selectedIndex);
          });
        },
        children: <Widget>[
          ProfilePage(
            showNavBar: false,
            showAppBar: false,
          ),
          HomePage(),
          DiscussionsPage(
            index: selectedIndex,
          ),
          FindProfilePage(index: selectedIndex,),
        ],
      ),
    );
  }
}