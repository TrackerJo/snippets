import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/helper/helper_function.dart';

class Database {
  Future<Stream<Map<String, dynamic>>> getBOTWStream(
      StreamController controller) async {
    int? lastUpdated = (await LocalDatabase().getBOTW())["lastUpdatedMillis"];

    StreamController<Map<String, dynamic>> fbcontroller = StreamController();

    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .getBlankOfTheWeek(fbcontroller, lastUpdated);

    fbcontroller.stream.listen((event) async {
      if (controller.isClosed) return;

      await LocalDatabase().deleteBOTW();
      await LocalDatabase().addBOTW(event);
    });
    return await LocalDatabase().getBOTWStream();
  }

  Future<Map<String, dynamic>> getBOTW() async {
    int? lastUpdated = (await LocalDatabase().getBOTW())["lastUpdatedMillis"];

    Map<String, dynamic>? fbBotw =
        await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
            .getBlankOfTheWeekData(lastUpdated);
    if (fbBotw != null) {
      await LocalDatabase().deleteBOTW();
      await LocalDatabase().addBOTW(fbBotw);
    }
    return await LocalDatabase().getBOTW();
  }

  Future<void> updateUsersBOTWAnswer(Map<String, dynamic> answer) async {
    //Get user data
    Map<String, dynamic> userData = await HelperFunctions.getUserDataFromSF();
    answer["displayName"] = userData["displayName"];
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .updateUsersBOTWAnswer(answer);
    await LocalDatabase().updateUsersBOTWAnswer(answer);
  }

  Future<void> updateBOTWAnswer(Map<String, dynamic> answer) async {
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .updateBOTWAnswer(answer);
    await LocalDatabase().updateUsersBOTWAnswer(answer);
  }

  Future<List<Map<String, dynamic>>> getSnippetsList() async {
    Snippet? lastSnippet = (await LocalDatabase().getMostRecentSnippet());
    List<Map<String, dynamic>> snippets = await FBDatabase(
            uid: FirebaseAuth.instance.currentUser!.uid)
        .getSnippetsList(
            lastSnippet?.lastUpdatedMillis, lastSnippet?.lastRecievedMillis);
    print("SNIPPETS FROM FB: ${snippets.length}");
    for (var i = 0; i < snippets.length; i++) {
      print("Adding snippet to local db BACKEND");
      await LocalDatabase().addSnippet(snippets[i], snippets[i]["lastUpdated"],
          snippets[i]["lastUpdatedMillis"]);
    }
    return await LocalDatabase().getSnippetsList();
  }

  Future<List<Map<String, dynamic>>> getSnippetsResponses() async {
    List<Map<String, dynamic>> snippets = await getSnippetsList();
    List<Map<String, dynamic>> responses = [];
    for (var i = 0; i < snippets.length; i++) {
      SnipResponse? latestResponse =
          await LocalDatabase().getLatestResponse(snippets[i]["snippetId"]);
      print("LATEST RESPONSE: ${latestResponse?.lastUpdatedMillis}");
      // DateTime? lastUpdated = latestResponse?.lastUpdated;
      List<Map<String, dynamic>> response =
          await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
              .getSnippetResponses(
                  snippets[i]["snippetId"],
                  latestResponse?.lastUpdatedMillis,
                  snippets[i]["snippetType"] == "anonymous");
      print("***RESPONSES FROM FB: ${response.length} ");
      for (var j = 0; j < response.length; j++) {
        response[j]["snippetId"] = snippets[i]["snippetId"];

        await LocalDatabase().addResponse(response[j]);
      }
      responses.addAll(
          await LocalDatabase().getSnippetResponses(snippets[i]["snippetId"]));
    }
    //Delete duplicates
    List<String> responseIDs = [];
    List<Map<String, dynamic>> newResponses = [];
    for (var item in responses) {
      if (!responseIDs.contains("${item["uid"]}-${item["snippetId"]}")) {
        newResponses.add(item);
        responseIDs.add("${item["uid"]}-${item["snippetId"]}");
      } else {
        LocalDatabase().removeResponse(item["snippetId"], item["uid"]);
      }
    }
    return newResponses;
  }

  Future getDiscussionChats(
      StreamController controller, String snippetId, String answerId) async {
    Chat? latestChat =
        await LocalDatabase().getMostRecentChat("$snippetId-$answerId");
    int? latestChatDate = latestChat?.lastUpdatedMillis;
    print("LATEST CHAT DATE: $latestChatDate");

    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .loadDiscussion(snippetId, answerId, latestChatDate);
    latestChat =
        await LocalDatabase().getMostRecentChat("$snippetId-$answerId");
    latestChatDate = latestChat?.lastUpdatedMillis;
    StreamController fbcontroller = StreamController();
    print("LATEST CHAT DATE NEW: $latestChatDate");

    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDiscussion(snippetId, answerId, latestChatDate, fbcontroller);

    fbcontroller.stream.listen((event) async {
      if (controller.isClosed) return;

      if (event.docs.isNotEmpty) {
        print("ADDING CHATS TO LOCAL DATABASE");
        print("EVENT LENGTH: ${event.docs.length}");
        //Go through each chat and add to local database
        for (var i = 0; i < event.docs.length; i++) {
          Map<String, dynamic> data =
              event.docs[i].data() as Map<String, dynamic>;

          Map<String, dynamic> chatMessageMap = {
            "messageId": event.docs[i].id,
            "message": data['message'],
            "senderUsername": data['senderUsername'],
            "senderId": data['senderId'],
            "senderDisplayName": data['senderDisplayName'],
            "date": data['date'].toDate(),
            "readBy": data['readBy'].join(","),
            "chatId": "$snippetId-$answerId",
            "snippetId": snippetId,
            "lastUpdatedMillis": data['lastUpdatedMillis']
          };
          await LocalDatabase().insertChat(chatMessageMap);
        }
      }
    });

    var localChats = await LocalDatabase().getChats("$snippetId-$answerId");
    localChats.listen((event) {
      if (controller.isClosed) return;
      controller.add(event);
    });
  }

  Future getSnippetResponses(
      StreamController controller,
      String snippetId,
      bool isAnonymous,
      bool getFriends,
      List<String> friendsToGet,
      List<String> friends) async {
    SnipResponse? latestResponse =
        await LocalDatabase().getLatestResponse(snippetId);
    // DateTime? lastUpdated = latestResponse?.date;

    print("Last updated FIRST: ${latestResponse?.lastUpdatedMillis}");
    StreamController fbcontroller = StreamController();
    List<Map<String, dynamic>> responses =
        await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
            .getSnippetResponses(
                snippetId, latestResponse?.lastUpdatedMillis, isAnonymous);
    print("RESPONSES FROM FB: ${responses.length} LIST");
    for (var response in responses) {
      print("Adding response to local db");
      response["snippetId"] = snippetId;

      await LocalDatabase().addResponse(response);
    }
    latestResponse = await LocalDatabase().getLatestResponse(snippetId);
    // lastUpdated = latestResponse?.date;
    print("Last updated SECOND: ${latestResponse?.lastUpdatedMillis}");
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .getResponsesList(snippetId, latestResponse?.lastUpdatedMillis,
            getFriends, friendsToGet, isAnonymous, fbcontroller);

    fbcontroller.stream.listen((event) async {
      if (controller.isClosed) return;
      print("RESPONSES FROM STREAM FB: ${event.docs.length}");
      for (var element in event.docs) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        Map<String, dynamic> responseMap = {
          "snippetId": snippetId,
          "uid": data["uid"],
          "displayName": data["displayName"],
          "answer": data["answer"],
          "date": data["date"].toDate(),
          "lastUpdated": data["lastUpdated"].toDate(),
          "lastUpdatedMillis": data['lastUpdatedMillis']
        };
        LocalDatabase().addResponse(responseMap);
      }
    });
    Stream<List<SnipResponse>> responsesStream =
        await LocalDatabase().getResponses(snippetId, friends, isAnonymous);
    responsesStream.listen((event) {
      if (controller.isClosed) return;
      //Remove duplicates
      List<SnipResponse> newResponses = [];
      List<String> responsesIDs = [];
      for (var item in event) {
        if (!responsesIDs.contains(item.uid)) {
          newResponses.add(item);
          responsesIDs.add(item.uid);
        } else {
          // LocalDatabase().removeResponse(snippetId, item.uid);
        }
      }

      controller.add(newResponses);
    });
  }
}
