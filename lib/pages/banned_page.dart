import 'package:flutter/material.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class BannedPage extends StatelessWidget {
  const BannedPage({super.key});

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
              title: "Account Banned",
              theme: "purple",
              showBackButton: false,
              fixRight: false,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                      "Your account has been banned for violating our community guidelines.",
                      style: TextStyle(
                          color: styling.backgroundText, fontSize: 20)),
                  const SizedBox(height: 10),
                  Text(
                    "If you believe this is a mistake, please contact us at kazoom.apps@gmail.com",
                    style:
                        TextStyle(color: styling.backgroundText, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
