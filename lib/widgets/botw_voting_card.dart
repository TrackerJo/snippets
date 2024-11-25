import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippets/main.dart';
import 'package:snippets/providers/card_provider.dart';

class BOTWVotingCard extends StatefulWidget {
  // final bool isAnswered;

  final String displayName;
  final String answer;
  final bool isFront;
  final bool isSecond;
  final int numberOfLines;

  const BOTWVotingCard({
    super.key,
    required this.displayName,
    required this.isFront,
    required this.answer,
    required this.numberOfLines,
    required this.isSecond,
  });

  @override
  State<BOTWVotingCard> createState() => _BOTWVotingCardState();
}

class _BOTWVotingCardState extends State<BOTWVotingCard> {
  TextEditingController answerController = TextEditingController();
  bool isEditting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        child: widget.isFront ? buildFrontCard() : buildCard(),
      );

  Widget buildFrontCard() => GestureDetector(
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            duration: Duration(milliseconds: milliseconds),
            curve: Curves.easeInOut,
            transform: rotatedMatrix
              ..translate(
                position.dx,
                position.dy,
              ),
            child: buildCard(),
          );
        }),
      );

  Widget buildCard() => Material(
        elevation: 10,
        shadowColor: widget.isFront || widget.isSecond
            ? styling.primaryDark
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 300,
          height: 80 + widget.numberOfLines.toDouble() * 20,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: ShapeDecoration(
            gradient: styling.getPurpleBlueGradient(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: ListTile(
            onTap: () => {},
            title: Text(
              widget.displayName,
              style: TextStyle(
                color: styling.theme == "colorful-light"
                    ? styling.primaryDark
                    : Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
              textAlign: TextAlign.center,
            ),
            subtitle: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.answer,
                            style: TextStyle(
                                color: styling.theme == "colorful-light"
                                    ? styling.primaryDark
                                    : Colors.black,
                                fontSize: 16))),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
