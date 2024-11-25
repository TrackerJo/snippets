import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/modify_profile_page.dart';
import 'package:snippets/widgets/helper_functions.dart';

class SettingTile extends StatelessWidget {
  final String setting;
  final bool showForwardIcon;
  final void Function() onTap;
  const SettingTile(
      {super.key,
      required this.setting,
      this.showForwardIcon = true,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        splashColor: styling.secondaryDark,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        tileColor: styling.theme == "colorful-light"
            ? Colors.white
            : styling.secondary,
        title: Text(setting,
            style: TextStyle(
                color: styling.theme == "colorful-light"
                    ? styling.secondaryDark
                    : Colors.black)),
        trailing: showForwardIcon
            ? Icon(Icons.arrow_forward_ios,
                color: styling.theme == "colorful-light"
                    ? styling.secondaryDark
                    : Colors.black)
            : null,
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
      ),
    );
  }
}
