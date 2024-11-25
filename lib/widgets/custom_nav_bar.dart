import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

class CustomNavBar extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;
  final bool hasAnsweredBOTW;
  const CustomNavBar(
      {super.key,
      required this.pageIndex,
      required this.pageController,
      required this.hasAnsweredBOTW});

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
                gradient: styling.getPurpleGradient(),
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
                  hasAnsweredBOTW
                      ? IconButton(
                          iconSize: 35,
                          icon: Icon(
                              pageIndex == 0
                                  ? Icons.account_circle
                                  : Icons.account_circle_outlined,
                              color: styling.theme == "colorful-light"
                                  ? Colors.white
                                  : Colors.black),
                          onPressed: () async {
                            if (pageIndex == 0) return;
                            String hapticFeedback =
                                await HelperFunctions.getHapticFeedbackSF();
                            if (hapticFeedback == "normal") {
                              HapticFeedback.mediumImpact();
                            } else if (hapticFeedback == "light") {
                              HapticFeedback.lightImpact();
                            } else if (hapticFeedback == "heavy") {
                              HapticFeedback.heavyImpact();
                            }
                            pageController.jumpToPage(0);
                            await HelperFunctions.saveOpenedPageSF("profile");
                          },
                        )
                      : Stack(
                          children: [
                            //Dot

                            IconButton(
                              iconSize: 35,
                              icon: Icon(
                                  pageIndex == 0
                                      ? Icons.account_circle
                                      : Icons.account_circle_outlined,
                                  color: styling.theme == "colorful-light"
                                      ? Colors.white
                                      : Colors.black),
                              onPressed: () async {
                                if (pageIndex == 0) return;
                                String hapticFeedback =
                                    await HelperFunctions.getHapticFeedbackSF();
                                if (hapticFeedback == "normal") {
                                  HapticFeedback.mediumImpact();
                                } else if (hapticFeedback == "light") {
                                  HapticFeedback.lightImpact();
                                } else if (hapticFeedback == "heavy") {
                                  HapticFeedback.heavyImpact();
                                }
                                pageController.jumpToPage(0);
                                await HelperFunctions.saveOpenedPageSF(
                                    "profile");
                              },
                            ),
                            Positioned(
                              right: 10,
                              top: 8,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(
                        pageIndex == 1 ? Icons.home : Icons.home_outlined,
                        color: styling.theme == "colorful-light"
                            ? Colors.white
                            : Colors.black),
                    onPressed: () async {
                      if (pageIndex == 1) return;
                      String hapticFeedback =
                          await HelperFunctions.getHapticFeedbackSF();
                      if (hapticFeedback == "normal") {
                        HapticFeedback.mediumImpact();
                      } else if (hapticFeedback == "light") {
                        HapticFeedback.lightImpact();
                      } else if (hapticFeedback == "heavy") {
                        HapticFeedback.heavyImpact();
                      }
                      pageController.jumpToPage(1);
                      await HelperFunctions.saveOpenedPageSF("snippets");
                    },
                  ),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(
                        pageIndex == 2
                            ? Icons.chat_bubble
                            : Icons.chat_bubble_outline,
                        color: styling.theme == "colorful-light"
                            ? Colors.white
                            : Colors.black),
                    onPressed: () async {
                      if (pageIndex == 2) return;
                      String hapticFeedback =
                          await HelperFunctions.getHapticFeedbackSF();
                      if (hapticFeedback == "normal") {
                        HapticFeedback.mediumImpact();
                      } else if (hapticFeedback == "light") {
                        HapticFeedback.lightImpact();
                      } else if (hapticFeedback == "heavy") {
                        HapticFeedback.heavyImpact();
                      }
                      pageController.jumpToPage(2);
                      await HelperFunctions.saveOpenedPageSF("discussions");
                    },
                  ),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(
                        pageIndex == 3
                            ? Icons.person_search
                            : Icons.person_search_outlined,
                        color: styling.theme == "colorful-light"
                            ? Colors.white
                            : Colors.black),
                    onPressed: () async {
                      if (pageIndex == 3) return;
                      String hapticFeedback =
                          await HelperFunctions.getHapticFeedbackSF();
                      if (hapticFeedback == "normal") {
                        HapticFeedback.mediumImpact();
                      } else if (hapticFeedback == "light") {
                        HapticFeedback.lightImpact();
                      } else if (hapticFeedback == "heavy") {
                        HapticFeedback.heavyImpact();
                      }
                      pageController.jumpToPage(3);
                      await HelperFunctions.saveOpenedPageSF("search");
                    },
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
