import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:snippets/helper/helper_function.dart';

class AppBadge {
  static Future addBadge(int count) async {
    if (!(await FlutterAppBadgeControl.isAppBadgeSupported())) {
      return;
    }
    int badgeCount = await HelperFunctions.getAppBadgeFromSF();
    badgeCount += count;
    FlutterAppBadgeControl.updateBadgeCount(badgeCount);
    await HelperFunctions.saveAppBadgeSF(badgeCount);

  }

  static Future removeBadge(int count) async {
    if (!(await FlutterAppBadgeControl.isAppBadgeSupported())) {
      return;
    }
    int badgeCount = await HelperFunctions.getAppBadgeFromSF();
    badgeCount -= count;
    FlutterAppBadgeControl.updateBadgeCount(badgeCount);
    await HelperFunctions.saveAppBadgeSF(badgeCount);
  }

  static Future resetBadge() async {
    if (!(await FlutterAppBadgeControl.isAppBadgeSupported())) {
      return;
    }
    FlutterAppBadgeControl.updateBadgeCount(0);
    await HelperFunctions.saveAppBadgeSF(0);
  }
}