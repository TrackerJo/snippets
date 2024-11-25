import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

class NotificationTile extends StatelessWidget {
  final String type;
  final String description;
  final bool isAllowed;
  final void Function(bool isAllowed) setIsAllowed;
  const NotificationTile(
      {super.key,
      required this.type,
      required this.description,
      required this.isAllowed,
      required this.setIsAllowed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        tileColor: styling.theme == "colorful-light"
            ? Colors.white
            : styling.secondary,
        title: Text(type,
            style: TextStyle(
                color: styling.theme == "colorful-light"
                    ? styling.secondaryDark
                    : Colors.black)),
        subtitle: Text(description,
            style: TextStyle(
                color: styling.theme == "colorful-light"
                    ? styling.secondaryDark
                    : Colors.grey[900])),
        trailing: Switch(
          activeColor: styling.primary,
          inactiveThumbColor: styling.secondaryDark,
          value: isAllowed,
          onChanged: (value) async {
            String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
            if (hapticFeedback == "normal") {
              HapticFeedback.mediumImpact();
            } else if (hapticFeedback == "light") {
              HapticFeedback.lightImpact();
            } else if (hapticFeedback == "heavy") {
              HapticFeedback.heavyImpact();
            }
            setIsAllowed(value);
          },
        ),
      ),
    );
  }
}
