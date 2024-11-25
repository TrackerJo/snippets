import 'package:cloud_firestore/cloud_firestore.dart';

class Snippet {
  bool answered;
  String question;
  String snippetId;
  int index;
  String type;
  int lastUpdatedMillis;
  int lastRecievedMillis;

  //dynamic to string list
  static List<String> toStringList(List<dynamic> oldList) {
    List<String> newList = [];
    for (var item in oldList) {
      newList.add(item.toString());
    }
    return newList;
  }

  Snippet(
      {required this.answered,
      required this.question,
      required this.snippetId,
      required this.index,
      required this.type,
      required this.lastUpdatedMillis,
      required this.lastRecievedMillis});

  factory Snippet.fromMap(Map<String, dynamic> map) {
    return Snippet(
        answered: map['answered'],
        question: map['question'],
        snippetId: map['snippetId'],
        index: map['index'],
        type: map['type'],
        lastUpdatedMillis: map['lastUpdatedMillis'],
        lastRecievedMillis: map['lastRecievedMillis']);
  }

  Map<String, dynamic> toMap() {
    return {
      'answered': answered,
      'question': question,
      'snippetId': snippetId,
      'index': index,
      'type': type,
      'lastUpdatedMillis': lastUpdatedMillis,
      'lastRecievedMillis': lastRecievedMillis
    };
  }
}

class DiscussionUser {
  String FCMToken;
  String userId;

  DiscussionUser({required this.FCMToken, required this.userId});

  factory DiscussionUser.fromMap(Map<String, dynamic> map) {
    return DiscussionUser(FCMToken: map['FCMToken'], userId: map['userId']);
  }

  Map<String, dynamic> toMap() {
    return {'FCMToken': FCMToken, 'userId': userId};
  }
}

class SnippetResponse {
  String snippetId;
  String answer;
  String userId;
  DateTime date;
  int lastUpdatedMillis;
  List<DiscussionUser> discussionUsers;
  String displayName;

  SnippetResponse(
      {required this.snippetId,
      required this.answer,
      required this.userId,
      required this.date,
      required this.lastUpdatedMillis,
      required this.discussionUsers,
      required this.displayName});

  factory SnippetResponse.fromMap(Map<String, dynamic> map) {
    List<DiscussionUser> discussionUsers = [];
    for (var item in map['discussionUsers']) {
      discussionUsers.add(DiscussionUser.fromMap(item));
    }
    return SnippetResponse(
        snippetId: map['snippetId'],
        answer: map['answer'],
        userId: map['uid'],
        date: map['date'] is Timestamp ? map['date'].toDate() : map['date'],
        lastUpdatedMillis: map['lastUpdatedMillis'],
        displayName: map['displayName'],
        discussionUsers: discussionUsers);
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> discussionUsers = [];
    for (var item in this.discussionUsers) {
      discussionUsers.add(item.toMap());
    }
    return {
      'snippetId': snippetId,
      'answer': answer,
      'userId': userId,
      'date': date,
      'lastUpdatedMillis': lastUpdatedMillis,
      'displayName': displayName,
      'discussionUsers': discussionUsers
    };
  }
}

class Message {
  String message;
  String senderId;
  List<String> readBy;
  String senderDisplayName;
  DateTime date;
  int lastUpdatedMillis;
  String senderUsername;
  String snippetId;
  String messageId;
  String discussionId;

  Message(
      {required this.message,
      required this.senderId,
      required this.readBy,
      required this.senderDisplayName,
      required this.date,
      required this.lastUpdatedMillis,
      required this.senderUsername,
      required this.snippetId,
      required this.discussionId,
      required this.messageId});

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        message: map['message'],
        senderId: map['senderId'],
        readBy: List<String>.from(map['readBy']),
        senderDisplayName: map['senderDisplayName'],
        date: map['date'] is Timestamp ? map['date'].toDate() : map['date'],
        lastUpdatedMillis: map['lastUpdatedMillis'],
        senderUsername: map['senderUsername'],
        messageId: map['messageId'],
        discussionId: map['discussionId'],
        snippetId: map['snippetId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'readBy': readBy,
      'senderDisplayName': senderDisplayName,
      'date': date,
      'lastUpdatedMillis': lastUpdatedMillis,
      'senderUsername': senderUsername,
      'messageId': messageId,
      'discussionId': discussionId,
      'snippetId': snippetId
    };
  }
}

class BOTWAnswer {
  String FCMToken;
  String answer;
  String displayName;
  String userId;
  List<String> voters;
  int votes;

  BOTWAnswer(
      {required this.FCMToken,
      required this.answer,
      required this.displayName,
      required this.userId,
      required this.voters,
      required this.votes});

  factory BOTWAnswer.fromMap(Map<String, dynamic> map) {
    return BOTWAnswer(
        FCMToken: map['FCMToken'],
        answer: map['answer'],
        displayName: map['displayName'],
        userId: map['userId'],
        voters: List<String>.from(map['voters']),
        votes: map['votes']);
  }

  Map<String, dynamic> toMap() {
    //remove empty strings
    List<String> voters = [];
    for (var item in this.voters) {
      if (item != "") {
        voters.add(item);
      }
    }
    return {
      'FCMToken': FCMToken,
      'answer': answer,
      'displayName': displayName,
      'userId': userId,
      'voters': voters,
      'votes': votes
    };
  }
}

enum BOTWStatusType { voting, answering, done }

class BOTW {
  Map<String, BOTWAnswer> answers;
  String blank;
  int lastUpdatedMillis;
  BOTWStatusType status;
  DateTime week;

  BOTW(
      {required this.answers,
      required this.blank,
      required this.lastUpdatedMillis,
      required this.week,
      required this.status});

  BOTW.empty()
      : answers = {},
        blank = "",
        lastUpdatedMillis = 0,
        week = DateTime.now(),
        status = BOTWStatusType.voting;

  factory BOTW.fromMap(Map<String, dynamic> map) {
    Map<String, BOTWAnswer> answers = {};
    for (var key in map['answers'].keys) {
      answers[key] = BOTWAnswer.fromMap(map['answers'][key]);
    }
    return BOTW(
        answers: answers,
        blank: map['blank'],
        lastUpdatedMillis: map['lastUpdatedMillis'],
        week: DateTime.now(),
        status:
            BOTWStatusType.values.firstWhere((e) => e.name == map['status']));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> answers = {};
    for (var key in this.answers.keys) {
      answers[key] = this.answers[key]?.toMap();
    }
    return {
      'answers': answers,
      'blank': blank,
      'lastUpdatedMillis': lastUpdatedMillis,
      'week': week,
      'status': status.name
    };
  }
}

class BOTWStatus {
  String date;
  bool hasAnswered;
  bool hasSeenResults;

  BOTWStatus(
      {required this.date,
      required this.hasAnswered,
      required this.hasSeenResults});

  factory BOTWStatus.fromMap(Map<String, dynamic> map) {
    return BOTWStatus(
        date: map['date'],
        hasAnswered: map['hasAnswered'],
        hasSeenResults: map['hasSeenResults']);
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'hasAnswered': hasAnswered,
      'hasSeenResults': hasSeenResults
    };
  }
}

class Discussion {
  String answerId;
  bool isAnonymous;
  String snippetId;
  String snippetQuestion;

  Discussion(
      {required this.answerId,
      required this.isAnonymous,
      required this.snippetId,
      required this.snippetQuestion});

  factory Discussion.fromMap(Map<String, dynamic> map) {
    return Discussion(
        answerId: map['answerId'],
        isAnonymous: map['isAnonymous'],
        snippetId: map['snippetId'],
        snippetQuestion: map['snippetQuestion']);
  }

  Map<String, dynamic> toMap() {
    return {
      'answerId': answerId,
      'isAnonymous': isAnonymous,
      'snippetId': snippetId,
      'snippetQuestion': snippetQuestion
    };
  }
}

class UserMini {
  String FCMToken;
  String displayName;
  String userId;
  String username;

  UserMini(
      {required this.FCMToken,
      required this.displayName,
      required this.userId,
      required this.username});

  factory UserMini.fromMap(Map<String, dynamic> map) {
    return UserMini(
        FCMToken: map['FCMToken'],
        displayName: map['displayName'],
        userId: map['userId'],
        username: map['username']);
  }

  Map<String, dynamic> toMap() {
    return {
      'FCMToken': FCMToken,
      'displayName': displayName,
      'userId': userId,
      'username': username
    };
  }
}

class User {
  String FCMToken;
  String displayName;
  BOTWStatus botwStatus;
  String description;
  List<Discussion> discussions;
  String email;
  List<UserMini> friends;
  List<UserMini> friendRequests;
  List<UserMini> outgoingFriendRequests;
  String username;
  String searchKey;
  String userId;
  int votesLeft;
  int lastUpdatedMillis;
  int snippetsRespondedTo;
  int messagesSent;
  int discussionsStarted;

  User(
      {required this.FCMToken,
      required this.displayName,
      required this.botwStatus,
      required this.description,
      required this.discussions,
      required this.email,
      required this.friends,
      required this.friendRequests,
      required this.outgoingFriendRequests,
      required this.username,
      required this.searchKey,
      required this.userId,
      required this.snippetsRespondedTo,
      this.lastUpdatedMillis = 0,
      required this.discussionsStarted,
      required this.messagesSent,
      required this.votesLeft});

  //Create empty user
  User.empty()
      : FCMToken = "",
        displayName = "",
        botwStatus =
            BOTWStatus(date: "", hasAnswered: false, hasSeenResults: false),
        description = "",
        discussions = [],
        email = "",
        friends = [],
        friendRequests = [],
        outgoingFriendRequests = [],
        username = "",
        searchKey = "",
        lastUpdatedMillis = 0,
        snippetsRespondedTo = 0,
        discussionsStarted = 0,
        messagesSent = 0,
        userId = "",
        votesLeft = 0;

  factory User.fromMap(Map<String, dynamic> map) {
    List<Discussion> discussions = [];
    for (var item in map['discussions']) {
      discussions.add(Discussion.fromMap(item));
    }
    List<UserMini> friends = [];
    for (var item in map['friends']) {
      friends.add(UserMini.fromMap(item));
    }
    List<UserMini> friendRequests = [];
    for (var item in map['friendRequests']) {
      friendRequests.add(UserMini.fromMap(item));
    }
    List<UserMini> outgoingFriendRequests = [];
    for (var item in map['outgoingRequests']) {
      outgoingFriendRequests.add(UserMini.fromMap(item));
    }
    return User(
        FCMToken: map['FCMToken'],
        displayName: map['fullname'],
        botwStatus: BOTWStatus.fromMap(map['botwStatus']),
        description: map['description'],
        discussions: discussions,
        email: map['email'],
        friends: friends,
        friendRequests: friendRequests,
        outgoingFriendRequests: outgoingFriendRequests,
        username: map['username'],
        searchKey: map['searchKey'],
        userId: map['uid'],
        snippetsRespondedTo: map['snippetsRespondedTo'] ?? 0,
        lastUpdatedMillis: map['lastUpdatedMillis'] ?? 0,
        discussionsStarted: map['discussionsStarted'] ?? 0,
        messagesSent: map['messagesSent'] ?? 0,
        votesLeft: map['votesLeft']);
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> discussions = [];
    for (var item in this.discussions) {
      discussions.add(item.toMap());
    }
    List<Map<String, dynamic>> friends = [];
    for (var item in this.friends) {
      friends.add(item.toMap());
    }
    List<Map<String, dynamic>> friendRequests = [];
    for (var item in this.friendRequests) {
      friendRequests.add(item.toMap());
    }
    List<Map<String, dynamic>> outgoingFriendRequests = [];
    for (var item in this.outgoingFriendRequests) {
      outgoingFriendRequests.add(item.toMap());
    }
    return {
      'FCMToken': FCMToken,
      'fullname': displayName,
      'botwStatus': botwStatus.toMap(),
      'description': description,
      'discussions': discussions,
      'email': email,
      'friends': friends,
      'friendRequests': friendRequests,
      'outgoingRequests': outgoingFriendRequests,
      'username': username,
      'searchKey': searchKey,
      'uid': userId,
      'votesLeft': votesLeft,
      'snippetsRespondedTo': snippetsRespondedTo,
      'lastUpdatedMillis': lastUpdatedMillis
    };
  }
}

class DiscussionFull {
  String snippetQuestion;
  String answerDisplayName;
  Message lastMessage;
  String snippetId;
  String answerId;
  String answer;
  List<DiscussionUser> discussionUsers;
  bool isAnonymous;

  DiscussionFull(
      {required this.snippetQuestion,
      required this.answerDisplayName,
      required this.lastMessage,
      required this.snippetId,
      required this.answerId,
      required this.answer,
      required this.discussionUsers,
      required this.isAnonymous});

  factory DiscussionFull.fromMap(Map<String, dynamic> map) {
    return DiscussionFull(
        snippetQuestion: map['snippetQuestion'],
        answerDisplayName: map['answerDisplayName'],
        lastMessage: Message.fromMap(map['lastMessage']),
        snippetId: map['snippetId'],
        answerId: map['answerId'],
        answer: map['answer'],
        discussionUsers: List<DiscussionUser>.from(map['discussionUsers']),
        isAnonymous: map['isAnonymous']);
  }

  Map<String, dynamic> toMap() {
    return {
      'snippetQuestion': snippetQuestion,
      'answerDisplayName': answerDisplayName,
      'lastMessage': lastMessage.toMap(),
      'snippetId': snippetId,
      'answerId': answerId,
      'answer': answer,
      'discussionUsers': discussionUsers,
      'isAnonymous': isAnonymous
    };
  }
}

class NotificationText {
  String title;
  String body;

  NotificationText({required this.title, required this.body});

  factory NotificationText.fromString(String notification) {
    List<String> split = notification.split("~~~");
    return NotificationText(title: split[0], body: split[1]);
  }

  @override
  String toString() {
    return "$title~~~$body";
  }
}
