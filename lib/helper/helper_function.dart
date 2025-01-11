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
  static String listenToMessagesKey = "LISTENTOMESSAGESKEY";
  static String topicNotificationsKey = "TOPICNOTIFICATIONSKEY";
  static String allowedNotificationsKey = "ALLOWEDNOTIFICATIONSKEY";
  static String snippetResponseDelayKey = "SNIPPETRESPONSEDELAYKEY";
  static String hapticFeedbackKey = "HAPTICFEEDBACKKEY";
  static String seenUpdateDialogKey = "SEENUPDATEDIALOGKEY";
  static String themeKey = "THEMEKEY";
  static String setChristmasThemeKey = "SETCHRISTMASTHEMEKEY";
  static String setChristmasAppIconKey = "SETCHRISTMASAPPICONKEY";
  static String appIconKey = "APPICONKEY";
  static String showDisplayTileKey = "SHOWDISPLAYTILEKEY";
  static String listenedToUserKey = "LISTENEDTOUSERKEY";
  static String seenSavedResponseKey = "SEENSAVEDRESPONSEKEY";
  static String seenFavoritesKey = "SEENFAVORITESKEY";
  static String streakTopicKey = "STREAKTOPICKEY";
  static String sendStreakNotificationKey = "SENDSTREAKNOTIFICATIONKEY";
  static String seenStreaksKey = "SEENSTREAKSKEY";
  static String seenTriviaSnippetKey = "SEENTRIVIASNIPPETKEY";
  static String setNewYearIconKey = "SETNEWYEARICONKEY";
  static String seenSuggestSnippetKey = "SEENSUGGESTSNIPPETKEY";

  static Future<bool> saveSeenSuggestSnippetSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(seenSuggestSnippetKey, status);
  }

  static Future<bool> getSeenSuggestSnippetSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(seenSuggestSnippetKey) ?? false;
  }

  static Future<bool> saveSeenTriviaSnippetSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(seenTriviaSnippetKey, status);
  }

  static Future<bool> getSeenTriviaSnippetSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(seenTriviaSnippetKey) ?? false;
  }

  static Future<bool> saveSetNewYearIconSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(setNewYearIconKey, status);
  }

  static Future<bool> getSetNewYearIconSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(setNewYearIconKey) ?? false;
  }

  static Future<bool> saveSeenStreaksSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(seenStreaksKey, status);
  }

  static Future<bool> getSeenStreaksSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(seenStreaksKey) ?? false;
  }

  static Future<bool> saveSendStreakNotificationSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(sendStreakNotificationKey, status);
  }

  static Future<bool> getSendStreakNotificationSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(sendStreakNotificationKey) ?? true;
  }

  static Future<bool> saveStreakTopicSF(String topic) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(streakTopicKey, topic);
  }

  static Future<String> getStreakTopicSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(streakTopicKey) ?? "";
  }

  static Future<bool> saveSeenFavoritesSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(seenFavoritesKey, status);
  }

  static Future<bool> getSeenFavoritesSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(seenFavoritesKey) ?? false;
  }

  static Future<bool> saveSeenSavedResponseSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(seenSavedResponseKey, status);
  }

  static Future<bool> getSeenSavedResponseSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(seenSavedResponseKey) ?? false;
  }

  static Future<bool> saveListenedToUserSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(listenedToUserKey, status);
  }

  static Future<bool> getListenedToUserSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(listenedToUserKey) ?? false;
  }

  static Future<bool> saveShowDisplayTileSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(showDisplayTileKey, status);
  }

  static Future<bool> getShowDisplayTileSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(showDisplayTileKey) ?? true;
  }

  static Future<bool> saveSetChristmasAppIconSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(setChristmasAppIconKey, status);
  }

  static Future<bool> getSetChristmasAppIconSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(setChristmasAppIconKey) ?? false;
  }

  static Future<bool> saveAppIconSF(String icon) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(appIconKey, icon);
  }

  static Future<String> getAppIconSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(appIconKey) ?? "default";
  }

  static Future<bool> saveSetChristmasThemeSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(setChristmasThemeKey, status);
  }

  static Future<bool> getSetChristmasThemeSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(setChristmasThemeKey) ?? false;
  }

  static Future<bool> saveThemeSF(String theme) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(themeKey, theme);
  }

  static Future<String> getThemeSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(themeKey) ?? "dark";
  }

  static Future<bool> saveSeenUpdateDialogSF(int num) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setInt(seenUpdateDialogKey, num);
  }

  static Future<int> getSeenUpdateDialogSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getInt(seenUpdateDialogKey) ?? 0;
  }

  static Future<bool> saveListenToMessagesSF(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(listenToMessagesKey, status);
  }

  static Future<bool> getListenToMessagesSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(listenToMessagesKey) ?? false;
  }

  static Future<bool> saveHapticFeedbackSF(String status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(hapticFeedbackKey, status);
  }

  static Future<String> getHapticFeedbackSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(hapticFeedbackKey) ?? "normal";
  }

  static Future<bool> saveSnippetResponseDelaySF(int delay) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setInt(snippetResponseDelayKey, delay);
  }

  static Future<int> getSnippetResponseDelaySF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getInt(snippetResponseDelayKey) ?? 5;
  }

  static Future<bool> addTopicNotification(String topic) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    List<String> topics = sf.getStringList(topicNotificationsKey) ?? [];
    if (topics.contains(topic)) {
      return true;
    }
    return await sf.setStringList(topicNotificationsKey, [...topics, topic]);
  }

  static Future<bool> removeTopicNotification(String topic) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    List<String> topics = sf.getStringList(topicNotificationsKey) ?? [];
    topics.remove(topic);
    return await sf.setStringList(topicNotificationsKey, topics);
  }

  static Future<List<String>> getTopicNotifications() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getStringList(topicNotificationsKey) ?? [];
  }

  static Future<bool> addAllowedNotification(String type) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    List<String> allowedNotifications =
        sf.getStringList(allowedNotificationsKey) ?? [];
    if (allowedNotifications.contains(type)) {
      return true;
    }
    return await sf.setStringList(
        allowedNotificationsKey, [...allowedNotifications, type]);
  }

  static Future<bool> removeAllowedNotification(String type) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    List<String> allowedNotifications =
        sf.getStringList(allowedNotificationsKey) ?? [];
    allowedNotifications.remove(type);
    return await sf.setStringList(
        allowedNotificationsKey, allowedNotifications);
  }

  static Future<List<String>> getAllowedNotifications() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getStringList(allowedNotificationsKey) ?? [];
  }

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
