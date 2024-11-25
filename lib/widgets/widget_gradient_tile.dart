import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';

class WidgetGradientTile extends StatelessWidget {
  final LinearGradient gradient;
  final String name;
  final Function onTap;
  final bool isSelected;
  const WidgetGradientTile(
      {super.key,
      required this.gradient,
      required this.name,
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
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
