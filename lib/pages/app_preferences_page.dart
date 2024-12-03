import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:go_router/go_router.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/settings_page.dart';
import 'package:snippets/pages/swipe_pages.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/custom_page_route.dart';
import 'package:snippets/widgets/helper_functions.dart';
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
  void load() async {
    String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
    String theme = await HelperFunctions.getThemeSF();
    setState(() {
      this.hapticFeedback = hapticFeedback;
      this.theme = theme;
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
                              : styling.secondary,
                          title: Text("Haptic Feedback Intensity",
                              style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.secondaryDark
                                      : Colors.black)),
                          subtitle: Text(
                              "Choose the intensity of the haptic feedback",
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
                                              : styling.primary),
                              dropdownColor: styling.theme == "colorful-light"
                                  ? styling.secondary
                                  : styling.primary,
                              iconEnabledColor:
                                  styling.theme == "colorful-light"
                                      ? styling.primary
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          tileColor: styling.theme == "colorful-light"
                              ? Colors.white
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
                                              : styling.primary),
                              dropdownColor: styling.theme == "colorful-light"
                                  ? styling.secondary
                                  : styling.primary,
                              iconEnabledColor:
                                  styling.theme == "colorful-light"
                                      ? styling.primary
                                      : styling.secondary,
                              borderRadius: BorderRadius.circular(10),
                              items: [
                                "dark",
                                "light",
                                "colorful",
                                "colorful-light",
                                "dotted-dark",
                                "dotted-light",
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
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
