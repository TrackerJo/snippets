import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //Keys
  static String userNameKey = "USERNAMEKEY";
  static String userDisplayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userDataKey = "USERDATAKEY";

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

}
