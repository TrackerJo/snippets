import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

class StatsTile extends StatelessWidget {
  final String title;
  final String description;
  final String value;

  const StatsTile({
    super.key,
    required this.title,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          tileColor: styling.theme == "colorful-light"
              ? Colors.white
              : styling.theme == "christmas"
                  ? styling.green
                  : styling.secondary,
          title: Text(title,
              style: TextStyle(
                  color: styling.theme == "colorful-light"
                      ? styling.secondaryDark
                      : Colors.black)),
          subtitle: Text(description,
              style: TextStyle(
                  color: styling.theme == "colorful-light"
                      ? styling.secondaryDark
                      : Colors.grey[900])),
          trailing: Text(value,
              style: TextStyle(
                  fontSize: 18,
                  color: styling.theme == "colorful-light"
                      ? styling.secondaryDark
                      : Colors.black))),
    );
  }
}
