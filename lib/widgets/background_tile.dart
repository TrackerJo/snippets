import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BackgroundTile extends StatelessWidget {
  const BackgroundTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: const Color(0xFF232323),
        child: Wrap(
          children: List<Widget>.generate(1000, (int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                null,
                color: const Color.fromARGB(255, 48, 48, 48).withOpacity(0.5),
                size: 10,
              ),
            );
          }),
        ),
      ),
    );
  }
}
