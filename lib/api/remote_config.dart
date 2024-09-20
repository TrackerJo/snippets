import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfig {
  final String? uid;
  RemoteConfig({this.uid});
  final remoteConfig = FirebaseRemoteConfig.instance;
  Future<bool> checkUpdates() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
    await remoteConfig.fetchAndActivate();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      var requiredBuildNumber =
          remoteConfig.getInt('requiredBuildNumberAndroid');
      final currentBuildNumber = int.parse(packageInfo.buildNumber);
      return currentBuildNumber < requiredBuildNumber;
    } else if (Platform.isIOS) {
      var requiredBuildNumber =
          remoteConfig.getString('requiredBuildNumberIOS');
      String currentBuildNumber = packageInfo.buildNumber;
      print(requiredBuildNumber);
      print(currentBuildNumber);
      return currentBuildNumber != requiredBuildNumber;
    } else {
      return false;
    }
  }
}
