import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snippets/main.dart';

class BackgroundTile extends StatelessWidget {
  const BackgroundTile({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: Container(
  //       color: const Color(0xFF232323),
  //       child: Wrap(
  //         children: List<Widget>.generate(10000, (int index) {
  //           return Padding(
  //             padding: const EdgeInsets.all(4.0),
  //             child: Icon(
  //               Icons.circle,
  //               color: styling.primary.withOpacity(0.5),
  //               size: 8,
  //             ),
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

// Each dot is 8px + 16px padding (8px on each side)
    const double dotSize = 8.0;
    const double dotPadding = 16.0; // 8px padding * 2
    const double totalDotSpace = dotSize + dotPadding;

// Calculate dots per row and column
    int dotsPerRow = (screenWidth / totalDotSpace).ceil();
    int dotsPerColumn = (screenHeight / totalDotSpace).ceil();

// Total dots needed
    int totalDots = dotsPerRow * dotsPerColumn;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient:
              styling.theme == "colorful" || styling.theme == "colorful-light"
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        styling.primary,
                        styling.secondary,
                      ],
                    )
                  : null,
          color:
              styling.theme == "colorful" || styling.theme == "colorful-light"
                  ? null
                  : styling.background,
        ),
        child: styling.theme == "dotted-dark"
            ? SizedBox(
                width: double.infinity,
                child: Center(
                  child: Wrap(
                    children: List<Widget>.generate(totalDots, (int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.circle,
                          color: const Color.fromARGB(255, 52, 52, 52)
                              .withOpacity(0.5),
                          size: 8,
                        ),
                      );
                    }),
                  ),
                ),
              )
            : styling.theme == "dotted-light"
                ? SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Wrap(
                        children: List<Widget>.generate(totalDots, (int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.circle,
                              color: styling.primary.withOpacity(0.5),
                              size: 8,
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                : null,
      ),
    );
  }
}
