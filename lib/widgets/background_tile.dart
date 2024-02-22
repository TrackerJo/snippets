import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BackgroundTile extends StatelessWidget {
  const BackgroundTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Color(0xFF232323),
        child: Wrap(
          children: List<Widget>.generate(2000, (int index) {
            return Icon(
              Icons.add,
              color: Colors.black.withOpacity(0.5),
            );
          }),
        ),
      ),
    );
  }
}
