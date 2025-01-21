import 'package:cloud_firestore/cloud_firestore.dart';

enum ReportType { profile, response, message }

class Report {
  DateTime date;
  ReportType type;
  String reportId;
  String reportedUserId;
  String reason = "";
  String additionalInfo = "";

  Report(
      {required this.date,
      required this.type,
      required this.reportId,
      required this.reportedUserId,
      required this.reason,
      required this.additionalInfo});

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
        date: map['date'].toDate(),
        type: ReportType.values.firstWhere((e) => e.name == map['type']),
        reportId: map['reportId'],
        reportedUserId: map['reportedUserId'],
        reason: map['reason'],
        additionalInfo: map['additionalInfo']);
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'type': type.name,
      'reportId': reportId,
      'reportedUserId': reportedUserId,
      'reason': reason,
      'additionalInfo': additionalInfo
    };
  }
}

class ResponseReport extends Report {
  String responseId;
  String snippetId;
  String response;

  ResponseReport(
      {required this.responseId,
      required this.snippetId,
      required this.response,
      required super.date,
      super.type = ReportType.response,
      required super.reportId,
      required super.reportedUserId,
      required super.reason,
      required super.additionalInfo});

  factory ResponseReport.fromMap(Map<String, dynamic> map) {
    return ResponseReport(
        responseId: map['responseId'],
        snippetId: map['snippetId'],
        response: map['response'],
        date: map['date'].toDate(),
        type: ReportType.values.firstWhere((e) => e.name == map['type']),
        reportId: map['reportId'],
        reportedUserId: map['reportedUserId'],
        reason: map['reason'],
        additionalInfo: map['additionalInfo']);
  }

  Map<String, dynamic> toMap() {
    return {
      'responseId': responseId,
      'snippetId': snippetId,
      'response': response,
      'date': date,
      'type': type.name,
      'reportId': reportId,
      'reportedUserId': reportedUserId,
      'reason': reason,
      'additionalInfo': additionalInfo
    };
  }
}

enum ProfileReportType {
  name,
  username,
  description,
  botw,
  other;

  @override
  String toString() {
    switch (this) {
      case ProfileReportType.name:
        return 'name';
      case ProfileReportType.description:
        return 'description';
      case ProfileReportType.botw:
        return 'botw';
      case ProfileReportType.other:
        return 'other';
      case ProfileReportType.username:
        return 'username';
      default:
        return '';
    }
  }
}

class ProfileReport extends Report {
  ProfileReportType profileReportType;
  String other;
  String reportedInfo;

  ProfileReport(
      {required this.profileReportType,
      required this.reportedInfo,
      required this.other,
      required super.date,
      super.type = ReportType.profile,
      required super.reportId,
      required super.reportedUserId,
      required super.reason,
      required super.additionalInfo});

  factory ProfileReport.fromMap(Map<String, dynamic> map) {
    return ProfileReport(
        profileReportType: ProfileReportType.values
            .firstWhere((e) => e.name == map['profileReportType']),
        reportedInfo: map['reportedInfo'],
        date: map['date'].toDate(),
        type: ReportType.values.firstWhere((e) => e.name == map['type']),
        reportId: map['reportId'],
        other: map['other'],
        reportedUserId: map['reportedUserId'],
        reason: map['reason'],
        additionalInfo: map['additionalInfo']);
  }

  Map<String, dynamic> toMap() {
    return {
      'profileReportType': profileReportType.name,
      'reportedInfo': reportedInfo,
      'date': date,
      'other': other,
      'type': type.name,
      'reportId': reportId,
      'reportedUserId': reportedUserId,
      'reason': reason,
      'additionalInfo': additionalInfo
    };
  }
}

class MessageReport extends Report {
  String messageId;
  String message;
  String snippetId;
  String responseId;

  MessageReport(
      {required this.messageId,
      required this.message,
      required this.snippetId,
      required this.responseId,
      required super.date,
      super.type = ReportType.message,
      required super.reportId,
      required super.reportedUserId,
      required super.reason,
      required super.additionalInfo});

  factory MessageReport.fromMap(Map<String, dynamic> map) {
    return MessageReport(
        messageId: map['messageId'],
        message: map['message'],
        snippetId: map['snippetId'],
        responseId: map['responseId'],
        date: map['date'].toDate(),
        type: ReportType.values.firstWhere((e) => e.name == map['type']),
        reportId: map['reportId'],
        reportedUserId: map['reportedUserId'],
        reason: map['reason'],
        additionalInfo: map['additionalInfo']);
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'message': message,
      'snippetId': snippetId,
      'responseId': responseId,
      'date': date,
      'type': type.name,
      'reportId': reportId,
      'reportedUserId': reportedUserId,
      'reason': reason,
      'additionalInfo': additionalInfo
    };
  }
}

class Snippet {
  bool answered;
  String question;
  String snippetId;
  int index;
  String type;
  List<String> options;
  String correctAnswer;
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
      required this.correctAnswer,
      required this.options,
      required this.lastRecievedMillis});

  factory Snippet.fromMap(Map<String, dynamic> map) {
    return Snippet(
        answered: map['answered'],
        question: map['question'],
        snippetId: map['snippetId'],
        index: map['index'],
        type: map['type'],
        correctAnswer: map['correctAnswer'] ?? "",
        options: map['options'] != null ? toStringList(map['options']) : [],
        lastUpdatedMillis: map['lastUpdatedMillis'],
        lastRecievedMillis: map['lastRecievedMillis']);
  }

  Map<String, dynamic> toMap() {
    return {
      'answered': answered,
      'question': question,
      'snippetId': snippetId,
      'index': index,
      'options': options,
      'correctAnswer': correctAnswer,
      'type': type,
      'lastUpdatedMillis': lastUpdatedMillis,
      'lastRecievedMillis': lastRecievedMillis
    };
  }
}

class OptionData {
  final String option;
  int occurrence;

  OptionData({required this.option, required this.occurrence});
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
  int reports;
  List<String> reportIds = [];

  SnippetResponse(
      {required this.snippetId,
      required this.answer,
      required this.userId,
      required this.date,
      required this.lastUpdatedMillis,
      required this.discussionUsers,
      required this.reports,
      required this.reportIds,
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
        reports: map['reports'] ?? 0,
        reportIds:
            map['reportIds'] != null ? List<String>.from(map['reportIds']) : [],
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
      'reports': reports,
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
  List<String> reportIds = [];
  int reports;

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
      required this.reports,
      required this.reportIds,
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
        snippetId: map['snippetId'],
        reports: map['reports'] ?? 0,
        reportIds: map['reportIds'] != null
            ? List<String>.from(map['reportIds'])
            : []);
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
      'snippetId': snippetId,
      'reports': reports,
      'reportIds': reportIds
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
  Map<String, BOTWAnswer> previousAnswers;
  String blank;
  int lastUpdatedMillis;
  BOTWStatusType status;
  DateTime week;

  BOTW(
      {required this.answers,
      required this.blank,
      required this.lastUpdatedMillis,
      required this.previousAnswers,
      required this.week,
      required this.status});

  BOTW.empty()
      : answers = {},
        blank = "",
        lastUpdatedMillis = 0,
        previousAnswers = {},
        week = DateTime.now(),
        status = BOTWStatusType.voting;

  factory BOTW.fromMap(Map<String, dynamic> map) {
    Map<String, BOTWAnswer> answers = {};
    for (var key in map['answers'].keys) {
      answers[key] = BOTWAnswer.fromMap(map['answers'][key]);
    }
    Map<String, BOTWAnswer> previousAnswers = {};
    if (map['previousAnswers'] == null) {
      map['previousAnswers'] = {};
    }
    for (var key in map['previousAnswers'].keys) {
      previousAnswers[key] = BOTWAnswer.fromMap(map['previousAnswers'][key]);
    }
    return BOTW(
        answers: answers,
        blank: map['blank'],
        lastUpdatedMillis: map['lastUpdatedMillis'],
        week: DateTime.now(),
        previousAnswers: previousAnswers,
        status:
            BOTWStatusType.values.firstWhere((e) => e.name == map['status']));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> answers = {};
    for (var key in this.answers.keys) {
      answers[key] = this.answers[key]?.toMap();
    }
    Map<String, dynamic> previousAnswers = {};
    for (var key in this.previousAnswers.keys) {
      previousAnswers[key] = this.previousAnswers[key]?.toMap();
    }
    return {
      'answers': answers,
      'blank': blank,
      'lastUpdatedMillis': lastUpdatedMillis,
      'week': week,
      'previousAnswers': previousAnswers,
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
  List<String> bestFriends;
  String username;
  String searchKey;
  String userId;
  int votesLeft;
  int lastUpdatedMillis;
  int snippetsRespondedTo;
  int messagesSent;
  int discussionsStarted;
  int streak;
  DateTime streakDate;
  int longestStreak;
  int triviaPoints;
  int topBOTW;
  List<String> profileStrikes;

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
      required this.longestStreak,
      required this.userId,
      required this.snippetsRespondedTo,
      this.lastUpdatedMillis = 0,
      required this.discussionsStarted,
      required this.bestFriends,
      required this.messagesSent,
      required this.streak,
      required this.streakDate,
      required this.topBOTW,
      required this.triviaPoints,
      required this.profileStrikes,
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
        longestStreak = 0,
        bestFriends = [],
        streak = 0,
        streakDate = DateTime.now(),
        profileStrikes = [],
        username = "",
        searchKey = "",
        lastUpdatedMillis = 0,
        snippetsRespondedTo = 0,
        discussionsStarted = 0,
        messagesSent = 0,
        triviaPoints = 0,
        topBOTW = 0,
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
    List<String> bestFriends = [];
    if (map['bestFriends'] != null) {
      for (var item in map['bestFriends']) {
        bestFriends.add(item.toString());
      }
    }
    List<String> profileStrikes = [];
    if (map['profileStrikes'] != null) {
      for (var item in map['profileStrikes']) {
        profileStrikes.add(item.toString());
      }
    }
    return User(
        FCMToken: map['FCMToken'],
        displayName: map['fullname'],
        botwStatus: BOTWStatus.fromMap(map['botwStatus']),
        description: map['description'],
        discussions: discussions,
        streak: map['streak'] ?? 0,
        streakDate: map['streakDate'] != null
            ? map['streakDate'].toDate()
            : DateTime(2021, 1, 1),
        email: map['email'],
        friends: friends,
        bestFriends: bestFriends,
        friendRequests: friendRequests,
        outgoingFriendRequests: outgoingFriendRequests,
        username: map['username'],
        searchKey: map['searchKey'],
        userId: map['uid'],
        longestStreak: map['longestStreak'] ?? 0,
        snippetsRespondedTo: map['snippetsRespondedTo'] ?? 0,
        lastUpdatedMillis: map['lastUpdatedMillis'] ?? 0,
        discussionsStarted: map['discussionsStarted'] ?? 0,
        messagesSent: map['messagesSent'] ?? 0,
        topBOTW: map["topBOTW"] ?? 0,
        triviaPoints: map["triviaPoints"] ?? 0,
        profileStrikes: profileStrikes,
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
      'streak': streak,
      'streakDate': streakDate,
      'friendRequests': friendRequests,
      'outgoingRequests': outgoingFriendRequests,
      'username': username,
      'searchKey': searchKey,
      'uid': userId,
      'bestFriends': bestFriends,
      'votesLeft': votesLeft,
      'snippetsRespondedTo': snippetsRespondedTo,
      'longestStreak': longestStreak,
      "triviaPoints": triviaPoints,
      "topBOTW": topBOTW,
      "profileStrikes": profileStrikes,
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

class SavedResponse {
  String question;
  String answer;
  String responseId;
  bool isPublic;
  int lastUpdated;
  String userId;

  SavedResponse(
      {required this.answer,
      required this.lastUpdated,
      required this.isPublic,
      required this.responseId,
      required this.userId,
      required this.question});

  factory SavedResponse.fromMap(Map<String, dynamic> map) {
    return SavedResponse(
        question: map["question"],
        answer: map["answer"],
        lastUpdated: map["lastUpdated"],
        responseId: map['responseId'],
        userId: map['userId'],
        isPublic: map['isPublic']);
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'lastUpdated': lastUpdated,
      'isPublic': isPublic,
      'userId': userId,
      'responseId': responseId
    };
  }
}

class SavedMessage {
  String message;
  String senderId;
  String senderDisplayName;
  DateTime date;
  String senderUsername;
  String messageId;
  String responseId;
  List<String> reportIds = [];
  int reports;

  SavedMessage(
      {required this.message,
      required this.senderId,
      required this.senderDisplayName,
      required this.date,
      required this.senderUsername,
      required this.responseId,
      required this.reports,
      required this.reportIds,
      required this.messageId});

  factory SavedMessage.fromMap(Map<String, dynamic> map) {
    return SavedMessage(
      message: map['message'],
      senderId: map['senderId'],
      responseId: map['responseId'],
      senderDisplayName: map['senderDisplayName'],
      date: map['date'] is Timestamp ? map['date'].toDate() : map['date'],
      senderUsername: map['senderUsername'],
      messageId: map['messageId'],
      reports: map['reports'] ?? 0,
      reportIds:
          map['reportIds'] != null ? List<String>.from(map['reportIds']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'senderDisplayName': senderDisplayName,
      'date': date,
      'senderUsername': senderUsername,
      'messageId': messageId,
      'responseId': responseId,
      'reports': reports,
      'reportIds': reportIds
    };
  }
}
