import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/providers/card_provider.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/botw_voting_card.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class VotingPage extends StatefulWidget {
  final Map<String, dynamic> blank;


  const VotingPage({super.key, this.blank = const {}});

  @override
  State<VotingPage> createState() => _VotingPageState();
}



class _VotingPageState extends State<VotingPage> {
  List<Map<String, dynamic>> votedAnswers = [];
  List<Map<String, dynamic>> answers = [];
  int votesLeft = 3;
  bool hasSavedVotes = true;
  Map<String, dynamic> profileData  = {};
  Map<String, dynamic> blank = {};
  List<Map<String, dynamic>> movedAnswers = [];
  List<Map<String, dynamic>> removedVotedAnswers = [];


  List<Map<String,dynamic>> getAnswers(Map<String, dynamic> answers, Map<String, dynamic> profileData){
    List<Map<String,dynamic>> listAnswers = [];
    answers.forEach((key, value) {
      if(key == profileData["uid"]) return;
      if(value["voters"].contains(profileData["uid"])) return;
      
      listAnswers.add(value);
    });
    return listAnswers;
  }


  List<Map<String,dynamic>> getVotedBOTW(Map<String, dynamic> answers, Map<String, dynamic> profileData){

    List<Map<String,dynamic>> votedBOTW = [];
    answers.forEach((key, value) {
      if(value["voters"].contains(profileData["uid"])) votedBOTW.add(value);
    });

    return votedBOTW;
  }

  void getData() async {
    bool hasVotedBefore = await HelperFunctions.checkIfVotedBeforeSF();
    if(!hasVotedBefore){
      await HelperFunctions.saveVotedBeforeSF();
      showVotingHelp();

    }
    Map<String, dynamic> nblank = {};
    if(widget.blank.isEmpty){
      nblank = await Database().getBOTW();

      setState(() {
        blank = nblank;
      });
    } else {
      nblank = widget.blank;
      setState(() {
        
        blank = widget.blank;
      });
    }
    
    Map<String, dynamic> data = await HelperFunctions.getUserDataFromSF();
    final provider = Provider.of<CardProvider>(context, listen: false);


    provider.setAnswers(getAnswers(nblank["answers"], data));
    provider.setOnLike(voteForAnswer);
    provider.setOnDislike(skipAnswer);
    setState(() {
      profileData = data;
      votesLeft = data["votesLeft"];
      votedAnswers = getVotedBOTW(blank["answers"], data);
      answers = getAnswers(blank["answers"], data);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void voteForAnswer(Map<String, dynamic> answer) async {

    if(votesLeft == 0){
      showOutOfVotes();
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.goBack(answer);
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() {
      hasSavedVotes = false;
      movedAnswers.add(answer);
      votedAnswers.add(answer);
      votesLeft--;
      if(removedVotedAnswers.contains(answer)){
        removedVotedAnswers.remove(answer);
      }
     
      

    });
 await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
       answers.remove(answer);
    });
  }

   void skipAnswer(Map<String, dynamic> answer) {
    HapticFeedback.mediumImpact();
    setState(() {

      movedAnswers.add(answer);
     



    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "Voting",
            showHelpButton: true,
            onHelpButtonPressed: () {
              showVotingHelp();
            },
            showBackButton: true,

            onBackButtonPressed: () async {
              
              for (var answer in votedAnswers) {
                if(answer["voters"].contains(profileData["uid"])) continue;
                answer["votes"] += 1;
                answer["voters"].add(FirebaseAuth.instance.currentUser!.uid);
                await Database().updateBOTWAnswer(answer);
                await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).updateUserVotesLeft(votesLeft);
                PushNotifications().sendNotification(title: "${profileData["fullname"]} voted for your ${blank["blank"]}", body: "Click here to see how many votes it now has!", targetIds: [answer["FCMToken"]], data: {"type": "voted"});
              }
              for (var answer in removedVotedAnswers) {
                answer["votes"] -= 1;
                answer["voters"].remove(profileData["uid"]);
                await Database().updateBOTWAnswer(answer);
                await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).updateUserVotesLeft(votesLeft);
              }
              //update votes left
              await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid).updateUserVotesLeft(votesLeft);
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Best ${blank["blank"]}", style: const TextStyle(color: Colors.white, fontSize: 26), textAlign: TextAlign.center,  ),
              ),
              const Text("Vote for the best three answers", style: TextStyle(color: Colors.white, fontSize: 16)),
             const SizedBox(height: 10),
              Text("Votes left: $votesLeft", style: const TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 20),
              buildCards(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(
                        color: ColorSys.primary.withOpacity(0.5),
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      )],

                    ),
                    child: IconButton(onPressed: () {
                      if(movedAnswers.isEmpty ) return;
                      HapticFeedback.mediumImpact();
                      final provider = Provider.of<CardProvider>(context, listen: false);
                      provider.goBack(movedAnswers.last);
                      setState(() {
                        if(votedAnswers.contains(movedAnswers.last)) {votedAnswers.removeLast(); votesLeft++;}
                        answers.add(movedAnswers.last);
                        movedAnswers.removeLast();

                      });
                    
                    }, splashColor: ColorSys.primary,icon: const Icon(Icons.rotate_left, color: Colors.white, size: 30)),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(
                        color: ColorSys.primary.withOpacity(0.5),
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      )],

                    ),
                    
                    child: IconButton(onPressed: () {
                      HapticFeedback.mediumImpact();
                      if(votesLeft == 0){
                        showOutOfVotes();
                        return;
                      }
                      if(answers.isEmpty) return;
                      final provider = Provider.of<CardProvider>(context, listen: false);
                      provider.like();
                     
                    
                    }, splashColor: ColorSys.primary,icon: const Icon(Icons.check, color: Colors.white, size: 30)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              const Text("Answers Voted For", style: TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: votedAnswers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Material(
                            elevation: 10,
                            shadowColor: ColorSys.purpleBlueGradient.colors[1],
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 300,
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              decoration: ShapeDecoration(
                                gradient: ColorSys.purpleBlueGradient,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ), 
                              child: ListTile(
                        title: Text(votedAnswers[index]["answer"], style: const TextStyle(color: Colors.black, fontSize: 16)),
                        subtitle: Text(votedAnswers[index]["displayName"], style: const TextStyle(color: Colors.black, fontSize: 14)),
                        trailing: IconButton(onPressed: () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            //Add back to answers
                            final provider = Provider.of<CardProvider>(context, listen: false);
                            provider.goBack(votedAnswers[index]);
                            answers.add(votedAnswers[index]);
                            movedAnswers.remove(votedAnswers[index]);
                            removedVotedAnswers.add(votedAnswers[index]);
                            votedAnswers.removeAt(index);
                            votesLeft++;
                          });
                        }, splashColor: ColorSys.primary, icon: const Icon(Icons.delete, color: Colors.white, size: 30)),

                      )
                            )
                      ),
                    );
                  },
                ),
              )
              ],
          ),
        )
    );
  }

  void showOutOfVotes(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Out of votes"),
          content: const Text("You have no votes left"),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            )
          ],
        );
      }
    );
  }

  void showVotingHelp(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Voting help"),
          content: const Text("Swipe left to see more answers\nSwipe right to vote for answer or click checkmark\nClick the left arrow to undo your last action"),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            )
          ],
        );
      }
    );
  }

  Widget buildCards() {
   final provider = Provider.of<CardProvider>(context);
   final answers = provider.answers;

   return answers.isEmpty ?
    const Text("No more answers", style: TextStyle(color: Colors.white, fontSize: 20)) :
   
   answers.isNotEmpty ? Stack(
    children: answers.map((answer) {
     

      return BOTWVotingCard(displayName: answer["displayName"], answer: answer["answer"], isFront: answers.last == answer);
    }).toList()
   ) :  Container(
     
      child: const Column(
        children: [
          
          Text("No more answers", style: TextStyle(color: Colors.white, fontSize: 20)),
          
        ],
      ),
   );
  }
}