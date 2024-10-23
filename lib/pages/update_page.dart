import 'package:flutter/material.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
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
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "Update Available",
          ),
        ),
        backgroundColor: ColorSys.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "An update is available! Please update the app to continue.",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
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
              style: elevatedButtonDecoration,
              child:
                  const Text("Update", style: TextStyle(color: Colors.white)),
            ),
          ],
        ));
  }
}
