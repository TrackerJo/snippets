import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/constants.dart';

class Database {
  Future<Stream<BOTW>> getBOTWStream(StreamController controller) async {
    int? lastUpdated = (await LocalDatabase().getBOTW())?.lastUpdatedMillis;

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
        await getCurrentUserData();
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

    List<Snippet> snippets = await FBDatabase(
            uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .getSnippetsList(
            lastSnippet?.lastUpdatedMillis, lastSnippet?.lastRecievedMillis);

    for (var i = 0; i < snippets.length; i++) {
      //if snippet is anonymous

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

      // DateTime? lastUpdated = latestResponse?.lastUpdated;
      List<SnippetResponse> response =
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getSnippetResponses(
                  snippets[i].snippetId,
                  latestResponse?.lastUpdatedMillis,
                  snippets[i].type == "anonymous");

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

    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .loadDiscussion(snippetId, answerId, latestChatDate);
    latestChat =
        await LocalDatabase().getMostRecentChat("$snippetId-$answerId");
    latestChatDate = latestChat?.lastUpdatedMillis;
    StreamController<List<Message>> fbcontroller = StreamController();

    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .getDiscussion(snippetId, answerId, latestChatDate, fbcontroller);

    fbcontroller.stream.listen((event) async {
      if (controller.isClosed) return;

      if (event.isNotEmpty) {
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

    StreamController<List<SnippetResponse>> fbcontroller = StreamController();
    List<SnippetResponse> responses =
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .getSnippetResponses(
                snippetId, latestResponse?.lastUpdatedMillis, isAnonymous);

    for (var response in responses) {
      response.snippetId = snippetId;

      await LocalDatabase().addResponse(response);
    }
    latestResponse = await LocalDatabase().getLatestResponse(snippetId);
    // lastUpdated = latestResponse?.date;

    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .getResponsesList(snippetId, latestResponse?.lastUpdatedMillis,
            getFriends, friendsToGet, isAnonymous, fbcontroller);

    fbcontroller.stream.listen((event) async {
      if (controller.isClosed) return;

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
        await LocalDatabase().addResponse(fbResponse);
        response = fbResponse;
      }
    }
    return response;
  }

  Future<User> getCurrentUserData() async {
    return (await LocalDatabase().getUserData(auth.FirebaseAuth.instance.currentUser!.uid));
  }

  Future<User> getUserData(String userId) async {
    return (await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .getUserData(userId))!;
    ;
  }

  Future<void> addBestFriend(String bestFriendId) async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .addBestFriend(bestFriendId);
  }

  Future<void> removeBestFriend(String bestFriendId) async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .removeBestFriend(bestFriendId);
  }

  Future<List<SavedResponse>> getSavedResponses(String userId) async {
    print("Getting saved responses");
    int? lastCachedSavedResponse =
        await LocalDatabase().getLastCachedSavedResponse(userId);
    print("Last cached saved response: $lastCachedSavedResponse");
    List<SavedResponse> fbSavedResponses =
        await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
            .getSavedResponses(userId, lastCachedSavedResponse);
    for (var res in fbSavedResponses) {
      print("Adding saved response to local database");
      await LocalDatabase().addSavedResponse(res);
      List<SavedMessage> savedMessages =
          await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
              .getSavedMessages(res);
      for (var message in savedMessages) {
        print("Adding message to local database");
        await LocalDatabase().addSavedMessage(message);
      }
    }
    return await LocalDatabase().getSavedResponses(userId);
  }

  Future<List<SavedMessage>> getSavedMessages(String responseId) async {
    return await LocalDatabase().getSavedMessages(responseId);
  }

  Future<void> changeSavedResponseVisibility(
      String responseId, bool visibility) async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .changeSavedResponseVisibility(responseId, visibility);
    await LocalDatabase().changeSavedResponseVisibility(responseId, visibility);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isTwoOrMoreDaysApart(DateTime date1, DateTime date2) {
    return date1.difference(date2).inDays.abs() >= 2;
  }

  Future<void> updateUserStreak(String userId) async {
    print("Updating user streak");
    User userData = await getUserData(userId);
    DateTime today = DateTime.now();
    print(isTwoOrMoreDaysApart(today, userData.streakDate));
    print(userData.streak);
    if (isTwoOrMoreDaysApart(today, userData.streakDate) &&
        userData.streak > 0) {
      print("Resetting streak");
      userData.streak = 0;
      await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
          .updateUserStreak(userId, 0);
    }
  }

  Future<void> suggestSnippet(String snippet) async {
    await FBDatabase(uid: auth.FirebaseAuth.instance.currentUser!.uid)
        .suggestSnippet(snippet);
  }
}
