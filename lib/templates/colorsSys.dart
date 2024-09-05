import 'package:flutter/material.dart';

class ColorSys {
  static Color primary = const Color(0xB5D1AEFF);
  static Color primarySolid = const Color.fromARGB(255, 209, 174, 255);
  static Color primaryDark = const Color.fromARGB(255, 174, 111, 255);
  static Color secondary = const Color.fromARGB(224, 151, 224, 255);
  static Color secondarySolid = const Color.fromARGB(255, 151, 224, 255);
  static Color background = const Color(0xFF232323);


  static Color green = const Color.fromARGB(209, 44, 157, 255);
  static Color sunset = const Color.fromARGB(255, 249, 156, 22);
  static Color purpleBtn = const Color.fromARGB(255, 186, 127, 255);
  static Color primaryInput = const Color.fromARGB(255, 183, 128, 255);
  static LinearGradient blueGreenGradient = LinearGradient(
    begin: const Alignment(0.00, -1.00),
    end: const Alignment(0, 1),
    colors: [secondary, green],
  );
  static LinearGradient purpleBlueGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [ Color.fromARGB(223, 119, 214, 255),Color.fromARGB(181, 163, 93, 255)],
  );
  static LinearGradient purpleBarGradient = LinearGradient(
    begin: const Alignment(0.00, -1.00),
    end: const Alignment(0, 1),
    colors: [primarySolid, const Color.fromARGB(255, 178, 110, 255)],
  );
  static LinearGradient sunriseGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 255, 141, 35),
      Color.fromARGB(255, 233, 24, 45)
      
    ],
  );
  static LinearGradient sunriseBarGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 253, 214, 0),
      Color.fromARGB(255,249, 120, 0)
    ],
  );
  static LinearGradient sunsetGradient = LinearGradient(
    begin: const Alignment(0.00, -1.00),
    end: const Alignment(0, 1),
    colors: [
      //Sunrise gradient
      sunset,
      const Color.fromARGB(255, 253, 53, 0),
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
  static LinearGradient blackGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 145, 145, 145),

      Color.fromARGB(255, 44, 44, 44),
    ],
  );

  static LinearGradient widgetBPGradient = const LinearGradient(

    begin: Alignment(0.00, -1.00),

    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255,10,122,255),

      Color.fromARGB(255,157, 79, 207),
    ],
  );
  static LinearGradient widgetBGGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 10, 122, 255),
      Color.fromARGB(255, 38, 169, 94),
    ],
  );

  static LinearGradient widgetORGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 245, 139, 5),
      Color.fromARGB(255, 228, 57, 43),
    ],
  );

  static LinearGradient widgetYRGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 241, 190, 2),
      Color.fromARGB(255, 228, 57, 43),
    ],
  );

  static LinearGradient widgetPPGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      //Sunrise gradient
      Color.fromARGB(255, 236, 45, 82),
      Color.fromARGB(255, 153, 71, 194),
    ],
  );
}
