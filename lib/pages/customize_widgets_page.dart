import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:snippets/widgets/widget_gradient_tile.dart';

class CustomizeWidgetsPage extends StatefulWidget {
  const CustomizeWidgetsPage({super.key});

  @override
  State<CustomizeWidgetsPage> createState() => _CustomizeWidgetsPageState();
}

class _CustomizeWidgetsPageState extends State<CustomizeWidgetsPage> {
  String botwGradient = "bluePurple";
  String snippetGradient = "bluePurple";
  String responseGradient = "bluePurple";

  void load() async {
    String? botwConfig =
        await WidgetKit.getItem('botwConfig', 'group.kazoom_snippets');
    String? snippetsConfig =
        await WidgetKit.getItem('snippetsConfig', 'group.kazoom_snippets');
    String? snippetsResponsesConfig = await WidgetKit.getItem(
        'snippetsResponsesConfig', 'group.kazoom_snippets');
    Map<String, dynamic> botwConfigMap = jsonDecode(botwConfig ?? "");
    botwGradient = botwConfigMap["gradient"];
    Map<String, dynamic> snippetsConfigMap = jsonDecode(snippetsConfig ?? "");
    snippetGradient = snippetsConfigMap["gradient"];
    Map<String, dynamic> snippetsResponsesConfigMap =
        jsonDecode(snippetsResponsesConfig ?? "");
    responseGradient = snippetsResponsesConfigMap["gradient"];
    setState(() {});
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
                  title: "Customize Widgets",
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
                    Text(
                      "Select a color for the Snippet of the Week Widget",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: styling.backgroundText),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WidgetGradientTile(
                          gradient: styling.widgetBPGradient(),
                          name: "bluePurple",
                          onTap: () {
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
                          },
                          isSelected: botwGradient == "bluePurple",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetBGGradient(),
                          name: "blueGreen",
                          onTap: () {
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
                          },
                          isSelected: botwGradient == "blueGreen",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetORGradient(),
                          name: "orangeRed",
                          onTap: () {
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
                          },
                          isSelected: botwGradient == "orangeRed",
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WidgetGradientTile(
                          gradient: styling.widgetYRGradient(),
                          name: "yellowRed",
                          onTap: () {
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
                          },
                          isSelected: botwGradient == "yellowRed",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetPPGradient(),
                          name: "pinkPurple",
                          onTap: () {
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
                          },
                          isSelected: botwGradient == "pinkPurple",
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Select a color for the Current Snippet Widget",
                      style: TextStyle(color: styling.backgroundText),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WidgetGradientTile(
                          gradient: styling.widgetBPGradient(),
                          name: "bluePurple",
                          onTap: () {
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
                          },
                          isSelected: snippetGradient == "bluePurple",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetBGGradient(),
                          name: "blueGreen",
                          onTap: () {
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
                          },
                          isSelected: snippetGradient == "blueGreen",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetORGradient(),
                          name: "orangeRed",
                          onTap: () {
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
                          },
                          isSelected: snippetGradient == "orangeRed",
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WidgetGradientTile(
                          gradient: styling.widgetYRGradient(),
                          name: "yellowRed",
                          onTap: () {
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
                          },
                          isSelected: snippetGradient == "yellowRed",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetPPGradient(),
                          name: "pinkPurple",
                          onTap: () {
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
                          },
                          isSelected: snippetGradient == "pinkPurple",
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Select a color for the Responses Widget",
                      style: TextStyle(color: styling.backgroundText),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WidgetGradientTile(
                          gradient: styling.widgetBPGradient(),
                          name: "bluePurple",
                          onTap: () {
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
                          },
                          isSelected: responseGradient == "bluePurple",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetBGGradient(),
                          name: "blueGreen",
                          onTap: () {
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
                          },
                          isSelected: responseGradient == "blueGreen",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetORGradient(),
                          name: "orangeRed",
                          onTap: () {
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
                          },
                          isSelected: responseGradient == "orangeRed",
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WidgetGradientTile(
                          gradient: styling.widgetYRGradient(),
                          name: "yellowRed",
                          onTap: () {
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
                          },
                          isSelected: responseGradient == "yellowRed",
                        ),
                        WidgetGradientTile(
                          gradient: styling.widgetPPGradient(),
                          name: "pinkPurple",
                          onTap: () {
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
                          },
                          isSelected: responseGradient == "pinkPurple",
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
