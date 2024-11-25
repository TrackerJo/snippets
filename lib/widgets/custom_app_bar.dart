import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final String theme;
  final void Function()? onBackButtonPressed;
  final bool showSettingsButton;
  final bool showFriendsButton;
  final void Function()? onSettingsButtonPressed;
  final void Function()? onFriendsButtonPressed;
  final bool hasFriendRequests;
  final bool showHelpButton;
  final void Function()? onHelpButtonPressed;
  final bool showShareButton;
  final void Function()? onShareButtonPressed;
  final bool showPreviewButton;
  final void Function()? onPreviewButtonPressed;
  final bool showLogoutButton;
  final void Function()? onLogoutButtonPressed;
  final int? index;
  final bool fixRight;
  const CustomAppBar(
      {super.key,
      required this.title,
      this.showBackButton = false,
      this.onBackButtonPressed,
      this.showSettingsButton = false,
      this.onSettingsButtonPressed,
      this.theme = "purple",
      this.showFriendsButton = false,
      this.onFriendsButtonPressed,
      this.hasFriendRequests = false,
      this.showHelpButton = false,
      this.showShareButton = false,
      this.onShareButtonPressed,
      this.onHelpButtonPressed,
      this.showPreviewButton = false,
      this.onPreviewButtonPressed,
      this.showLogoutButton = false,
      this.onLogoutButtonPressed,
      this.index,
      this.fixRight = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          elevation: 10,
          shadowColor: styling.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(23),
            bottomRight: Radius.circular(23),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            decoration: ShapeDecoration(
              gradient: theme == "blue"
                  ? styling.getBlueGradient()
                  : styling.getPurpleBarGradient(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
              ),
            ),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: AutoSizeText(
                  maxLines: 1,
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: styling.theme == "colorful-light"
                        ? Colors.white
                        : Colors.black,
                    decorationColor: Colors.black,
                    decorationThickness: 2,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
          leading: showBackButton
              ? IconButton(
                  splashColor: Colors.transparent,
                  splashRadius: 25,
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: styling.theme == "colorful-light"
                          ? Colors.white
                          : Colors.black),
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

                    if (onBackButtonPressed != null) {
                      onBackButtonPressed!();
                    }
                  },
                  color: Colors.black,
                )
              : showShareButton
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        splashColor: styling.primary,
                        splashRadius: 25,
                        icon: Icon(Icons.ios_share_outlined,
                            color: styling.theme == "colorful-light"
                                ? Colors.white
                                : Colors.black),
                        onPressed: onShareButtonPressed,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    )
                  : showFriendsButton
                      ? const SizedBox(
                          width: 15,
                          height: 0,
                        )
                      : null,
          // actions: [],
          actions: [
            if (fixRight)
              const SizedBox(
                width: 40,
                height: 0,
              ),
            if (title == "Responses" ||
                title == "Friends" ||
                title == "Results")
              const SizedBox(
                width: 50,
                height: 0,
              ),
            if (showPreviewButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  splashColor: styling.primary,
                  splashRadius: 25,
                  icon: Icon(Icons.preview,
                      color: styling.theme == "colorful-light"
                          ? Colors.white
                          : Colors.black),
                  onPressed: onPreviewButtonPressed,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            if (showHelpButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  splashColor: styling.primary,
                  splashRadius: 25,
                  icon: Icon(Icons.help_outline,
                      color: styling.theme == "colorful-light"
                          ? Colors.white
                          : Colors.black),
                  onPressed: onHelpButtonPressed,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            if (showSettingsButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  splashColor: styling.primary,
                  splashRadius: 25,
                  icon: Icon(Icons.settings,
                      color: styling.theme == "colorful-light"
                          ? Colors.white
                          : Colors.black),
                  onPressed: onSettingsButtonPressed,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            if (showLogoutButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  splashColor: styling.primary,
                  splashRadius: 25,
                  icon: Icon(Icons.logout,
                      color: styling.theme == "colorful-light"
                          ? Colors.white
                          : Colors.black),
                  onPressed: onLogoutButtonPressed,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            if (showFriendsButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    //Dot
                    if (hasFriendRequests)
                      Positioned(
                        right: 10,
                        top: 5,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    IconButton(
                      splashColor: styling.primary,
                      splashRadius: 25,
                      icon: Icon(Icons.people,
                          color: styling.theme == "colorful-light"
                              ? Colors.white
                              : Colors.black),
                      onPressed: onFriendsButtonPressed,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
