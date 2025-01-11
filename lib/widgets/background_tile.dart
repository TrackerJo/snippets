import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/snowflake.dart';

class BackgroundTile extends StatelessWidget {
  final bool rounded;
  final bool flatBack;
  const BackgroundTile(
      {super.key, this.rounded = false, this.flatBack = false});

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
    final List<Offset> snowflakePositions = [
      Offset(screenWidth * 0.1, screenHeight * 0.13),
      Offset(screenWidth * 0.7, screenHeight * 0.16),
      Offset(screenWidth * 0.3, screenHeight * 0.6),
      Offset(screenWidth * 0.74, screenHeight * 0.76),
      Offset(screenWidth * 0.12, screenHeight * 0.8),
      Offset(screenWidth * 0.6, screenHeight * 0.4),
      Offset(screenWidth * 0.25, screenHeight * 0.3),
      Offset(screenWidth * 0.15, screenHeight * 0.5),
      Offset(screenWidth * 0.75, screenHeight * 0.6),
      Offset(screenWidth * 0.64, screenHeight * 0.32),
      Offset(screenWidth * 0.55, screenHeight * 0.76),
      Offset(screenWidth * 0.5, screenHeight * 0.18),
      Offset(screenWidth * 0.65, screenHeight * 0.92),
      Offset(screenWidth * 0.85, screenHeight * 0.03),
      Offset(screenWidth * 0.15, screenHeight * 0.07),
    ];

    final List<double> snowflakeSizes = [
      100,
      100,
      100,
      100,
      100,
      100,
      100,
      25,
      25,
      25,
      25,
      25,
      25,
      25,
      25
    ];

    const List<double> strokeWidths = [
      2,
      2,
      2,
      2,
      2,
      2,
      2,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1
    ];

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
          borderRadius: rounded
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                )
              : null,
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
                  : styling.theme == "christmas"
                      ? LinearGradient(
                          colors: [
                            styling.red,
                            styling.red,
                            styling.red,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 0.5, 1.0], // Adjust for blending balance
                        )
                      : null,
          color: styling.theme == "colorful" ||
                  styling.theme == "colorful-light" ||
                  styling.theme == "christmas"
              ? null
              : styling.background,
        ),
        child: !flatBack && styling.theme == "dotted-dark"
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
            : !flatBack && styling.theme == "dotted-light"
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
                : !flatBack && styling.theme == "christmas"
                    ? Stack(
                        children: snowflakePositions.map((position) {
                          return Positioned(
                            left: position.dx,
                            top: position.dy,
                            child: Snowflake(
                              size: snowflakeSizes[
                                  snowflakePositions.indexOf(position)],
                              strokeWidth: strokeWidths[
                                  snowflakePositions.indexOf(position)],
                            ), // Adjust size as needed
                          );
                        }).toList(),
                      )
                    : null,
      ),
    );
  }
}
