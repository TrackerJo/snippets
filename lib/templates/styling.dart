import 'package:flutter/material.dart';

class Styling {
  Color primaryLight = const Color(0xB5D1AEFF);
  Color primary = const Color.fromARGB(255, 164, 111, 221);
  Color primarySolid = const Color.fromARGB(255, 209, 174, 255);
  Color primaryDark = const Color.fromARGB(255, 138, 50, 233);
  Color secondary =
      const Color.fromARGB(255, 130, 188, 255); // Brighter sky blue
  Color secondarySolid = const Color.fromARGB(255, 151, 224, 255);
  Color background = Colors.white;
  Color darkBackground = const Color(0xFF232323);
  Color secondaryInput = Colors.lightBlueAccent;
  Color secondaryDark =
      const Color.fromARGB(209, 48, 131, 194); // Brighter dark blue
  Color sunset = const Color.fromARGB(255, 249, 156, 22);

  Color primaryInput = const Color.fromARGB(255, 183, 128, 255);

  Color backgroundText = Colors.black;

  String theme = "dark";

// Color.fromARGB(255, 135, 195, 143)
  Color green = Color.fromARGB(255, 135, 195, 143);
  Color greenLight = Color.fromARGB(255, 135, 195, 143);
  Color red = Color.fromARGB(255, 218, 44, 56);

  Key key = UniqueKey();

  void refresh() {
    key = UniqueKey();
  }

  void setTheme(String theme) {
    switch (theme) {
      case "dark":
        background = const Color(0xFF232323);
        backgroundText = Colors.white;
        this.theme = "dark";
        break;
      case "light":
        background = Colors.white;
        backgroundText = Colors.black;
        this.theme = "light";
        break;
      case "colorful":
        this.theme = "colorful";
        backgroundText = Colors.black;
        break;
      case "colorful-light":
        this.theme = "colorful-light";
        backgroundText = Colors.white;
        break;
      case "dotted-dark":
        this.theme = "dotted-dark";
        background = const Color(0xFF232323);
        backgroundText = Colors.white;
        break;
      case "dotted-light":
        this.theme = "dotted-light";
        background = Colors.white;
        backgroundText = Colors.black;
        break;
      case "christmas":
        this.theme = "christmas";
        background = red;
        backgroundText = Colors.white;
        break;
      default:
        this.theme = "dark";
        background = const Color(0xFF232323);
        backgroundText = Colors.white;
    }
  }

  LinearGradient getBlueGradient() {
    return LinearGradient(
      begin: const Alignment(0.00, -1.00),
      end: const Alignment(0, 1),
      colors: [secondary, secondaryDark],
    );
  }

  LinearGradient getSnippetGradient() {
    if (theme == "colorful-light") {
      return LinearGradient(
        begin: const Alignment(0.00, -1.00),
        end: const Alignment(0, 1),
        colors: [Colors.white, Colors.white],
      );
    } else if (theme == "christmas") {
      return LinearGradient(
        colors: [
          green,
          green,
          green,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, .5, 1.0], // Adjust for blending balance
      );
    }
    return LinearGradient(
      begin: const Alignment(0.00, -1.00),
      end: const Alignment(0, 1),
      colors: [secondary, secondaryInput],
    );
  }

  LinearGradient getBOTWGradient() {
    return LinearGradient(
      begin: const Alignment(0.00, -1.00),
      end: const Alignment(0, 1),
      colors: [secondary, secondaryInput],
    );
  }

  LinearGradient getPurpleBlueGradient() {
    if (theme == "colorful-light") {
      return LinearGradient(
        begin: const Alignment(0.00, -1.00),
        end: const Alignment(0, 1),
        colors: [Colors.white, Colors.white],
      );
    } else if (theme == "christmas") {
      return LinearGradient(
        colors: [
          green,
          // Color(0xFFFFFFFF), // White
          green
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 1.0], // Adjust for blending balance
      );
    }
    return const LinearGradient(
      begin: Alignment(0.00, -1.00),
      end: Alignment(0, 1),
      colors: [
        Color.fromARGB(223, 119, 214, 255),
        Color.fromARGB(181, 163, 93, 255)
      ],
    );
  }

  LinearGradient getPurpleBarGradient() {
    if (theme == "light") {
      return LinearGradient(
        begin: const Alignment(0.00, -1.50),
        end: const Alignment(0, 1),
        colors: [primary, primary],
      );
    } else if (theme == "christmas") {
      return LinearGradient(
        begin: const Alignment(0.00, -1.00),
        end: const Alignment(0, 1),
        colors: [green, greenLight],
      );
    }
    return LinearGradient(
      begin: const Alignment(0.00, -1.00),
      end: const Alignment(0, 1),
      colors: [primary, primaryDark],
    );
  }

  LinearGradient getPurpleGradient() {
    if (theme == "light") {
      return LinearGradient(
        begin: const Alignment(0.00, -.70),
        end: const Alignment(0, 1),
        colors: [primary, primary],
      );
    } else if (theme == "christmas") {
      return LinearGradient(
        begin: const Alignment(0.00, -1.00),
        end: const Alignment(0, 1.5),
        colors: [greenLight, green],
      );
    }

    return LinearGradient(
      begin: const Alignment(0.00, -1.00),
      end: const Alignment(0, 1.5),
      colors: [primary, primaryDark],
    );
  }

  LinearGradient getBlackGradient() {
    if (theme == "christmas") {
      return const LinearGradient(
        begin: Alignment(0.00, -1.00),
        end: Alignment(0, 1),
        colors: [
          //Sunrise gradient
          Color.fromARGB(255, 76, 76, 76),
          Color.fromARGB(255, 76, 76, 76),
        ],
      );
    }
    return const LinearGradient(
      begin: Alignment(0.00, -1.00),
      end: Alignment(0, 1),
      colors: [
        //Sunrise gradient
        Color.fromARGB(255, 145, 145, 145),
        Color.fromARGB(255, 44, 44, 44),
      ],
    );
  }

  LinearGradient widgetBPGradient() {
    return const LinearGradient(
      begin: Alignment(0.00, -1.00),
      end: Alignment(0, 1),
      colors: [
        //Sunrise gradient
        Color.fromARGB(255, 10, 122, 255),

        Color.fromARGB(255, 157, 79, 207),
      ],
    );
  }

  LinearGradient widgetBGGradient() {
    return const LinearGradient(
      begin: Alignment(0.00, -1.00),
      end: Alignment(0, 1),
      colors: [
        //Sunrise gradient
        Color.fromARGB(255, 10, 122, 255),
        Color.fromARGB(255, 38, 169, 94),
      ],
    );
  }

  LinearGradient widgetORGradient() {
    return const LinearGradient(
      begin: Alignment(0.00, -1.00),
      end: Alignment(0, 1),
      colors: [
        //Sunrise gradient
        Color.fromARGB(255, 245, 139, 5),
        Color.fromARGB(255, 228, 57, 43),
      ],
    );
  }

  LinearGradient widgetYRGradient() {
    return const LinearGradient(
      begin: Alignment(0.00, -1.00),
      end: Alignment(0, 1),
      colors: [
        //Sunrise gradient
        Color.fromARGB(255, 241, 190, 2),
        Color.fromARGB(255, 228, 57, 43),
      ],
    );
  }

  LinearGradient widgetPPGradient() {
    return const LinearGradient(
      begin: Alignment(0.00, -1.00),
      end: Alignment(0, 1),
      colors: [
        //Sunrise gradient
        Color.fromARGB(255, 236, 45, 82),
        Color.fromARGB(255, 153, 71, 194),
      ],
    );
  }

  InputDecoration textInputDecoration() {
    return InputDecoration(
        labelStyle: TextStyle(
          color: theme == "colorful-light" ? Colors.white : Colors.black,
        ),
        hintStyle: TextStyle(
          color: theme == "colorful-light" ? Colors.white : Colors.black,
        ),
        errorStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 102, 91),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        filled: true,
        fillColor:
            theme == "christmas" ? Color.fromARGB(255, 135, 195, 143) : primary,
        floatingLabelBehavior: FloatingLabelBehavior.never);
  }

  ButtonStyle elevatedButtonDecoration() {
    return ElevatedButton.styleFrom(
        elevation: 10,
        shadowColor: theme == "christmas" ? green : secondaryDark,
        minimumSize: const Size(100, 50),
        textStyle: TextStyle(
            color: theme == "colorful-light" ? primary : Colors.black),
        backgroundColor: theme == "colorful-light"
            ? Colors.white
            : theme == "christmas"
                ? green
                : secondaryInput,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ));
  }

  ButtonStyle elevatedButtonDecorationBlue() {
    return ElevatedButton.styleFrom(
        elevation: 10,
        shadowColor: theme == "christmas" ? green : secondary,
        minimumSize: const Size(100, 50),
        backgroundColor: theme == "christmas" ? green : secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ));
  }

  ButtonStyle elevatedButtonDecorationPurple() {
    return ElevatedButton.styleFrom(
        elevation: 10,
        shadowColor: theme == "christmas" ? red : primaryInput,
        minimumSize: const Size(100, 50),
        backgroundColor: theme == "christmas" ? red : primaryInput,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ));
  }

  String font = "Inknut Antiqua";
}
