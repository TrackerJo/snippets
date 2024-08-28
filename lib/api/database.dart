import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/local_database.dart';

class Database {
  Future<Stream<Map<String, dynamic>>> getBOTWStream(StreamController controller) async {
    DateTime? lastUpdated = (await LocalDatabase().getBOTW())["lastUpdated"];
    print("Last updated: $lastUpdated");
    StreamController<Map<String, dynamic>> fbcontroller = StreamController();
    
    print("Last updated: $lastUpdated");
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).getBlankOfTheWeek(fbcontroller, lastUpdated);

    fbcontroller.stream.listen((event) async{
      if(controller.isClosed) return;
      print("Event: $event");
      
        


        print("ADDDDD");
        await LocalDatabase().deleteBOTW();
        await LocalDatabase().addBOTW(event);
      
    });
    return await LocalDatabase().getBOTWStream();

  }

  Future<Map<String, dynamic>> getBOTW() async {
    DateTime? lastUpdated = (await LocalDatabase().getBOTW())["lastUpdated"];
    print("Last updated: $lastUpdated");
    Map<String, dynamic>? fbBotw = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).getBlankOfTheWeekData(lastUpdated);
    if(fbBotw != null){
      await LocalDatabase().deleteBOTW();
      await LocalDatabase().addBOTW(fbBotw);
    }
    return await LocalDatabase().getBOTW();

  }

  Future<void> updateUsersBOTWAnswer(Map<String, dynamic> answer) async {
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).updateUsersBOTWAnswer(answer);
    await LocalDatabase().updateUsersBOTWAnswer(answer);
  }

  Future<void> updateBOTWAnswer(Map<String, dynamic> answer) async {
    await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).updateBOTWAnswer(answer);
    await LocalDatabase().updateUsersBOTWAnswer(answer);
  }

  Future<List<Map<String, dynamic>>> getSnippetsList() async {
    DateTime? lastUpdated = (await LocalDatabase().getMostRecentSnippet())?.lastRecieved;
    List<Map<String, dynamic>> snippets = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).getSnippetsList(lastUpdated);
    for (var i = 0; i < snippets.length; i++) {
      
      await LocalDatabase().addSnippet(snippets[i]);
      
    }
    return await LocalDatabase().getSnippetsList();

  }

  Future<List<Map<String, dynamic>>> getSnippetsResponses() async {
    List<Map<String, dynamic>> snippets = await getSnippetsList();
    List<Map<String, dynamic>> responses = [];
    for (var i = 0; i < snippets.length; i++) {
      SnipResponse? latestResponse = await LocalDatabase().getLatestResponse(snippets[i]["snippetId"]);
      print("Snippet: ${snippets[i]["snippetId"]}");
      print("Question: ${snippets[i]["question"]}");
      print("Latest response: $latestResponse");
      
      DateTime? lastUpdated = latestResponse?.lastUpdated;
      List<Map<String, dynamic>> response = await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).getSnippetResponses(snippets[i]["snippetId"], lastUpdated, snippets[i]["snippetType"] == "anonymous");
      for (var j = 0; j < response.length; j++) {
        response[j]["snippetId"] = snippets[i]["snippetId"];
        await LocalDatabase().addResponse(response[j]);
      }
      responses.addAll(await LocalDatabase().getSnippetResponses(snippets[i]["snippetId"]));
    }
    return responses;
  }


}