import 'package:flutter/material.dart';
import 'package:snippets/templates/colorsSys.dart';

var textInputDecoration = InputDecoration(
    labelStyle: const TextStyle(color: Colors.black),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    filled: true,
    fillColor: ColorSys.secondary,
    floatingLabelBehavior: FloatingLabelBehavior.never);
