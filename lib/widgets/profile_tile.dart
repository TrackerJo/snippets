import 'package:flutter/material.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/helper_functions.dart';

class ProfileTile extends StatefulWidget {
  final String displayName;
  final String uid;
  final String username;
  const ProfileTile(
      {super.key,
      required this.displayName,
      required this.uid,
      required this.username});

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
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
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '@${widget.username}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              nextScreen(
                  context,
                  ProfilePage(
                    uid: widget.uid,
                    showNavBar: false,
                  ));
            },
          ),
        ));
  }
}
