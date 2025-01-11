import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/local_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

import 'package:snippets/widgets/response_tile.dart';
import 'package:snippets/widgets/saved_response_tile.dart';

class SavedResponsesPage extends StatefulWidget {
  final String userId;
  final bool isCurrentUser;
  const SavedResponsesPage(
      {super.key, required this.userId, required this.isCurrentUser});

  @override
  State<SavedResponsesPage> createState() => _SavedResponsesPageState();
}

class _SavedResponsesPageState extends State<SavedResponsesPage> {
  List<SavedResponse> savedResponses = [];
  bool isLoading = false;

  void getResponsesList() async {
    setState(() {
      isLoading = true;
    });
    await HelperFunctions.saveOpenedPageSF("saved-responses-${widget.userId}");
    if (widget.isCurrentUser) {
      List<SavedResponse> responses = await Database()
          .getSavedResponses(auth.FirebaseAuth.instance.currentUser!.uid);
      if (!mounted) return;
      setState(() {
        if (!mounted) return;
        savedResponses = responses;
        //sort by date
        savedResponses.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        isLoading = false;
      });
    } else {
      List<SavedResponse> responses =
          await Database().getSavedResponses(widget.userId);
      if (!mounted) return;
      setState(() {
        if (!mounted) return;
        savedResponses = responses.where((res) => res.isPublic).toList();
        //sort by date
        savedResponses.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResponsesList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: "Saved Responses",
              theme: "purple",
              showBackButton: true,
              onBackButtonPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    if (isLoading)
                      Center(
                          child: CircularProgressIndicator(
                        color: styling.theme == "christmas"
                            ? styling.green
                            : styling.primary,
                      )),
                    responsesList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  responsesList() {
    return Expanded(
      child: ListView.builder(
          itemCount: savedResponses.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SavedResponseTile(
                  isFirst: index == 0,
                  savedResponse: savedResponses[index],
                  changeVisibility: () async {
                    String hapticFeedback =
                        await HelperFunctions.getHapticFeedbackSF();
                    if (hapticFeedback == "normal") {
                      HapticFeedback.mediumImpact();
                    } else if (hapticFeedback == "light") {
                      HapticFeedback.lightImpact();
                    } else if (hapticFeedback == "heavy") {
                      HapticFeedback.heavyImpact();
                    }
                    await Database().changeSavedResponseVisibility(
                        savedResponses[index].responseId,
                        !savedResponses[index].isPublic);
                    if (!mounted) return;
                    setState(() {
                      if (!mounted) return;
                      savedResponses[index].isPublic =
                          !savedResponses[index].isPublic;
                    });
                  },
                  isCurrentUser: widget.isCurrentUser),
            );
          }),
    );
  }
}
