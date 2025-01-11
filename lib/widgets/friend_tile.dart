import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/widgets/helper_functions.dart';

class FriendTile extends StatefulWidget {
  final String displayName;
  final String uid;
  final String username;
  final bool isBestFriend;
  final bool showX;
  final bool showCheck;
  final Function()? onXPressed;
  final Function()? onCheckPressed;
  final Function()? onTap;

  const FriendTile({
    super.key,
    required this.displayName,
    required this.uid,
    required this.username,
    this.isBestFriend = false,
    this.showX = false,
    this.showCheck = false,
    this.onXPressed,
    this.onCheckPressed,
    this.onTap,
  });

  @override
  State<FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10,
        shadowColor:
            styling.theme == "christmas" ? styling.green : styling.secondary,
        borderRadius: BorderRadius.circular(12),
        // color: ColorSys.primary,
        child: ListTile(
          tileColor: styling.theme == "colorful-light"
              ? Colors.white
              : styling.theme == "christmas"
                  ? styling.green
                  : styling.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () async {
            String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
            if (hapticFeedback == "normal") {
              HapticFeedback.mediumImpact();
            } else if (hapticFeedback == "light") {
              HapticFeedback.lightImpact();
            } else if (hapticFeedback == "heavy") {
              HapticFeedback.heavyImpact();
            }
            if (widget.onTap != null) {
              await widget.onTap!();
            } else {
              nextScreen(
                  context,
                  ProfilePage(
                    uid: widget.uid,
                    showNavBar: false,
                    showBackButton: true,
                  ));
            }
          },
          leading: widget.isBestFriend
              ? Icon(Icons.star, size: 30, color: Colors.black)
              : null,
          title: Text(
            widget.displayName,
            style: TextStyle(
              color: styling.theme == "colorful-light"
                  ? styling.secondaryDark
                  : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '@${widget.username}',
            style: TextStyle(
              color: styling.theme == "colorful-light"
                  ? styling.secondaryDark
                  : Colors.black,
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
                  icon: Icon(Icons.check,
                      color: styling.theme == "colorful-light"
                          ? styling.secondaryDark
                          : Colors.black),
                  onPressed: () {
                    widget.onCheckPressed!();
                  },
                ),
              if (widget.showX)
                IconButton(
                  icon: Icon(Icons.close,
                      color: styling.theme == "colorful-light"
                          ? styling.secondaryDark
                          : Colors.black),
                  onPressed: () {
                    widget.onXPressed!();
                  },
                ),
              if (!widget.showX && !widget.showCheck)
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios,
                      color: styling.theme == "colorful-light"
                          ? styling.secondaryDark
                          : Colors.black),
                  onPressed: () async {
                    String hapticFeedback =
                        await HelperFunctions.getHapticFeedbackSF();
                    if (hapticFeedback == "normal") {
                      HapticFeedback.mediumImpact();
                    } else if (hapticFeedback == "light") {
                      HapticFeedback.lightImpact();
                    } else if (hapticFeedback == "heavy") {
                      HapticFeedback.heavyImpact();
                    }

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
