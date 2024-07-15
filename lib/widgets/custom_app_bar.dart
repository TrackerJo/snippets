import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:snippets/templates/colorsSys.dart';

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
      this.hasFriendRequests = false});

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
                  onPressed:(){
                    HapticFeedback.mediumImpact();

                    if(onBackButtonPressed != null){
                      onBackButtonPressed!();
                    }
                  } ,
                  color: Colors.black,
                )
              : null,
          // actions: [],
          actions: [
            if (showSettingsButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  splashColor: ColorSys.primary,
                  splashRadius: 25,
                  icon: const Icon(Icons.settings),
                  onPressed: onSettingsButtonPressed,
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
                      splashColor: ColorSys.primary,
                      splashRadius: 25,
                      icon: const Icon(Icons.people),
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
