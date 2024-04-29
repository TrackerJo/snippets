import 'package:flutter/material.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/helper_functions.dart';

class FriendTile extends StatefulWidget {
  final String displayName;
  final String uid;
  final String username;
  final bool showX;
  final bool showCheck;
  final Function()? onXPressed;
  final Function()? onCheckPressed;

  const FriendTile({
    super.key,
    required this.displayName,
    required this.uid,
    required this.username,
    this.showX = false,
    this.showCheck = false,
    this.onXPressed,
    this.onCheckPressed,
  });

  @override
  State<FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10,
        shadowColor: ColorSys.primary,
        borderRadius: BorderRadius.circular(12),
        // color: ColorSys.primary,
        child: ListTile(
          tileColor: ColorSys.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () {
            nextScreen(
                context,
                ProfilePage(
                  uid: widget.uid,
                  showNavBar: false,
                ));
          },
          title: Text(
            widget.displayName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '@${widget.username}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.showCheck)
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    widget.onCheckPressed!();
                  },
                ),
              if (widget.showX)
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    widget.onXPressed!();
                  },
                ),
              if (!widget.showX && !widget.showCheck)
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    nextScreen(
                        context,
                        ProfilePage(
                          uid: widget.uid,
                          showNavBar: false,
                        ));
                  },
                ),
            ],
          ),
        ));
  }
}
