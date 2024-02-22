import 'package:flutter/material.dart';

class ColorSys {
  static Color primary = Color(0xB5D1AEFF);
  static Color primarySolid = Color.fromARGB(255, 209, 174, 255);
  static Color secondary = Color.fromARGB(224, 151, 224, 255);
  static Color secondarySolid = Color.fromARGB(255, 151, 224, 255);
  static Color background = Color(0xFF232323);
  static Color green = Color(0xD185FFBD);
  static Color sunset = Color.fromARGB(255, 243, 153, 18);
  static LinearGradient blueGreenGradient = LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [secondary, green],
  );
  static LinearGradient purpleBlueGradient = LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [primary, secondary],
  );
  static LinearGradient purpleBarGradient = LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [primary, Color.fromARGB(255, 199, 156, 247)],
  );
  static LinearGradient sunriseGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 247, 205, 93),
      Color.fromARGB(255, 253, 128, 70)
    ],
  );
  static LinearGradient sunriseBarGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 247, 173, 93),
      Color.fromARGB(255, 253, 128, 70)
    ],
  );
  static LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      sunset,
      Color.fromARGB(255, 255, 46, 30),
    ],
  );
  static LinearGradient sunsetBarGradient = LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      sunset,
      Color.fromARGB(255, 253, 74, 42),
    ],
  );
}
