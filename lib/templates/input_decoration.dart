import 'package:flutter/material.dart';
import 'package:snippets/templates/colorsSys.dart';

var textInputDecoration = InputDecoration(
    labelStyle: const TextStyle(color: Colors.black),
    errorStyle: const TextStyle(color: Color.fromARGB(255, 255, 102, 91),),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide(color: Colors.transparent)
    ),
    enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide(color: Colors.transparent)

                        ),
    filled: true,
    
    fillColor: ColorSys.primary,
    floatingLabelBehavior: FloatingLabelBehavior.never);

var elevatedButtonDecoration =  ElevatedButton.styleFrom(
                        elevation: 10,
                        shadowColor: ColorSys.purpleBlueGradient.colors[1],
                        minimumSize: const Size(100, 50),
                        backgroundColor: const Color.fromARGB(255, 183, 128, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )
                      );
var elevatedButtonDecorationBlue =  ElevatedButton.styleFrom(
                        elevation: 10,
                        shadowColor: const Color.fromARGB(223, 119, 214, 255),
                        minimumSize: const Size(100, 50),
                        backgroundColor: const Color.fromARGB(223, 119, 214, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )
                      );