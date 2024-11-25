import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/customize_widgets_page.dart';
import 'package:snippets/pages/app_preferences_page.dart';
import 'package:snippets/pages/modify_profile_page.dart';
import 'package:snippets/pages/notifications_page.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/setting_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String feedback = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          BackgroundTile(),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: CustomAppBar(
                  title: "Settings",
                  theme: "purple",
                  showBackButton: true,
                  fixRight: false,
                  showLogoutButton: true,
                  onLogoutButtonPressed: () async {
                    print("Logging out");
                    await Auth().signOut();
                  },
                  onBackButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: ListView(
                children: [
                  const SizedBox(height: 10),
                  SettingTile(
                    setting: "Modify Profile",
                    onTap: () =>
                        {nextScreen(context, const ModifyProfilePage())},
                  ),
                  SettingTile(
                      setting: "Notifications",
                      onTap: () =>
                          {nextScreen(context, const NotificationsPage())}),
                  SettingTile(
                      setting: "App Preferences",
                      onTap: () {
                        Navigator.pop(context);
                        router.pushReplacement("/app_preferences");
                        // nextScreen(context, const AppPreferencesPage());
                      }),
                  SettingTile(
                      setting: "Customize Widgets",
                      onTap: () {
                        nextScreen(context, const CustomizeWidgetsPage());
                      }),
                  SettingTile(
                      setting: "View Onboarding",
                      onTap: () {
                        router.push("/onboarding/true");
                      }),
                  SettingTile(
                      setting: "Share Feedback",
                      onTap: () {
                        showShareFeedbackDialog(context);
                      }),
                  SettingTile(
                      setting: "Contact Support",
                      onTap: () async {
                        Uri sms = Uri.parse(
                            'mailto:kazoom.apps@gmail.com?subject=Snippet%20App%20Support');
                        if (await launchUrl(sms)) {
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text("Unable to open emailing app"),
                                  content:
                                      const Text("Please try again later."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Okay"),
                                    ),
                                  ],
                                );
                              });
                        }
                      }),
                  SettingTile(
                      setting: "About the Developer",
                      onTap: () {
                        showAboutTheDeveloperSheet(context);
                      }),
                  SettingTile(
                    setting: "Delete Account",
                    onTap: () {
                      deleteAccount();
                    },
                    showForwardIcon: false,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void showAboutTheDeveloperSheet(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: styling.background,
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
                      //  Text("About the Developer", style: TextStyle(color: ColorSys.primary, fontSize: 30),),
                      // const SizedBox(height: 20),
                      Text(
                        "Hi! I'm Nathaniel Kemme Nash",
                        style: TextStyle(
                            color: styling.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "I'm a self taught programmer, who made Snippets in high school",
                        style: TextStyle(
                            color: styling.backgroundText,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "My passion is making websites and apps that help people, even if it's just one person",
                        style: TextStyle(
                            color: styling.backgroundText,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "I've been coding for about 7 years, and in that time I've co-founded a sports recruiting profiles company, made a few small video games, a programming language, an e-commerce store for a school, and so much more!",
                        style: TextStyle(
                            color: styling.backgroundText,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                          onPressed: () async {
                            String hapticFeedback =
                                await HelperFunctions.getHapticFeedbackSF();
                            if (hapticFeedback == "normal") {
                              HapticFeedback.mediumImpact();
                            } else if (hapticFeedback == "light") {
                              HapticFeedback.lightImpact();
                            } else if (hapticFeedback == "heavy") {
                              HapticFeedback.heavyImpact();
                            }
                            Uri sms = Uri.parse('https://github.com/TrackerJo');
                            if (await launchUrl(sms)) {
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Unable to open messaging app"),
                                      content:
                                          const Text("Please try again later."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Okay"),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: styling.primaryDark, width: 2)),
                            surfaceTintColor: styling.primaryDark,

                            // shadowColor: ColorSys.primaryDark,
                            // Change the shadow position
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/github.png",
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "View My Github",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ],
                  )));
        });
  }

  void showShareFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: styling.background,
          title:
              Text("Share Feedback", style: TextStyle(color: styling.primary)),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
                Text(
                    "We would love to hear your feedback! Please share any thoughts or suggestions you have.",
                    style: TextStyle(color: styling.backgroundText)),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onTap: () async {
                    String hapticFeedback =
                        await HelperFunctions.getHapticFeedbackSF();
                    if (hapticFeedback == "normal") {
                      HapticFeedback.selectionClick();
                    } else if (hapticFeedback == "light") {
                      HapticFeedback.selectionClick();
                    } else if (hapticFeedback == "heavy") {
                      HapticFeedback.mediumImpact();
                    }
                  },
                  maxLines: 6,
                  decoration: styling.textInputDecoration().copyWith(
                        hintText: 'Feedback',
                        counterStyle: TextStyle(color: styling.backgroundText),
                        fillColor: styling.primaryInput,
                        // counter: Text("Characters: ${editDescription.length}/125", style: TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                  onChanged: (value) {
                    setState(() {
                      feedback = value;
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
              onPressed: () async {
                String hapticFeedback =
                    await HelperFunctions.getHapticFeedbackSF();
                if (hapticFeedback == "normal") {
                  HapticFeedback.mediumImpact();
                } else if (hapticFeedback == "light") {
                  HapticFeedback.lightImpact();
                } else if (hapticFeedback == "heavy") {
                  HapticFeedback.heavyImpact();
                }
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: styling.primaryDark,
              ),
              onPressed: () async {
                String hapticFeedback =
                    await HelperFunctions.getHapticFeedbackSF();
                if (hapticFeedback == "normal") {
                  HapticFeedback.mediumImpact();
                } else if (hapticFeedback == "light") {
                  HapticFeedback.lightImpact();
                } else if (hapticFeedback == "heavy") {
                  HapticFeedback.heavyImpact();
                }
                await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
                    .shareFeedback(feedback);
                Navigator.of(context).pop();
              },
              child:
                  const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future deleteAccount() async {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    bool isLoadingAccount = false;
    //Show Login Dialog
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: AlertDialog(
                backgroundColor: styling.background,
                title: Text("Account Verification Before Deletion",
                    style: TextStyle(color: styling.backgroundText)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onTap: () async {
                        String hapticFeedback =
                            await HelperFunctions.getHapticFeedbackSF();
                        if (hapticFeedback == "normal") {
                          HapticFeedback.selectionClick();
                        } else if (hapticFeedback == "light") {
                          HapticFeedback.selectionClick();
                        } else if (hapticFeedback == "heavy") {
                          HapticFeedback.mediumImpact();
                        }
                      },
                      decoration: styling.textInputDecoration().copyWith(
                          labelText: "Email",
                          fillColor: styling.secondary,
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
                      onTap: () async {
                        String hapticFeedback =
                            await HelperFunctions.getHapticFeedbackSF();
                        if (hapticFeedback == "normal") {
                          HapticFeedback.selectionClick();
                        } else if (hapticFeedback == "light") {
                          HapticFeedback.selectionClick();
                        } else if (hapticFeedback == "heavy") {
                          HapticFeedback.mediumImpact();
                        }
                      },
                      decoration: styling.textInputDecoration().copyWith(
                          labelText: "Password",
                          fillColor: styling.secondary,
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
                    onPressed: () async {
                      String hapticFeedback =
                          await HelperFunctions.getHapticFeedbackSF();
                      if (hapticFeedback == "normal") {
                        HapticFeedback.mediumImpact();
                      } else if (hapticFeedback == "light") {
                        HapticFeedback.lightImpact();
                      } else if (hapticFeedback == "heavy") {
                        HapticFeedback.heavyImpact();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",
                        style: TextStyle(color: styling.backgroundText)),
                  ),
                  isLoadingAccount
                      ? CircularProgressIndicator(
                          color: styling.secondary,
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            String hapticFeedback =
                                await HelperFunctions.getHapticFeedbackSF();
                            if (hapticFeedback == "normal") {
                              HapticFeedback.mediumImpact();
                            } else if (hapticFeedback == "light") {
                              HapticFeedback.lightImpact();
                            } else if (hapticFeedback == "heavy") {
                              HapticFeedback.heavyImpact();
                            }
                            setState(() {
                              isLoadingAccount = true;
                            });

                            //Change password
                            String? res = await FBDatabase(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .deleteAccount(email.text, password.text);
                            if (res != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(res)));
                            } else {
                              router.pushReplacement("/login");
                            }
                            setState(() {
                              isLoadingAccount = false;
                            });
                          },
                          style: styling.elevatedButtonDecoration(),
                          child: Text("Delete Account",
                              style: TextStyle(
                                color: styling.theme == "colorful-light"
                                    ? styling.primaryDark
                                    : Colors.white,
                              )),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
