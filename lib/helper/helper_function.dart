import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //Keys
  static String openedPageKey = "OPENEDPAGEKEY";
  static String anonymousIDKey = "ANONYMOUSIDKEY";
  static String seenAnonymousSnippetKey = "SEENANONYMOUSSNIPPETKEY";
  static String votedBeforeKey = "VOTEDBEFOREKEY";
  static String appBadgeKey = "appBadge";
  static String updateLocalDatabaseKey = "UPDATELOCALDATABASEKEY";

  //Saving data to SF
  static Future<bool> saveLocalDatabaseUpdateSF(int update) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setInt(updateLocalDatabaseKey, update);
  }

  static Future<bool> saveOpenedPageSF(String openedPage) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(openedPageKey, openedPage);
  }

  static Future<bool> saveAppBadgeSF(int appBadge) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setInt(appBadgeKey, appBadge);
  }

  static Future<String> saveAnonymouseIDSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    final random = Random();
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    // Generate a random string of 5 characters
    String randomString = List.generate(
        5, (index) => characters[random.nextInt(characters.length)]).join();

    // Get the current time in milliseconds since epoch and convert it to a string
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Combine and take the last 5 characters of the timestamp to ensure it always fits into 9 characters
    String uniqueId = randomString + timestamp.substring(timestamp.length - 5);
    await sf.setString(anonymousIDKey, uniqueId);
    return uniqueId;
  }

  static Future<bool> saveSeenAnonymousSnippetSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return await sf.setBool(seenAnonymousSnippetKey, status);
  }

  static Future<bool> saveVotedBeforeSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(votedBeforeKey, true);
  }

  //Getting data from SF
  static Future<int> getLocalDatabaseUpdateSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getInt(updateLocalDatabaseKey) ?? 0;
  }

  static Future<String?> getOpenedPageFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(openedPageKey);
  }

  static Future<String?> getAnonymousIDFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(anonymousIDKey);
  }

  static Future<int> getAppBadgeFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getInt(appBadgeKey) ?? 0;
  }

  static Future<bool> checkIfSeenAnonymousSnippetSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(seenAnonymousSnippetKey) ?? false;
  }

  static Future<bool> checkIfVotedBeforeSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(votedBeforeKey) ?? false;
  }
}
