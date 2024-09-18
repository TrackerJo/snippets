import 'dart:async';
import 'dart:convert';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/fb_database.dart';

import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/discussions_page.dart';
import 'package:snippets/pages/find_profile_page.dart';
import 'package:snippets/pages/friends_page.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/modify_profile_page.dart';
import 'package:snippets/pages/profile_page.dart';

import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_nav_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/widget_gradient_tile.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

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
      if(!mounted) return;
    setState(() {
      if(!mounted) return;

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

  Future deleteAccount() async {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    bool isLoadingAccount = false;
    //Show Login Dialog
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: ColorSys.primaryInput,
              title: const Text("Account Verification Before Deletion", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    TextFormField(
                    onTap: () {
                        HapticFeedback.selectionClick();
                      },
                    decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        fillColor: ColorSys.secondary,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        )),
                        controller: email,
                    
                    //Check email validation
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                    decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        fillColor: ColorSys.secondary,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        )),
                        controller: password,
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Password must be at least 6 characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
                isLoadingAccount ? CircularProgressIndicator(color: ColorSys.secondary,) : ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      isLoadingAccount = true;
                    });
            
                    //Change password
                    String? res = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).deleteAccount(email.text, password.text);
                    if(res != null){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
                    } else{

                      router.pushReplacement("/login");
                    }
                    setState(() {
                      isLoadingAccount = false;
                    });
                  },
                  style: elevatedButtonDecorationBlue,
                  child: const Text("Delete Account", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void onSettingsButtonPressed() {
  HapticFeedback.mediumImpact();
   showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: ColorSys.background,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return SizedBox(
                        height: 600,
                        child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();

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
                                        nextScreen(context, const ModifyProfilePage());
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
                                      child: const Text("Modify Profile",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15))),
                                ),
                                 const SizedBox(height: 20),
                                 SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        Navigator.of(context).pop();
                                        widgetCustomization();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
                                      child: const Text("Customize Widgets",
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
                                   const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        showShareFeedbackDialog(context);
                                        
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
                                      child: const Text("Share Feedback",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15))),
                                ),
                                 const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        HapticFeedback.mediumImpact();
                                          Uri sms = Uri.parse('mailto:kazoom.apps@gmail.com?subject=Snippet%20App%20Support');
                                          if (await launchUrl(sms)) {
                                              
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Unable to open messaging app"),
                                                    content: const Text("Please try again later."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text("Okay"),
                                                      ),
                                                    ],
                                                  );
                                                }
                                            );
                                          }
                                        
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
                                      child: const Text("Contact Support",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15))),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        showAboutTheDeveloperSheet(context);
                                        
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
                                      child: const Text("About the Developer",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15))),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        deleteAccount();
                                        
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorSys.purpleBtn,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          shadowColor: ColorSys.primaryDark),
                                      child: const Text("Delete Account",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15))),
                                ),
                              ],
                            )));
                  });
            
  }

  void showAboutTheDeveloperSheet(BuildContext context) {
    showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: ColorSys.background,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height - 90,
                        child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                //  Text("About the Developer", style: TextStyle(color: ColorSys.primary, fontSize: 30),),
                                // const SizedBox(height: 20),
                               Text("Hi! I'm Nathaniel Kemme Nash", style: TextStyle(color: ColorSys.primary, fontSize: 30, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 20),
                                const Text("I'm a self taught programmer, who made Snippets in high school", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
                                const SizedBox(height: 10),
                                const Text("My passion is making websites and apps that help people, even if it's just one person", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                                const SizedBox(height: 10),
                                const Text("I've been coding for about 7 years, and in that time I've made a few small video games, a programming language, an e-commerce store for a school, and so much more! I've even co-founded a company!", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                                const SizedBox(height: 10),

                                ElevatedButton(onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  Uri sms = Uri.parse('https://github.com/TrackerJo');
                                  if (await launchUrl(sms)) {
                                      
                                  }else{
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Unable to open messaging app"),
                                            content: const Text("Please try again later."),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Okay"),
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: ColorSys.primaryDark, width: 2)
                                    

                                  ),
                                  surfaceTintColor: ColorSys.primaryDark,

                                  // shadowColor: ColorSys.primaryDark,
                                  // Change the shadow position

                                ) 
                                ,child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                   Image.asset("assets/github.png", width: 20, height: 20,),
                                    const SizedBox(width: 10),
                                    const Text("View My Github", style: TextStyle(color: Colors.white),),
                                    
                                  ],
                                )),
                               
                              ],
                            )));
                  });
    
  }

   void widgetCustomization() async {
    String botwGradient = "bluePurple";
    String snippetGradient = "bluePurple";
    String responseGradient = "bluePurple";
    String? botwConfig = await WidgetKit.getItem('botwConfig', 'group.kazoom_snippets');
    String? snippetsConfig = await WidgetKit.getItem('snippetsConfig', 'group.kazoom_snippets');
    String? snippetsResponsesConfig = await WidgetKit.getItem('snippetsResponsesConfig', 'group.kazoom_snippets');
    if(botwConfig != null){
      Map<String, dynamic> botwConfigMap = jsonDecode(botwConfig);
      botwGradient = botwConfigMap["gradient"];
    }
    if(snippetsConfig != null){
      Map<String, dynamic> snippetsConfigMap = jsonDecode(snippetsConfig);
      snippetGradient = snippetsConfigMap["gradient"];
    }
    if(snippetsResponsesConfig != null){
      Map<String, dynamic> snippetsResponsesConfigMap = jsonDecode(snippetsResponsesConfig);
      responseGradient = snippetsResponsesConfigMap["gradient"];
    }
   showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: ColorSys.background,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return SizedBox(
                            height: MediaQuery.of(context).size.height - 100,
                            child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text("Customize Widgets", style: TextStyle(color: ColorSys.primary, fontSize: 20),),
                                      const SizedBox(height: 20),
                                      const Text("Select a color for the Snippet of the Week Widget", textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          WidgetGradientTile(gradient: ColorSys.widgetBPGradient, name: "bluePurple", onTap: () {
                                            setState(() {
                                              botwGradient = "bluePurple";
                                            });
                                             WidgetKit.setItem(
                                              'botwConfig',
                                              jsonEncode({
                                                "gradient": "bluePurple",
                                              }),
                                              'group.kazoom_snippets');
                                              WidgetKit.reloadAllTimelines();
                                            WidgetKit.reloadAllTimelines();
                                          }, isSelected: botwGradient == "bluePurple",),
                                          WidgetGradientTile(gradient: ColorSys.widgetBGGradient, name: "blueGreen", onTap: () {
                                            setState(() {
                                              botwGradient = "blueGreen";
                                            });
                                              WidgetKit.setItem(
                                                'botwConfig',
                                                jsonEncode({
                                                  "gradient": "blueGreen",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: botwGradient == "blueGreen",),
                                          WidgetGradientTile(gradient: ColorSys.widgetORGradient, name: "orangeRed", onTap: () {
                                            setState(() {
                                              botwGradient = "orangeRed";
                                            });
                                              WidgetKit.setItem(
                                                'botwConfig',
                                                jsonEncode({
                                                  "gradient": "orangeRed",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: botwGradient == "orangeRed",),
                                          
                                  
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          
                                          WidgetGradientTile(gradient: ColorSys.widgetYRGradient, name: "yellowRed", onTap: () {
                                            setState(() {
                                              botwGradient = "yellowRed";
                                            });
                                              WidgetKit.setItem(
                                                'botwConfig',
                                                jsonEncode({
                                                  "gradient": "yellowRed",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: botwGradient == "yellowRed",),
                                          WidgetGradientTile(gradient: ColorSys.widgetPPGradient, name: "pinkPurple", onTap: () {
                                            setState(() {
                                              botwGradient = "pinkPurple";
                                            });
                                              WidgetKit.setItem(
                                                'botwConfig',
                                                jsonEncode({
                                                  "gradient": "pinkPurple",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: botwGradient == "pinkPurple",),
                                  
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      const Text("Select a color for the Current Snippet Widget", style: TextStyle(color: Colors.white),),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          WidgetGradientTile(gradient: ColorSys.widgetBPGradient, name: "bluePurple", onTap: () {
                                            setState(() {
                                              snippetGradient = "bluePurple";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsConfig',
                                                jsonEncode({
                                                  "gradient": "bluePurple",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: snippetGradient == "bluePurple",),
                                          WidgetGradientTile(gradient: ColorSys.widgetBGGradient, name: "blueGreen", onTap: () {
                                            setState(() {
                                              snippetGradient = "blueGreen";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsConfig',
                                                jsonEncode({
                                                  "gradient": "blueGreen",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: snippetGradient == "blueGreen",),
                                          WidgetGradientTile(gradient: ColorSys.widgetORGradient, name: "orangeRed", onTap: () {
                                            setState(() {
                                              snippetGradient = "orangeRed";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsConfig',
                                                jsonEncode({
                                                  "gradient": "orangeRed",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: snippetGradient == "orangeRed",),
                                          
                                  
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          
                                          WidgetGradientTile(gradient: ColorSys.widgetYRGradient, name: "yellowRed", onTap: () {
                                            setState(() {
                                              snippetGradient = "yellowRed";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsConfig',
                                                jsonEncode({
                                                  "gradient": "yellowRed",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: snippetGradient == "yellowRed",),
                                          WidgetGradientTile(gradient: ColorSys.widgetPPGradient, name: "pinkPurple", onTap: () {
                                            setState(() {
                                              snippetGradient = "pinkPurple";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsConfig',
                                                jsonEncode({
                                                  "gradient": "pinkPurple",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: snippetGradient == "pinkPurple",),
                                  
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      const Text("Select a color for the Responses Widget", style: TextStyle(color: Colors.white),),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          WidgetGradientTile(gradient: ColorSys.widgetBPGradient, name: "bluePurple", onTap: () {
                                            setState(() {
                                              responseGradient = "bluePurple";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsResponsesConfig',
                                                jsonEncode({
                                                  "gradient": "bluePurple",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: responseGradient == "bluePurple",),
                                          WidgetGradientTile(gradient: ColorSys.widgetBGGradient, name: "blueGreen", onTap: () {
                                            setState(() {
                                              responseGradient = "blueGreen";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsResponsesConfig',
                                                jsonEncode({
                                                  "gradient": "blueGreen",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: responseGradient == "blueGreen",),
                                          WidgetGradientTile(gradient: ColorSys.widgetORGradient, name: "orangeRed", onTap: () {
                                            setState(() {
                                              responseGradient = "orangeRed";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsResponsesConfig',
                                                jsonEncode({
                                                  "gradient": "orangeRed",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: responseGradient == "orangeRed",),
                                          
                                  
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          
                                          WidgetGradientTile(gradient: ColorSys.widgetYRGradient, name: "yellowRed", onTap: () {
                                            setState(() {
                                              responseGradient = "yellowRed";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsResponsesConfig',
                                                jsonEncode({
                                                  "gradient": "yellowRed",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: responseGradient == "yellowRed",),
                                          WidgetGradientTile(gradient: ColorSys.widgetPPGradient, name: "pinkPurple", onTap: () {
                                            setState(() {
                                              responseGradient = "pinkPurple";
                                            });
                                              WidgetKit.setItem(
                                                'snippetsResponsesConfig',
                                                jsonEncode({
                                                  "gradient": "pinkPurple",
                                                }),
                                                'group.kazoom_snippets');
                                                WidgetKit.reloadAllTimelines();
                                          }, isSelected: responseGradient == "pinkPurple",),
                                  
                                        ],
                                      ),
                                  
                                      
                                    ],
                                  ),
                                )));
                      }
                    );
                  });
            
  }

  void showShareFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorSys.background,
          title: Text("Share Feedback", style: TextStyle(color: ColorSys.primary)),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
                const Text(
                    "We would love to hear your feedback! Please share any thoughts or suggestions you have.",
                    style: TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onTap: () => HapticFeedback.selectionClick(),
                  maxLines: 6,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Feedback',
                    counterStyle: const TextStyle(color: Colors.white),
                    fillColor: ColorSys.primaryInput,
                    // counter: Text("Characters: ${editDescription.length}/125", style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  onChanged: (value) {
                    setState(() {

                      editDescription = value;
                    });
                  },
                  maxLength: 500,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSys.primaryDark,
              ),
              onPressed: () async {
                HapticFeedback.mediumImpact();
                await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
                    .shareFeedback(editDescription);
                Navigator.of(context).pop();
              },
              child: const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
      body: !loggedIn ? const Center(child: CircularProgressIndicator(),) :
      PageView(
        controller: pageController,
        allowImplicitScrolling: true,

        onPageChanged: (int index) async{
          FocusManager.instance.primaryFocus?.unfocus();
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

          });
        },
        children: <Widget>[
          const ProfilePage(
            showNavBar: false,
            showAppBar: false,
          ),
          const HomePage(),
          DiscussionsPage(
            index: selectedIndex,
          ),
          FindProfilePage(index: selectedIndex,),
        ],
      ),
    );
  }
}