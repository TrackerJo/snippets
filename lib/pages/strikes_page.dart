import 'package:flutter/material.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/banned_page.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class StrikesPage extends StatelessWidget {
  final List<String> strikesReceived;
  final int totalStrikes;
  const StrikesPage(
      {super.key, required this.strikesReceived, required this.totalStrikes});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: "Profile Strike",
              theme: "purple",
              showBackButton: true,
              fixRight: false,
              onBackButtonPressed: () {
                if (totalStrikes >= 5) {
                  //Push and remove all routes
                  router.pushReplacement("/banned");

                  return;
                }
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                      "You recieved ${strikesReceived.length > 1 ? "${strikesReceived.length} strikes" : "a strike"}",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 20)),
                  Text("Total strikes: $totalStrikes",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                      "${strikesReceived.length > 1 ? "Strikes" : "Strike"} received for the following ${strikesReceived.length > 1 ? "reasons" : "reason"}:",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 16)),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: strikesReceived.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            " - ${strikesReceived[index]}",
                            style: TextStyle(color: styling.backgroundText),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                  const SizedBox(height: 10),
                  if (totalStrikes == 1)
                    Text(
                      "After 2 more strikes, all your snippet responses will automatically be censored!",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  if (totalStrikes == 2)
                    Text(
                      "After 1 more strike, all your snippet responses will automatically be censored!",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  if (totalStrikes == 3)
                    Text(
                      "All your snippet responses have been censored! After 2 more strikes, your account will be banned",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  if (totalStrikes == 4)
                    Text(
                      "After 1 more strike, your account will be banned",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  if (totalStrikes >= 5)
                    Text(
                      "Your account has been banned",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 10),
                  Text(
                    "If you believe this is a mistake, please contact us at kazoom.apps@gmail.com",
                    style:
                        TextStyle(color: styling.backgroundText, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        if (totalStrikes >= 5) {
                          //Push and remove all routes
                          router.pushReplacement("/banned");

                          return;
                        }
                        Navigator.of(context).pop();
                      },
                      style: styling.elevatedButtonDecoration(),
                      child:
                          Text("Okay", style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
