import 'dart:io';

import 'package:flutter/services.dart';
import 'package:snippets/helper/helper_function.dart';

class AppIconChanger {
  static const androidPlatform = MethodChannel('app.icon');
  static const MethodChannel iosPlatform = MethodChannel('appIconChannel');

  static Future<void> changeIcon(String iconName) async {
    String previousIcon = await HelperFunctions.getAppIconSF();
    if (iconName == previousIcon) {
      return;
    }
    await HelperFunctions.saveAppIconSF(iconName);
    if (Platform.isIOS) {
      String iconNameIOS = iconName;
      if (iconName == "default") {
        iconNameIOS = "default";
      } else if (iconName == "christmas") {
        iconNameIOS = "Christmas";
      } else if (iconName == "premium") {
        iconNameIOS = "Premium";
      }
      print("Changing app icon to $iconNameIOS");
      return await iosPlatform.invokeMethod('changeIcon', iconNameIOS);
    } else if (Platform.isAndroid) {
      // try {
      //   String iconNameAndroid = iconName;
      //   String previousIconAndroid = previousIcon;
      //   if (iconName == "default") {
      //     iconNameAndroid = "MainActivity";
      //   } else if (iconName == "christmas") {
      //     iconNameAndroid = "ChristmasIconAlias";
      //   }

      //   if (previousIcon == "default") {
      //     previousIconAndroid = "MainActivity";
      //   } else if (previousIcon == "christmas") {
      //     previousIconAndroid = "ChristmasIconAlias";
      //   }

      //   print(
      //       "Changing app icon from $previousIconAndroid to $iconNameAndroid");

      //   await androidPlatform.invokeMethod('changeAppIcon',
      //       {'iconName': iconNameAndroid, 'previousIcon': previousIconAndroid});
      // } on PlatformException catch (e) {
      //   print("Failed to change app icon: ${e.message}");
      // }
    }
  }
}
