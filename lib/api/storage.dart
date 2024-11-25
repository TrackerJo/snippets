import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/helper/helper_function.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> setUserSnippetResponseDelay(int delay) async {
    //Get the FCM token
    String fcmToken = await PushNotifications().getDeviceToken();
    //Get the reference to the file
    Reference ref = _storage.ref().child("$fcmToken.json");
    //get data from the file
    var data = await ref.getData();
    //if the file exists
    if (data != null) {
      //update the file
      //Convert the data to JSON
      var jsonData = String.fromCharCodes(data);
      //Convert the JSON to a Map
      Map<String, dynamic> jsonMap = jsonDecode(jsonData);
      //Update the delay
      jsonMap["delay"] = delay * 60000;
      //Convert the Map to JSON
      var jsonString = jsonEncode(jsonMap);
      //Convert the JSON to bytes
      var bytes = Uint8List.fromList(jsonString.codeUnits);
      //Update the file
      await ref.putData(bytes);
    } else {
      //create the file
      //Create the JSON
      var jsonData = jsonEncode({"delay": delay * 60000});
      //Convert the JSON to bytes
      var bytes = Uint8List.fromList(jsonData.codeUnits);
      //Create the file
      await ref.putData(bytes);
    }
  }

  Future<void> changeAllowedNotification(String type, bool isAllowed) async {
    String fcmToken = await PushNotifications().getDeviceToken();
    Reference ref = _storage.ref().child("$fcmToken.json");
    var data = await ref.getData();
    if (data != null) {
      var jsonData = String.fromCharCodes(data);
      Map<String, dynamic> jsonMap = jsonDecode(jsonData);
      if (jsonMap["allowedNotifications"] == null) {
        jsonMap["allowedNotifications"] = [];
      }
      if (isAllowed) {
        if (!jsonMap["allowedNotifications"].contains(type)) {
          jsonMap["allowedNotifications"].add(type);
        }
      } else {
        jsonMap["allowedNotifications"].remove(type);
      }
      var jsonString = jsonEncode(jsonMap);
      var bytes = Uint8List.fromList(jsonString.codeUnits);
      await ref.putData(bytes);
    } else {
      var jsonData = jsonEncode({
        "allowedNotifications": [type]
      });
      var bytes = Uint8List.fromList(jsonData.codeUnits);
      await ref.putData(bytes);
    }
  }

  Future<void> printJSONFile() async {
    String fcmToken = await PushNotifications().getDeviceToken();
    //Get the reference to the file
    Reference ref = _storage.ref().child("$fcmToken.json");
    //get data from the file
    var data = await ref.getData();
    //if the file exists
    if (data != null) {
      //update the file
      //Convert the data to JSON
      var jsonData = String.fromCharCodes(data);
      //Convert the JSON to a Map
      Map<String, dynamic> jsonMap = jsonDecode(jsonData);
      print(jsonMap);
    }
  }
}
