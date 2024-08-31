import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
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
}

class SnipResponses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get answer => text()();
  TextColumn get snippetId => text()();
  TextColumn get uid => text()();
  TextColumn get displayName => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get lastUpdated => dateTime()();

}


class Snippets extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get lastRecieved => dateTime()();
  TextColumn get snippetId => text()();
  TextColumn get question => text()();
  TextColumn get theme => text()();
  IntColumn get index => integer()();
  BoolColumn get answered => boolean()();
  TextColumn get uid => text()();
  TextColumn get type => text()();


}

class BOTW extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get blank => text()();
  TextColumn get status => text()();
  TextColumn get answers => text()();
  DateTimeColumn get lastUpdated => dateTime()();
  DateTimeColumn get week => dateTime()();
}




@DriftDatabase(tables: [Chats, SnipResponses, Snippets, BOTW])
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

  String answersToString(Map<String, dynamic> map) {
    String result = "";
    map.forEach((key, value) {
      result += "$key*${answerToString(value)}~";
    });
    if(result.isEmpty) return "";
    result = result.substring(0, result.length - 1);
    return result;
  }

  String answerToString(Map<String, dynamic> map) {
    String result = "";
    map.forEach((key, value) {
      if(key == "voters"){
        result += "$key:${value.join(",")}|";
        return;
      }
      result += "$key:$value|";
    });
    result = result.substring(0, result.length - 1);
    return result;
  }

  Map<String, dynamic> stringToAnswer(String string) {
    List<String> split = string.split("|");
    Map<String, dynamic> result = {};
    for (var item in split) {
      List<String> splitItem = item.split(":");

      if(splitItem[0] == "voters"){
        if(splitItem.length < 2){
          result[splitItem[0]] = [];
          continue;
        }
        result[splitItem[0]] = splitItem[1].split(",");
        continue;
      }
      if(splitItem.length < 2) continue;
      if(splitItem[0] == "votes"){
        result[splitItem[0]] = int.parse(splitItem[1]);
        continue;
      }
      result[splitItem[0]] = splitItem[1];
    }
    return result;
  }

  Map<String, dynamic> stringToAnswers(String string) {
    List<String> split = string.split("~");
    Map<String, dynamic> result = {};
    for (var item in split) {
      List<String> splitItem = item.split("*");
      if(splitItem.length < 2) continue;
      result[splitItem[0]] = stringToAnswer(splitItem[1]);
    }
    return result;
  }

  Future<void> addBOTW(Map<String, dynamic> botw) async {

    var existingBOTW = await (localDb.select(localDb.botw)).get();
    if(existingBOTW.isNotEmpty) {

      return;
    }
    await localDb.into(localDb.botw).insert(BOTWCompanion(
      status: Value(botw['status']),
      answers: Value(answersToString(botw['answers'])),
      lastUpdated: Value(botw['lastUpdated'].toDate()),
      week: Value(DateTime.now()),
      blank: Value(botw['blank'])
    ));
  }

  Future<void> updateBOTW(Map<String, dynamic> botw) async {
    await (localDb.update(localDb.botw)..where((tbl) => tbl.week.equals(botw['week']))).write(BOTWCompanion(
      status: Value(botw['status']),
      answers: Value(answersToString(botw['answers'])),
      lastUpdated: Value(botw['lastUpdated']),
      week: Value(botw['week'])
    ));
  }

  Future<void> deleteBOTW() async {
    await (localDb.delete(localDb.botw)).go();
  }

  Future<Map<String, dynamic> > getBOTW() async {
    return (localDb.select(localDb.botw)..orderBy([(u) => OrderingTerm.desc(u.week)])).get().then((value) => value.isNotEmpty ? {
      "status": value.first.status,
      "answers": stringToAnswers(value.first.answers),
      "lastUpdated": value.first.lastUpdated,
      "week": value.first.week,
      "blank": value.first.blank
    } : {});
  }

  Future<Stream<Map<String, dynamic>>> getBOTWStream() async {
    Stream<Map<String, dynamic>> botw = (localDb.select(localDb.botw)..orderBy([(u) => OrderingTerm.desc(u.week)])).watch().map((event) {
      if(event.isNotEmpty){
        var data = event.first;
        return {
          "status": data.status,
          "answers": stringToAnswers(data.answers),
          "lastUpdated": data.lastUpdated,
          "week": data.week,
          "blank": data.blank
        };
        
      }
      return {};
      
    });
    return botw;
  }



  Future<List<String>> getCachedResponsesIDs(String snippetId) async {
    var responses = await (localDb.select(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(snippetId))..orderBy([(u) => OrderingTerm.desc(u.lastUpdated)])).get();
    List<String> ids = [];
    for (var item in responses) {
      ids.add(item.uid);
    }
    return ids;
  }

  Future<void> updateUsersBOTWAnswer(Map<String, dynamic> answer) async {
    //Get first BOTW
    var botw = await (localDb.select(localDb.botw)..orderBy([(u) => OrderingTerm.desc(u.week)])).get();
    if(botw.isEmpty) return;
    var answers = stringToAnswers(botw.first.answers);
    answers[answer['userId']] = answer;
    await (localDb.update(localDb.botw)..where((tbl) => tbl.week.equals(botw.first.week))).write(BOTWCompanion(
      answers: Value(answersToString(answers))
    ));

  }

  Future<void> answerSnippet(String snippetId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
     (localDb.update(localDb.snippets)..where((tbl) => tbl.snippetId.equals(snippetId))..where((tbl) => tbl.uid.equals(uid))..write(const SnippetsCompanion(answered: Value(true))));
  }

  Future<void> addSnippet(Map<String, dynamic> snippet) async{
    //Check if index already exists
    var snippetIndex = await (localDb.select(localDb.snippets)..where((tbl) => tbl.index.equals(snippet["index"]))).get();
    if(snippetIndex.isNotEmpty){
      await (localDb.delete(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(snippet["snippetId"]))).go();
      await (localDb.delete(localDb.chats)..where((tbl) => tbl.snippetId.equals(snippet["snippetId"]))).go();
      //Check if snippet already exists
      Snippet? existingSnippet = await (localDb.select(localDb.snippets)..where((tbl) => tbl.snippetId.equals(snippet["snippetId"]))).get().then((value) => value.isNotEmpty ? value.first : null);
      if(existingSnippet != null) {

        //Check if the snippets are the same
        if(existingSnippet.question == snippet["question"] && existingSnippet.theme == snippet["theme"] && existingSnippet.type == snippet["type"]) {

          return;
        } else {
          await (localDb.delete(localDb.snippets)..where((tbl) => tbl.index.equals(snippet["index"]))).go();
        }
      } else {
         await (localDb.delete(localDb.snippets)..where((tbl) => tbl.index.equals(snippet["index"]))).go();
      }

      
      
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await localDb.into(localDb.snippets).insert(SnippetsCompanion(
      snippetId: Value(snippet["snippetId"]),
      lastRecieved:  Value(snippet["lastRecieved"]),
      question: Value(snippet["question"]),
      answered:  Value(snippet["answered"]),
      theme:  Value(snippet["theme"]),
      index:  Value(snippet["index"]),
      type: Value(snippet["type"]),
      uid: Value(uid)

    ));

  }

  Future<void> deleteSnippetById(String snippetId) async {
    await (localDb.delete(localDb.snippets)..where((tbl) => tbl.snippetId.equals(snippetId))).go();
  }

  Future<Snippet?> getMostRecentSnippet() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
     return (localDb.select(localDb.snippets)..where((tbl) => tbl.uid.equals(uid))..orderBy([(u) => OrderingTerm.desc(u.lastRecieved)])).get().then((value) => value.isNotEmpty ? value.first : null);
  }

  getSnippets(StreamController controller, StreamController mainController) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
      (localDb.select(localDb.snippets)..where((tbl) => tbl.uid.equals(uid))..orderBy([(u) => OrderingTerm.desc(u.index)])).watch().listen((event) {
        if(mainController.isClosed) return;
        controller.add(event);
      });
 
  }

  Future<List<Map<String, dynamic>>> getSnippetsList() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snippets = await (localDb.select(localDb.snippets)..where((tbl) => tbl.uid.equals(uid))..orderBy([(u) => OrderingTerm.desc(u.index)])).get();
    List<Map<String, dynamic>> result = [];
    for (var item in snippets) {
      result.add({
        "snippetId": item.snippetId,
        "lastRecieved": item.lastRecieved,
        "question": item.question,
        "answered": item.answered,
        "theme": item.theme,
        "index": item.index,
        "type": item.type
      });
    }
    return result;
  }


  Future<void> deleteOldResponse() async {
    //Delete all responses older than a day
    await (localDb.delete(localDb.snipResponses)..where((tbl) => tbl.date.isSmallerThan(currentDate.modify(DateTimeModifier.days(-2))))).go();
  }

  Future<void> removeResponse(String snippetId,String userId) async{
    
    (localDb.delete(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(snippetId))..where((tbl) => tbl.uid.equals(userId))).go();


  }

  Future<void> addResponse(Map<String, dynamic> response) async {
    var existingResponse = await (localDb.select(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(response['snippetId']))..where((tbl) => tbl.uid.equals(response['uid']))).get();
    if(existingResponse.isNotEmpty) {

      //Delete existing response
      await (localDb.delete(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(response['snippetId']))..where((tbl) => tbl.uid.equals(response['uid']))).go();

    }

    await localDb.into(localDb.snipResponses).insert(SnipResponsesCompanion(
      answer: Value(response['answer']),
      snippetId: Value(response['snippetId']),
      uid: Value(response['uid']),
      displayName: Value(response['displayName']),
      date: Value(response['date']),
      lastUpdated: Value(response['lastUpdated'])
    ));
  }

  Future<Stream> getResponses(String snippetId, List<String> friendsList, bool isAnonymous) async {

    if(isAnonymous){
      return (localDb.select(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(snippetId))..orderBy([(u) => OrderingTerm.desc(u.date)])).watch();

    } else {
      return (localDb.select(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(snippetId))..where((tbl) => tbl.uid.isIn(friendsList))..orderBy([(u) => OrderingTerm.desc(u.date)])).watch();

    }
  }

  Future<SnipResponse?> getLatestResponse(String snippetId) async {
    return (localDb.select(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(snippetId))..orderBy([(u) => OrderingTerm.desc(u.date)])).get().then((value) => value.isNotEmpty ? value.first : null);
  }


  Future<void> deleteChats(String chatId) async {
    await (localDb.delete(localDb.chats)..where((tbl) => tbl.chatId.equals(chatId))).go();
  }

  Future<void> insertChat(Map<String, dynamic> chat) async {
    //Check if 
    //Check if chat already exists
    var existingChat = await (localDb.select(localDb.chats)..where((tbl) => tbl.messageId.equals(chat['messageId']))).get();
    if(existingChat.isNotEmpty) {

      
      return;
    }


    await localDb.into(localDb.chats).insert(ChatsCompanion(
      message: Value(chat['message']),
      senderId: Value(chat['senderId']),
      senderUsername: Value(chat['senderUsername']),
      date: Value(chat['date']),
      senderDisplayName: Value(chat['senderDisplayName']),
      readBy: Value(chat['readBy']),
      chatId: Value(chat['chatId']),
      messageId: Value(chat['messageId']),
      snippetId: Value(chat["snippetId"])
    ));
  }

  Future<Stream> getChats(String chatId) async {

    return (localDb.select(localDb.chats)..where((tbl) => tbl.chatId.equals(chatId))..orderBy([(u) => OrderingTerm.asc(u.date)])).watch();
  }

  //Get most recent chat
  Future<Chat?> getMostRecentChat(String chatId) async {

    return (localDb.select(localDb.chats)..where((tbl) => tbl.chatId.equals(chatId))..orderBy([(u) => OrderingTerm.desc(u.date)])).get().then((value) => value.isNotEmpty ? value.first : null);

  }

  Future<List<Map<String, dynamic>>> getSnippetResponses(String snippetId) async {
    var responses = await (localDb.select(localDb.snipResponses)..where((tbl) => tbl.snippetId.equals(snippetId))..orderBy([(u) => OrderingTerm.desc(u.date)])).get();
    List<Map<String, dynamic>> result = [];
    for (var item in responses) {
      result.add({
        "answer": item.answer,
        "snippetId": item.snippetId,
        "uid": item.uid,
        "displayName": item.displayName,
        "date": item.date,
        "lastUpdated": item.lastUpdated,
        
      });
    }
    return result;
  }
}