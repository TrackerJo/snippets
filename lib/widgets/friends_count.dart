import 'package:flutter/material.dart';
import 'package:snippets/main.dart';

class FriendsCount extends StatelessWidget {
  final bool isCurrentUser;
  final int mutualFriends;
  final int friends;
  final void Function()? onFriendsButtonPressed;
  final void Function()? onMutualFriendsButtonPressed;
  const FriendsCount(
      {super.key,
      required this.isCurrentUser,
      this.mutualFriends = 0,
      this.friends = 0,
      this.onFriendsButtonPressed,
      this.onMutualFriendsButtonPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isCurrentUser
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isCurrentUser)
            GestureDetector(
              onTap: onMutualFriendsButtonPressed,
              child: Column(
                children: [
                  Text("Mutual Friends",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: styling.backgroundText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(mutualFriends.toString(),
                      style: TextStyle(
                          color: styling.backgroundText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          // Create a line between the two columns
          if (!isCurrentUser)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: 2,
                color: styling.backgroundText,
              ),
            ),

          GestureDetector(
            onTap: onFriendsButtonPressed,
            child: Column(
              children: [
                Text("Friends",
                    style: TextStyle(
                        color: styling.backgroundText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text(friends.toString(),
                    style: TextStyle(
                        color: styling.backgroundText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
