import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/constants.dart';

class Database {
  Future<Stream<BOTW>> getBOTWStream(StreamController controller) async {
    int? lastUpdated = (await LocalDatabase().getBOTW())?.lastUpdatedMillis;
    print("GETTING BOTW STREAM");

    StreamController<BOTW> fbcontroller = StreamController();

    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .getBlankOfTheWeek(fbcontroller, lastUpdated);

    fbcontroller.stream.listen((event) async {
      if (controller.isClosed) return;

      await LocalDatabase().deleteBOTW();
      await LocalDatabase().addBOTW(event);
    });
    return await LocalDatabase().getBOTWStream();
  }

  Future<BOTW> getBOTW() async {
    int? lastUpdated = (await LocalDatabase().getBOTW())?.lastUpdatedMillis;
    print("GETTING BOTW");

    BOTW? fbBotw =
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .getBlankOfTheWeekData(lastUpdated);
    if (fbBotw != null) {
      await LocalDatabase().deleteBOTW();
      await LocalDatabase().addBOTW(fbBotw);
    }
    return (await LocalDatabase().getBOTW())!;
  }

  Future<void> updateUsersBOTWAnswer(BOTWAnswer answer) async {
    //Get user data
    User userData =
        await getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
    answer.displayName = userData.displayName;
    answer.FCMToken = userData.FCMToken;
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .updateUsersBOTWAnswer(answer);
    await LocalDatabase().updateUsersBOTWAnswer(answer);
  }

  Future<void> updateBOTWAnswer(BOTWAnswer answer) async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .updateBOTWAnswer(answer);
    await LocalDatabase().updateUsersBOTWAnswer(answer);
  }

  Future<List<Snippet>> getSnippetsList() async {
    Snippet? lastSnippet = (await LocalDatabase().getMostRecentSnippet());
    print("LAST SNIPPET: ${lastSnippet?.lastUpdatedMillis}");
    List<Snippet> snippets = await FBDatabase(
            uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .getSnippetsList(
            lastSnippet?.lastUpdatedMillis, lastSnippet?.lastRecievedMillis);
    print("SNIPPETS FROM FB: ${snippets.length}");
    for (var i = 0; i < snippets.length; i++) {
      print("Adding snippet to local db BACKEND");
      //if snippet is anonymous
      print("SNIPPET: ${snippets[i].snippetId}");
      await LocalDatabase()
          .addSnippet(snippets[i], snippets[i].lastUpdatedMillis);
    }
    return await LocalDatabase().getSnippetsList();
  }

  Future<List<SnippetResponse>> getSnippetsResponses() async {
    List<Snippet> snippets = await getSnippetsList();
    List<SnippetResponse> responses = [];
    for (var i = 0; i < snippets.length; i++) {
      SnippetResponse? latestResponse =
          await LocalDatabase().getLatestResponse(snippets[i].snippetId);
      print("LATEST RESPONSE: ${latestResponse?.lastUpdatedMillis}");
      // DateTime? lastUpdated = latestResponse?.lastUpdated;
      List<SnippetResponse> response =
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getSnippetResponses(
                  snippets[i].snippetId,
                  latestResponse?.lastUpdatedMillis,
                  snippets[i].type == "anonymous");
      print("***RESPONSES FROM FB: ${response.length} ");
      for (var j = 0; j < response.length; j++) {
        response[j].snippetId = snippets[i].snippetId;

        await LocalDatabase().addResponse(response[j]);
      }
      responses.addAll(
          await LocalDatabase().getSnippetResponses(snippets[i].snippetId));
    }
    //Delete duplicates
    List<String> responseIDs = [];
    List<SnippetResponse> newResponses = [];
    for (var item in responses) {
      if (!responseIDs.contains("${item.userId}-${item.snippetId}")) {
        newResponses.add(item);
        responseIDs.add("${item.userId}-${item.snippetId}");
      } else {
        LocalDatabase().removeResponse(item.snippetId, item.userId);
      }
    }
    return newResponses;
  }

  Future getDiscussionChats(StreamController<List<Message>> controller,
      String snippetId, String answerId) async {
    Message? latestChat =
        await LocalDatabase().getMostRecentChat("$snippetId-$answerId");
    int? latestChatDate = latestChat?.lastUpdatedMillis;
    print("LATEST CHAT DATE: $latestChatDate");

    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .loadDiscussion(snippetId, answerId, latestChatDate);
    latestChat =
        await LocalDatabase().getMostRecentChat("$snippetId-$answerId");
    latestChatDate = latestChat?.lastUpdatedMillis;
    StreamController<List<Message>> fbcontroller = StreamController();
    print("LATEST CHAT DATE NEW: $latestChatDate");

    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .getDiscussion(snippetId, answerId, latestChatDate, fbcontroller);

    fbcontroller.stream.listen((event) async {
      if (controller.isClosed) return;

      if (event.isNotEmpty) {
        print("ADDING CHATS TO LOCAL DATABASE");
        print("EVENT LENGTH: ${event.length}");
        //Go through each chat and add to local database
        for (var i = 0; i < event.length; i++) {
          await LocalDatabase().insertChat(event[i]);
        }
      }
    });

    await LocalDatabase().getChats("$snippetId-$answerId", controller);
  }

  Future getSnippetResponses(
      StreamController<List<SnippetResponse>> controller,
      String snippetId,
      bool isAnonymous,
      bool getFriends,
      List<String> friendsToGet,
      List<String> friends) async {
    SnippetResponse? latestResponse =
        await LocalDatabase().getLatestResponse(snippetId);
    // DateTime? lastUpdated = latestResponse?.date;

    print("Last updated FIRST: ${latestResponse?.lastUpdatedMillis}");
    StreamController<List<SnippetResponse>> fbcontroller = StreamController();
    List<SnippetResponse> responses =
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .getSnippetResponses(
                snippetId, latestResponse?.lastUpdatedMillis, isAnonymous);
    print("RESPONSES FROM FB: ${responses.length} LIST");
    for (var response in responses) {
      print("Adding response to local db");
      response.snippetId = snippetId;

      await LocalDatabase().addResponse(response);
    }
    latestResponse = await LocalDatabase().getLatestResponse(snippetId);
    // lastUpdated = latestResponse?.date;
    print("Last updated SECOND: ${latestResponse?.lastUpdatedMillis}");
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .getResponsesList(snippetId, latestResponse?.lastUpdatedMillis,
            getFriends, friendsToGet, isAnonymous, fbcontroller);

    fbcontroller.stream.listen((event) async {
      if (controller.isClosed) return;
      print("RESPONSES FROM STREAM FB: ${event.length}");
      for (var element in event) {
        LocalDatabase().addResponse(element);
      }
    });

    await LocalDatabase()
        .getResponses(snippetId, friends, isAnonymous, controller);
  }

  Future<SnippetResponse> getSnippetResponse(
      String snippetId, String userId) async {
    SnippetResponse? response =
        await LocalDatabase().getSnippetResponse(snippetId, userId);
    if (response == null) {
      print("USERRESPONSE IS NULL");
      response =
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getSnippetResponse(snippetId, userId);
      await LocalDatabase().addResponse(response);
    } else {
      int lastUpdated = response.lastUpdatedMillis;
      SnippetResponse? fbResponse =
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getSnippetResponseLatest(snippetId, userId, lastUpdated);
      if (fbResponse != null) {
        print("ADDING NEW RESPONSE TO LOCAL DB");
        await LocalDatabase().addResponse(fbResponse);
        response = fbResponse;
      }
    }
    return response;
  }

  Future<User> getUserData(String userId) async {
    return (await LocalDatabase().getUserData(userId));
  }
}
