import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetGradientTile extends StatelessWidget {
  final LinearGradient gradient;
  final String name;
  final Function onTap;
  final bool isSelected;
  const WidgetGradientTile({super.key, required this.gradient, required this.name, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return 
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
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