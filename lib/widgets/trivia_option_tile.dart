import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

class TriviaOptionTile extends StatelessWidget {
  final String option;
  final void Function() onClick;
  const TriviaOptionTile(
      {super.key, required this.option, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor:
          styling.theme == "christmas" ? styling.red : styling.secondary,
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () async {
          String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
          if (hapticFeedback == "normal") {
            HapticFeedback.mediumImpact();
          } else if (hapticFeedback == "light") {
            HapticFeedback.lightImpact();
          } else if (hapticFeedback == "heavy") {
            HapticFeedback.heavyImpact();
          }
          onClick();
        },
        child: Container(
          decoration: BoxDecoration(
            color: styling.theme == "colorful-light"
                ? Colors.white
                : styling.theme == "christmas"
                    ? styling.red
                    : styling.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(option,
                style: TextStyle(
                    color: styling.theme == "colorful-light"
                        ? styling.secondaryDark
                        : Colors.white)),
          ),
        ),
      ),
    );
  }
}
