import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  final bool isLoggedIn;
  const UpdatePage({super.key, required this.isLoggedIn});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HelperFunctions.saveOpenedPageSF("update");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(
                title: "Update Available",
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "An update is available! Please update the app to continue.",
                  style: TextStyle(
                    fontSize: 30,
                    color: styling.theme == "colorful" ||
                            styling.theme == "colorful-light" || styling.theme == "christmas"
                        ? Colors.white
                        : styling.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.isLoggedIn) {
                      router.pushReplacement("/");
                    } else {
                      router.pushReplacement("/login");
                    }
                    Uri sms = Uri.parse(
                        'https://apps.apple.com/app/snippets-only-reality-no-bs/id6642639704');
                    if (Platform.isAndroid) {
                      sms = Uri.parse(
                          'https://us-central1-snippets2024.cloudfunctions.net/updateLink');
                    }
                    if (await launchUrl(sms)) {
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Unable to open app store"),
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
                          });
                    }
                  },
                  style: styling.elevatedButtonDecoration(),
                  child: Text("Update",
                      style: TextStyle(
                        color: styling.theme == "colorful-light"
                            ? styling.primaryDark
                            : Colors.white,
                      )),
                ),
              ],
            )),
      ],
    );
  }
}
