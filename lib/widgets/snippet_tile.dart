import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/responses_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';

import 'helper_functions.dart';

class SnippetTile extends StatefulWidget {
  // final bool isAnswered;

  final String question;

  final String snippetId;
  final bool isAnswered;
  final String theme;
  final String type;
  const SnippetTile({
    super.key,

    required this.question,

    required this.snippetId,
    required this.isAnswered,
    required this.theme,
    required this.type,
  });

  @override
  State<SnippetTile> createState() => _SnippetTileState();
}

class _SnippetTileState extends State<SnippetTile> {
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: widget.type == "anonymous" ?
        ColorSys.blackGradient.colors[0]
      : ColorSys.blueGreenGradient.colors[1],

      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: ShapeDecoration(
          gradient:  widget.type == "anonymous" ? 
            ColorSys.blackGradient
          
          :ColorSys.blueGreenGradient,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: ListTile(
          onTap: () => {
            if (!widget.isAnswered)
              {}
            else
              {
                HapticFeedback.mediumImpact(),
                nextScreen(
                  context,
                  ResponsesPage(
                      snippetId: widget.snippetId,
                      question: widget.question,
                      theme: widget.theme,
                      isAnonymous: widget.type == "anonymous",),
                ),
              }
          },
          trailing: IconButton(
            icon: !widget.isAnswered
                ? const Icon(Icons.send, color: Colors.black)
                : const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onPressed: () async {
              // show options
              if (!widget.isAnswered) {
                if(answerController.text.isEmpty){
                  return;
                }
                if(widget.type == "anonymous") {
                  String anonymousID = await HelperFunctions.saveAnonymouseIDSF();
                  await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                    .submitAnswer(widget.snippetId, answerController.text, widget.question, widget.theme,anonymousID);
                } else 
                {
                  await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                    .submitAnswer(widget.snippetId, answerController.text, widget.question, widget.theme, null);
                }
                setState(() {
                  answerController.clear();
                });
                // Navigator.of(context).pop();
                //Go to responses page
                
              } else {
                HapticFeedback.mediumImpact();
                nextScreen(
                  context,
                  ResponsesPage(
                      snippetId: widget.snippetId,
                      question: widget.question,
                      theme: widget.theme,
                      isAnonymous: widget.type == "anonymous",),
                );
              }
            },
          ),
          title: Text(
            widget.question,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontFamily: 'Inknut Antiqua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          subtitle: !widget.isAnswered
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                      controller: answerController,
                      decoration: textInputDecoration.copyWith(
                        hintText: "Enter answer here",
                        //Border color: color: ColorSys.primarySolid,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            
                        ),
                        fillColor: ColorSys.primaryInput
                        
                        //   borderRadius: BorderRadius.circular(20.0),
                        //   borderSide: BorderSide(
                        //     color: ColorSys.primarySolid,
                        //     width: 20,
                        //   ),
                        // ),
                      )),
                )
              : null,
        ),
      ),
    );
  }
}
