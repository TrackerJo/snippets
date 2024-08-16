import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //Keys
  static String userNameKey = "USERNAMEKEY";
  static String userDisplayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userDataKey = "USERDATAKEY";
  static String openedPageKey = "OPENEDPAGEKEY";
  static String anonymousIDKey = "ANONYMOUSIDKEY";

  //Saving data to SF
  static Future<bool> saveUserDisplayNameSF(String userDisplayName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userDisplayNameKey, userDisplayName);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserDataSF(String userData) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userDataKey, userData);
  }

  static Future<bool> saveOpenedPageSF(String openedPage) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(openedPageKey, openedPage);
  }

  static Future<String> saveAnonymouseIDSF() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    final random = Random();
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    
    // Generate a random string of 5 characters
    String randomString = List.generate(5, (index) => characters[random.nextInt(characters.length)]).join();
    
    // Get the current time in milliseconds since epoch and convert it to a string
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Combine and take the first 4 characters of the timestamp to ensure it always fits into 9 characters
    String uniqueId = randomString + timestamp.substring(0, 4);
    await sf.setString(anonymousIDKey, uniqueId);
    return uniqueId;
  }

  //Getting data from SF
  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserDisplayNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userDisplayNameKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<Map<String, dynamic>> getUserDataFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    String userData = sf.getString(userDataKey) ?? "";
    return Map<String, dynamic>.from(
        Map<String, dynamic>.from(jsonDecode(userData)));
  }

  static Future<String?> getOpenedPageFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(openedPageKey);
  }

  static Future<String?> getAnonymousIDFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(anonymousIDKey);
  }
  

}
