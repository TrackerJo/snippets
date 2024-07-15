import 'package:flutter/material.dart';
import 'package:snippets/pages/discussions_page.dart';
import 'package:snippets/pages/find_profile_page.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/profile_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/custom_page_route.dart';

class CustomNavBar extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;
  const CustomNavBar({super.key, required this.pageIndex, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          elevation: 10,
          shadowColor: const Color(0xB5D1AEFF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              decoration: ShapeDecoration(
                gradient: ColorSys.purpleBarGradient,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 35,
                    icon: Icon(pageIndex == 0
                        ? Icons.account_circle
                        : Icons.account_circle_outlined, color: Colors.black),
                    onPressed: () {
                      if (pageIndex == 0) return;
                      pageController.jumpToPage(0);
                    },
                  ),
                  IconButton(
                    iconSize: 35,
                    icon:
                        Icon(pageIndex == 1 ? Icons.home : Icons.home_outlined, color: Colors.black),
                    onPressed: () {
                      if (pageIndex == 1) return;
                     pageController.jumpToPage(1);
                    },
                  ),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(pageIndex == 2
                        ? Icons.chat_bubble
                        : Icons.chat_bubble_outline, color: Colors.black),
                    onPressed: () {
                      if (pageIndex == 2) return;
                      pageController.jumpToPage(2);
                    },
                  ),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(pageIndex == 3
                        ? Icons.person_search
                        : Icons.person_search_outlined, color: Colors.black),
                    onPressed: () {
                      if (pageIndex == 3) return;
                      pageController.jumpToPage(3);
                    },
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
