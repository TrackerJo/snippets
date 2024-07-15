import 'package:flutter/material.dart';

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
      width:isCurrentUser ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isCurrentUser)
            GestureDetector(
              onTap: onMutualFriendsButtonPressed,
              child: Column(
                children: [
                  const Text("Mutual Friends",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(mutualFriends.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          // Create a line between the two columns
          if (!isCurrentUser)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: 2,
                color: Colors.white,
              ),
            ),

          GestureDetector(
            onTap: onFriendsButtonPressed,
            child: Column(
              children: [
                const Text("Friends",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text(friends.toString(),
                    style: const TextStyle(
                        color: Colors.white,
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
