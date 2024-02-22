import 'package:flutter/material.dart';

class FriendsCount extends StatelessWidget {
  const FriendsCount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text("Mutual Friends",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text("0",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        // Create a line between the two columns
        Column(
          children: [
            Container(
              height: 50,
              width: 1,
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
          ],
        ),
        Column(
          children: [
            Text("Friends",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text("0",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
