import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';

import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/botw_result_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class BotwResultsPage extends StatefulWidget {
  final Map<String, dynamic> answers;
  const BotwResultsPage({super.key, this.answers = const {}});

  @override
  State<BotwResultsPage> createState() => _BotwResultsPageState();
}

class _BotwResultsPageState extends State<BotwResultsPage> {
  List<Map<String, dynamic>> results = [];
  Map<String,dynamic> userAnswer = {};

  void getResults() async {
     Map<String, dynamic> botwAnswers = widget.answers;
    if(botwAnswers.isEmpty){
      botwAnswers = (await Database().getBOTW())["answers"];
    }
    List<Map<String, dynamic>> botwResults = [];
    botwAnswers.forEach((key, value) {
      if(key == FirebaseAuth.instance.currentUser!.uid){
        userAnswer = value;
      }
      botwResults.add(value);
    });
    botwResults.sort((a, b) => b['votes'].compareTo(a['votes']));
    setState(() {
      results = botwResults;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResults();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "Results",

           
            showBackButton: true,

            onBackButtonPressed: () async {
              
              
              Navigator.pop(context, true);
            },
          ),
        ),
            
        backgroundColor: ColorSys.background,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children:[ 
              const SizedBox(height: 20),
              if(results.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BOTWResultTile(displayName: results[0]["displayName"], answer: results[0]["answer"], votes: results[0]["votes"], ranking: 1, userId: results[0]["userId"]),
                ),
              if(results.length > 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BOTWResultTile(displayName: results[1]["displayName"], answer: results[1]["answer"], votes: results[1]["votes"], ranking: 2, userId: results[1]["userId"]),
                ),
              if(results.length > 2)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BOTWResultTile(displayName: results[2]["displayName"], answer: results[2]["answer"], votes: results[2]["votes"], ranking: 3, userId: results[2]["userId"]),
                ),
              if(results.indexOf(userAnswer) > 2)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BOTWResultTile(displayName: userAnswer["displayName"], answer: userAnswer["answer"], votes: userAnswer["votes"], ranking: results.indexOf(userAnswer)+1, userId: userAnswer["uid"]),
                ),
            ]
          ),
        ));
  }
}