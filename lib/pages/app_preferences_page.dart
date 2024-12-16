import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:go_router/go_router.dart';
import 'package:snippets/helper/app_icon_changer.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/settings_page.dart';
import 'package:snippets/pages/swipe_pages.dart';
import 'package:snippets/widgets/app_icon_tile.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/helper_functions.dart';
import 'package:snippets/widgets/notification_tile.dart';
import 'package:snippets/widgets/widget_gradient_tile.dart';

class AppPreferencesPage extends StatefulWidget {
  const AppPreferencesPage({super.key});

  @override
  State<AppPreferencesPage> createState() => _AppPreferencesPageState();
}

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 500);
}

class _AppPreferencesPageState extends State<AppPreferencesPage> {
  String hapticFeedback = "normal";
  String theme = "dark";
  String appIcon = "default";
  bool showDiscussionResponseTile = true;
  void load() async {
    String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
    String theme = await HelperFunctions.getThemeSF();
    String appIcon = await HelperFunctions.getAppIconSF();
    bool showDiscussionResponseTile =
        await HelperFunctions.getShowDisplayTileSF();
    setState(() {
      this.hapticFeedback = hapticFeedback;
      this.theme = theme;
      this.showDiscussionResponseTile = showDiscussionResponseTile;
      this.appIcon = appIcon;
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
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            BackgroundTile(),
            Scaffold(
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: CustomAppBar(
                    title: "App Preferences",
                    theme: "purple",
                    showBackButton: true,
                    fixRight: true,
                    onBackButtonPressed: () async {
                      router.pushReplacement("/home/index/0");
                      router.push("/settings");

                      //
                    },
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
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
                          title: Text("Haptic Feedback Intensity",
                              style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.secondaryDark
                                      : Colors.black)),
                          subtitle: Text(
                              "Choose the intensity of the haptic feedback (the vibration when you interact with the app)",
                              style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.secondaryDark
                                      : Colors.grey[900])),
                          trailing: SizedBox(
                            width: 100,
                            child: DropdownButtonFormField(
                              value: hapticFeedback,
                              decoration: styling
                                  .textInputDecoration()
                                  .copyWith(
                                      fillColor:
                                          styling.theme == "colorful-light"
                                              ? styling.secondary
                                              : styling.theme == "christmas"
                                                  ? styling.red
                                                  : styling.primary),
                              dropdownColor: styling.theme == "colorful-light"
                                  ? styling.secondary
                                  : styling.theme == "christmas"
                                      ? styling.red
                                      : styling.primary,
                              iconEnabledColor:
                                  styling.theme == "colorful-light"
                                      ? styling.primary
                                      : styling.theme == "christmas"
                                          ? styling.green
                                          : styling.secondary,
                              borderRadius: BorderRadius.circular(10),
                              items: [
                                "heavy",
                                "normal",
                                "light",
                                "none",
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14)),
                                );
                              }).toList(),
                              onTap: () async {
                                String? value =
                                    await HelperFunctions.getHapticFeedbackSF();
                                if (value == "normal") {
                                  HapticFeedback.mediumImpact();
                                } else if (value == "light") {
                                  HapticFeedback.lightImpact();
                                } else if (value == "heavy") {
                                  HapticFeedback.heavyImpact();
                                }
                              },
                              onChanged: (String? value) async {
                                await HelperFunctions.saveHapticFeedbackSF(
                                    value!);
                                if (value == "normal") {
                                  HapticFeedback.mediumImpact();
                                } else if (value == "light") {
                                  HapticFeedback.lightImpact();
                                } else if (value == "heavy") {
                                  HapticFeedback.heavyImpact();
                                }
                                setState(() {
                                  hapticFeedback = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      NotificationTile(
                          type: "Show Discussion Response Tile by default",
                          description:
                              "When viewing a discussion, choose wether the person's response tile is shown by default",
                          isAllowed: showDiscussionResponseTile,
                          setIsAllowed: (show) async {
                            await HelperFunctions.saveShowDisplayTileSF(show);
                            setState(() {
                              showDiscussionResponseTile = show;
                            });
                          }),
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
                          title: Text("Theme",
                              style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.secondaryDark
                                      : Colors.black)),
                          subtitle: Text("Choose the theme of the app",
                              style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.secondaryDark
                                      : Colors.grey[900])),
                          trailing: SizedBox(
                            width: 140,
                            child: DropdownButtonFormField(
                              value: theme,
                              decoration: styling
                                  .textInputDecoration()
                                  .copyWith(
                                      fillColor:
                                          styling.theme == "colorful-light"
                                              ? styling.secondary
                                              : styling.theme == "christmas"
                                                  ? styling.red
                                                  : styling.primary),
                              dropdownColor: styling.theme == "colorful-light"
                                  ? styling.secondary
                                  : styling.theme == "christmas"
                                      ? styling.red
                                      : styling.primary,
                              iconEnabledColor:
                                  styling.theme == "colorful-light"
                                      ? styling.primary
                                      : styling.theme == "christmas"
                                          ? styling.green
                                          : styling.secondary,
                              borderRadius: BorderRadius.circular(10),
                              items: [
                                "dark",
                                "light",
                                "colorful",
                                "colorful-light",
                                "dotted-dark",
                                "dotted-light",
                                "christmas",
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.replaceAll("-", " "),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14)),
                                );
                              }).toList(),
                              onTap: () async {
                                String? value =
                                    await HelperFunctions.getHapticFeedbackSF();
                                if (value == "normal") {
                                  HapticFeedback.mediumImpact();
                                } else if (value == "light") {
                                  HapticFeedback.lightImpact();
                                } else if (value == "heavy") {
                                  HapticFeedback.heavyImpact();
                                }
                              },
                              onChanged: (String? value) async {
                                await HelperFunctions.saveThemeSF(value!);
                                String? haptics =
                                    await HelperFunctions.getHapticFeedbackSF();
                                if (haptics == "normal") {
                                  HapticFeedback.mediumImpact();
                                } else if (haptics == "light") {
                                  HapticFeedback.lightImpact();
                                }
                                setState(() {
                                  theme = value;
                                  styling.setTheme(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      if (Platform.isIOS) const SizedBox(height: 20),
                      if (Platform.isIOS)
                        Text("App Icon",
                            style: TextStyle(
                                color: styling.theme == "colorful-light"
                                    ? styling.secondaryDark
                                    : styling.backgroundText,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      if (Platform.isIOS)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppIconTile(
                                    path: "assets/icon/icon.png",
                                    onTap: () {
                                      AppIconChanger.changeIcon("default");
                                      setState(() {
                                        appIcon = "default";
                                      });
                                    },
                                    isSelected: appIcon == "default"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppIconTile(
                                    path: "assets/icon/christmas_icon.png",
                                    onTap: () {
                                      AppIconChanger.changeIcon("christmas");
                                      setState(() {
                                        appIcon = "christmas";
                                      });
                                    },
                                    isSelected: appIcon == "christmas"),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: AppIconTile(
                              //       path: "assets/icon/premium_icon.png",
                              //       onTap: () {
                              //         AppIconChanger.changeIcon("premium");
                              //         setState(() {
                              //           appIcon = "premium";
                              //         });
                              //       },
                              //       isSelected: appIcon == "premium"),
                              // ),
                            ],
                          ),
                        )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
