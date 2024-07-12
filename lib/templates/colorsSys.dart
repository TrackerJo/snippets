import 'package:flutter/material.dart';

class ColorSys {
  static Color primary = const Color(0xB5D1AEFF);
  static Color primarySolid = const Color.fromARGB(255, 209, 174, 255);
  static Color secondary = const Color.fromARGB(224, 151, 224, 255);
  static Color secondarySolid = const Color.fromARGB(255, 151, 224, 255);
  static Color background = const Color(0xFF232323);
  static Color green = const Color(0xD185FFBD);
  static Color sunset = const Color.fromARGB(255, 243, 153, 18);
  static LinearGradient blueGreenGradient = LinearGradient(
    begin: const Alignment(0.00, -1.00),
    end: const Alignment(0, 1),
    colors: [secondary, green],
  );
  static LinearGradient purpleBlueGradient = LinearGradient(
    begin: const Alignment(0.00, -1.00),
    end: const Alignment(0, 1),
    colors: [primary, secondary],
  );
  static LinearGradient purpleBarGradient = LinearGradient(
    begin: const Alignment(0.00, -1.00),
    end: const Alignment(0, 1),
    colors: [primary, const Color.fromARGB(255, 199, 156, 247)],
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
    begin: const Alignment(0.00, -1.00),
    end: const Alignment(0, 1),
    colors: [
      //Sunrise gradient
      sunset,
      const Color.fromARGB(255, 255, 46, 30),
    ],
  );
  static LinearGradient sunsetBarGradient = LinearGradient(
    begin: const Alignment(0.00, -1.00),
    end: const Alignment(0, 1),
    colors: [
      //Sunrise gradient
      sunset,
      const Color.fromARGB(255, 253, 74, 42),
    ],
  );
}
