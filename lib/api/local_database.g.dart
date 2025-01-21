// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderUsernameMeta =
      const VerificationMeta('senderUsername');
  @override
  late final GeneratedColumn<String> senderUsername = GeneratedColumn<String>(
      'sender_username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _senderDisplayNameMeta =
      const VerificationMeta('senderDisplayName');
  @override
  late final GeneratedColumn<String> senderDisplayName =
      GeneratedColumn<String>('sender_display_name', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _readByMeta = const VerificationMeta('readBy');
  @override
  late final GeneratedColumn<String> readBy = GeneratedColumn<String>(
      'read_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _snippetIdMeta =
      const VerificationMeta('snippetId');
  @override
  late final GeneratedColumn<String> snippetId = GeneratedColumn<String>(
      'snippet_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMillisMeta =
      const VerificationMeta('lastUpdatedMillis');
  @override
  late final GeneratedColumn<int> lastUpdatedMillis = GeneratedColumn<int>(
      'last_updated_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reportsMeta =
      const VerificationMeta('reports');
  @override
  late final GeneratedColumn<int> reports = GeneratedColumn<int>(
      'reports', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reportIdsMeta =
      const VerificationMeta('reportIds');
  @override
  late final GeneratedColumn<String> reportIds = GeneratedColumn<String>(
      'report_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        message,
        messageId,
        senderId,
        senderUsername,
        date,
        senderDisplayName,
        readBy,
        chatId,
        snippetId,
        lastUpdatedMillis,
        reports,
        reportIds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('sender_username')) {
      context.handle(
          _senderUsernameMeta,
          senderUsername.isAcceptableOrUnknown(
              data['sender_username']!, _senderUsernameMeta));
    } else if (isInserting) {
      context.missing(_senderUsernameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('sender_display_name')) {
      context.handle(
          _senderDisplayNameMeta,
          senderDisplayName.isAcceptableOrUnknown(
              data['sender_display_name']!, _senderDisplayNameMeta));
    } else if (isInserting) {
      context.missing(_senderDisplayNameMeta);
    }
    if (data.containsKey('read_by')) {
      context.handle(_readByMeta,
          readBy.isAcceptableOrUnknown(data['read_by']!, _readByMeta));
    } else if (isInserting) {
      context.missing(_readByMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('snippet_id')) {
      context.handle(_snippetIdMeta,
          snippetId.isAcceptableOrUnknown(data['snippet_id']!, _snippetIdMeta));
    } else if (isInserting) {
      context.missing(_snippetIdMeta);
    }
    if (data.containsKey('last_updated_millis')) {
      context.handle(
          _lastUpdatedMillisMeta,
          lastUpdatedMillis.isAcceptableOrUnknown(
              data['last_updated_millis']!, _lastUpdatedMillisMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMillisMeta);
    }
    if (data.containsKey('reports')) {
      context.handle(_reportsMeta,
          reports.isAcceptableOrUnknown(data['reports']!, _reportsMeta));
    } else if (isInserting) {
      context.missing(_reportsMeta);
    }
    if (data.containsKey('report_ids')) {
      context.handle(_reportIdsMeta,
          reportIds.isAcceptableOrUnknown(data['report_ids']!, _reportIdsMeta));
    } else if (isInserting) {
      context.missing(_reportIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      senderUsername: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sender_username'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      senderDisplayName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sender_display_name'])!,
      readBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}read_by'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      snippetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snippet_id'])!,
      lastUpdatedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_millis'])!,
      reports: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reports'])!,
      reportIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_ids'])!,
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final int id;
  final String message;
  final String messageId;
  final String senderId;
  final String senderUsername;
  final DateTime date;
  final String senderDisplayName;
  final String readBy;
  final String chatId;
  final String snippetId;
  final int lastUpdatedMillis;
  final int reports;
  final String reportIds;
  const Chat(
      {required this.id,
      required this.message,
      required this.messageId,
      required this.senderId,
      required this.senderUsername,
      required this.date,
      required this.senderDisplayName,
      required this.readBy,
      required this.chatId,
      required this.snippetId,
      required this.lastUpdatedMillis,
      required this.reports,
      required this.reportIds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message'] = Variable<String>(message);
    map['message_id'] = Variable<String>(messageId);
    map['sender_id'] = Variable<String>(senderId);
    map['sender_username'] = Variable<String>(senderUsername);
    map['date'] = Variable<DateTime>(date);
    map['sender_display_name'] = Variable<String>(senderDisplayName);
    map['read_by'] = Variable<String>(readBy);
    map['chat_id'] = Variable<String>(chatId);
    map['snippet_id'] = Variable<String>(snippetId);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    map['reports'] = Variable<int>(reports);
    map['report_ids'] = Variable<String>(reportIds);
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      message: Value(message),
      messageId: Value(messageId),
      senderId: Value(senderId),
      senderUsername: Value(senderUsername),
      date: Value(date),
      senderDisplayName: Value(senderDisplayName),
      readBy: Value(readBy),
      chatId: Value(chatId),
      snippetId: Value(snippetId),
      lastUpdatedMillis: Value(lastUpdatedMillis),
      reports: Value(reports),
      reportIds: Value(reportIds),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<int>(json['id']),
      message: serializer.fromJson<String>(json['message']),
      messageId: serializer.fromJson<String>(json['messageId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      senderUsername: serializer.fromJson<String>(json['senderUsername']),
      date: serializer.fromJson<DateTime>(json['date']),
      senderDisplayName: serializer.fromJson<String>(json['senderDisplayName']),
      readBy: serializer.fromJson<String>(json['readBy']),
      chatId: serializer.fromJson<String>(json['chatId']),
      snippetId: serializer.fromJson<String>(json['snippetId']),
      lastUpdatedMillis: serializer.fromJson<int>(json['lastUpdatedMillis']),
      reports: serializer.fromJson<int>(json['reports']),
      reportIds: serializer.fromJson<String>(json['reportIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'message': serializer.toJson<String>(message),
      'messageId': serializer.toJson<String>(messageId),
      'senderId': serializer.toJson<String>(senderId),
      'senderUsername': serializer.toJson<String>(senderUsername),
      'date': serializer.toJson<DateTime>(date),
      'senderDisplayName': serializer.toJson<String>(senderDisplayName),
      'readBy': serializer.toJson<String>(readBy),
      'chatId': serializer.toJson<String>(chatId),
      'snippetId': serializer.toJson<String>(snippetId),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
      'reports': serializer.toJson<int>(reports),
      'reportIds': serializer.toJson<String>(reportIds),
    };
  }

  Chat copyWith(
          {int? id,
          String? message,
          String? messageId,
          String? senderId,
          String? senderUsername,
          DateTime? date,
          String? senderDisplayName,
          String? readBy,
          String? chatId,
          String? snippetId,
          int? lastUpdatedMillis,
          int? reports,
          String? reportIds}) =>
      Chat(
        id: id ?? this.id,
        message: message ?? this.message,
        messageId: messageId ?? this.messageId,
        senderId: senderId ?? this.senderId,
        senderUsername: senderUsername ?? this.senderUsername,
        date: date ?? this.date,
        senderDisplayName: senderDisplayName ?? this.senderDisplayName,
        readBy: readBy ?? this.readBy,
        chatId: chatId ?? this.chatId,
        snippetId: snippetId ?? this.snippetId,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
        reports: reports ?? this.reports,
        reportIds: reportIds ?? this.reportIds,
      );
  Chat copyWithCompanion(ChatsCompanion data) {
    return Chat(
      id: data.id.present ? data.id.value : this.id,
      message: data.message.present ? data.message.value : this.message,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      senderUsername: data.senderUsername.present
          ? data.senderUsername.value
          : this.senderUsername,
      date: data.date.present ? data.date.value : this.date,
      senderDisplayName: data.senderDisplayName.present
          ? data.senderDisplayName.value
          : this.senderDisplayName,
      readBy: data.readBy.present ? data.readBy.value : this.readBy,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      lastUpdatedMillis: data.lastUpdatedMillis.present
          ? data.lastUpdatedMillis.value
          : this.lastUpdatedMillis,
      reports: data.reports.present ? data.reports.value : this.reports,
      reportIds: data.reportIds.present ? data.reportIds.value : this.reportIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('messageId: $messageId, ')
          ..write('senderId: $senderId, ')
          ..write('senderUsername: $senderUsername, ')
          ..write('date: $date, ')
          ..write('senderDisplayName: $senderDisplayName, ')
          ..write('readBy: $readBy, ')
          ..write('chatId: $chatId, ')
          ..write('snippetId: $snippetId, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('reports: $reports, ')
          ..write('reportIds: $reportIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      message,
      messageId,
      senderId,
      senderUsername,
      date,
      senderDisplayName,
      readBy,
      chatId,
      snippetId,
      lastUpdatedMillis,
      reports,
      reportIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.message == this.message &&
          other.messageId == this.messageId &&
          other.senderId == this.senderId &&
          other.senderUsername == this.senderUsername &&
          other.date == this.date &&
          other.senderDisplayName == this.senderDisplayName &&
          other.readBy == this.readBy &&
          other.chatId == this.chatId &&
          other.snippetId == this.snippetId &&
          other.lastUpdatedMillis == this.lastUpdatedMillis &&
          other.reports == this.reports &&
          other.reportIds == this.reportIds);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<int> id;
  final Value<String> message;
  final Value<String> messageId;
  final Value<String> senderId;
  final Value<String> senderUsername;
  final Value<DateTime> date;
  final Value<String> senderDisplayName;
  final Value<String> readBy;
  final Value<String> chatId;
  final Value<String> snippetId;
  final Value<int> lastUpdatedMillis;
  final Value<int> reports;
  final Value<String> reportIds;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.message = const Value.absent(),
    this.messageId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.senderUsername = const Value.absent(),
    this.date = const Value.absent(),
    this.senderDisplayName = const Value.absent(),
    this.readBy = const Value.absent(),
    this.chatId = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
    this.reports = const Value.absent(),
    this.reportIds = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    required String message,
    required String messageId,
    required String senderId,
    required String senderUsername,
    required DateTime date,
    required String senderDisplayName,
    required String readBy,
    required String chatId,
    required String snippetId,
    required int lastUpdatedMillis,
    required int reports,
    required String reportIds,
  })  : message = Value(message),
        messageId = Value(messageId),
        senderId = Value(senderId),
        senderUsername = Value(senderUsername),
        date = Value(date),
        senderDisplayName = Value(senderDisplayName),
        readBy = Value(readBy),
        chatId = Value(chatId),
        snippetId = Value(snippetId),
        lastUpdatedMillis = Value(lastUpdatedMillis),
        reports = Value(reports),
        reportIds = Value(reportIds);
  static Insertable<Chat> custom({
    Expression<int>? id,
    Expression<String>? message,
    Expression<String>? messageId,
    Expression<String>? senderId,
    Expression<String>? senderUsername,
    Expression<DateTime>? date,
    Expression<String>? senderDisplayName,
    Expression<String>? readBy,
    Expression<String>? chatId,
    Expression<String>? snippetId,
    Expression<int>? lastUpdatedMillis,
    Expression<int>? reports,
    Expression<String>? reportIds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (message != null) 'message': message,
      if (messageId != null) 'message_id': messageId,
      if (senderId != null) 'sender_id': senderId,
      if (senderUsername != null) 'sender_username': senderUsername,
      if (date != null) 'date': date,
      if (senderDisplayName != null) 'sender_display_name': senderDisplayName,
      if (readBy != null) 'read_by': readBy,
      if (chatId != null) 'chat_id': chatId,
      if (snippetId != null) 'snippet_id': snippetId,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
      if (reports != null) 'reports': reports,
      if (reportIds != null) 'report_ids': reportIds,
    });
  }

  ChatsCompanion copyWith(
      {Value<int>? id,
      Value<String>? message,
      Value<String>? messageId,
      Value<String>? senderId,
      Value<String>? senderUsername,
      Value<DateTime>? date,
      Value<String>? senderDisplayName,
      Value<String>? readBy,
      Value<String>? chatId,
      Value<String>? snippetId,
      Value<int>? lastUpdatedMillis,
      Value<int>? reports,
      Value<String>? reportIds}) {
    return ChatsCompanion(
      id: id ?? this.id,
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      date: date ?? this.date,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      readBy: readBy ?? this.readBy,
      chatId: chatId ?? this.chatId,
      snippetId: snippetId ?? this.snippetId,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      reports: reports ?? this.reports,
      reportIds: reportIds ?? this.reportIds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (senderUsername.present) {
      map['sender_username'] = Variable<String>(senderUsername.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (senderDisplayName.present) {
      map['sender_display_name'] = Variable<String>(senderDisplayName.value);
    }
    if (readBy.present) {
      map['read_by'] = Variable<String>(readBy.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (snippetId.present) {
      map['snippet_id'] = Variable<String>(snippetId.value);
    }
    if (lastUpdatedMillis.present) {
      map['last_updated_millis'] = Variable<int>(lastUpdatedMillis.value);
    }
    if (reports.present) {
      map['reports'] = Variable<int>(reports.value);
    }
    if (reportIds.present) {
      map['report_ids'] = Variable<String>(reportIds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('messageId: $messageId, ')
          ..write('senderId: $senderId, ')
          ..write('senderUsername: $senderUsername, ')
          ..write('date: $date, ')
          ..write('senderDisplayName: $senderDisplayName, ')
          ..write('readBy: $readBy, ')
          ..write('chatId: $chatId, ')
          ..write('snippetId: $snippetId, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('reports: $reports, ')
          ..write('reportIds: $reportIds')
          ..write(')'))
        .toString();
  }
}

class $SnipResponsesTable extends SnipResponses
    with TableInfo<$SnipResponsesTable, SnipResponse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnipResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _snippetIdMeta =
      const VerificationMeta('snippetId');
  @override
  late final GeneratedColumn<String> snippetId = GeneratedColumn<String>(
      'snippet_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
      'uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reportsMeta =
      const VerificationMeta('reports');
  @override
  late final GeneratedColumn<int> reports = GeneratedColumn<int>(
      'reports', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reportIdsMeta =
      const VerificationMeta('reportIds');
  @override
  late final GeneratedColumn<String> reportIds = GeneratedColumn<String>(
      'report_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMillisMeta =
      const VerificationMeta('lastUpdatedMillis');
  @override
  late final GeneratedColumn<int> lastUpdatedMillis = GeneratedColumn<int>(
      'last_updated_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discussionUsersMeta =
      const VerificationMeta('discussionUsers');
  @override
  late final GeneratedColumn<String> discussionUsers = GeneratedColumn<String>(
      'discussion_users', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        answer,
        snippetId,
        displayName,
        date,
        uid,
        reports,
        reportIds,
        lastUpdatedMillis,
        discussionUsers
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snip_responses';
  @override
  VerificationContext validateIntegrity(Insertable<SnipResponse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('snippet_id')) {
      context.handle(_snippetIdMeta,
          snippetId.isAcceptableOrUnknown(data['snippet_id']!, _snippetIdMeta));
    } else if (isInserting) {
      context.missing(_snippetIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('reports')) {
      context.handle(_reportsMeta,
          reports.isAcceptableOrUnknown(data['reports']!, _reportsMeta));
    } else if (isInserting) {
      context.missing(_reportsMeta);
    }
    if (data.containsKey('report_ids')) {
      context.handle(_reportIdsMeta,
          reportIds.isAcceptableOrUnknown(data['report_ids']!, _reportIdsMeta));
    } else if (isInserting) {
      context.missing(_reportIdsMeta);
    }
    if (data.containsKey('last_updated_millis')) {
      context.handle(
          _lastUpdatedMillisMeta,
          lastUpdatedMillis.isAcceptableOrUnknown(
              data['last_updated_millis']!, _lastUpdatedMillisMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMillisMeta);
    }
    if (data.containsKey('discussion_users')) {
      context.handle(
          _discussionUsersMeta,
          discussionUsers.isAcceptableOrUnknown(
              data['discussion_users']!, _discussionUsersMeta));
    } else if (isInserting) {
      context.missing(_discussionUsersMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnipResponse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnipResponse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      snippetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snippet_id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      uid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uid'])!,
      reports: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reports'])!,
      reportIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_ids'])!,
      lastUpdatedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_millis'])!,
      discussionUsers: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}discussion_users'])!,
    );
  }

  @override
  $SnipResponsesTable createAlias(String alias) {
    return $SnipResponsesTable(attachedDatabase, alias);
  }
}

class SnipResponse extends DataClass implements Insertable<SnipResponse> {
  final int id;
  final String answer;
  final String snippetId;
  final String displayName;
  final DateTime date;
  final String uid;
  final int reports;
  final String reportIds;
  final int lastUpdatedMillis;
  final String discussionUsers;
  const SnipResponse(
      {required this.id,
      required this.answer,
      required this.snippetId,
      required this.displayName,
      required this.date,
      required this.uid,
      required this.reports,
      required this.reportIds,
      required this.lastUpdatedMillis,
      required this.discussionUsers});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['answer'] = Variable<String>(answer);
    map['snippet_id'] = Variable<String>(snippetId);
    map['display_name'] = Variable<String>(displayName);
    map['date'] = Variable<DateTime>(date);
    map['uid'] = Variable<String>(uid);
    map['reports'] = Variable<int>(reports);
    map['report_ids'] = Variable<String>(reportIds);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    map['discussion_users'] = Variable<String>(discussionUsers);
    return map;
  }

  SnipResponsesCompanion toCompanion(bool nullToAbsent) {
    return SnipResponsesCompanion(
      id: Value(id),
      answer: Value(answer),
      snippetId: Value(snippetId),
      displayName: Value(displayName),
      date: Value(date),
      uid: Value(uid),
      reports: Value(reports),
      reportIds: Value(reportIds),
      lastUpdatedMillis: Value(lastUpdatedMillis),
      discussionUsers: Value(discussionUsers),
    );
  }

  factory SnipResponse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnipResponse(
      id: serializer.fromJson<int>(json['id']),
      answer: serializer.fromJson<String>(json['answer']),
      snippetId: serializer.fromJson<String>(json['snippetId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      date: serializer.fromJson<DateTime>(json['date']),
      uid: serializer.fromJson<String>(json['uid']),
      reports: serializer.fromJson<int>(json['reports']),
      reportIds: serializer.fromJson<String>(json['reportIds']),
      lastUpdatedMillis: serializer.fromJson<int>(json['lastUpdatedMillis']),
      discussionUsers: serializer.fromJson<String>(json['discussionUsers']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'answer': serializer.toJson<String>(answer),
      'snippetId': serializer.toJson<String>(snippetId),
      'displayName': serializer.toJson<String>(displayName),
      'date': serializer.toJson<DateTime>(date),
      'uid': serializer.toJson<String>(uid),
      'reports': serializer.toJson<int>(reports),
      'reportIds': serializer.toJson<String>(reportIds),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
      'discussionUsers': serializer.toJson<String>(discussionUsers),
    };
  }

  SnipResponse copyWith(
          {int? id,
          String? answer,
          String? snippetId,
          String? displayName,
          DateTime? date,
          String? uid,
          int? reports,
          String? reportIds,
          int? lastUpdatedMillis,
          String? discussionUsers}) =>
      SnipResponse(
        id: id ?? this.id,
        answer: answer ?? this.answer,
        snippetId: snippetId ?? this.snippetId,
        displayName: displayName ?? this.displayName,
        date: date ?? this.date,
        uid: uid ?? this.uid,
        reports: reports ?? this.reports,
        reportIds: reportIds ?? this.reportIds,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
        discussionUsers: discussionUsers ?? this.discussionUsers,
      );
  SnipResponse copyWithCompanion(SnipResponsesCompanion data) {
    return SnipResponse(
      id: data.id.present ? data.id.value : this.id,
      answer: data.answer.present ? data.answer.value : this.answer,
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      date: data.date.present ? data.date.value : this.date,
      uid: data.uid.present ? data.uid.value : this.uid,
      reports: data.reports.present ? data.reports.value : this.reports,
      reportIds: data.reportIds.present ? data.reportIds.value : this.reportIds,
      lastUpdatedMillis: data.lastUpdatedMillis.present
          ? data.lastUpdatedMillis.value
          : this.lastUpdatedMillis,
      discussionUsers: data.discussionUsers.present
          ? data.discussionUsers.value
          : this.discussionUsers,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnipResponse(')
          ..write('id: $id, ')
          ..write('answer: $answer, ')
          ..write('snippetId: $snippetId, ')
          ..write('displayName: $displayName, ')
          ..write('date: $date, ')
          ..write('uid: $uid, ')
          ..write('reports: $reports, ')
          ..write('reportIds: $reportIds, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('discussionUsers: $discussionUsers')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, answer, snippetId, displayName, date, uid,
      reports, reportIds, lastUpdatedMillis, discussionUsers);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnipResponse &&
          other.id == this.id &&
          other.answer == this.answer &&
          other.snippetId == this.snippetId &&
          other.displayName == this.displayName &&
          other.date == this.date &&
          other.uid == this.uid &&
          other.reports == this.reports &&
          other.reportIds == this.reportIds &&
          other.lastUpdatedMillis == this.lastUpdatedMillis &&
          other.discussionUsers == this.discussionUsers);
}

class SnipResponsesCompanion extends UpdateCompanion<SnipResponse> {
  final Value<int> id;
  final Value<String> answer;
  final Value<String> snippetId;
  final Value<String> displayName;
  final Value<DateTime> date;
  final Value<String> uid;
  final Value<int> reports;
  final Value<String> reportIds;
  final Value<int> lastUpdatedMillis;
  final Value<String> discussionUsers;
  const SnipResponsesCompanion({
    this.id = const Value.absent(),
    this.answer = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.date = const Value.absent(),
    this.uid = const Value.absent(),
    this.reports = const Value.absent(),
    this.reportIds = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
    this.discussionUsers = const Value.absent(),
  });
  SnipResponsesCompanion.insert({
    this.id = const Value.absent(),
    required String answer,
    required String snippetId,
    required String displayName,
    required DateTime date,
    required String uid,
    required int reports,
    required String reportIds,
    required int lastUpdatedMillis,
    required String discussionUsers,
  })  : answer = Value(answer),
        snippetId = Value(snippetId),
        displayName = Value(displayName),
        date = Value(date),
        uid = Value(uid),
        reports = Value(reports),
        reportIds = Value(reportIds),
        lastUpdatedMillis = Value(lastUpdatedMillis),
        discussionUsers = Value(discussionUsers);
  static Insertable<SnipResponse> custom({
    Expression<int>? id,
    Expression<String>? answer,
    Expression<String>? snippetId,
    Expression<String>? displayName,
    Expression<DateTime>? date,
    Expression<String>? uid,
    Expression<int>? reports,
    Expression<String>? reportIds,
    Expression<int>? lastUpdatedMillis,
    Expression<String>? discussionUsers,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (answer != null) 'answer': answer,
      if (snippetId != null) 'snippet_id': snippetId,
      if (displayName != null) 'display_name': displayName,
      if (date != null) 'date': date,
      if (uid != null) 'uid': uid,
      if (reports != null) 'reports': reports,
      if (reportIds != null) 'report_ids': reportIds,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
      if (discussionUsers != null) 'discussion_users': discussionUsers,
    });
  }

  SnipResponsesCompanion copyWith(
      {Value<int>? id,
      Value<String>? answer,
      Value<String>? snippetId,
      Value<String>? displayName,
      Value<DateTime>? date,
      Value<String>? uid,
      Value<int>? reports,
      Value<String>? reportIds,
      Value<int>? lastUpdatedMillis,
      Value<String>? discussionUsers}) {
    return SnipResponsesCompanion(
      id: id ?? this.id,
      answer: answer ?? this.answer,
      snippetId: snippetId ?? this.snippetId,
      displayName: displayName ?? this.displayName,
      date: date ?? this.date,
      uid: uid ?? this.uid,
      reports: reports ?? this.reports,
      reportIds: reportIds ?? this.reportIds,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      discussionUsers: discussionUsers ?? this.discussionUsers,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (snippetId.present) {
      map['snippet_id'] = Variable<String>(snippetId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (reports.present) {
      map['reports'] = Variable<int>(reports.value);
    }
    if (reportIds.present) {
      map['report_ids'] = Variable<String>(reportIds.value);
    }
    if (lastUpdatedMillis.present) {
      map['last_updated_millis'] = Variable<int>(lastUpdatedMillis.value);
    }
    if (discussionUsers.present) {
      map['discussion_users'] = Variable<String>(discussionUsers.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnipResponsesCompanion(')
          ..write('id: $id, ')
          ..write('answer: $answer, ')
          ..write('snippetId: $snippetId, ')
          ..write('displayName: $displayName, ')
          ..write('date: $date, ')
          ..write('uid: $uid, ')
          ..write('reports: $reports, ')
          ..write('reportIds: $reportIds, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('discussionUsers: $discussionUsers')
          ..write(')'))
        .toString();
  }
}

class $SnippetsDataTable extends SnippetsData
    with TableInfo<$SnippetsDataTable, SnippetsDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _snippetIdMeta =
      const VerificationMeta('snippetId');
  @override
  late final GeneratedColumn<String> snippetId = GeneratedColumn<String>(
      'snippet_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionsMeta =
      const VerificationMeta('options');
  @override
  late final GeneratedColumn<String> options = GeneratedColumn<String>(
      'options', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswerMeta =
      const VerificationMeta('correctAnswer');
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
      'correct_answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _answeredMeta =
      const VerificationMeta('answered');
  @override
  late final GeneratedColumn<bool> answered = GeneratedColumn<bool>(
      'answered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("answered" IN (0, 1))'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMillisMeta =
      const VerificationMeta('lastUpdatedMillis');
  @override
  late final GeneratedColumn<int> lastUpdatedMillis = GeneratedColumn<int>(
      'last_updated_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastRecievedMillisMeta =
      const VerificationMeta('lastRecievedMillis');
  @override
  late final GeneratedColumn<int> lastRecievedMillis = GeneratedColumn<int>(
      'last_recieved_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        snippetId,
        question,
        options,
        correctAnswer,
        index,
        answered,
        type,
        lastUpdatedMillis,
        lastRecievedMillis
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets_data';
  @override
  VerificationContext validateIntegrity(Insertable<SnippetsDataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('snippet_id')) {
      context.handle(_snippetIdMeta,
          snippetId.isAcceptableOrUnknown(data['snippet_id']!, _snippetIdMeta));
    } else if (isInserting) {
      context.missing(_snippetIdMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('options')) {
      context.handle(_optionsMeta,
          options.isAcceptableOrUnknown(data['options']!, _optionsMeta));
    } else if (isInserting) {
      context.missing(_optionsMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
          _correctAnswerMeta,
          correctAnswer.isAcceptableOrUnknown(
              data['correct_answer']!, _correctAnswerMeta));
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('answered')) {
      context.handle(_answeredMeta,
          answered.isAcceptableOrUnknown(data['answered']!, _answeredMeta));
    } else if (isInserting) {
      context.missing(_answeredMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('last_updated_millis')) {
      context.handle(
          _lastUpdatedMillisMeta,
          lastUpdatedMillis.isAcceptableOrUnknown(
              data['last_updated_millis']!, _lastUpdatedMillisMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMillisMeta);
    }
    if (data.containsKey('last_recieved_millis')) {
      context.handle(
          _lastRecievedMillisMeta,
          lastRecievedMillis.isAcceptableOrUnknown(
              data['last_recieved_millis']!, _lastRecievedMillisMeta));
    } else if (isInserting) {
      context.missing(_lastRecievedMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnippetsDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnippetsDataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      snippetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snippet_id'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      options: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}options'])!,
      correctAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}correct_answer'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      answered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}answered'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      lastUpdatedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_millis'])!,
      lastRecievedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_recieved_millis'])!,
    );
  }

  @override
  $SnippetsDataTable createAlias(String alias) {
    return $SnippetsDataTable(attachedDatabase, alias);
  }
}

class SnippetsDataData extends DataClass
    implements Insertable<SnippetsDataData> {
  final int id;
  final String snippetId;
  final String question;
  final String options;
  final String correctAnswer;
  final int index;
  final bool answered;
  final String type;
  final int lastUpdatedMillis;
  final int lastRecievedMillis;
  const SnippetsDataData(
      {required this.id,
      required this.snippetId,
      required this.question,
      required this.options,
      required this.correctAnswer,
      required this.index,
      required this.answered,
      required this.type,
      required this.lastUpdatedMillis,
      required this.lastRecievedMillis});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['snippet_id'] = Variable<String>(snippetId);
    map['question'] = Variable<String>(question);
    map['options'] = Variable<String>(options);
    map['correct_answer'] = Variable<String>(correctAnswer);
    map['index'] = Variable<int>(index);
    map['answered'] = Variable<bool>(answered);
    map['type'] = Variable<String>(type);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    map['last_recieved_millis'] = Variable<int>(lastRecievedMillis);
    return map;
  }

  SnippetsDataCompanion toCompanion(bool nullToAbsent) {
    return SnippetsDataCompanion(
      id: Value(id),
      snippetId: Value(snippetId),
      question: Value(question),
      options: Value(options),
      correctAnswer: Value(correctAnswer),
      index: Value(index),
      answered: Value(answered),
      type: Value(type),
      lastUpdatedMillis: Value(lastUpdatedMillis),
      lastRecievedMillis: Value(lastRecievedMillis),
    );
  }

  factory SnippetsDataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnippetsDataData(
      id: serializer.fromJson<int>(json['id']),
      snippetId: serializer.fromJson<String>(json['snippetId']),
      question: serializer.fromJson<String>(json['question']),
      options: serializer.fromJson<String>(json['options']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      index: serializer.fromJson<int>(json['index']),
      answered: serializer.fromJson<bool>(json['answered']),
      type: serializer.fromJson<String>(json['type']),
      lastUpdatedMillis: serializer.fromJson<int>(json['lastUpdatedMillis']),
      lastRecievedMillis: serializer.fromJson<int>(json['lastRecievedMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'snippetId': serializer.toJson<String>(snippetId),
      'question': serializer.toJson<String>(question),
      'options': serializer.toJson<String>(options),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'index': serializer.toJson<int>(index),
      'answered': serializer.toJson<bool>(answered),
      'type': serializer.toJson<String>(type),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
      'lastRecievedMillis': serializer.toJson<int>(lastRecievedMillis),
    };
  }

  SnippetsDataData copyWith(
          {int? id,
          String? snippetId,
          String? question,
          String? options,
          String? correctAnswer,
          int? index,
          bool? answered,
          String? type,
          int? lastUpdatedMillis,
          int? lastRecievedMillis}) =>
      SnippetsDataData(
        id: id ?? this.id,
        snippetId: snippetId ?? this.snippetId,
        question: question ?? this.question,
        options: options ?? this.options,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        index: index ?? this.index,
        answered: answered ?? this.answered,
        type: type ?? this.type,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
        lastRecievedMillis: lastRecievedMillis ?? this.lastRecievedMillis,
      );
  SnippetsDataData copyWithCompanion(SnippetsDataCompanion data) {
    return SnippetsDataData(
      id: data.id.present ? data.id.value : this.id,
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      question: data.question.present ? data.question.value : this.question,
      options: data.options.present ? data.options.value : this.options,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      index: data.index.present ? data.index.value : this.index,
      answered: data.answered.present ? data.answered.value : this.answered,
      type: data.type.present ? data.type.value : this.type,
      lastUpdatedMillis: data.lastUpdatedMillis.present
          ? data.lastUpdatedMillis.value
          : this.lastUpdatedMillis,
      lastRecievedMillis: data.lastRecievedMillis.present
          ? data.lastRecievedMillis.value
          : this.lastRecievedMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsDataData(')
          ..write('id: $id, ')
          ..write('snippetId: $snippetId, ')
          ..write('question: $question, ')
          ..write('options: $options, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('index: $index, ')
          ..write('answered: $answered, ')
          ..write('type: $type, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('lastRecievedMillis: $lastRecievedMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      snippetId,
      question,
      options,
      correctAnswer,
      index,
      answered,
      type,
      lastUpdatedMillis,
      lastRecievedMillis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnippetsDataData &&
          other.id == this.id &&
          other.snippetId == this.snippetId &&
          other.question == this.question &&
          other.options == this.options &&
          other.correctAnswer == this.correctAnswer &&
          other.index == this.index &&
          other.answered == this.answered &&
          other.type == this.type &&
          other.lastUpdatedMillis == this.lastUpdatedMillis &&
          other.lastRecievedMillis == this.lastRecievedMillis);
}

class SnippetsDataCompanion extends UpdateCompanion<SnippetsDataData> {
  final Value<int> id;
  final Value<String> snippetId;
  final Value<String> question;
  final Value<String> options;
  final Value<String> correctAnswer;
  final Value<int> index;
  final Value<bool> answered;
  final Value<String> type;
  final Value<int> lastUpdatedMillis;
  final Value<int> lastRecievedMillis;
  const SnippetsDataCompanion({
    this.id = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.question = const Value.absent(),
    this.options = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.index = const Value.absent(),
    this.answered = const Value.absent(),
    this.type = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
    this.lastRecievedMillis = const Value.absent(),
  });
  SnippetsDataCompanion.insert({
    this.id = const Value.absent(),
    required String snippetId,
    required String question,
    required String options,
    required String correctAnswer,
    required int index,
    required bool answered,
    required String type,
    required int lastUpdatedMillis,
    required int lastRecievedMillis,
  })  : snippetId = Value(snippetId),
        question = Value(question),
        options = Value(options),
        correctAnswer = Value(correctAnswer),
        index = Value(index),
        answered = Value(answered),
        type = Value(type),
        lastUpdatedMillis = Value(lastUpdatedMillis),
        lastRecievedMillis = Value(lastRecievedMillis);
  static Insertable<SnippetsDataData> custom({
    Expression<int>? id,
    Expression<String>? snippetId,
    Expression<String>? question,
    Expression<String>? options,
    Expression<String>? correctAnswer,
    Expression<int>? index,
    Expression<bool>? answered,
    Expression<String>? type,
    Expression<int>? lastUpdatedMillis,
    Expression<int>? lastRecievedMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (snippetId != null) 'snippet_id': snippetId,
      if (question != null) 'question': question,
      if (options != null) 'options': options,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (index != null) 'index': index,
      if (answered != null) 'answered': answered,
      if (type != null) 'type': type,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
      if (lastRecievedMillis != null)
        'last_recieved_millis': lastRecievedMillis,
    });
  }

  SnippetsDataCompanion copyWith(
      {Value<int>? id,
      Value<String>? snippetId,
      Value<String>? question,
      Value<String>? options,
      Value<String>? correctAnswer,
      Value<int>? index,
      Value<bool>? answered,
      Value<String>? type,
      Value<int>? lastUpdatedMillis,
      Value<int>? lastRecievedMillis}) {
    return SnippetsDataCompanion(
      id: id ?? this.id,
      snippetId: snippetId ?? this.snippetId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      index: index ?? this.index,
      answered: answered ?? this.answered,
      type: type ?? this.type,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      lastRecievedMillis: lastRecievedMillis ?? this.lastRecievedMillis,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (snippetId.present) {
      map['snippet_id'] = Variable<String>(snippetId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(options.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (answered.present) {
      map['answered'] = Variable<bool>(answered.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (lastUpdatedMillis.present) {
      map['last_updated_millis'] = Variable<int>(lastUpdatedMillis.value);
    }
    if (lastRecievedMillis.present) {
      map['last_recieved_millis'] = Variable<int>(lastRecievedMillis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsDataCompanion(')
          ..write('id: $id, ')
          ..write('snippetId: $snippetId, ')
          ..write('question: $question, ')
          ..write('options: $options, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('index: $index, ')
          ..write('answered: $answered, ')
          ..write('type: $type, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('lastRecievedMillis: $lastRecievedMillis')
          ..write(')'))
        .toString();
  }
}

class $BOTWDataTableTable extends BOTWDataTable
    with TableInfo<$BOTWDataTableTable, BOTWDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BOTWDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _blankMeta = const VerificationMeta('blank');
  @override
  late final GeneratedColumn<String> blank = GeneratedColumn<String>(
      'blank', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answersMeta =
      const VerificationMeta('answers');
  @override
  late final GeneratedColumn<String> answers = GeneratedColumn<String>(
      'answers', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousAnswersMeta =
      const VerificationMeta('previousAnswers');
  @override
  late final GeneratedColumn<String> previousAnswers = GeneratedColumn<String>(
      'previous_answers', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekMeta = const VerificationMeta('week');
  @override
  late final GeneratedColumn<DateTime> week = GeneratedColumn<DateTime>(
      'week', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMillisMeta =
      const VerificationMeta('lastUpdatedMillis');
  @override
  late final GeneratedColumn<int> lastUpdatedMillis = GeneratedColumn<int>(
      'last_updated_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, blank, status, answers, previousAnswers, week, lastUpdatedMillis];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'b_o_t_w_data_table';
  @override
  VerificationContext validateIntegrity(Insertable<BOTWDataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('blank')) {
      context.handle(
          _blankMeta, blank.isAcceptableOrUnknown(data['blank']!, _blankMeta));
    } else if (isInserting) {
      context.missing(_blankMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('answers')) {
      context.handle(_answersMeta,
          answers.isAcceptableOrUnknown(data['answers']!, _answersMeta));
    } else if (isInserting) {
      context.missing(_answersMeta);
    }
    if (data.containsKey('previous_answers')) {
      context.handle(
          _previousAnswersMeta,
          previousAnswers.isAcceptableOrUnknown(
              data['previous_answers']!, _previousAnswersMeta));
    } else if (isInserting) {
      context.missing(_previousAnswersMeta);
    }
    if (data.containsKey('week')) {
      context.handle(
          _weekMeta, week.isAcceptableOrUnknown(data['week']!, _weekMeta));
    } else if (isInserting) {
      context.missing(_weekMeta);
    }
    if (data.containsKey('last_updated_millis')) {
      context.handle(
          _lastUpdatedMillisMeta,
          lastUpdatedMillis.isAcceptableOrUnknown(
              data['last_updated_millis']!, _lastUpdatedMillisMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BOTWDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BOTWDataTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      blank: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blank'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      answers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answers'])!,
      previousAnswers: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}previous_answers'])!,
      week: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}week'])!,
      lastUpdatedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_millis'])!,
    );
  }

  @override
  $BOTWDataTableTable createAlias(String alias) {
    return $BOTWDataTableTable(attachedDatabase, alias);
  }
}

class BOTWDataTableData extends DataClass
    implements Insertable<BOTWDataTableData> {
  final int id;
  final String blank;
  final String status;
  final String answers;
  final String previousAnswers;
  final DateTime week;
  final int lastUpdatedMillis;
  const BOTWDataTableData(
      {required this.id,
      required this.blank,
      required this.status,
      required this.answers,
      required this.previousAnswers,
      required this.week,
      required this.lastUpdatedMillis});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['blank'] = Variable<String>(blank);
    map['status'] = Variable<String>(status);
    map['answers'] = Variable<String>(answers);
    map['previous_answers'] = Variable<String>(previousAnswers);
    map['week'] = Variable<DateTime>(week);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    return map;
  }

  BOTWDataTableCompanion toCompanion(bool nullToAbsent) {
    return BOTWDataTableCompanion(
      id: Value(id),
      blank: Value(blank),
      status: Value(status),
      answers: Value(answers),
      previousAnswers: Value(previousAnswers),
      week: Value(week),
      lastUpdatedMillis: Value(lastUpdatedMillis),
    );
  }

  factory BOTWDataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BOTWDataTableData(
      id: serializer.fromJson<int>(json['id']),
      blank: serializer.fromJson<String>(json['blank']),
      status: serializer.fromJson<String>(json['status']),
      answers: serializer.fromJson<String>(json['answers']),
      previousAnswers: serializer.fromJson<String>(json['previousAnswers']),
      week: serializer.fromJson<DateTime>(json['week']),
      lastUpdatedMillis: serializer.fromJson<int>(json['lastUpdatedMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'blank': serializer.toJson<String>(blank),
      'status': serializer.toJson<String>(status),
      'answers': serializer.toJson<String>(answers),
      'previousAnswers': serializer.toJson<String>(previousAnswers),
      'week': serializer.toJson<DateTime>(week),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
    };
  }

  BOTWDataTableData copyWith(
          {int? id,
          String? blank,
          String? status,
          String? answers,
          String? previousAnswers,
          DateTime? week,
          int? lastUpdatedMillis}) =>
      BOTWDataTableData(
        id: id ?? this.id,
        blank: blank ?? this.blank,
        status: status ?? this.status,
        answers: answers ?? this.answers,
        previousAnswers: previousAnswers ?? this.previousAnswers,
        week: week ?? this.week,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      );
  BOTWDataTableData copyWithCompanion(BOTWDataTableCompanion data) {
    return BOTWDataTableData(
      id: data.id.present ? data.id.value : this.id,
      blank: data.blank.present ? data.blank.value : this.blank,
      status: data.status.present ? data.status.value : this.status,
      answers: data.answers.present ? data.answers.value : this.answers,
      previousAnswers: data.previousAnswers.present
          ? data.previousAnswers.value
          : this.previousAnswers,
      week: data.week.present ? data.week.value : this.week,
      lastUpdatedMillis: data.lastUpdatedMillis.present
          ? data.lastUpdatedMillis.value
          : this.lastUpdatedMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BOTWDataTableData(')
          ..write('id: $id, ')
          ..write('blank: $blank, ')
          ..write('status: $status, ')
          ..write('answers: $answers, ')
          ..write('previousAnswers: $previousAnswers, ')
          ..write('week: $week, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, blank, status, answers, previousAnswers, week, lastUpdatedMillis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BOTWDataTableData &&
          other.id == this.id &&
          other.blank == this.blank &&
          other.status == this.status &&
          other.answers == this.answers &&
          other.previousAnswers == this.previousAnswers &&
          other.week == this.week &&
          other.lastUpdatedMillis == this.lastUpdatedMillis);
}

class BOTWDataTableCompanion extends UpdateCompanion<BOTWDataTableData> {
  final Value<int> id;
  final Value<String> blank;
  final Value<String> status;
  final Value<String> answers;
  final Value<String> previousAnswers;
  final Value<DateTime> week;
  final Value<int> lastUpdatedMillis;
  const BOTWDataTableCompanion({
    this.id = const Value.absent(),
    this.blank = const Value.absent(),
    this.status = const Value.absent(),
    this.answers = const Value.absent(),
    this.previousAnswers = const Value.absent(),
    this.week = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
  });
  BOTWDataTableCompanion.insert({
    this.id = const Value.absent(),
    required String blank,
    required String status,
    required String answers,
    required String previousAnswers,
    required DateTime week,
    required int lastUpdatedMillis,
  })  : blank = Value(blank),
        status = Value(status),
        answers = Value(answers),
        previousAnswers = Value(previousAnswers),
        week = Value(week),
        lastUpdatedMillis = Value(lastUpdatedMillis);
  static Insertable<BOTWDataTableData> custom({
    Expression<int>? id,
    Expression<String>? blank,
    Expression<String>? status,
    Expression<String>? answers,
    Expression<String>? previousAnswers,
    Expression<DateTime>? week,
    Expression<int>? lastUpdatedMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blank != null) 'blank': blank,
      if (status != null) 'status': status,
      if (answers != null) 'answers': answers,
      if (previousAnswers != null) 'previous_answers': previousAnswers,
      if (week != null) 'week': week,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
    });
  }

  BOTWDataTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? blank,
      Value<String>? status,
      Value<String>? answers,
      Value<String>? previousAnswers,
      Value<DateTime>? week,
      Value<int>? lastUpdatedMillis}) {
    return BOTWDataTableCompanion(
      id: id ?? this.id,
      blank: blank ?? this.blank,
      status: status ?? this.status,
      answers: answers ?? this.answers,
      previousAnswers: previousAnswers ?? this.previousAnswers,
      week: week ?? this.week,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (blank.present) {
      map['blank'] = Variable<String>(blank.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (answers.present) {
      map['answers'] = Variable<String>(answers.value);
    }
    if (previousAnswers.present) {
      map['previous_answers'] = Variable<String>(previousAnswers.value);
    }
    if (week.present) {
      map['week'] = Variable<DateTime>(week.value);
    }
    if (lastUpdatedMillis.present) {
      map['last_updated_millis'] = Variable<int>(lastUpdatedMillis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BOTWDataTableCompanion(')
          ..write('id: $id, ')
          ..write('blank: $blank, ')
          ..write('status: $status, ')
          ..write('answers: $answers, ')
          ..write('previousAnswers: $previousAnswers, ')
          ..write('week: $week, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
          ..write(')'))
        .toString();
  }
}

class $UserDataTableTable extends UserDataTable
    with TableInfo<$UserDataTableTable, UserDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _FCMTokenMeta =
      const VerificationMeta('FCMToken');
  @override
  late final GeneratedColumn<String> FCMToken = GeneratedColumn<String>(
      'f_c_m_token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _BOTWStatusMeta =
      const VerificationMeta('BOTWStatus');
  @override
  late final GeneratedColumn<String> BOTWStatus = GeneratedColumn<String>(
      'b_o_t_w_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _discussionsMeta =
      const VerificationMeta('discussions');
  @override
  late final GeneratedColumn<String> discussions = GeneratedColumn<String>(
      'discussions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _friendsMeta =
      const VerificationMeta('friends');
  @override
  late final GeneratedColumn<String> friends = GeneratedColumn<String>(
      'friends', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _friendRequestsMeta =
      const VerificationMeta('friendRequests');
  @override
  late final GeneratedColumn<String> friendRequests = GeneratedColumn<String>(
      'friend_requests', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _outgoingFriendRequestsMeta =
      const VerificationMeta('outgoingFriendRequests');
  @override
  late final GeneratedColumn<String> outgoingFriendRequests =
      GeneratedColumn<String>('outgoing_friend_requests', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bestFriendsMeta =
      const VerificationMeta('bestFriends');
  @override
  late final GeneratedColumn<String> bestFriends = GeneratedColumn<String>(
      'best_friends', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _searchKeyMeta =
      const VerificationMeta('searchKey');
  @override
  late final GeneratedColumn<String> searchKey = GeneratedColumn<String>(
      'search_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMillisMeta =
      const VerificationMeta('lastUpdatedMillis');
  @override
  late final GeneratedColumn<int> lastUpdatedMillis = GeneratedColumn<int>(
      'last_updated_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _votesLeftMeta =
      const VerificationMeta('votesLeft');
  @override
  late final GeneratedColumn<int> votesLeft = GeneratedColumn<int>(
      'votes_left', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _longestStreakMeta =
      const VerificationMeta('longestStreak');
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
      'longest_streak', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _topBOTWMeta =
      const VerificationMeta('topBOTW');
  @override
  late final GeneratedColumn<int> topBOTW = GeneratedColumn<int>(
      'top_b_o_t_w', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _triviaPointsMeta =
      const VerificationMeta('triviaPoints');
  @override
  late final GeneratedColumn<int> triviaPoints = GeneratedColumn<int>(
      'trivia_points', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _snippetsRespondedToMeta =
      const VerificationMeta('snippetsRespondedTo');
  @override
  late final GeneratedColumn<int> snippetsRespondedTo = GeneratedColumn<int>(
      'snippets_responded_to', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _messagesSentMeta =
      const VerificationMeta('messagesSent');
  @override
  late final GeneratedColumn<int> messagesSent = GeneratedColumn<int>(
      'messages_sent', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discussionsStartedMeta =
      const VerificationMeta('discussionsStarted');
  @override
  late final GeneratedColumn<int> discussionsStarted = GeneratedColumn<int>(
      'discussions_started', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _profileStrikesMeta =
      const VerificationMeta('profileStrikes');
  @override
  late final GeneratedColumn<String> profileStrikes = GeneratedColumn<String>(
      'profile_strikes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _streakDateMeta =
      const VerificationMeta('streakDate');
  @override
  late final GeneratedColumn<DateTime> streakDate = GeneratedColumn<DateTime>(
      'streak_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        FCMToken,
        displayName,
        BOTWStatus,
        description,
        discussions,
        email,
        friends,
        friendRequests,
        outgoingFriendRequests,
        bestFriends,
        username,
        searchKey,
        userId,
        lastUpdatedMillis,
        votesLeft,
        longestStreak,
        topBOTW,
        triviaPoints,
        snippetsRespondedTo,
        messagesSent,
        discussionsStarted,
        streak,
        profileStrikes,
        streakDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_data_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserDataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('f_c_m_token')) {
      context.handle(_FCMTokenMeta,
          FCMToken.isAcceptableOrUnknown(data['f_c_m_token']!, _FCMTokenMeta));
    } else if (isInserting) {
      context.missing(_FCMTokenMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('b_o_t_w_status')) {
      context.handle(
          _BOTWStatusMeta,
          BOTWStatus.isAcceptableOrUnknown(
              data['b_o_t_w_status']!, _BOTWStatusMeta));
    } else if (isInserting) {
      context.missing(_BOTWStatusMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('discussions')) {
      context.handle(
          _discussionsMeta,
          discussions.isAcceptableOrUnknown(
              data['discussions']!, _discussionsMeta));
    } else if (isInserting) {
      context.missing(_discussionsMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('friends')) {
      context.handle(_friendsMeta,
          friends.isAcceptableOrUnknown(data['friends']!, _friendsMeta));
    } else if (isInserting) {
      context.missing(_friendsMeta);
    }
    if (data.containsKey('friend_requests')) {
      context.handle(
          _friendRequestsMeta,
          friendRequests.isAcceptableOrUnknown(
              data['friend_requests']!, _friendRequestsMeta));
    } else if (isInserting) {
      context.missing(_friendRequestsMeta);
    }
    if (data.containsKey('outgoing_friend_requests')) {
      context.handle(
          _outgoingFriendRequestsMeta,
          outgoingFriendRequests.isAcceptableOrUnknown(
              data['outgoing_friend_requests']!, _outgoingFriendRequestsMeta));
    } else if (isInserting) {
      context.missing(_outgoingFriendRequestsMeta);
    }
    if (data.containsKey('best_friends')) {
      context.handle(
          _bestFriendsMeta,
          bestFriends.isAcceptableOrUnknown(
              data['best_friends']!, _bestFriendsMeta));
    } else if (isInserting) {
      context.missing(_bestFriendsMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('search_key')) {
      context.handle(_searchKeyMeta,
          searchKey.isAcceptableOrUnknown(data['search_key']!, _searchKeyMeta));
    } else if (isInserting) {
      context.missing(_searchKeyMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('last_updated_millis')) {
      context.handle(
          _lastUpdatedMillisMeta,
          lastUpdatedMillis.isAcceptableOrUnknown(
              data['last_updated_millis']!, _lastUpdatedMillisMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMillisMeta);
    }
    if (data.containsKey('votes_left')) {
      context.handle(_votesLeftMeta,
          votesLeft.isAcceptableOrUnknown(data['votes_left']!, _votesLeftMeta));
    } else if (isInserting) {
      context.missing(_votesLeftMeta);
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
          _longestStreakMeta,
          longestStreak.isAcceptableOrUnknown(
              data['longest_streak']!, _longestStreakMeta));
    } else if (isInserting) {
      context.missing(_longestStreakMeta);
    }
    if (data.containsKey('top_b_o_t_w')) {
      context.handle(_topBOTWMeta,
          topBOTW.isAcceptableOrUnknown(data['top_b_o_t_w']!, _topBOTWMeta));
    } else if (isInserting) {
      context.missing(_topBOTWMeta);
    }
    if (data.containsKey('trivia_points')) {
      context.handle(
          _triviaPointsMeta,
          triviaPoints.isAcceptableOrUnknown(
              data['trivia_points']!, _triviaPointsMeta));
    } else if (isInserting) {
      context.missing(_triviaPointsMeta);
    }
    if (data.containsKey('snippets_responded_to')) {
      context.handle(
          _snippetsRespondedToMeta,
          snippetsRespondedTo.isAcceptableOrUnknown(
              data['snippets_responded_to']!, _snippetsRespondedToMeta));
    } else if (isInserting) {
      context.missing(_snippetsRespondedToMeta);
    }
    if (data.containsKey('messages_sent')) {
      context.handle(
          _messagesSentMeta,
          messagesSent.isAcceptableOrUnknown(
              data['messages_sent']!, _messagesSentMeta));
    } else if (isInserting) {
      context.missing(_messagesSentMeta);
    }
    if (data.containsKey('discussions_started')) {
      context.handle(
          _discussionsStartedMeta,
          discussionsStarted.isAcceptableOrUnknown(
              data['discussions_started']!, _discussionsStartedMeta));
    } else if (isInserting) {
      context.missing(_discussionsStartedMeta);
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    } else if (isInserting) {
      context.missing(_streakMeta);
    }
    if (data.containsKey('profile_strikes')) {
      context.handle(
          _profileStrikesMeta,
          profileStrikes.isAcceptableOrUnknown(
              data['profile_strikes']!, _profileStrikesMeta));
    } else if (isInserting) {
      context.missing(_profileStrikesMeta);
    }
    if (data.containsKey('streak_date')) {
      context.handle(
          _streakDateMeta,
          streakDate.isAcceptableOrUnknown(
              data['streak_date']!, _streakDateMeta));
    } else if (isInserting) {
      context.missing(_streakDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserDataTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      FCMToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}f_c_m_token'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      BOTWStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}b_o_t_w_status'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      discussions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}discussions'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      friends: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}friends'])!,
      friendRequests: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}friend_requests'])!,
      outgoingFriendRequests: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}outgoing_friend_requests'])!,
      bestFriends: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}best_friends'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      searchKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}search_key'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      lastUpdatedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_millis'])!,
      votesLeft: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}votes_left'])!,
      longestStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}longest_streak'])!,
      topBOTW: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}top_b_o_t_w'])!,
      triviaPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trivia_points'])!,
      snippetsRespondedTo: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}snippets_responded_to'])!,
      messagesSent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}messages_sent'])!,
      discussionsStarted: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}discussions_started'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      profileStrikes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}profile_strikes'])!,
      streakDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}streak_date'])!,
    );
  }

  @override
  $UserDataTableTable createAlias(String alias) {
    return $UserDataTableTable(attachedDatabase, alias);
  }
}

class UserDataTableData extends DataClass
    implements Insertable<UserDataTableData> {
  final int id;
  final String FCMToken;
  final String displayName;
  final String BOTWStatus;
  final String description;
  final String discussions;
  final String email;
  final String friends;
  final String friendRequests;
  final String outgoingFriendRequests;
  final String bestFriends;
  final String username;
  final String searchKey;
  final String userId;
  final int lastUpdatedMillis;
  final int votesLeft;
  final int longestStreak;
  final int topBOTW;
  final int triviaPoints;
  final int snippetsRespondedTo;
  final int messagesSent;
  final int discussionsStarted;
  final int streak;
  final String profileStrikes;
  final DateTime streakDate;
  const UserDataTableData(
      {required this.id,
      required this.FCMToken,
      required this.displayName,
      required this.BOTWStatus,
      required this.description,
      required this.discussions,
      required this.email,
      required this.friends,
      required this.friendRequests,
      required this.outgoingFriendRequests,
      required this.bestFriends,
      required this.username,
      required this.searchKey,
      required this.userId,
      required this.lastUpdatedMillis,
      required this.votesLeft,
      required this.longestStreak,
      required this.topBOTW,
      required this.triviaPoints,
      required this.snippetsRespondedTo,
      required this.messagesSent,
      required this.discussionsStarted,
      required this.streak,
      required this.profileStrikes,
      required this.streakDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['f_c_m_token'] = Variable<String>(FCMToken);
    map['display_name'] = Variable<String>(displayName);
    map['b_o_t_w_status'] = Variable<String>(BOTWStatus);
    map['description'] = Variable<String>(description);
    map['discussions'] = Variable<String>(discussions);
    map['email'] = Variable<String>(email);
    map['friends'] = Variable<String>(friends);
    map['friend_requests'] = Variable<String>(friendRequests);
    map['outgoing_friend_requests'] = Variable<String>(outgoingFriendRequests);
    map['best_friends'] = Variable<String>(bestFriends);
    map['username'] = Variable<String>(username);
    map['search_key'] = Variable<String>(searchKey);
    map['user_id'] = Variable<String>(userId);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    map['votes_left'] = Variable<int>(votesLeft);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['top_b_o_t_w'] = Variable<int>(topBOTW);
    map['trivia_points'] = Variable<int>(triviaPoints);
    map['snippets_responded_to'] = Variable<int>(snippetsRespondedTo);
    map['messages_sent'] = Variable<int>(messagesSent);
    map['discussions_started'] = Variable<int>(discussionsStarted);
    map['streak'] = Variable<int>(streak);
    map['profile_strikes'] = Variable<String>(profileStrikes);
    map['streak_date'] = Variable<DateTime>(streakDate);
    return map;
  }

  UserDataTableCompanion toCompanion(bool nullToAbsent) {
    return UserDataTableCompanion(
      id: Value(id),
      FCMToken: Value(FCMToken),
      displayName: Value(displayName),
      BOTWStatus: Value(BOTWStatus),
      description: Value(description),
      discussions: Value(discussions),
      email: Value(email),
      friends: Value(friends),
      friendRequests: Value(friendRequests),
      outgoingFriendRequests: Value(outgoingFriendRequests),
      bestFriends: Value(bestFriends),
      username: Value(username),
      searchKey: Value(searchKey),
      userId: Value(userId),
      lastUpdatedMillis: Value(lastUpdatedMillis),
      votesLeft: Value(votesLeft),
      longestStreak: Value(longestStreak),
      topBOTW: Value(topBOTW),
      triviaPoints: Value(triviaPoints),
      snippetsRespondedTo: Value(snippetsRespondedTo),
      messagesSent: Value(messagesSent),
      discussionsStarted: Value(discussionsStarted),
      streak: Value(streak),
      profileStrikes: Value(profileStrikes),
      streakDate: Value(streakDate),
    );
  }

  factory UserDataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserDataTableData(
      id: serializer.fromJson<int>(json['id']),
      FCMToken: serializer.fromJson<String>(json['FCMToken']),
      displayName: serializer.fromJson<String>(json['displayName']),
      BOTWStatus: serializer.fromJson<String>(json['BOTWStatus']),
      description: serializer.fromJson<String>(json['description']),
      discussions: serializer.fromJson<String>(json['discussions']),
      email: serializer.fromJson<String>(json['email']),
      friends: serializer.fromJson<String>(json['friends']),
      friendRequests: serializer.fromJson<String>(json['friendRequests']),
      outgoingFriendRequests:
          serializer.fromJson<String>(json['outgoingFriendRequests']),
      bestFriends: serializer.fromJson<String>(json['bestFriends']),
      username: serializer.fromJson<String>(json['username']),
      searchKey: serializer.fromJson<String>(json['searchKey']),
      userId: serializer.fromJson<String>(json['userId']),
      lastUpdatedMillis: serializer.fromJson<int>(json['lastUpdatedMillis']),
      votesLeft: serializer.fromJson<int>(json['votesLeft']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      topBOTW: serializer.fromJson<int>(json['topBOTW']),
      triviaPoints: serializer.fromJson<int>(json['triviaPoints']),
      snippetsRespondedTo:
          serializer.fromJson<int>(json['snippetsRespondedTo']),
      messagesSent: serializer.fromJson<int>(json['messagesSent']),
      discussionsStarted: serializer.fromJson<int>(json['discussionsStarted']),
      streak: serializer.fromJson<int>(json['streak']),
      profileStrikes: serializer.fromJson<String>(json['profileStrikes']),
      streakDate: serializer.fromJson<DateTime>(json['streakDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'FCMToken': serializer.toJson<String>(FCMToken),
      'displayName': serializer.toJson<String>(displayName),
      'BOTWStatus': serializer.toJson<String>(BOTWStatus),
      'description': serializer.toJson<String>(description),
      'discussions': serializer.toJson<String>(discussions),
      'email': serializer.toJson<String>(email),
      'friends': serializer.toJson<String>(friends),
      'friendRequests': serializer.toJson<String>(friendRequests),
      'outgoingFriendRequests':
          serializer.toJson<String>(outgoingFriendRequests),
      'bestFriends': serializer.toJson<String>(bestFriends),
      'username': serializer.toJson<String>(username),
      'searchKey': serializer.toJson<String>(searchKey),
      'userId': serializer.toJson<String>(userId),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
      'votesLeft': serializer.toJson<int>(votesLeft),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'topBOTW': serializer.toJson<int>(topBOTW),
      'triviaPoints': serializer.toJson<int>(triviaPoints),
      'snippetsRespondedTo': serializer.toJson<int>(snippetsRespondedTo),
      'messagesSent': serializer.toJson<int>(messagesSent),
      'discussionsStarted': serializer.toJson<int>(discussionsStarted),
      'streak': serializer.toJson<int>(streak),
      'profileStrikes': serializer.toJson<String>(profileStrikes),
      'streakDate': serializer.toJson<DateTime>(streakDate),
    };
  }

  UserDataTableData copyWith(
          {int? id,
          String? FCMToken,
          String? displayName,
          String? BOTWStatus,
          String? description,
          String? discussions,
          String? email,
          String? friends,
          String? friendRequests,
          String? outgoingFriendRequests,
          String? bestFriends,
          String? username,
          String? searchKey,
          String? userId,
          int? lastUpdatedMillis,
          int? votesLeft,
          int? longestStreak,
          int? topBOTW,
          int? triviaPoints,
          int? snippetsRespondedTo,
          int? messagesSent,
          int? discussionsStarted,
          int? streak,
          String? profileStrikes,
          DateTime? streakDate}) =>
      UserDataTableData(
        id: id ?? this.id,
        FCMToken: FCMToken ?? this.FCMToken,
        displayName: displayName ?? this.displayName,
        BOTWStatus: BOTWStatus ?? this.BOTWStatus,
        description: description ?? this.description,
        discussions: discussions ?? this.discussions,
        email: email ?? this.email,
        friends: friends ?? this.friends,
        friendRequests: friendRequests ?? this.friendRequests,
        outgoingFriendRequests:
            outgoingFriendRequests ?? this.outgoingFriendRequests,
        bestFriends: bestFriends ?? this.bestFriends,
        username: username ?? this.username,
        searchKey: searchKey ?? this.searchKey,
        userId: userId ?? this.userId,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
        votesLeft: votesLeft ?? this.votesLeft,
        longestStreak: longestStreak ?? this.longestStreak,
        topBOTW: topBOTW ?? this.topBOTW,
        triviaPoints: triviaPoints ?? this.triviaPoints,
        snippetsRespondedTo: snippetsRespondedTo ?? this.snippetsRespondedTo,
        messagesSent: messagesSent ?? this.messagesSent,
        discussionsStarted: discussionsStarted ?? this.discussionsStarted,
        streak: streak ?? this.streak,
        profileStrikes: profileStrikes ?? this.profileStrikes,
        streakDate: streakDate ?? this.streakDate,
      );
  UserDataTableData copyWithCompanion(UserDataTableCompanion data) {
    return UserDataTableData(
      id: data.id.present ? data.id.value : this.id,
      FCMToken: data.FCMToken.present ? data.FCMToken.value : this.FCMToken,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      BOTWStatus:
          data.BOTWStatus.present ? data.BOTWStatus.value : this.BOTWStatus,
      description:
          data.description.present ? data.description.value : this.description,
      discussions:
          data.discussions.present ? data.discussions.value : this.discussions,
      email: data.email.present ? data.email.value : this.email,
      friends: data.friends.present ? data.friends.value : this.friends,
      friendRequests: data.friendRequests.present
          ? data.friendRequests.value
          : this.friendRequests,
      outgoingFriendRequests: data.outgoingFriendRequests.present
          ? data.outgoingFriendRequests.value
          : this.outgoingFriendRequests,
      bestFriends:
          data.bestFriends.present ? data.bestFriends.value : this.bestFriends,
      username: data.username.present ? data.username.value : this.username,
      searchKey: data.searchKey.present ? data.searchKey.value : this.searchKey,
      userId: data.userId.present ? data.userId.value : this.userId,
      lastUpdatedMillis: data.lastUpdatedMillis.present
          ? data.lastUpdatedMillis.value
          : this.lastUpdatedMillis,
      votesLeft: data.votesLeft.present ? data.votesLeft.value : this.votesLeft,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      topBOTW: data.topBOTW.present ? data.topBOTW.value : this.topBOTW,
      triviaPoints: data.triviaPoints.present
          ? data.triviaPoints.value
          : this.triviaPoints,
      snippetsRespondedTo: data.snippetsRespondedTo.present
          ? data.snippetsRespondedTo.value
          : this.snippetsRespondedTo,
      messagesSent: data.messagesSent.present
          ? data.messagesSent.value
          : this.messagesSent,
      discussionsStarted: data.discussionsStarted.present
          ? data.discussionsStarted.value
          : this.discussionsStarted,
      streak: data.streak.present ? data.streak.value : this.streak,
      profileStrikes: data.profileStrikes.present
          ? data.profileStrikes.value
          : this.profileStrikes,
      streakDate:
          data.streakDate.present ? data.streakDate.value : this.streakDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserDataTableData(')
          ..write('id: $id, ')
          ..write('FCMToken: $FCMToken, ')
          ..write('displayName: $displayName, ')
          ..write('BOTWStatus: $BOTWStatus, ')
          ..write('description: $description, ')
          ..write('discussions: $discussions, ')
          ..write('email: $email, ')
          ..write('friends: $friends, ')
          ..write('friendRequests: $friendRequests, ')
          ..write('outgoingFriendRequests: $outgoingFriendRequests, ')
          ..write('bestFriends: $bestFriends, ')
          ..write('username: $username, ')
          ..write('searchKey: $searchKey, ')
          ..write('userId: $userId, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('votesLeft: $votesLeft, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('topBOTW: $topBOTW, ')
          ..write('triviaPoints: $triviaPoints, ')
          ..write('snippetsRespondedTo: $snippetsRespondedTo, ')
          ..write('messagesSent: $messagesSent, ')
          ..write('discussionsStarted: $discussionsStarted, ')
          ..write('streak: $streak, ')
          ..write('profileStrikes: $profileStrikes, ')
          ..write('streakDate: $streakDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        FCMToken,
        displayName,
        BOTWStatus,
        description,
        discussions,
        email,
        friends,
        friendRequests,
        outgoingFriendRequests,
        bestFriends,
        username,
        searchKey,
        userId,
        lastUpdatedMillis,
        votesLeft,
        longestStreak,
        topBOTW,
        triviaPoints,
        snippetsRespondedTo,
        messagesSent,
        discussionsStarted,
        streak,
        profileStrikes,
        streakDate
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserDataTableData &&
          other.id == this.id &&
          other.FCMToken == this.FCMToken &&
          other.displayName == this.displayName &&
          other.BOTWStatus == this.BOTWStatus &&
          other.description == this.description &&
          other.discussions == this.discussions &&
          other.email == this.email &&
          other.friends == this.friends &&
          other.friendRequests == this.friendRequests &&
          other.outgoingFriendRequests == this.outgoingFriendRequests &&
          other.bestFriends == this.bestFriends &&
          other.username == this.username &&
          other.searchKey == this.searchKey &&
          other.userId == this.userId &&
          other.lastUpdatedMillis == this.lastUpdatedMillis &&
          other.votesLeft == this.votesLeft &&
          other.longestStreak == this.longestStreak &&
          other.topBOTW == this.topBOTW &&
          other.triviaPoints == this.triviaPoints &&
          other.snippetsRespondedTo == this.snippetsRespondedTo &&
          other.messagesSent == this.messagesSent &&
          other.discussionsStarted == this.discussionsStarted &&
          other.streak == this.streak &&
          other.profileStrikes == this.profileStrikes &&
          other.streakDate == this.streakDate);
}

class UserDataTableCompanion extends UpdateCompanion<UserDataTableData> {
  final Value<int> id;
  final Value<String> FCMToken;
  final Value<String> displayName;
  final Value<String> BOTWStatus;
  final Value<String> description;
  final Value<String> discussions;
  final Value<String> email;
  final Value<String> friends;
  final Value<String> friendRequests;
  final Value<String> outgoingFriendRequests;
  final Value<String> bestFriends;
  final Value<String> username;
  final Value<String> searchKey;
  final Value<String> userId;
  final Value<int> lastUpdatedMillis;
  final Value<int> votesLeft;
  final Value<int> longestStreak;
  final Value<int> topBOTW;
  final Value<int> triviaPoints;
  final Value<int> snippetsRespondedTo;
  final Value<int> messagesSent;
  final Value<int> discussionsStarted;
  final Value<int> streak;
  final Value<String> profileStrikes;
  final Value<DateTime> streakDate;
  const UserDataTableCompanion({
    this.id = const Value.absent(),
    this.FCMToken = const Value.absent(),
    this.displayName = const Value.absent(),
    this.BOTWStatus = const Value.absent(),
    this.description = const Value.absent(),
    this.discussions = const Value.absent(),
    this.email = const Value.absent(),
    this.friends = const Value.absent(),
    this.friendRequests = const Value.absent(),
    this.outgoingFriendRequests = const Value.absent(),
    this.bestFriends = const Value.absent(),
    this.username = const Value.absent(),
    this.searchKey = const Value.absent(),
    this.userId = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
    this.votesLeft = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.topBOTW = const Value.absent(),
    this.triviaPoints = const Value.absent(),
    this.snippetsRespondedTo = const Value.absent(),
    this.messagesSent = const Value.absent(),
    this.discussionsStarted = const Value.absent(),
    this.streak = const Value.absent(),
    this.profileStrikes = const Value.absent(),
    this.streakDate = const Value.absent(),
  });
  UserDataTableCompanion.insert({
    this.id = const Value.absent(),
    required String FCMToken,
    required String displayName,
    required String BOTWStatus,
    required String description,
    required String discussions,
    required String email,
    required String friends,
    required String friendRequests,
    required String outgoingFriendRequests,
    required String bestFriends,
    required String username,
    required String searchKey,
    required String userId,
    required int lastUpdatedMillis,
    required int votesLeft,
    required int longestStreak,
    required int topBOTW,
    required int triviaPoints,
    required int snippetsRespondedTo,
    required int messagesSent,
    required int discussionsStarted,
    required int streak,
    required String profileStrikes,
    required DateTime streakDate,
  })  : FCMToken = Value(FCMToken),
        displayName = Value(displayName),
        BOTWStatus = Value(BOTWStatus),
        description = Value(description),
        discussions = Value(discussions),
        email = Value(email),
        friends = Value(friends),
        friendRequests = Value(friendRequests),
        outgoingFriendRequests = Value(outgoingFriendRequests),
        bestFriends = Value(bestFriends),
        username = Value(username),
        searchKey = Value(searchKey),
        userId = Value(userId),
        lastUpdatedMillis = Value(lastUpdatedMillis),
        votesLeft = Value(votesLeft),
        longestStreak = Value(longestStreak),
        topBOTW = Value(topBOTW),
        triviaPoints = Value(triviaPoints),
        snippetsRespondedTo = Value(snippetsRespondedTo),
        messagesSent = Value(messagesSent),
        discussionsStarted = Value(discussionsStarted),
        streak = Value(streak),
        profileStrikes = Value(profileStrikes),
        streakDate = Value(streakDate);
  static Insertable<UserDataTableData> custom({
    Expression<int>? id,
    Expression<String>? FCMToken,
    Expression<String>? displayName,
    Expression<String>? BOTWStatus,
    Expression<String>? description,
    Expression<String>? discussions,
    Expression<String>? email,
    Expression<String>? friends,
    Expression<String>? friendRequests,
    Expression<String>? outgoingFriendRequests,
    Expression<String>? bestFriends,
    Expression<String>? username,
    Expression<String>? searchKey,
    Expression<String>? userId,
    Expression<int>? lastUpdatedMillis,
    Expression<int>? votesLeft,
    Expression<int>? longestStreak,
    Expression<int>? topBOTW,
    Expression<int>? triviaPoints,
    Expression<int>? snippetsRespondedTo,
    Expression<int>? messagesSent,
    Expression<int>? discussionsStarted,
    Expression<int>? streak,
    Expression<String>? profileStrikes,
    Expression<DateTime>? streakDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (FCMToken != null) 'f_c_m_token': FCMToken,
      if (displayName != null) 'display_name': displayName,
      if (BOTWStatus != null) 'b_o_t_w_status': BOTWStatus,
      if (description != null) 'description': description,
      if (discussions != null) 'discussions': discussions,
      if (email != null) 'email': email,
      if (friends != null) 'friends': friends,
      if (friendRequests != null) 'friend_requests': friendRequests,
      if (outgoingFriendRequests != null)
        'outgoing_friend_requests': outgoingFriendRequests,
      if (bestFriends != null) 'best_friends': bestFriends,
      if (username != null) 'username': username,
      if (searchKey != null) 'search_key': searchKey,
      if (userId != null) 'user_id': userId,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
      if (votesLeft != null) 'votes_left': votesLeft,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (topBOTW != null) 'top_b_o_t_w': topBOTW,
      if (triviaPoints != null) 'trivia_points': triviaPoints,
      if (snippetsRespondedTo != null)
        'snippets_responded_to': snippetsRespondedTo,
      if (messagesSent != null) 'messages_sent': messagesSent,
      if (discussionsStarted != null) 'discussions_started': discussionsStarted,
      if (streak != null) 'streak': streak,
      if (profileStrikes != null) 'profile_strikes': profileStrikes,
      if (streakDate != null) 'streak_date': streakDate,
    });
  }

  UserDataTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? FCMToken,
      Value<String>? displayName,
      Value<String>? BOTWStatus,
      Value<String>? description,
      Value<String>? discussions,
      Value<String>? email,
      Value<String>? friends,
      Value<String>? friendRequests,
      Value<String>? outgoingFriendRequests,
      Value<String>? bestFriends,
      Value<String>? username,
      Value<String>? searchKey,
      Value<String>? userId,
      Value<int>? lastUpdatedMillis,
      Value<int>? votesLeft,
      Value<int>? longestStreak,
      Value<int>? topBOTW,
      Value<int>? triviaPoints,
      Value<int>? snippetsRespondedTo,
      Value<int>? messagesSent,
      Value<int>? discussionsStarted,
      Value<int>? streak,
      Value<String>? profileStrikes,
      Value<DateTime>? streakDate}) {
    return UserDataTableCompanion(
      id: id ?? this.id,
      FCMToken: FCMToken ?? this.FCMToken,
      displayName: displayName ?? this.displayName,
      BOTWStatus: BOTWStatus ?? this.BOTWStatus,
      description: description ?? this.description,
      discussions: discussions ?? this.discussions,
      email: email ?? this.email,
      friends: friends ?? this.friends,
      friendRequests: friendRequests ?? this.friendRequests,
      outgoingFriendRequests:
          outgoingFriendRequests ?? this.outgoingFriendRequests,
      bestFriends: bestFriends ?? this.bestFriends,
      username: username ?? this.username,
      searchKey: searchKey ?? this.searchKey,
      userId: userId ?? this.userId,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      votesLeft: votesLeft ?? this.votesLeft,
      longestStreak: longestStreak ?? this.longestStreak,
      topBOTW: topBOTW ?? this.topBOTW,
      triviaPoints: triviaPoints ?? this.triviaPoints,
      snippetsRespondedTo: snippetsRespondedTo ?? this.snippetsRespondedTo,
      messagesSent: messagesSent ?? this.messagesSent,
      discussionsStarted: discussionsStarted ?? this.discussionsStarted,
      streak: streak ?? this.streak,
      profileStrikes: profileStrikes ?? this.profileStrikes,
      streakDate: streakDate ?? this.streakDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (FCMToken.present) {
      map['f_c_m_token'] = Variable<String>(FCMToken.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (BOTWStatus.present) {
      map['b_o_t_w_status'] = Variable<String>(BOTWStatus.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (discussions.present) {
      map['discussions'] = Variable<String>(discussions.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (friends.present) {
      map['friends'] = Variable<String>(friends.value);
    }
    if (friendRequests.present) {
      map['friend_requests'] = Variable<String>(friendRequests.value);
    }
    if (outgoingFriendRequests.present) {
      map['outgoing_friend_requests'] =
          Variable<String>(outgoingFriendRequests.value);
    }
    if (bestFriends.present) {
      map['best_friends'] = Variable<String>(bestFriends.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (searchKey.present) {
      map['search_key'] = Variable<String>(searchKey.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lastUpdatedMillis.present) {
      map['last_updated_millis'] = Variable<int>(lastUpdatedMillis.value);
    }
    if (votesLeft.present) {
      map['votes_left'] = Variable<int>(votesLeft.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (topBOTW.present) {
      map['top_b_o_t_w'] = Variable<int>(topBOTW.value);
    }
    if (triviaPoints.present) {
      map['trivia_points'] = Variable<int>(triviaPoints.value);
    }
    if (snippetsRespondedTo.present) {
      map['snippets_responded_to'] = Variable<int>(snippetsRespondedTo.value);
    }
    if (messagesSent.present) {
      map['messages_sent'] = Variable<int>(messagesSent.value);
    }
    if (discussionsStarted.present) {
      map['discussions_started'] = Variable<int>(discussionsStarted.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (profileStrikes.present) {
      map['profile_strikes'] = Variable<String>(profileStrikes.value);
    }
    if (streakDate.present) {
      map['streak_date'] = Variable<DateTime>(streakDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserDataTableCompanion(')
          ..write('id: $id, ')
          ..write('FCMToken: $FCMToken, ')
          ..write('displayName: $displayName, ')
          ..write('BOTWStatus: $BOTWStatus, ')
          ..write('description: $description, ')
          ..write('discussions: $discussions, ')
          ..write('email: $email, ')
          ..write('friends: $friends, ')
          ..write('friendRequests: $friendRequests, ')
          ..write('outgoingFriendRequests: $outgoingFriendRequests, ')
          ..write('bestFriends: $bestFriends, ')
          ..write('username: $username, ')
          ..write('searchKey: $searchKey, ')
          ..write('userId: $userId, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('votesLeft: $votesLeft, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('topBOTW: $topBOTW, ')
          ..write('triviaPoints: $triviaPoints, ')
          ..write('snippetsRespondedTo: $snippetsRespondedTo, ')
          ..write('messagesSent: $messagesSent, ')
          ..write('discussionsStarted: $discussionsStarted, ')
          ..write('streak: $streak, ')
          ..write('profileStrikes: $profileStrikes, ')
          ..write('streakDate: $streakDate')
          ..write(')'))
        .toString();
  }
}

class $SavedMessagesTableTable extends SavedMessagesTable
    with TableInfo<$SavedMessagesTableTable, SavedMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _responseIdMeta =
      const VerificationMeta('responseId');
  @override
  late final GeneratedColumn<String> responseId = GeneratedColumn<String>(
      'response_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderUsernameMeta =
      const VerificationMeta('senderUsername');
  @override
  late final GeneratedColumn<String> senderUsername = GeneratedColumn<String>(
      'sender_username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _senderDisplayNameMeta =
      const VerificationMeta('senderDisplayName');
  @override
  late final GeneratedColumn<String> senderDisplayName =
      GeneratedColumn<String>('sender_display_name', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reportsMeta =
      const VerificationMeta('reports');
  @override
  late final GeneratedColumn<int> reports = GeneratedColumn<int>(
      'reports', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reportIdsMeta =
      const VerificationMeta('reportIds');
  @override
  late final GeneratedColumn<String> reportIds = GeneratedColumn<String>(
      'report_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        message,
        messageId,
        senderId,
        responseId,
        senderUsername,
        date,
        senderDisplayName,
        reports,
        reportIds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_messages_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SavedMessagesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('response_id')) {
      context.handle(
          _responseIdMeta,
          responseId.isAcceptableOrUnknown(
              data['response_id']!, _responseIdMeta));
    } else if (isInserting) {
      context.missing(_responseIdMeta);
    }
    if (data.containsKey('sender_username')) {
      context.handle(
          _senderUsernameMeta,
          senderUsername.isAcceptableOrUnknown(
              data['sender_username']!, _senderUsernameMeta));
    } else if (isInserting) {
      context.missing(_senderUsernameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('sender_display_name')) {
      context.handle(
          _senderDisplayNameMeta,
          senderDisplayName.isAcceptableOrUnknown(
              data['sender_display_name']!, _senderDisplayNameMeta));
    } else if (isInserting) {
      context.missing(_senderDisplayNameMeta);
    }
    if (data.containsKey('reports')) {
      context.handle(_reportsMeta,
          reports.isAcceptableOrUnknown(data['reports']!, _reportsMeta));
    } else if (isInserting) {
      context.missing(_reportsMeta);
    }
    if (data.containsKey('report_ids')) {
      context.handle(_reportIdsMeta,
          reportIds.isAcceptableOrUnknown(data['report_ids']!, _reportIdsMeta));
    } else if (isInserting) {
      context.missing(_reportIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedMessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedMessagesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      responseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}response_id'])!,
      senderUsername: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sender_username'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      senderDisplayName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sender_display_name'])!,
      reports: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reports'])!,
      reportIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_ids'])!,
    );
  }

  @override
  $SavedMessagesTableTable createAlias(String alias) {
    return $SavedMessagesTableTable(attachedDatabase, alias);
  }
}

class SavedMessagesTableData extends DataClass
    implements Insertable<SavedMessagesTableData> {
  final int id;
  final String message;
  final String messageId;
  final String senderId;
  final String responseId;
  final String senderUsername;
  final DateTime date;
  final String senderDisplayName;
  final int reports;
  final String reportIds;
  const SavedMessagesTableData(
      {required this.id,
      required this.message,
      required this.messageId,
      required this.senderId,
      required this.responseId,
      required this.senderUsername,
      required this.date,
      required this.senderDisplayName,
      required this.reports,
      required this.reportIds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message'] = Variable<String>(message);
    map['message_id'] = Variable<String>(messageId);
    map['sender_id'] = Variable<String>(senderId);
    map['response_id'] = Variable<String>(responseId);
    map['sender_username'] = Variable<String>(senderUsername);
    map['date'] = Variable<DateTime>(date);
    map['sender_display_name'] = Variable<String>(senderDisplayName);
    map['reports'] = Variable<int>(reports);
    map['report_ids'] = Variable<String>(reportIds);
    return map;
  }

  SavedMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return SavedMessagesTableCompanion(
      id: Value(id),
      message: Value(message),
      messageId: Value(messageId),
      senderId: Value(senderId),
      responseId: Value(responseId),
      senderUsername: Value(senderUsername),
      date: Value(date),
      senderDisplayName: Value(senderDisplayName),
      reports: Value(reports),
      reportIds: Value(reportIds),
    );
  }

  factory SavedMessagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedMessagesTableData(
      id: serializer.fromJson<int>(json['id']),
      message: serializer.fromJson<String>(json['message']),
      messageId: serializer.fromJson<String>(json['messageId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      responseId: serializer.fromJson<String>(json['responseId']),
      senderUsername: serializer.fromJson<String>(json['senderUsername']),
      date: serializer.fromJson<DateTime>(json['date']),
      senderDisplayName: serializer.fromJson<String>(json['senderDisplayName']),
      reports: serializer.fromJson<int>(json['reports']),
      reportIds: serializer.fromJson<String>(json['reportIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'message': serializer.toJson<String>(message),
      'messageId': serializer.toJson<String>(messageId),
      'senderId': serializer.toJson<String>(senderId),
      'responseId': serializer.toJson<String>(responseId),
      'senderUsername': serializer.toJson<String>(senderUsername),
      'date': serializer.toJson<DateTime>(date),
      'senderDisplayName': serializer.toJson<String>(senderDisplayName),
      'reports': serializer.toJson<int>(reports),
      'reportIds': serializer.toJson<String>(reportIds),
    };
  }

  SavedMessagesTableData copyWith(
          {int? id,
          String? message,
          String? messageId,
          String? senderId,
          String? responseId,
          String? senderUsername,
          DateTime? date,
          String? senderDisplayName,
          int? reports,
          String? reportIds}) =>
      SavedMessagesTableData(
        id: id ?? this.id,
        message: message ?? this.message,
        messageId: messageId ?? this.messageId,
        senderId: senderId ?? this.senderId,
        responseId: responseId ?? this.responseId,
        senderUsername: senderUsername ?? this.senderUsername,
        date: date ?? this.date,
        senderDisplayName: senderDisplayName ?? this.senderDisplayName,
        reports: reports ?? this.reports,
        reportIds: reportIds ?? this.reportIds,
      );
  SavedMessagesTableData copyWithCompanion(SavedMessagesTableCompanion data) {
    return SavedMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      message: data.message.present ? data.message.value : this.message,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      responseId:
          data.responseId.present ? data.responseId.value : this.responseId,
      senderUsername: data.senderUsername.present
          ? data.senderUsername.value
          : this.senderUsername,
      date: data.date.present ? data.date.value : this.date,
      senderDisplayName: data.senderDisplayName.present
          ? data.senderDisplayName.value
          : this.senderDisplayName,
      reports: data.reports.present ? data.reports.value : this.reports,
      reportIds: data.reportIds.present ? data.reportIds.value : this.reportIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedMessagesTableData(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('messageId: $messageId, ')
          ..write('senderId: $senderId, ')
          ..write('responseId: $responseId, ')
          ..write('senderUsername: $senderUsername, ')
          ..write('date: $date, ')
          ..write('senderDisplayName: $senderDisplayName, ')
          ..write('reports: $reports, ')
          ..write('reportIds: $reportIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, message, messageId, senderId, responseId,
      senderUsername, date, senderDisplayName, reports, reportIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedMessagesTableData &&
          other.id == this.id &&
          other.message == this.message &&
          other.messageId == this.messageId &&
          other.senderId == this.senderId &&
          other.responseId == this.responseId &&
          other.senderUsername == this.senderUsername &&
          other.date == this.date &&
          other.senderDisplayName == this.senderDisplayName &&
          other.reports == this.reports &&
          other.reportIds == this.reportIds);
}

class SavedMessagesTableCompanion
    extends UpdateCompanion<SavedMessagesTableData> {
  final Value<int> id;
  final Value<String> message;
  final Value<String> messageId;
  final Value<String> senderId;
  final Value<String> responseId;
  final Value<String> senderUsername;
  final Value<DateTime> date;
  final Value<String> senderDisplayName;
  final Value<int> reports;
  final Value<String> reportIds;
  const SavedMessagesTableCompanion({
    this.id = const Value.absent(),
    this.message = const Value.absent(),
    this.messageId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.responseId = const Value.absent(),
    this.senderUsername = const Value.absent(),
    this.date = const Value.absent(),
    this.senderDisplayName = const Value.absent(),
    this.reports = const Value.absent(),
    this.reportIds = const Value.absent(),
  });
  SavedMessagesTableCompanion.insert({
    this.id = const Value.absent(),
    required String message,
    required String messageId,
    required String senderId,
    required String responseId,
    required String senderUsername,
    required DateTime date,
    required String senderDisplayName,
    required int reports,
    required String reportIds,
  })  : message = Value(message),
        messageId = Value(messageId),
        senderId = Value(senderId),
        responseId = Value(responseId),
        senderUsername = Value(senderUsername),
        date = Value(date),
        senderDisplayName = Value(senderDisplayName),
        reports = Value(reports),
        reportIds = Value(reportIds);
  static Insertable<SavedMessagesTableData> custom({
    Expression<int>? id,
    Expression<String>? message,
    Expression<String>? messageId,
    Expression<String>? senderId,
    Expression<String>? responseId,
    Expression<String>? senderUsername,
    Expression<DateTime>? date,
    Expression<String>? senderDisplayName,
    Expression<int>? reports,
    Expression<String>? reportIds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (message != null) 'message': message,
      if (messageId != null) 'message_id': messageId,
      if (senderId != null) 'sender_id': senderId,
      if (responseId != null) 'response_id': responseId,
      if (senderUsername != null) 'sender_username': senderUsername,
      if (date != null) 'date': date,
      if (senderDisplayName != null) 'sender_display_name': senderDisplayName,
      if (reports != null) 'reports': reports,
      if (reportIds != null) 'report_ids': reportIds,
    });
  }

  SavedMessagesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? message,
      Value<String>? messageId,
      Value<String>? senderId,
      Value<String>? responseId,
      Value<String>? senderUsername,
      Value<DateTime>? date,
      Value<String>? senderDisplayName,
      Value<int>? reports,
      Value<String>? reportIds}) {
    return SavedMessagesTableCompanion(
      id: id ?? this.id,
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      responseId: responseId ?? this.responseId,
      senderUsername: senderUsername ?? this.senderUsername,
      date: date ?? this.date,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      reports: reports ?? this.reports,
      reportIds: reportIds ?? this.reportIds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (responseId.present) {
      map['response_id'] = Variable<String>(responseId.value);
    }
    if (senderUsername.present) {
      map['sender_username'] = Variable<String>(senderUsername.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (senderDisplayName.present) {
      map['sender_display_name'] = Variable<String>(senderDisplayName.value);
    }
    if (reports.present) {
      map['reports'] = Variable<int>(reports.value);
    }
    if (reportIds.present) {
      map['report_ids'] = Variable<String>(reportIds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('messageId: $messageId, ')
          ..write('senderId: $senderId, ')
          ..write('responseId: $responseId, ')
          ..write('senderUsername: $senderUsername, ')
          ..write('date: $date, ')
          ..write('senderDisplayName: $senderDisplayName, ')
          ..write('reports: $reports, ')
          ..write('reportIds: $reportIds')
          ..write(')'))
        .toString();
  }
}

class $SavedResponsesTableTable extends SavedResponsesTable
    with TableInfo<$SavedResponsesTableTable, SavedResponsesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedResponsesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _responseIdMeta =
      const VerificationMeta('responseId');
  @override
  late final GeneratedColumn<String> responseId = GeneratedColumn<String>(
      'response_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isPublicMeta =
      const VerificationMeta('isPublic');
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
      'is_public', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_public" IN (0, 1))'));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<int> lastUpdated = GeneratedColumn<int>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, answer, question, responseId, isPublic, lastUpdated, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_responses_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SavedResponsesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('response_id')) {
      context.handle(
          _responseIdMeta,
          responseId.isAcceptableOrUnknown(
              data['response_id']!, _responseIdMeta));
    } else if (isInserting) {
      context.missing(_responseIdMeta);
    }
    if (data.containsKey('is_public')) {
      context.handle(_isPublicMeta,
          isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta));
    } else if (isInserting) {
      context.missing(_isPublicMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedResponsesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedResponsesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      responseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}response_id'])!,
      isPublic: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_public'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $SavedResponsesTableTable createAlias(String alias) {
    return $SavedResponsesTableTable(attachedDatabase, alias);
  }
}

class SavedResponsesTableData extends DataClass
    implements Insertable<SavedResponsesTableData> {
  final int id;
  final String answer;
  final String question;
  final String responseId;
  final bool isPublic;
  final int lastUpdated;
  final String userId;
  const SavedResponsesTableData(
      {required this.id,
      required this.answer,
      required this.question,
      required this.responseId,
      required this.isPublic,
      required this.lastUpdated,
      required this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['answer'] = Variable<String>(answer);
    map['question'] = Variable<String>(question);
    map['response_id'] = Variable<String>(responseId);
    map['is_public'] = Variable<bool>(isPublic);
    map['last_updated'] = Variable<int>(lastUpdated);
    map['user_id'] = Variable<String>(userId);
    return map;
  }

  SavedResponsesTableCompanion toCompanion(bool nullToAbsent) {
    return SavedResponsesTableCompanion(
      id: Value(id),
      answer: Value(answer),
      question: Value(question),
      responseId: Value(responseId),
      isPublic: Value(isPublic),
      lastUpdated: Value(lastUpdated),
      userId: Value(userId),
    );
  }

  factory SavedResponsesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedResponsesTableData(
      id: serializer.fromJson<int>(json['id']),
      answer: serializer.fromJson<String>(json['answer']),
      question: serializer.fromJson<String>(json['question']),
      responseId: serializer.fromJson<String>(json['responseId']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      lastUpdated: serializer.fromJson<int>(json['lastUpdated']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'answer': serializer.toJson<String>(answer),
      'question': serializer.toJson<String>(question),
      'responseId': serializer.toJson<String>(responseId),
      'isPublic': serializer.toJson<bool>(isPublic),
      'lastUpdated': serializer.toJson<int>(lastUpdated),
      'userId': serializer.toJson<String>(userId),
    };
  }

  SavedResponsesTableData copyWith(
          {int? id,
          String? answer,
          String? question,
          String? responseId,
          bool? isPublic,
          int? lastUpdated,
          String? userId}) =>
      SavedResponsesTableData(
        id: id ?? this.id,
        answer: answer ?? this.answer,
        question: question ?? this.question,
        responseId: responseId ?? this.responseId,
        isPublic: isPublic ?? this.isPublic,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        userId: userId ?? this.userId,
      );
  SavedResponsesTableData copyWithCompanion(SavedResponsesTableCompanion data) {
    return SavedResponsesTableData(
      id: data.id.present ? data.id.value : this.id,
      answer: data.answer.present ? data.answer.value : this.answer,
      question: data.question.present ? data.question.value : this.question,
      responseId:
          data.responseId.present ? data.responseId.value : this.responseId,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedResponsesTableData(')
          ..write('id: $id, ')
          ..write('answer: $answer, ')
          ..write('question: $question, ')
          ..write('responseId: $responseId, ')
          ..write('isPublic: $isPublic, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, answer, question, responseId, isPublic, lastUpdated, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedResponsesTableData &&
          other.id == this.id &&
          other.answer == this.answer &&
          other.question == this.question &&
          other.responseId == this.responseId &&
          other.isPublic == this.isPublic &&
          other.lastUpdated == this.lastUpdated &&
          other.userId == this.userId);
}

class SavedResponsesTableCompanion
    extends UpdateCompanion<SavedResponsesTableData> {
  final Value<int> id;
  final Value<String> answer;
  final Value<String> question;
  final Value<String> responseId;
  final Value<bool> isPublic;
  final Value<int> lastUpdated;
  final Value<String> userId;
  const SavedResponsesTableCompanion({
    this.id = const Value.absent(),
    this.answer = const Value.absent(),
    this.question = const Value.absent(),
    this.responseId = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.userId = const Value.absent(),
  });
  SavedResponsesTableCompanion.insert({
    this.id = const Value.absent(),
    required String answer,
    required String question,
    required String responseId,
    required bool isPublic,
    required int lastUpdated,
    required String userId,
  })  : answer = Value(answer),
        question = Value(question),
        responseId = Value(responseId),
        isPublic = Value(isPublic),
        lastUpdated = Value(lastUpdated),
        userId = Value(userId);
  static Insertable<SavedResponsesTableData> custom({
    Expression<int>? id,
    Expression<String>? answer,
    Expression<String>? question,
    Expression<String>? responseId,
    Expression<bool>? isPublic,
    Expression<int>? lastUpdated,
    Expression<String>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (answer != null) 'answer': answer,
      if (question != null) 'question': question,
      if (responseId != null) 'response_id': responseId,
      if (isPublic != null) 'is_public': isPublic,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (userId != null) 'user_id': userId,
    });
  }

  SavedResponsesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? answer,
      Value<String>? question,
      Value<String>? responseId,
      Value<bool>? isPublic,
      Value<int>? lastUpdated,
      Value<String>? userId}) {
    return SavedResponsesTableCompanion(
      id: id ?? this.id,
      answer: answer ?? this.answer,
      question: question ?? this.question,
      responseId: responseId ?? this.responseId,
      isPublic: isPublic ?? this.isPublic,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (responseId.present) {
      map['response_id'] = Variable<String>(responseId.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<int>(lastUpdated.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedResponsesTableCompanion(')
          ..write('id: $id, ')
          ..write('answer: $answer, ')
          ..write('question: $question, ')
          ..write('responseId: $responseId, ')
          ..write('isPublic: $isPublic, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $SnipResponsesTable snipResponses = $SnipResponsesTable(this);
  late final $SnippetsDataTable snippetsData = $SnippetsDataTable(this);
  late final $BOTWDataTableTable bOTWDataTable = $BOTWDataTableTable(this);
  late final $UserDataTableTable userDataTable = $UserDataTableTable(this);
  late final $SavedMessagesTableTable savedMessagesTable =
      $SavedMessagesTableTable(this);
  late final $SavedResponsesTableTable savedResponsesTable =
      $SavedResponsesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        chats,
        snipResponses,
        snippetsData,
        bOTWDataTable,
        userDataTable,
        savedMessagesTable,
        savedResponsesTable
      ];
}

typedef $$ChatsTableCreateCompanionBuilder = ChatsCompanion Function({
  Value<int> id,
  required String message,
  required String messageId,
  required String senderId,
  required String senderUsername,
  required DateTime date,
  required String senderDisplayName,
  required String readBy,
  required String chatId,
  required String snippetId,
  required int lastUpdatedMillis,
  required int reports,
  required String reportIds,
});
typedef $$ChatsTableUpdateCompanionBuilder = ChatsCompanion Function({
  Value<int> id,
  Value<String> message,
  Value<String> messageId,
  Value<String> senderId,
  Value<String> senderUsername,
  Value<DateTime> date,
  Value<String> senderDisplayName,
  Value<String> readBy,
  Value<String> chatId,
  Value<String> snippetId,
  Value<int> lastUpdatedMillis,
  Value<int> reports,
  Value<String> reportIds,
});

class $$ChatsTableTableManager extends RootTableManager<
    _$AppDb,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableCreateCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder> {
  $$ChatsTableTableManager(_$AppDb db, $ChatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ChatsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ChatsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<String> senderId = const Value.absent(),
            Value<String> senderUsername = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> senderDisplayName = const Value.absent(),
            Value<String> readBy = const Value.absent(),
            Value<String> chatId = const Value.absent(),
            Value<String> snippetId = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
            Value<int> reports = const Value.absent(),
            Value<String> reportIds = const Value.absent(),
          }) =>
              ChatsCompanion(
            id: id,
            message: message,
            messageId: messageId,
            senderId: senderId,
            senderUsername: senderUsername,
            date: date,
            senderDisplayName: senderDisplayName,
            readBy: readBy,
            chatId: chatId,
            snippetId: snippetId,
            lastUpdatedMillis: lastUpdatedMillis,
            reports: reports,
            reportIds: reportIds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String message,
            required String messageId,
            required String senderId,
            required String senderUsername,
            required DateTime date,
            required String senderDisplayName,
            required String readBy,
            required String chatId,
            required String snippetId,
            required int lastUpdatedMillis,
            required int reports,
            required String reportIds,
          }) =>
              ChatsCompanion.insert(
            id: id,
            message: message,
            messageId: messageId,
            senderId: senderId,
            senderUsername: senderUsername,
            date: date,
            senderDisplayName: senderDisplayName,
            readBy: readBy,
            chatId: chatId,
            snippetId: snippetId,
            lastUpdatedMillis: lastUpdatedMillis,
            reports: reports,
            reportIds: reportIds,
          ),
        ));
}

class $$ChatsTableFilterComposer extends FilterComposer<_$AppDb, $ChatsTable> {
  $$ChatsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get messageId => $state.composableBuilder(
      column: $state.table.messageId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get senderId => $state.composableBuilder(
      column: $state.table.senderId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get senderUsername => $state.composableBuilder(
      column: $state.table.senderUsername,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get senderDisplayName => $state.composableBuilder(
      column: $state.table.senderDisplayName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get readBy => $state.composableBuilder(
      column: $state.table.readBy,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get chatId => $state.composableBuilder(
      column: $state.table.chatId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get snippetId => $state.composableBuilder(
      column: $state.table.snippetId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reports => $state.composableBuilder(
      column: $state.table.reports,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reportIds => $state.composableBuilder(
      column: $state.table.reportIds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ChatsTableOrderingComposer
    extends OrderingComposer<_$AppDb, $ChatsTable> {
  $$ChatsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get messageId => $state.composableBuilder(
      column: $state.table.messageId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get senderId => $state.composableBuilder(
      column: $state.table.senderId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get senderUsername => $state.composableBuilder(
      column: $state.table.senderUsername,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get senderDisplayName => $state.composableBuilder(
      column: $state.table.senderDisplayName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get readBy => $state.composableBuilder(
      column: $state.table.readBy,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get chatId => $state.composableBuilder(
      column: $state.table.chatId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get snippetId => $state.composableBuilder(
      column: $state.table.snippetId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reports => $state.composableBuilder(
      column: $state.table.reports,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reportIds => $state.composableBuilder(
      column: $state.table.reportIds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SnipResponsesTableCreateCompanionBuilder = SnipResponsesCompanion
    Function({
  Value<int> id,
  required String answer,
  required String snippetId,
  required String displayName,
  required DateTime date,
  required String uid,
  required int reports,
  required String reportIds,
  required int lastUpdatedMillis,
  required String discussionUsers,
});
typedef $$SnipResponsesTableUpdateCompanionBuilder = SnipResponsesCompanion
    Function({
  Value<int> id,
  Value<String> answer,
  Value<String> snippetId,
  Value<String> displayName,
  Value<DateTime> date,
  Value<String> uid,
  Value<int> reports,
  Value<String> reportIds,
  Value<int> lastUpdatedMillis,
  Value<String> discussionUsers,
});

class $$SnipResponsesTableTableManager extends RootTableManager<
    _$AppDb,
    $SnipResponsesTable,
    SnipResponse,
    $$SnipResponsesTableFilterComposer,
    $$SnipResponsesTableOrderingComposer,
    $$SnipResponsesTableCreateCompanionBuilder,
    $$SnipResponsesTableUpdateCompanionBuilder> {
  $$SnipResponsesTableTableManager(_$AppDb db, $SnipResponsesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SnipResponsesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SnipResponsesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<String> snippetId = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> uid = const Value.absent(),
            Value<int> reports = const Value.absent(),
            Value<String> reportIds = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
            Value<String> discussionUsers = const Value.absent(),
          }) =>
              SnipResponsesCompanion(
            id: id,
            answer: answer,
            snippetId: snippetId,
            displayName: displayName,
            date: date,
            uid: uid,
            reports: reports,
            reportIds: reportIds,
            lastUpdatedMillis: lastUpdatedMillis,
            discussionUsers: discussionUsers,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String answer,
            required String snippetId,
            required String displayName,
            required DateTime date,
            required String uid,
            required int reports,
            required String reportIds,
            required int lastUpdatedMillis,
            required String discussionUsers,
          }) =>
              SnipResponsesCompanion.insert(
            id: id,
            answer: answer,
            snippetId: snippetId,
            displayName: displayName,
            date: date,
            uid: uid,
            reports: reports,
            reportIds: reportIds,
            lastUpdatedMillis: lastUpdatedMillis,
            discussionUsers: discussionUsers,
          ),
        ));
}

class $$SnipResponsesTableFilterComposer
    extends FilterComposer<_$AppDb, $SnipResponsesTable> {
  $$SnipResponsesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get answer => $state.composableBuilder(
      column: $state.table.answer,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get snippetId => $state.composableBuilder(
      column: $state.table.snippetId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get displayName => $state.composableBuilder(
      column: $state.table.displayName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get uid => $state.composableBuilder(
      column: $state.table.uid,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reports => $state.composableBuilder(
      column: $state.table.reports,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reportIds => $state.composableBuilder(
      column: $state.table.reportIds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get discussionUsers => $state.composableBuilder(
      column: $state.table.discussionUsers,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SnipResponsesTableOrderingComposer
    extends OrderingComposer<_$AppDb, $SnipResponsesTable> {
  $$SnipResponsesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get answer => $state.composableBuilder(
      column: $state.table.answer,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get snippetId => $state.composableBuilder(
      column: $state.table.snippetId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get displayName => $state.composableBuilder(
      column: $state.table.displayName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get uid => $state.composableBuilder(
      column: $state.table.uid,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reports => $state.composableBuilder(
      column: $state.table.reports,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reportIds => $state.composableBuilder(
      column: $state.table.reportIds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get discussionUsers => $state.composableBuilder(
      column: $state.table.discussionUsers,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SnippetsDataTableCreateCompanionBuilder = SnippetsDataCompanion
    Function({
  Value<int> id,
  required String snippetId,
  required String question,
  required String options,
  required String correctAnswer,
  required int index,
  required bool answered,
  required String type,
  required int lastUpdatedMillis,
  required int lastRecievedMillis,
});
typedef $$SnippetsDataTableUpdateCompanionBuilder = SnippetsDataCompanion
    Function({
  Value<int> id,
  Value<String> snippetId,
  Value<String> question,
  Value<String> options,
  Value<String> correctAnswer,
  Value<int> index,
  Value<bool> answered,
  Value<String> type,
  Value<int> lastUpdatedMillis,
  Value<int> lastRecievedMillis,
});

class $$SnippetsDataTableTableManager extends RootTableManager<
    _$AppDb,
    $SnippetsDataTable,
    SnippetsDataData,
    $$SnippetsDataTableFilterComposer,
    $$SnippetsDataTableOrderingComposer,
    $$SnippetsDataTableCreateCompanionBuilder,
    $$SnippetsDataTableUpdateCompanionBuilder> {
  $$SnippetsDataTableTableManager(_$AppDb db, $SnippetsDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SnippetsDataTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SnippetsDataTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> snippetId = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> options = const Value.absent(),
            Value<String> correctAnswer = const Value.absent(),
            Value<int> index = const Value.absent(),
            Value<bool> answered = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
            Value<int> lastRecievedMillis = const Value.absent(),
          }) =>
              SnippetsDataCompanion(
            id: id,
            snippetId: snippetId,
            question: question,
            options: options,
            correctAnswer: correctAnswer,
            index: index,
            answered: answered,
            type: type,
            lastUpdatedMillis: lastUpdatedMillis,
            lastRecievedMillis: lastRecievedMillis,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String snippetId,
            required String question,
            required String options,
            required String correctAnswer,
            required int index,
            required bool answered,
            required String type,
            required int lastUpdatedMillis,
            required int lastRecievedMillis,
          }) =>
              SnippetsDataCompanion.insert(
            id: id,
            snippetId: snippetId,
            question: question,
            options: options,
            correctAnswer: correctAnswer,
            index: index,
            answered: answered,
            type: type,
            lastUpdatedMillis: lastUpdatedMillis,
            lastRecievedMillis: lastRecievedMillis,
          ),
        ));
}

class $$SnippetsDataTableFilterComposer
    extends FilterComposer<_$AppDb, $SnippetsDataTable> {
  $$SnippetsDataTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get snippetId => $state.composableBuilder(
      column: $state.table.snippetId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get question => $state.composableBuilder(
      column: $state.table.question,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get options => $state.composableBuilder(
      column: $state.table.options,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get correctAnswer => $state.composableBuilder(
      column: $state.table.correctAnswer,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get index => $state.composableBuilder(
      column: $state.table.index,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get answered => $state.composableBuilder(
      column: $state.table.answered,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastRecievedMillis => $state.composableBuilder(
      column: $state.table.lastRecievedMillis,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SnippetsDataTableOrderingComposer
    extends OrderingComposer<_$AppDb, $SnippetsDataTable> {
  $$SnippetsDataTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get snippetId => $state.composableBuilder(
      column: $state.table.snippetId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get question => $state.composableBuilder(
      column: $state.table.question,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get options => $state.composableBuilder(
      column: $state.table.options,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get correctAnswer => $state.composableBuilder(
      column: $state.table.correctAnswer,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get index => $state.composableBuilder(
      column: $state.table.index,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get answered => $state.composableBuilder(
      column: $state.table.answered,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastRecievedMillis => $state.composableBuilder(
      column: $state.table.lastRecievedMillis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BOTWDataTableTableCreateCompanionBuilder = BOTWDataTableCompanion
    Function({
  Value<int> id,
  required String blank,
  required String status,
  required String answers,
  required String previousAnswers,
  required DateTime week,
  required int lastUpdatedMillis,
});
typedef $$BOTWDataTableTableUpdateCompanionBuilder = BOTWDataTableCompanion
    Function({
  Value<int> id,
  Value<String> blank,
  Value<String> status,
  Value<String> answers,
  Value<String> previousAnswers,
  Value<DateTime> week,
  Value<int> lastUpdatedMillis,
});

class $$BOTWDataTableTableTableManager extends RootTableManager<
    _$AppDb,
    $BOTWDataTableTable,
    BOTWDataTableData,
    $$BOTWDataTableTableFilterComposer,
    $$BOTWDataTableTableOrderingComposer,
    $$BOTWDataTableTableCreateCompanionBuilder,
    $$BOTWDataTableTableUpdateCompanionBuilder> {
  $$BOTWDataTableTableTableManager(_$AppDb db, $BOTWDataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BOTWDataTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BOTWDataTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> blank = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> answers = const Value.absent(),
            Value<String> previousAnswers = const Value.absent(),
            Value<DateTime> week = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
          }) =>
              BOTWDataTableCompanion(
            id: id,
            blank: blank,
            status: status,
            answers: answers,
            previousAnswers: previousAnswers,
            week: week,
            lastUpdatedMillis: lastUpdatedMillis,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String blank,
            required String status,
            required String answers,
            required String previousAnswers,
            required DateTime week,
            required int lastUpdatedMillis,
          }) =>
              BOTWDataTableCompanion.insert(
            id: id,
            blank: blank,
            status: status,
            answers: answers,
            previousAnswers: previousAnswers,
            week: week,
            lastUpdatedMillis: lastUpdatedMillis,
          ),
        ));
}

class $$BOTWDataTableTableFilterComposer
    extends FilterComposer<_$AppDb, $BOTWDataTableTable> {
  $$BOTWDataTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get blank => $state.composableBuilder(
      column: $state.table.blank,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get answers => $state.composableBuilder(
      column: $state.table.answers,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get previousAnswers => $state.composableBuilder(
      column: $state.table.previousAnswers,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get week => $state.composableBuilder(
      column: $state.table.week,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BOTWDataTableTableOrderingComposer
    extends OrderingComposer<_$AppDb, $BOTWDataTableTable> {
  $$BOTWDataTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get blank => $state.composableBuilder(
      column: $state.table.blank,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get answers => $state.composableBuilder(
      column: $state.table.answers,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get previousAnswers => $state.composableBuilder(
      column: $state.table.previousAnswers,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get week => $state.composableBuilder(
      column: $state.table.week,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$UserDataTableTableCreateCompanionBuilder = UserDataTableCompanion
    Function({
  Value<int> id,
  required String FCMToken,
  required String displayName,
  required String BOTWStatus,
  required String description,
  required String discussions,
  required String email,
  required String friends,
  required String friendRequests,
  required String outgoingFriendRequests,
  required String bestFriends,
  required String username,
  required String searchKey,
  required String userId,
  required int lastUpdatedMillis,
  required int votesLeft,
  required int longestStreak,
  required int topBOTW,
  required int triviaPoints,
  required int snippetsRespondedTo,
  required int messagesSent,
  required int discussionsStarted,
  required int streak,
  required String profileStrikes,
  required DateTime streakDate,
});
typedef $$UserDataTableTableUpdateCompanionBuilder = UserDataTableCompanion
    Function({
  Value<int> id,
  Value<String> FCMToken,
  Value<String> displayName,
  Value<String> BOTWStatus,
  Value<String> description,
  Value<String> discussions,
  Value<String> email,
  Value<String> friends,
  Value<String> friendRequests,
  Value<String> outgoingFriendRequests,
  Value<String> bestFriends,
  Value<String> username,
  Value<String> searchKey,
  Value<String> userId,
  Value<int> lastUpdatedMillis,
  Value<int> votesLeft,
  Value<int> longestStreak,
  Value<int> topBOTW,
  Value<int> triviaPoints,
  Value<int> snippetsRespondedTo,
  Value<int> messagesSent,
  Value<int> discussionsStarted,
  Value<int> streak,
  Value<String> profileStrikes,
  Value<DateTime> streakDate,
});

class $$UserDataTableTableTableManager extends RootTableManager<
    _$AppDb,
    $UserDataTableTable,
    UserDataTableData,
    $$UserDataTableTableFilterComposer,
    $$UserDataTableTableOrderingComposer,
    $$UserDataTableTableCreateCompanionBuilder,
    $$UserDataTableTableUpdateCompanionBuilder> {
  $$UserDataTableTableTableManager(_$AppDb db, $UserDataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UserDataTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UserDataTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> FCMToken = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> BOTWStatus = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> discussions = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> friends = const Value.absent(),
            Value<String> friendRequests = const Value.absent(),
            Value<String> outgoingFriendRequests = const Value.absent(),
            Value<String> bestFriends = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> searchKey = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
            Value<int> votesLeft = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<int> topBOTW = const Value.absent(),
            Value<int> triviaPoints = const Value.absent(),
            Value<int> snippetsRespondedTo = const Value.absent(),
            Value<int> messagesSent = const Value.absent(),
            Value<int> discussionsStarted = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<String> profileStrikes = const Value.absent(),
            Value<DateTime> streakDate = const Value.absent(),
          }) =>
              UserDataTableCompanion(
            id: id,
            FCMToken: FCMToken,
            displayName: displayName,
            BOTWStatus: BOTWStatus,
            description: description,
            discussions: discussions,
            email: email,
            friends: friends,
            friendRequests: friendRequests,
            outgoingFriendRequests: outgoingFriendRequests,
            bestFriends: bestFriends,
            username: username,
            searchKey: searchKey,
            userId: userId,
            lastUpdatedMillis: lastUpdatedMillis,
            votesLeft: votesLeft,
            longestStreak: longestStreak,
            topBOTW: topBOTW,
            triviaPoints: triviaPoints,
            snippetsRespondedTo: snippetsRespondedTo,
            messagesSent: messagesSent,
            discussionsStarted: discussionsStarted,
            streak: streak,
            profileStrikes: profileStrikes,
            streakDate: streakDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String FCMToken,
            required String displayName,
            required String BOTWStatus,
            required String description,
            required String discussions,
            required String email,
            required String friends,
            required String friendRequests,
            required String outgoingFriendRequests,
            required String bestFriends,
            required String username,
            required String searchKey,
            required String userId,
            required int lastUpdatedMillis,
            required int votesLeft,
            required int longestStreak,
            required int topBOTW,
            required int triviaPoints,
            required int snippetsRespondedTo,
            required int messagesSent,
            required int discussionsStarted,
            required int streak,
            required String profileStrikes,
            required DateTime streakDate,
          }) =>
              UserDataTableCompanion.insert(
            id: id,
            FCMToken: FCMToken,
            displayName: displayName,
            BOTWStatus: BOTWStatus,
            description: description,
            discussions: discussions,
            email: email,
            friends: friends,
            friendRequests: friendRequests,
            outgoingFriendRequests: outgoingFriendRequests,
            bestFriends: bestFriends,
            username: username,
            searchKey: searchKey,
            userId: userId,
            lastUpdatedMillis: lastUpdatedMillis,
            votesLeft: votesLeft,
            longestStreak: longestStreak,
            topBOTW: topBOTW,
            triviaPoints: triviaPoints,
            snippetsRespondedTo: snippetsRespondedTo,
            messagesSent: messagesSent,
            discussionsStarted: discussionsStarted,
            streak: streak,
            profileStrikes: profileStrikes,
            streakDate: streakDate,
          ),
        ));
}

class $$UserDataTableTableFilterComposer
    extends FilterComposer<_$AppDb, $UserDataTableTable> {
  $$UserDataTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get FCMToken => $state.composableBuilder(
      column: $state.table.FCMToken,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get displayName => $state.composableBuilder(
      column: $state.table.displayName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get BOTWStatus => $state.composableBuilder(
      column: $state.table.BOTWStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get discussions => $state.composableBuilder(
      column: $state.table.discussions,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get friends => $state.composableBuilder(
      column: $state.table.friends,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get friendRequests => $state.composableBuilder(
      column: $state.table.friendRequests,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get outgoingFriendRequests => $state.composableBuilder(
      column: $state.table.outgoingFriendRequests,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bestFriends => $state.composableBuilder(
      column: $state.table.bestFriends,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get searchKey => $state.composableBuilder(
      column: $state.table.searchKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get votesLeft => $state.composableBuilder(
      column: $state.table.votesLeft,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get longestStreak => $state.composableBuilder(
      column: $state.table.longestStreak,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get topBOTW => $state.composableBuilder(
      column: $state.table.topBOTW,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get triviaPoints => $state.composableBuilder(
      column: $state.table.triviaPoints,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get snippetsRespondedTo => $state.composableBuilder(
      column: $state.table.snippetsRespondedTo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get messagesSent => $state.composableBuilder(
      column: $state.table.messagesSent,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get discussionsStarted => $state.composableBuilder(
      column: $state.table.discussionsStarted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get streak => $state.composableBuilder(
      column: $state.table.streak,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get profileStrikes => $state.composableBuilder(
      column: $state.table.profileStrikes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get streakDate => $state.composableBuilder(
      column: $state.table.streakDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$UserDataTableTableOrderingComposer
    extends OrderingComposer<_$AppDb, $UserDataTableTable> {
  $$UserDataTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get FCMToken => $state.composableBuilder(
      column: $state.table.FCMToken,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get displayName => $state.composableBuilder(
      column: $state.table.displayName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get BOTWStatus => $state.composableBuilder(
      column: $state.table.BOTWStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get discussions => $state.composableBuilder(
      column: $state.table.discussions,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get friends => $state.composableBuilder(
      column: $state.table.friends,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get friendRequests => $state.composableBuilder(
      column: $state.table.friendRequests,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get outgoingFriendRequests =>
      $state.composableBuilder(
          column: $state.table.outgoingFriendRequests,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bestFriends => $state.composableBuilder(
      column: $state.table.bestFriends,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get searchKey => $state.composableBuilder(
      column: $state.table.searchKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get votesLeft => $state.composableBuilder(
      column: $state.table.votesLeft,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get longestStreak => $state.composableBuilder(
      column: $state.table.longestStreak,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get topBOTW => $state.composableBuilder(
      column: $state.table.topBOTW,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get triviaPoints => $state.composableBuilder(
      column: $state.table.triviaPoints,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get snippetsRespondedTo => $state.composableBuilder(
      column: $state.table.snippetsRespondedTo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get messagesSent => $state.composableBuilder(
      column: $state.table.messagesSent,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get discussionsStarted => $state.composableBuilder(
      column: $state.table.discussionsStarted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get streak => $state.composableBuilder(
      column: $state.table.streak,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get profileStrikes => $state.composableBuilder(
      column: $state.table.profileStrikes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get streakDate => $state.composableBuilder(
      column: $state.table.streakDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SavedMessagesTableTableCreateCompanionBuilder
    = SavedMessagesTableCompanion Function({
  Value<int> id,
  required String message,
  required String messageId,
  required String senderId,
  required String responseId,
  required String senderUsername,
  required DateTime date,
  required String senderDisplayName,
  required int reports,
  required String reportIds,
});
typedef $$SavedMessagesTableTableUpdateCompanionBuilder
    = SavedMessagesTableCompanion Function({
  Value<int> id,
  Value<String> message,
  Value<String> messageId,
  Value<String> senderId,
  Value<String> responseId,
  Value<String> senderUsername,
  Value<DateTime> date,
  Value<String> senderDisplayName,
  Value<int> reports,
  Value<String> reportIds,
});

class $$SavedMessagesTableTableTableManager extends RootTableManager<
    _$AppDb,
    $SavedMessagesTableTable,
    SavedMessagesTableData,
    $$SavedMessagesTableTableFilterComposer,
    $$SavedMessagesTableTableOrderingComposer,
    $$SavedMessagesTableTableCreateCompanionBuilder,
    $$SavedMessagesTableTableUpdateCompanionBuilder> {
  $$SavedMessagesTableTableTableManager(
      _$AppDb db, $SavedMessagesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SavedMessagesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$SavedMessagesTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<String> senderId = const Value.absent(),
            Value<String> responseId = const Value.absent(),
            Value<String> senderUsername = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> senderDisplayName = const Value.absent(),
            Value<int> reports = const Value.absent(),
            Value<String> reportIds = const Value.absent(),
          }) =>
              SavedMessagesTableCompanion(
            id: id,
            message: message,
            messageId: messageId,
            senderId: senderId,
            responseId: responseId,
            senderUsername: senderUsername,
            date: date,
            senderDisplayName: senderDisplayName,
            reports: reports,
            reportIds: reportIds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String message,
            required String messageId,
            required String senderId,
            required String responseId,
            required String senderUsername,
            required DateTime date,
            required String senderDisplayName,
            required int reports,
            required String reportIds,
          }) =>
              SavedMessagesTableCompanion.insert(
            id: id,
            message: message,
            messageId: messageId,
            senderId: senderId,
            responseId: responseId,
            senderUsername: senderUsername,
            date: date,
            senderDisplayName: senderDisplayName,
            reports: reports,
            reportIds: reportIds,
          ),
        ));
}

class $$SavedMessagesTableTableFilterComposer
    extends FilterComposer<_$AppDb, $SavedMessagesTableTable> {
  $$SavedMessagesTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get messageId => $state.composableBuilder(
      column: $state.table.messageId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get senderId => $state.composableBuilder(
      column: $state.table.senderId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get responseId => $state.composableBuilder(
      column: $state.table.responseId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get senderUsername => $state.composableBuilder(
      column: $state.table.senderUsername,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get senderDisplayName => $state.composableBuilder(
      column: $state.table.senderDisplayName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reports => $state.composableBuilder(
      column: $state.table.reports,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reportIds => $state.composableBuilder(
      column: $state.table.reportIds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SavedMessagesTableTableOrderingComposer
    extends OrderingComposer<_$AppDb, $SavedMessagesTableTable> {
  $$SavedMessagesTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get messageId => $state.composableBuilder(
      column: $state.table.messageId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get senderId => $state.composableBuilder(
      column: $state.table.senderId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get responseId => $state.composableBuilder(
      column: $state.table.responseId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get senderUsername => $state.composableBuilder(
      column: $state.table.senderUsername,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get senderDisplayName => $state.composableBuilder(
      column: $state.table.senderDisplayName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reports => $state.composableBuilder(
      column: $state.table.reports,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reportIds => $state.composableBuilder(
      column: $state.table.reportIds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SavedResponsesTableTableCreateCompanionBuilder
    = SavedResponsesTableCompanion Function({
  Value<int> id,
  required String answer,
  required String question,
  required String responseId,
  required bool isPublic,
  required int lastUpdated,
  required String userId,
});
typedef $$SavedResponsesTableTableUpdateCompanionBuilder
    = SavedResponsesTableCompanion Function({
  Value<int> id,
  Value<String> answer,
  Value<String> question,
  Value<String> responseId,
  Value<bool> isPublic,
  Value<int> lastUpdated,
  Value<String> userId,
});

class $$SavedResponsesTableTableTableManager extends RootTableManager<
    _$AppDb,
    $SavedResponsesTableTable,
    SavedResponsesTableData,
    $$SavedResponsesTableTableFilterComposer,
    $$SavedResponsesTableTableOrderingComposer,
    $$SavedResponsesTableTableCreateCompanionBuilder,
    $$SavedResponsesTableTableUpdateCompanionBuilder> {
  $$SavedResponsesTableTableTableManager(
      _$AppDb db, $SavedResponsesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$SavedResponsesTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$SavedResponsesTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> responseId = const Value.absent(),
            Value<bool> isPublic = const Value.absent(),
            Value<int> lastUpdated = const Value.absent(),
            Value<String> userId = const Value.absent(),
          }) =>
              SavedResponsesTableCompanion(
            id: id,
            answer: answer,
            question: question,
            responseId: responseId,
            isPublic: isPublic,
            lastUpdated: lastUpdated,
            userId: userId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String answer,
            required String question,
            required String responseId,
            required bool isPublic,
            required int lastUpdated,
            required String userId,
          }) =>
              SavedResponsesTableCompanion.insert(
            id: id,
            answer: answer,
            question: question,
            responseId: responseId,
            isPublic: isPublic,
            lastUpdated: lastUpdated,
            userId: userId,
          ),
        ));
}

class $$SavedResponsesTableTableFilterComposer
    extends FilterComposer<_$AppDb, $SavedResponsesTableTable> {
  $$SavedResponsesTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get answer => $state.composableBuilder(
      column: $state.table.answer,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get question => $state.composableBuilder(
      column: $state.table.question,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get responseId => $state.composableBuilder(
      column: $state.table.responseId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isPublic => $state.composableBuilder(
      column: $state.table.isPublic,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SavedResponsesTableTableOrderingComposer
    extends OrderingComposer<_$AppDb, $SavedResponsesTableTable> {
  $$SavedResponsesTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get answer => $state.composableBuilder(
      column: $state.table.answer,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get question => $state.composableBuilder(
      column: $state.table.question,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get responseId => $state.composableBuilder(
      column: $state.table.responseId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isPublic => $state.composableBuilder(
      column: $state.table.isPublic,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$SnipResponsesTableTableManager get snipResponses =>
      $$SnipResponsesTableTableManager(_db, _db.snipResponses);
  $$SnippetsDataTableTableManager get snippetsData =>
      $$SnippetsDataTableTableManager(_db, _db.snippetsData);
  $$BOTWDataTableTableTableManager get bOTWDataTable =>
      $$BOTWDataTableTableTableManager(_db, _db.bOTWDataTable);
  $$UserDataTableTableTableManager get userDataTable =>
      $$UserDataTableTableTableManager(_db, _db.userDataTable);
  $$SavedMessagesTableTableTableManager get savedMessagesTable =>
      $$SavedMessagesTableTableTableManager(_db, _db.savedMessagesTable);
  $$SavedResponsesTableTableTableManager get savedResponsesTable =>
      $$SavedResponsesTableTableTableManager(_db, _db.savedResponsesTable);
}
