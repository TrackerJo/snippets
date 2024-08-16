import 'package:flutter/material.dart';
import 'package:snippets/templates/colorsSys.dart';

var textInputDecoration = InputDecoration(
    labelStyle: const TextStyle(color: Colors.black),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(color: Colors.transparent)
    ),
    enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(color: Colors.transparent)

                        ),
    filled: true,
    fillColor: ColorSys.primary,
    floatingLabelBehavior: FloatingLabelBehavior.never);

var elevatedButtonDecoration =  ElevatedButton.styleFrom(
                        elevation: 10,
                        shadowColor: ColorSys.primary,
                        minimumSize: const Size(100, 50),
                        backgroundColor: Color.fromARGB(255, 183, 128, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )
                      );
var elevatedButtonDecorationBlue =  ElevatedButton.styleFrom(
                        elevation: 10,
                        shadowColor: Color.fromARGB(223, 119, 214, 255),
                        minimumSize: const Size(100, 50),
                        backgroundColor: Color.fromARGB(223, 119, 214, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )
                      );