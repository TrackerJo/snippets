import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/api/storage.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/notification_tile.dart';
import 'package:snippets/widgets/widget_gradient_tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<String> allowedNotifications = [];
  TextEditingController delayController = TextEditingController();
  bool sendStreakNotifications = false;

  void load() async {
    List<String> allowedNotifications =
        await HelperFunctions.getAllowedNotifications();
    int delay = await HelperFunctions.getSnippetResponseDelaySF();
    bool sendStreakNotifications =
        await HelperFunctions.getSendStreakNotificationSF();
    setState(() {
      delayController.text = delay.toString();
      this.allowedNotifications = allowedNotifications;
      this.sendStreakNotifications = sendStreakNotifications;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

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
                  title: "Notifications",
                  theme: "purple",
                  showBackButton: true,
                  fixRight: true,
                  onBackButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    NotificationTile(
                        type: "Snippets",
                        description:
                            "Get notified when new snippets are posted",
                        isAllowed: allowedNotifications.contains("snippets"),
                        setIsAllowed: (bool isAllowed) async {
                          if (isAllowed) {
                            allowedNotifications.add("snippets");
                            setState(() {});
                            await HelperFunctions.addTopicNotification(
                                "snippets");
                            await HelperFunctions.addAllowedNotification(
                                "snippets");
                            await PushNotifications()
                                .subscribeToTopic("snippets");
                          } else {
                            allowedNotifications.remove("snippets");
                            setState(() {});
                            await HelperFunctions.removeAllowedNotification(
                                "snippets");
                            await HelperFunctions.removeTopicNotification(
                                "snippets");
                            await PushNotifications()
                                .unsubscribeFromTopic("snippets");
                          }
                        }),
                    NotificationTile(
                        type: "Snippet of the Week",
                        description:
                            "Get notified about the snippet of the week, like when a new one is posted, and when voting starts",
                        isAllowed: allowedNotifications.contains("botw"),
                        setIsAllowed: (bool isAllowed) async {
                          if (isAllowed) {
                            allowedNotifications.add("botw");
                            setState(() {});
                            await HelperFunctions.addAllowedNotification(
                                "botw");
                            await HelperFunctions.addTopicNotification("botw");
                            await PushNotifications().subscribeToTopic("botw");
                          } else {
                            allowedNotifications.remove("botw");
                            setState(() {});
                            await HelperFunctions.removeAllowedNotification(
                                "botw");
                            await HelperFunctions.removeTopicNotification(
                                "botw");
                            await PushNotifications()
                                .unsubscribeFromTopic("botw");
                          }
                        }),
                    NotificationTile(
                      type: "Friend Requests",
                      description:
                          "Get notified when friends send you requests and accept your requests",
                      isAllowed: allowedNotifications.contains("friend"),
                      setIsAllowed: (bool isAllowed) async {
                        if (isAllowed) {
                          allowedNotifications.add("friend");
                          setState(() {});
                          await HelperFunctions.addAllowedNotification(
                              "friend");
                          await Storage()
                              .changeAllowedNotification("friend", true);
                        } else {
                          allowedNotifications.remove("friend");
                          setState(() {});
                          await HelperFunctions.removeAllowedNotification(
                              "friend");
                          await Storage()
                              .changeAllowedNotification("friend", false);
                        }
                      },
                    ),
                    NotificationTile(
                        type: "Discussion",
                        description:
                            "Get notified when friends send discussion messages",
                        isAllowed: allowedNotifications.contains("discussion"),
                        setIsAllowed: (bool isAllowed) async {
                          if (isAllowed) {
                            allowedNotifications.add("discussion");
                            setState(() {});
                            await HelperFunctions.addAllowedNotification(
                                "discussion");
                            await Storage()
                                .changeAllowedNotification("discussion", true);
                          } else {
                            allowedNotifications.remove("discussion");
                            setState(() {});
                            await HelperFunctions.removeAllowedNotification(
                                "discussion");
                            await Storage()
                                .changeAllowedNotification("discussion", false);
                          }
                        }),
                    NotificationTile(
                        type: "Snippet Responses",
                        description: "Get notified friends respond to snippets",
                        isAllowed:
                            allowedNotifications.contains("snippetResponse"),
                        setIsAllowed: (bool isAllowed) async {
                          if (isAllowed) {
                            allowedNotifications.add("snippetResponse");
                            setState(() {});

                            await HelperFunctions.addAllowedNotification(
                                "snippetResponse");
                            await Storage().changeAllowedNotification(
                                "snippetResponse", true);
                          } else {
                            allowedNotifications.remove("snippetResponse");
                            setState(() {});
                            await HelperFunctions.removeAllowedNotification(
                                "snippetResponse");
                            await Storage().changeAllowedNotification(
                                "snippetResponse", false);
                          }
                        }),
                    if (allowedNotifications.contains("snippetResponse"))
                      //Add custom tile, dont use another custom widget for setting delay in between notifications
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          tileColor: styling.theme == "colorful-light"
                              ? Colors.white
                              : styling.theme == "christmas"
                                  ? styling.green
                                  : styling.secondary,
                          title: Text("Snippet Response Delay",
                              style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.secondaryDark
                                      : Colors.black)),
                          subtitle: Text(
                              "Minimum time between response notifications, missed responses will be sent in a single notification (in minutes)",
                              style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.secondaryDark
                                      : Colors.grey[900])),
                          trailing: SizedBox(
                            width: 50,
                            child: TextFormField(
                              controller: delayController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: styling
                                  .textInputDecoration()
                                  .copyWith(
                                      fillColor: styling.theme == "christmas"
                                          ? styling.red
                                          : styling.primary),
                              onChanged: (val) async {
                                print("val: $val");
                                if (val == null || val.isEmpty) {
                                  return;
                                }
                                int delay = int.parse(val);
                                if (delay > 180) {
                                  delay = 180;
                                  delayController.text = delay.toString();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Delay cannot be more than 180 minutes"),
                                  ));
                                }

                                await HelperFunctions
                                    .saveSnippetResponseDelaySF(delay);
                                await Storage()
                                    .setUserSnippetResponseDelay(delay);
                              },
                            ),
                          ),
                        ),
                      ),
                    NotificationTile(
                        type: "Snippet Streak",
                        description:
                            "Get notified when you're about to lose your snippet streak",
                        isAllowed: sendStreakNotifications,
                        setIsAllowed: (bool isAllowed) async {
                          if (isAllowed) {
                            setState(() {
                              sendStreakNotifications = true;
                            });
                            await HelperFunctions.saveSendStreakNotificationSF(
                                true);
                          } else {
                            setState(() {
                              sendStreakNotifications = false;
                            });
                            await HelperFunctions.saveSendStreakNotificationSF(
                                false);
                            String streakTopic =
                                await HelperFunctions.getStreakTopicSF();
                            if (streakTopic != "") {
                              await PushNotifications()
                                  .unsubscribeFromTopic(streakTopic);
                            }
                          }
                        }),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
