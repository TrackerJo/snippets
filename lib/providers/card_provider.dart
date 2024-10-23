import 'package:flutter/material.dart';
import 'package:snippets/constants.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<BOTWAnswer> _answers = [];
  bool _isDragging = false;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  double _angle = 0;
  void Function(BOTWAnswer answer)? onLike;
  void Function(BOTWAnswer answer)? onDislike;

  List<BOTWAnswer> get answers => _answers;
  Offset get position => _position;
  bool get isDragging => _isDragging;
  double get angle => _angle;

  CardProvider() {
    reset();
  }

  void setAnswers(List<BOTWAnswer> answers) {
    _answers = answers.reversed.toList();
  }

  void setOnLike(void Function(BOTWAnswer answer) onLike) {
    this.onLike = onLike;
  }

  void setOnDislike(void Function(BOTWAnswer answer) onDislike) {
    this.onDislike = onDislike;
  }

  void setScreenSize(Size size) {
    _screenSize = size;
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 15 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus();
    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      default:
        resetPosition();
    }
  }

  void like() async {
    _angle = 15;
    _position += Offset(2 * _screenSize.width / 2, 0);

    onLike!(answers.last);
    _nextCard();
    notifyListeners();
  }

  void dislike() {
    _angle = 15;
    _position += Offset(-2 * _screenSize.width / 2, 0);
    onDislike!(answers.last);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_answers.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    BOTWAnswer lastCard = _answers.last;
    _answers.removeLast();
    // _answers.insert(0, lastCard);

    resetPosition();
  }

  void goBack(BOTWAnswer answer) {
    _answers.add(answer);

    // _answers = _answers.reversed.toList();
    resetPosition();
  }

  void resetPosition() {
    _position = Offset.zero;
    _angle = 0;
    _isDragging = false;

    notifyListeners();
  }

  CardStatus? getStatus() {
    if (_position.dx >= 100) {
      return CardStatus.like;
    } else if (_position.dx < -100) {
      return CardStatus.dislike;
    } else {
      return null;
    }
  }

  void reset() {
    notifyListeners();
  }
}
