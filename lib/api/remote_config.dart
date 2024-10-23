import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snippets/constants.dart';

class RemoteConfig {
  final String? uid;
  RemoteConfig({this.uid});
  final remoteConfig = FirebaseRemoteConfig.instance;
  Future<bool> checkUpdates() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: Duration.zero,
    ));
    await remoteConfig.fetchAndActivate();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      var requiredBuildNumber =
          remoteConfig.getString('requiredBuildNumberAndroid');
      String currentBuildNumber = packageInfo.buildNumber;
      var devBuild = remoteConfig.getString('devBuildNumberIOS');
      if (devBuild == currentBuildNumber) {
        return false;
      }
      return currentBuildNumber != requiredBuildNumber;
    } else if (Platform.isIOS) {
      var requiredBuildNumber =
          remoteConfig.getString('requiredBuildNumberIOS');
      String currentBuildNumber = packageInfo.buildNumber;
      var devBuild = remoteConfig.getString('devBuildNumberIOS');
      if (devBuild == currentBuildNumber) {
        return false;
      }

      return currentBuildNumber != requiredBuildNumber;
    } else {
      return false;
    }
  }

  Future<List<NotificationText>>
      getPossibleSnippetResponseNotifications() async {
    List<NotificationText> notifications = [];
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    final responseNotifications =
        remoteConfig.getString('responseNotifications');
    List<String> responseNotificationsList = responseNotifications.split(";");
    for (var item in responseNotificationsList) {
      notifications.add(NotificationText.fromString(item));
    }
    return notifications;
  }
}
