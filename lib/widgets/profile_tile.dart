import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/widgets/helper_functions.dart';

class ProfileTile extends StatefulWidget {
  final String displayName;
  final String uid;
  final String username;
  final int? mutualFriends;
  const ProfileTile(
      {super.key,
      required this.displayName,
      required this.uid,
      required this.username,
      this.mutualFriends});

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10,
        shadowColor: styling.secondary,
        borderRadius: BorderRadius.circular(12),
        // color: ColorSys.primary,
        child: ListTile(
          tileColor: styling.theme == "colorful-light"
              ? Colors.white
              : styling.secondary,
          splashColor: styling.secondaryDark,
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
            nextScreen(
                context,
                ProfilePage(
                  uid: widget.uid,
                  showNavBar: false,
                  showBackButton: true,
                ));
          },
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
            '@${widget.username} ${widget.mutualFriends != null ? "- ${widget.mutualFriends} mutual ${widget.mutualFriends == 1 ? "friend" : "friends"}" : ""}',
            style: TextStyle(
              color: styling.theme == "colorful-light"
                  ? styling.secondaryDark
                  : Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: styling.theme == "colorful-light"
                  ? styling.secondaryDark
                  : Colors.black,
            ),
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
                    showAppBar: true,
                  ));
            },
          ),
        ));
  }
}
