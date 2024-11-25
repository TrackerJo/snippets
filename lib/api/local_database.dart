import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:snippets/constants.dart';
import 'package:snippets/main.dart';

part 'local_database.g.dart';

class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get message => text()();
  TextColumn get messageId => text()();
  TextColumn get senderId => text()();
  TextColumn get senderUsername => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get senderDisplayName => text()();
  //Read by list of strings
  TextColumn get readBy => text()();
  TextColumn get chatId => text()();
  TextColumn get snippetId => text()();
  IntColumn get lastUpdatedMillis => integer()();
}

class SnipResponses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get answer => text()();
  TextColumn get snippetId => text()();

  TextColumn get displayName => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get uid => text()();

  IntColumn get lastUpdatedMillis => integer()();
  TextColumn get discussionUsers => text()();
}

class SnippetsData extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get snippetId => text()();
  TextColumn get question => text()();

  IntColumn get index => integer()();
  BoolColumn get answered => boolean()();

  TextColumn get type => text()();

  IntColumn get lastUpdatedMillis => integer()();
  IntColumn get lastRecievedMillis => integer()();
}

class BOTWDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get blank => text()();
  TextColumn get status => text()();
  TextColumn get answers => text()();
  DateTimeColumn get week => dateTime()();
  IntColumn get lastUpdatedMillis => integer()();
}

class UserDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get FCMToken => text()();
  TextColumn get displayName => text()();
  TextColumn get BOTWStatus => text()();
  TextColumn get description => text()();
  TextColumn get discussions => text()();
  TextColumn get email => text()();
  TextColumn get friends => text()();
  TextColumn get friendRequests => text()();
  TextColumn get outgoingFriendRequests => text()();
  TextColumn get username => text()();
  TextColumn get searchKey => text()();
  TextColumn get userId => text()();
  IntColumn get lastUpdatedMillis => integer()();
  IntColumn get votesLeft => integer()();
  IntColumn get snippetsRespondedTo => integer()();
  IntColumn get messagesSent => integer()();
  IntColumn get discussionsStarted => integer()();
}

@DriftDatabase(
    tables: [Chats, SnipResponses, SnippetsData, BOTWDataTable, UserDataTable])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    if (true) {
      // await file.delete();
    }

    return NativeDatabase.createInBackground(file);
  });
}

class LocalDatabase {
  Future<void> deleteDB() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    //check if file exists
    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<void> clearDB() async {
    //Clear all tables
    await (localDb.delete(localDb.snipResponses)).go();
    await (localDb.delete(localDb.snippetsData)).go();
    await (localDb.delete(localDb.bOTWDataTable)).go();
    await (localDb.delete(localDb.chats)).go();
  }

  String answersToString(Map<String, BOTWAnswer> map) {
    String result = "";
    map.forEach((key, value) {
      result += "$key*${answerToString(value)}~";
    });
    if (result.isEmpty) return "";
    result = result.substring(0, result.length - 1);
    return result;
  }

  Future<int> numberOfResponses() async {
    return (localDb.select(localDb.snipResponses))
        .get()
        .then((value) => value.length);
  }

  Future<int> numberOfSnippets() async {
    return (localDb.select(localDb.snippetsData))
        .get()
        .then((value) => value.length);
  }

  String answerToString(BOTWAnswer map) {
    String result = "";
    map.toMap().forEach((key, value) {
      if (key == "voters") {
        result += "$key>${value.join(",")}|";
        return;
      }
      result += "$key>$value|";
    });
    if (result.isEmpty) return "";
    result = result.substring(0, result.length - 1);
    return result;
  }

  BOTWAnswer stringToAnswer(String string) {
    List<String> split = string.split("|");
    Map<String, dynamic> result = {};
    for (var item in split) {
      List<String> splitItem = item.split(">");

      if (splitItem[0] == "voters") {
        if (splitItem.length < 2) {
          result[splitItem[0]] = [];
          continue;
        }
        result[splitItem[0]] = splitItem[1].split(",");
        continue;
      }
      if (splitItem.length < 2) continue;
      if (splitItem[0] == "votes") {
        result[splitItem[0]] = int.parse(splitItem[1]);
        continue;
      }
      result[splitItem[0]] = splitItem[1];
    }
    return BOTWAnswer.fromMap(result);
  }

  Map<String, BOTWAnswer> stringToAnswers(String string) {
    List<String> split = string.split("~");
    Map<String, BOTWAnswer> result = {};
    for (var item in split) {
      List<String> splitItem = item.split("*");
      if (splitItem.length < 2) continue;
      result[splitItem[0]] = stringToAnswer(splitItem[1]);
    }
    return result;
  }

  String discussionUsersToString(List<DiscussionUser> list) {
    String result = "";
    for (var item in list) {
      result += "${item.userId}:${item.FCMToken}|";
    }
    if (result.isEmpty) return "";
    result = result.substring(0, result.length - 1);
    return result;
  }

  List<DiscussionUser> stringToDiscussionUsers(String string) {
    List<String> split = string.split("|");
    List<DiscussionUser> result = [];
    for (var item in split) {
      List<String> splitItem = item.split(":");
      if (splitItem.length < 2) continue;
      result.add(DiscussionUser(userId: splitItem[0], FCMToken: splitItem[1]));
    }
    return result;
  }

  String discussionToString(Discussion discussion) {
    return "${discussion.answerId}:${discussion.isAnonymous}:${discussion.snippetId}:${discussion.snippetQuestion}";
  }

  Discussion stringToDiscussion(String string) {
    List<String> split = string.split(":");
    if (split.length < 4) {
      return Discussion(
          answerId: "", isAnonymous: false, snippetId: "", snippetQuestion: "");
    }
    return Discussion(
        answerId: split[0],
        isAnonymous: split[1] == "true",
        snippetId: split[2],
        snippetQuestion: split[3]);
  }

  String discussionListToString(List<Discussion> list) {
    String result = "";
    if (list.isEmpty) return "";
    for (var item in list) {
      result += "${discussionToString(item)}|";
    }
    result = result.substring(0, result.length - 1);
    return result;
  }

  List<Discussion> stringToDiscussionList(String string) {
    List<String> split = string.split("|");
    List<Discussion> result = [];
    if (string == "") return result;
    for (var item in split) {
      result.add(stringToDiscussion(item));
    }
    return result;
  }

  String userMiniToString(UserMini user) {
    return "${user.userId}~~~${user.displayName}~~~${user.FCMToken}~~~${user.username}";
  }

  UserMini stringToUserMini(String string) {
    List<String> split = string.split("~~~");
    if (split.length < 4) {
      return UserMini(userId: "", displayName: "", FCMToken: "", username: "");
    }
    return UserMini(
        userId: split[0],
        displayName: split[1],
        FCMToken: split[2],
        username: split[3]);
  }

  String userMiniListToString(List<UserMini> list) {
    String result = "";
    if (list.isEmpty) return "";
    for (var item in list) {
      result += "${userMiniToString(item)}|";
    }

    result = result.substring(0, result.length - 1);
    return result;
  }

  String botwStatusToString(BOTWStatus status) {
    return "${status.date}|${status.hasAnswered}|${status.hasSeenResults}";
  }

  BOTWStatus stringToBOTWStatus(String string) {
    List<String> split = string.split("|");
    if (split.length < 3) {
      return BOTWStatus(date: "", hasAnswered: false, hasSeenResults: false);
    }
    return BOTWStatus(
        date: split[0],
        hasAnswered: split[1] == "true",
        hasSeenResults: split[2] == "true");
  }

  List<UserMini> stringToUserMiniList(String string) {
    List<String> split = string.split("|");
    List<UserMini> result = [];
    if (string == "") return result;
    for (var item in split) {
      //Check if user is already in list
      UserMini user = stringToUserMini(item);
      if (result.any((element) => element.userId == user.userId)) continue;
      result.add(user);
    }
    return result;
  }

  Future<void> addBOTW(BOTW botw) async {
    var existingBOTW = await (localDb.select(localDb.bOTWDataTable)).get();
    if (existingBOTW.isNotEmpty) {
      return;
    }
    await localDb.into(localDb.bOTWDataTable).insert(BOTWDataTableCompanion(
          status: Value(botw.status.name),
          answers: Value(answersToString(botw.answers)),
          week: Value(DateTime.now()),
          blank: Value(botw.blank),
          lastUpdatedMillis: Value(botw.lastUpdatedMillis),
        ));
  }

  Future<void> updateBOTW(BOTW botw) async {
    await (localDb.update(localDb.bOTWDataTable)
          ..where((tbl) => tbl.week.equals(botw.week)))
        .write(BOTWDataTableCompanion(
            status: Value(botw.status.name),
            answers: Value(answersToString(botw.answers)),
            week: Value(
              botw.week,
            ),
            lastUpdatedMillis: Value(botw.lastUpdatedMillis)));
  }

  Future<void> deleteBOTW() async {
    await (localDb.delete(localDb.bOTWDataTable)).go();
  }

  Future<BOTW?> getBOTW() async {
    return (localDb.select(localDb.bOTWDataTable)
          ..orderBy([(u) => OrderingTerm.desc(u.week)]))
        .get()
        .then((value) => value.isNotEmpty
            ? BOTW(
                status: BOTWStatusType.values.firstWhere(
                    (element) => element.name == value.first.status),
                answers: stringToAnswers(value.first.answers),
                week: value.first.week,
                blank: value.first.blank,
                lastUpdatedMillis: value.first.lastUpdatedMillis)
            : null);
  }

  Future<Stream<BOTW>> getBOTWStream() async {
    Stream<BOTW> botw = (localDb.select(localDb.bOTWDataTable)
          ..orderBy([(u) => OrderingTerm.desc(u.week)]))
        .watch()
        .map((event) {
      if (event.isNotEmpty) {
        var data = event.first;
        return BOTW(
            status: BOTWStatusType.values
                .firstWhere((element) => element.name == data.status),
            answers: stringToAnswers(data.answers),
            week: data.week,
            blank: data.blank,
            lastUpdatedMillis: data.lastUpdatedMillis);
      }
      return BOTW(
          status: BOTWStatusType.answering,
          answers: {},
          week: DateTime.now(),
          blank: "",
          lastUpdatedMillis: 0);
    });
    return botw;
  }

  Future<List<String>> getCachedResponsesIDs(String snippetId) async {
    //Print all responses in db
    var allResponses = await (localDb.select(localDb.snipResponses)
          ..orderBy([(u) => OrderingTerm.desc(u.lastUpdatedMillis)]))
        .get();

    var responses = await (localDb.select(localDb.snipResponses)
          ..where((tbl) => tbl.snippetId.equals(snippetId))
          ..orderBy([(u) => OrderingTerm.desc(u.lastUpdatedMillis)]))
        .get();
    List<String> ids = [];
    for (var item in responses) {
      ids.add(item.uid);
    }
    return ids;
  }

  Future<void> updateUsersBOTWAnswer(BOTWAnswer answer) async {
    //Get first BOTW
    var botw = await (localDb.select(localDb.bOTWDataTable)
          ..orderBy([(u) => OrderingTerm.desc(u.week)]))
        .get();
    if (botw.isEmpty) return;
    var answers = stringToAnswers(botw.first.answers);
    answers[answer.userId] = answer;
    await (localDb.update(localDb.bOTWDataTable)
          ..where((tbl) => tbl.week.equals(botw.first.week)))
        .write(
            BOTWDataTableCompanion(answers: Value(answersToString(answers))));
  }

  Future<void> answerSnippet(String snippetId, DateTime lastUpdated) async {
    (localDb.update(localDb.snippetsData)
      ..where((tbl) => tbl.snippetId.equals(snippetId))
      ..write(SnippetsDataCompanion(
          answered: const Value(true),
          lastUpdatedMillis: Value(lastUpdated.millisecondsSinceEpoch))));
  }

  Future<void> addSnippet(Snippet snippet, int lastUpdatedMillis) async {
    //Check if index already exists
    var snippetIndex = await (localDb.select(localDb.snippetsData)
          ..where((tbl) => tbl.index.equals(snippet.index)))
        .get();
    if (snippetIndex.isNotEmpty) {
      //Check if snippet already exists
      SnippetsDataData? existingSnippet =
          await (localDb.select(localDb.snippetsData)
                ..where((tbl) => tbl.snippetId.equals(snippet.snippetId)))
              .get()
              .then((value) => value.isNotEmpty ? value.first : null);
      //Check if the snippets are the same
      if (existingSnippet?.question == snippet.question &&
          existingSnippet?.type == snippet.type) {
        //Check if has been answered
        if (existingSnippet?.answered == true) {
          return;
        } else {
          //update snippet to answered
          await (localDb.update(localDb.snippetsData)
                ..where((tbl) => tbl.snippetId.equals(snippet.snippetId)))
              .write(SnippetsDataCompanion(
                  answered: Value(snippet.answered),
                  lastUpdatedMillis: Value(lastUpdatedMillis)));
        }

        return;
      } else {
        await (localDb.delete(localDb.snipResponses)
              ..where((tbl) => tbl.snippetId.equals(snippet.snippetId)))
            .go();

        await (localDb.delete(localDb.chats)
              ..where((tbl) => tbl.snippetId.equals(snippet.snippetId)))
            .go();
        await (localDb.delete(localDb.snippetsData)
              ..where((tbl) => tbl.index.equals(snippet.index)))
            .go();
      }
    }

    await localDb.into(localDb.snippetsData).insert(SnippetsDataCompanion(
          snippetId: Value(snippet.snippetId),
          lastRecievedMillis: Value(snippet.lastRecievedMillis),
          question: Value(snippet.question),
          answered: Value(snippet.answered),
          index: Value(snippet.index),
          type: Value(snippet.type),
          lastUpdatedMillis: Value(lastUpdatedMillis),
        ));
  }

  Future<void> deleteSnippetById(String snippetId) async {
    await (localDb.delete(localDb.snipResponses)
          ..where((tbl) => tbl.snippetId.equals(snippetId)))
        .go();

    await (localDb.delete(localDb.chats)
          ..where((tbl) => tbl.snippetId.equals(snippetId)))
        .go();
    await (localDb.delete(localDb.snippetsData)
          ..where((tbl) => tbl.snippetId.equals(snippetId)))
        .go();
  }

  Future<Snippet?> getMostRecentSnippet() async {
    return (localDb.select(localDb.snippetsData)
          ..orderBy([(u) => OrderingTerm.desc(u.lastUpdatedMillis)]))
        .get()
        .then((value) => value.isNotEmpty
            ? Snippet(
                snippetId: value.first.snippetId,
                lastRecievedMillis: value.first.lastRecievedMillis,
                question: value.first.question,
                answered: value.first.answered,
                index: value.first.index,
                type: value.first.type,
                lastUpdatedMillis: value.first.lastUpdatedMillis)
            : null);
  }

  getSnippets(
      StreamController controller, StreamController mainController) async {
    (localDb.select(localDb.snippetsData)
          ..orderBy([(u) => OrderingTerm.desc(u.index)]))
        .watch()
        .listen((event) {
      if (mainController.isClosed) return;
      List<Snippet> snippets = [];
      for (var item in event) {
        snippets.add(Snippet(
            snippetId: item.snippetId,
            lastRecievedMillis: item.lastRecievedMillis,
            question: item.question,
            answered: item.answered,
            index: item.index,
            type: item.type,
            lastUpdatedMillis: item.lastUpdatedMillis));
      }
      controller.add(snippets);
    });
  }

  Future<List<Snippet>> getSnippetsList() async {
    var snippets = await (localDb.select(localDb.snippetsData)
          ..orderBy([(u) => OrderingTerm.desc(u.index)]))
        .get();
    List<Snippet> result = [];
    for (var item in snippets) {
      result.add(Snippet(
          snippetId: item.snippetId,
          lastRecievedMillis: item.lastRecievedMillis,
          question: item.question,
          answered: item.answered,
          index: item.index,
          type: item.type,
          lastUpdatedMillis: item.lastUpdatedMillis));
    }
    return result;
  }

  Future<void> deleteOldResponse() async {
    //Delete all responses older than a day
    await (localDb.delete(localDb.snipResponses)
          ..where((tbl) => tbl.date.isSmallerThan(
              currentDate.modify(const DateTimeModifier.days(-2)))))
        .go();
  }

  Future<void> removeResponse(String snippetId, String userId) async {
    (localDb.delete(localDb.snipResponses)
          ..where((tbl) => tbl.snippetId.equals(snippetId))
          ..where((tbl) => tbl.uid.equals(userId)))
        .go();
  }

  Future<void> addResponse(SnippetResponse response) async {
    var existingResponse = await (localDb.select(localDb.snipResponses)
          ..where((tbl) => tbl.snippetId.equals(response.snippetId))
          ..where((tbl) => tbl.uid.equals(response.userId)))
        .get();

    if (existingResponse.isNotEmpty) {
      // return;
      //Delete existing response
      await (localDb.delete(localDb.snipResponses)
            ..where((tbl) => tbl.snippetId.equals(response.snippetId))
            ..where((tbl) => tbl.uid.equals(response.userId)))
          .go();
    }

    await localDb.into(localDb.snipResponses).insert(SnipResponsesCompanion(
        answer: Value(response.answer),
        snippetId: Value(response.snippetId),
        uid: Value(response.userId),
        displayName: Value(response.displayName),
        date: Value(response.date),
        discussionUsers:
            Value(discussionUsersToString(response.discussionUsers)),
        lastUpdatedMillis: Value(response.lastUpdatedMillis)));
  }

  Future<void> getResponses(String snippetId, List<String> friendsList,
      bool isAnonymous, StreamController controller) async {
    if (isAnonymous) {
      (localDb.select(localDb.snipResponses)
            ..where((tbl) => tbl.snippetId.equals(snippetId))
            ..orderBy([(u) => OrderingTerm.desc(u.date)]))
          .watch()
          .listen((event) {
        if (controller.isClosed) return;
        List<SnippetResponse> responses = [];
        for (var item in event) {
          responses.add(SnippetResponse(
              answer: item.answer,
              snippetId: item.snippetId,
              userId: item.uid,
              displayName: item.displayName,
              date: item.date,
              discussionUsers: stringToDiscussionUsers(item.discussionUsers),
              lastUpdatedMillis: item.lastUpdatedMillis));
        }
        controller.add(responses);
      });
    } else {
      (localDb.select(localDb.snipResponses)
            ..where((tbl) => tbl.snippetId.equals(snippetId))
            ..where((tbl) => tbl.uid.isIn(friendsList))
            ..orderBy([(u) => OrderingTerm.desc(u.date)]))
          .watch()
          .listen((event) {
        if (controller.isClosed) return;
        List<SnippetResponse> responses = [];
        for (var item in event) {
          responses.add(SnippetResponse(
              answer: item.answer,
              snippetId: item.snippetId,
              userId: item.uid,
              displayName: item.displayName,
              date: item.date,
              discussionUsers: stringToDiscussionUsers(item.discussionUsers),
              lastUpdatedMillis: item.lastUpdatedMillis));
        }
        controller.add(responses);
      });
    }
  }

  Future<SnippetResponse?> getLatestResponse(String snippetId) async {
    return (localDb.select(localDb.snipResponses)
          ..where((tbl) => tbl.snippetId.equals(snippetId))
          ..orderBy([(u) => OrderingTerm.desc(u.lastUpdatedMillis)]))
        .get()
        .then((value) => value.isNotEmpty
            ? SnippetResponse(
                answer: value.first.answer,
                snippetId: value.first.snippetId,
                userId: value.first.uid,
                displayName: value.first.displayName,
                date: value.first.date,
                discussionUsers:
                    stringToDiscussionUsers(value.first.discussionUsers),
                lastUpdatedMillis: value.first.lastUpdatedMillis)
            : null);
  }

  Future<void> deleteChats(String chatId) async {
    await (localDb.delete(localDb.chats)
          ..where((tbl) => tbl.chatId.equals(chatId)))
        .go();
  }

  Future<void> insertChat(Message chat) async {
    //Check if
    //Check if chat already exists
    var existingChat = await (localDb.select(localDb.chats)
          ..where((tbl) => tbl.messageId.equals(chat.messageId)))
        .get();
    if (existingChat.isNotEmpty) {
      return;
    }

    await localDb.into(localDb.chats).insert(ChatsCompanion(
        message: Value(chat.message),
        senderId: Value(chat.senderId),
        senderUsername: Value(chat.senderUsername),
        date: Value(chat.date),
        senderDisplayName: Value(chat.senderDisplayName),
        readBy: Value(chat.readBy.join(",")),
        chatId: Value(chat.discussionId),
        messageId: Value(chat.messageId),
        lastUpdatedMillis: Value(chat.lastUpdatedMillis),
        snippetId: Value(chat.snippetId)));
  }

  Future<void> getChats(String chatId, StreamController controller) async {
    (localDb.select(localDb.chats)
          ..where((tbl) => tbl.chatId.equals(chatId))
          ..orderBy([(u) => OrderingTerm.asc(u.lastUpdatedMillis)]))
        .watch()
        .listen((event) {
      if (controller.isClosed) return;
      List<Message> messages = [];
      for (var item in event) {
        messages.add(Message(
            message: item.message,
            senderId: item.senderId,
            senderUsername: item.senderUsername,
            date: item.date,
            senderDisplayName: item.senderDisplayName,
            readBy: item.readBy.split(","),
            discussionId: item.chatId,
            messageId: item.messageId,
            lastUpdatedMillis: item.lastUpdatedMillis,
            snippetId: item.snippetId));
      }
      controller.add(messages);
    });
  }

  //Get most recent chat
  Future<Message?> getMostRecentChat(String chatId) async {
    return (localDb.select(localDb.chats)
          ..where((tbl) => tbl.chatId.equals(chatId))
          ..orderBy([(u) => OrderingTerm.desc(u.lastUpdatedMillis)]))
        .get()
        .then((value) => value.isNotEmpty
            ? Message(
                message: value.first.message,
                senderId: value.first.senderId,
                senderUsername: value.first.senderUsername,
                date: value.first.date,
                senderDisplayName: value.first.senderDisplayName,
                readBy: value.first.readBy.split(","),
                discussionId: value.first.chatId,
                messageId: value.first.messageId,
                lastUpdatedMillis: value.first.lastUpdatedMillis,
                snippetId: value.first.snippetId)
            : null);
  }

  Future<List<SnippetResponse>> getSnippetResponses(String snippetId) async {
    var responses = await (localDb.select(localDb.snipResponses)
          ..where((tbl) => tbl.snippetId.equals(snippetId))
          ..orderBy([(u) => OrderingTerm.desc(u.lastUpdatedMillis)]))
        .get();
    List<SnippetResponse> result = [];
    for (var item in responses) {
      result.add(SnippetResponse(
          answer: item.answer,
          snippetId: item.snippetId,
          userId: item.uid,
          displayName: item.displayName,
          date: item.date,
          discussionUsers: [],
          lastUpdatedMillis: item.lastUpdatedMillis));
    }
    return result;
  }

  Future<SnippetResponse?> getSnippetResponse(String snippetId, String userId) {
    return (localDb.select(localDb.snipResponses)
          ..where((tbl) => tbl.snippetId.equals(snippetId))
          ..where((tbl) => tbl.uid.equals(userId)))
        .get()
        .then((value) => value.isNotEmpty
            ? SnippetResponse(
                answer: value.first.answer,
                snippetId: value.first.snippetId,
                userId: value.first.uid,
                displayName: value.first.displayName,
                date: value.first.date,
                discussionUsers: [],
                lastUpdatedMillis: value.first.lastUpdatedMillis)
            : null);
  }

  Future<void> addUserData(User user, int lastUpdated) async {
    var existingUser = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(user.userId)))
        .get();
    if (existingUser.isNotEmpty) {
      await (localDb.update(localDb.userDataTable)
            ..where((tbl) => tbl.userId.equals(user.userId)))
          .write(UserDataTableCompanion(
              FCMToken: Value(user.FCMToken),
              displayName: Value(user.displayName),
              BOTWStatus: Value(botwStatusToString(user.botwStatus)),
              description: Value(user.description),
              discussions: Value(discussionListToString(user.discussions)),
              email: Value(user.email),
              friends: Value(userMiniListToString(user.friends)),
              friendRequests: Value(userMiniListToString(user.friendRequests)),
              outgoingFriendRequests:
                  Value(userMiniListToString(user.outgoingFriendRequests)),
              username: Value(user.username),
              searchKey: Value(user.searchKey),
              lastUpdatedMillis: Value(lastUpdated),
              votesLeft: Value(user.votesLeft)));
    } else {
      await localDb.into(localDb.userDataTable).insert(UserDataTableCompanion(
            FCMToken: Value(user.FCMToken),
            displayName: Value(user.displayName),
            BOTWStatus: Value(botwStatusToString(user.botwStatus)),
            description: Value(user.description),
            discussions: Value(discussionListToString(user.discussions)),
            email: Value(user.email),
            friends: Value(userMiniListToString(user.friends)),
            friendRequests: Value(userMiniListToString(user.friendRequests)),
            outgoingFriendRequests:
                Value(userMiniListToString(user.outgoingFriendRequests)),
            username: Value(user.username),
            searchKey: Value(user.searchKey),
            userId: Value(user.userId),
            lastUpdatedMillis: Value(lastUpdated),
            votesLeft: Value(user.votesLeft),
          ));
    }
  }

  Future<void> updateUserData(User user, int lastUpdated) async {
    //Check if user exists
    var existingUser = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(user.userId)))
        .get();
    if (existingUser.isEmpty) {
      //Add user if it doesn't exist

      await localDb.into(localDb.userDataTable).insert(
            UserDataTableCompanion(
                FCMToken: Value(user.FCMToken),
                displayName: Value(user.displayName),
                BOTWStatus: Value(botwStatusToString(user.botwStatus)),
                description: Value(user.description),
                discussions: Value(discussionListToString(user.discussions)),
                email: Value(user.email),
                friends: Value(userMiniListToString(user.friends)),
                friendRequests:
                    Value(userMiniListToString(user.friendRequests)),
                outgoingFriendRequests:
                    Value(userMiniListToString(user.outgoingFriendRequests)),
                username: Value(user.username),
                searchKey: Value(user.searchKey),
                userId: Value(user.userId),
                lastUpdatedMillis: Value(lastUpdated),
                votesLeft: Value(user.votesLeft),
                snippetsRespondedTo: Value(user.snippetsRespondedTo),
                discussionsStarted: Value(user.discussionsStarted),
                messagesSent: Value(user.messagesSent)),
          );
    }

    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(user.userId)))
        .write(UserDataTableCompanion(
            FCMToken: Value(user.FCMToken),
            displayName: Value(user.displayName),
            BOTWStatus: Value(botwStatusToString(user.botwStatus)),
            description: Value(user.description),
            discussions: Value(discussionListToString(user.discussions)),
            email: Value(user.email),
            friends: Value(userMiniListToString(user.friends)),
            friendRequests: Value(userMiniListToString(user.friendRequests)),
            outgoingFriendRequests:
                Value(userMiniListToString(user.outgoingFriendRequests)),
            username: Value(user.username),
            searchKey: Value(user.searchKey),
            lastUpdatedMillis: Value(lastUpdated),
            votesLeft: Value(user.votesLeft)));
  }

  Future<int?> getLastUpdatedUser(String userId) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) return null;
    return user.first.lastUpdatedMillis;
  }

  Future<User> getUserData(String userId) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) {
      return User(
          FCMToken: "",
          displayName: "",
          botwStatus:
              BOTWStatus(date: "", hasAnswered: false, hasSeenResults: false),
          description: "",
          discussions: [],
          email: "",
          friends: [],
          friendRequests: [],
          outgoingFriendRequests: [],
          username: "",
          searchKey: "",
          snippetsRespondedTo: 0,
          discussionsStarted: 0,
          messagesSent: 0,
          userId: "",
          votesLeft: 0);
    }

    return User(
        FCMToken: user.first.FCMToken,
        displayName: user.first.displayName,
        botwStatus: stringToBOTWStatus(user.first.BOTWStatus),
        description: user.first.description,
        discussions: stringToDiscussionList(user.first.discussions),
        email: user.first.email,
        friends: stringToUserMiniList(user.first.friends),
        friendRequests: stringToUserMiniList(user.first.friendRequests),
        outgoingFriendRequests:
            stringToUserMiniList(user.first.outgoingFriendRequests),
        username: user.first.username,
        searchKey: user.first.searchKey,
        userId: user.first.userId,
        snippetsRespondedTo: user.first.snippetsRespondedTo,
        discussionsStarted: user.first.discussionsStarted,
        messagesSent: user.first.messagesSent,
        votesLeft: user.first.votesLeft);
  }

  Future<void> getCurrentUserStream(StreamController controller) async {
    (localDb.select(localDb.userDataTable)
          ..where((tbl) =>
              tbl.userId.equals(auth.FirebaseAuth.instance.currentUser!.uid)))
        .watch()
        .listen((event) {
      if (controller.isClosed) return;
      if (event.isNotEmpty) {
        var user = event.first;

        controller.add(User(
            FCMToken: user.FCMToken,
            displayName: user.displayName,
            botwStatus: stringToBOTWStatus(user.BOTWStatus),
            description: user.description,
            discussions: stringToDiscussionList(user.discussions),
            email: user.email,
            friends: stringToUserMiniList(user.friends),
            friendRequests: stringToUserMiniList(user.friendRequests),
            outgoingFriendRequests:
                stringToUserMiniList(user.outgoingFriendRequests),
            username: user.username,
            searchKey: user.searchKey,
            userId: user.userId,
            snippetsRespondedTo: user.snippetsRespondedTo,
            discussionsStarted: user.discussionsStarted,
            messagesSent: user.messagesSent,
            votesLeft: user.votesLeft));
      }
    });
  }

  Future<void> addDiscussionToUser(
      String userId, Discussion discussion, int lastUpdated) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) return;
    var discussions = stringToDiscussionList(user.first.discussions);
    discussions.add(discussion);
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            discussions: Value(discussionListToString(discussions)),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> removeDiscussionFromUser(
      String userId, Discussion discussion, int lastUpdated) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) return;
    var discussions = stringToDiscussionList(user.first.discussions);
    discussions.removeWhere((element) =>
        element.snippetId == discussion.snippetId &&
        element.answerId == discussion.answerId);
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            discussions: Value(discussionListToString(discussions)),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> addFriendToUser(
      String userId, UserMini friend, int lastUpdated) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) return;
    var friends = stringToUserMiniList(user.first.friends);
    friends.add(friend);
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            friends: Value(userMiniListToString(friends)),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> removeFriendFromUser(
      String userId, String friendId, int lastUpdated) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) return;
    var friends = stringToUserMiniList(user.first.friends);
    friends.removeWhere((element) => element.userId == friendId);
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            friends: Value(userMiniListToString(friends)),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> addOutgoingFriendToUser(
      String userId, UserMini request, int lastUpdated) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) return;
    var requests = stringToUserMiniList(user.first.outgoingFriendRequests);
    requests.add(request);
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            outgoingFriendRequests: Value(userMiniListToString(requests)),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> removeOutgoingFriendFromUser(
      String userId, String friendId, int lastUpdated) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) return;
    var requests = stringToUserMiniList(user.first.outgoingFriendRequests);
    requests.removeWhere((element) => element.userId == friendId);
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            outgoingFriendRequests: Value(userMiniListToString(requests)),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> removeIncomingFriendRequestFromUser(
      String userId, String friendId, int lastUpdated) async {
    var user = await (localDb.select(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    if (user.isEmpty) return;
    var requests = stringToUserMiniList(user.first.friendRequests);
    requests.removeWhere((element) => element.userId == friendId);
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            friendRequests: Value(userMiniListToString(requests)),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> updateUserDescription(
      String userId, String description, int lastUpdated) async {
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            description: Value(description),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> updateUserBOTWStatus(
      String userId, BOTWStatus botwStatus, int lastUpdated) async {
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            BOTWStatus: Value(botwStatusToString(botwStatus)),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> updateUserVotes(
      String userId, int votesLeft, int lastUpdated) async {
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            votesLeft: Value(votesLeft),
            lastUpdatedMillis: Value(lastUpdated)));
  }

  Future<void> updateUserFCMToken(
      String userId, String FCMToken, int lastUpdated) async {
    await (localDb.update(localDb.userDataTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .write(UserDataTableCompanion(
            FCMToken: Value(FCMToken), lastUpdatedMillis: Value(lastUpdated)));
  }
}
