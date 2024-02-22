import 'package:flutter/material.dart';

import 'package:snippets/templates/colorsSys.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final String theme;
  final void Function()? onBackButtonPressed;
  final bool showSettingsButton;
  final void Function()? onSettingsButtonPressed;
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackButtonPressed,
    this.showSettingsButton = false,
    this.onSettingsButtonPressed,
    this.theme = "purple",
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          elevation: 10,
          shadowColor: theme == "sunset"
              ? ColorSys.sunsetGradient.colors[1]
              : theme == "sunrise"
                  ? ColorSys.sunriseGradient.colors[0]
                  : theme == "blue"
                      ? ColorSys.blueGreenGradient.colors[0]
                      : ColorSys.purpleBlueGradient.colors[0],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(23),
            bottomRight: Radius.circular(23),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            decoration: ShapeDecoration(
              gradient: theme == "sunset"
                  ? ColorSys.sunsetBarGradient
                  : theme == "sunrise"
                      ? ColorSys.sunriseBarGradient
                      : theme == "blue"
                          ? ColorSys.blueGreenGradient
                          : ColorSys.purpleBarGradient,
              shape: RoundedRectangleBorder(
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
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Inknut Antiqua',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          leading: showBackButton
              ? IconButton(
                  splashColor: Colors.transparent,
                  splashRadius: 25,
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: onBackButtonPressed,
                  color: Colors.black,
                )
              : null,
          // actions: [],
          actions: [
            if (showSettingsButton)
              IconButton(
                splashColor: ColorSys.primary,
                splashRadius: 25,
                icon: const Icon(Icons.settings),
                onPressed: onSettingsButtonPressed,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
          ],
        ),
      ],
    );
  }
}
