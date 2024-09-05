import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';

import 'helper_functions.dart';

class BOTWTile extends StatefulWidget {
  // final bool isAnswered;

  final String blank;
  final Map<String, dynamic> answer;
  final bool isCurrentUser;
  final String status;


  const BOTWTile({
    super.key,
   
    required this.blank,
    required this.isCurrentUser,
    required this.answer,
    required this.status,
  });

  @override
  State<BOTWTile> createState() => _BOTWTileState();
}

class _BOTWTileState extends State<BOTWTile> {
  TextEditingController answerController = TextEditingController();
  bool isEditting = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
          onTap: () => {
           
          },
          
          title: Text(
            widget.blank,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontFamily: 'Inknut Antiqua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: widget.status == "answering" && widget.isCurrentUser && (widget.answer["answer"] == "" || isEditting)
              ? Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onTap: () {
                          HapticFeedback.selectionClick();
                        },
                          controller: answerController,
                          maxLines: 2,
                          decoration: textInputDecoration.copyWith(
                            hintText: "Enter submission here",
                            fillColor: ColorSys.primaryInput
                            //Border color: color: ColorSys.primarySolid,

                            //   borderSide: BorderSide(
                            //     color: ColorSys.primarySolid,
                            //     width: 20,
                            //   ),
                            // ),
                          )),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          isEditting = false;
                        });
                        widget.answer["answer"] = answerController.text;
                        await Database().updateUsersBOTWAnswer(widget.answer);
                        


                       
                      },
                      style: elevatedButtonDecorationBlue,
                      child: Text(isEditting ? "Save" : "Submit",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                ],
              )
              : Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 100,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.answer["answer"], style: const TextStyle(color: Colors.black, fontSize: 16))),
                    ),
                  ),
                  if(widget.status == "answering" &&  widget.isCurrentUser)
                    ElevatedButton(onPressed: () {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        isEditting = true;
                        answerController.text = widget.answer["answer"];
                      });
                    }, style: elevatedButtonDecorationBlue, child: const Text("Edit", style: TextStyle(color: Colors.black, fontSize: 16)) ),
                  if(widget.status == "voting" && widget.isCurrentUser)
                    Text("Votes: ${widget.answer["votes"]}", style: const TextStyle(color: Colors.black, fontSize: 16)) 
                ],
              ),
        ),
      ),
    );
  }
}
