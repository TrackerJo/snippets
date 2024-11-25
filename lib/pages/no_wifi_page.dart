import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class NoWifiPage extends StatefulWidget {
  const NoWifiPage({super.key});

  @override
  State<NoWifiPage> createState() => _NoWifiPageState();
}

class _NoWifiPageState extends State<NoWifiPage> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HelperFunctions.saveOpenedPageSF("nowifi");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            BackgroundTile(),
            Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: CustomAppBar(
                    title: "No Wifi",
                    showBackButton: false,
                  ),
                ),
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 20),
                    Text(
                      "Oh no! Looks like you're offline",
                      style: TextStyle(
                        color: styling.theme == "colorful" ||
                                styling.theme == "colorful-light"
                            ? Colors.white
                            : styling.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Please connect to a wifi network to continue",
                      style: TextStyle(
                        color: styling.theme == "colorful" ||
                                styling.theme == "colorful-light"
                            ? Colors.white
                            : styling.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator(
                            color: styling.primary,
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              //Check if connected to wifi
                              setState(() {
                                isLoading = true;
                              });
                              if (await InternetConnection()
                                  .hasInternetAccess) {
                                router.pushReplacement("/");
                              }
                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: styling.elevatedButtonDecoration(),
                            child: Text("Retry",
                                style: TextStyle(
                                  color: styling.theme == "colorful-light"
                                      ? styling.primaryDark
                                      : Colors.black,
                                )),
                          )
                  ]),
                )),
          ],
        ));
  }
}
