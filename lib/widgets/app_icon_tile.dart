import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';

class AppIconTile extends StatelessWidget {
  final String path;
  final Function onTap;
  final bool isSelected;
  const AppIconTile(
      {super.key,
      required this.path,
      required this.onTap,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
        if (hapticFeedback == "normal") {
          HapticFeedback.mediumImpact();
        } else if (hapticFeedback == "light") {
          HapticFeedback.lightImpact();
        } else if (hapticFeedback == "heavy") {
          HapticFeedback.heavyImpact();
        }
        onTap();
      },
      child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(path))),
    );
  }
}
