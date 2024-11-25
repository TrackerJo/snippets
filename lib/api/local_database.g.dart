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
        lastUpdatedMillis
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
      required this.lastUpdatedMillis});
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
          int? lastUpdatedMillis}) =>
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
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
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
      lastUpdatedMillis);
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
          other.lastUpdatedMillis == this.lastUpdatedMillis);
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
  })  : message = Value(message),
        messageId = Value(messageId),
        senderId = Value(senderId),
        senderUsername = Value(senderUsername),
        date = Value(date),
        senderDisplayName = Value(senderDisplayName),
        readBy = Value(readBy),
        chatId = Value(chatId),
        snippetId = Value(snippetId),
        lastUpdatedMillis = Value(lastUpdatedMillis);
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
      Value<int>? lastUpdatedMillis}) {
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
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
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
  final int lastUpdatedMillis;
  final String discussionUsers;
  const SnipResponse(
      {required this.id,
      required this.answer,
      required this.snippetId,
      required this.displayName,
      required this.date,
      required this.uid,
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
          int? lastUpdatedMillis,
          String? discussionUsers}) =>
      SnipResponse(
        id: id ?? this.id,
        answer: answer ?? this.answer,
        snippetId: snippetId ?? this.snippetId,
        displayName: displayName ?? this.displayName,
        date: date ?? this.date,
        uid: uid ?? this.uid,
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
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('discussionUsers: $discussionUsers')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, answer, snippetId, displayName, date, uid,
      lastUpdatedMillis, discussionUsers);
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
  final Value<int> lastUpdatedMillis;
  final Value<String> discussionUsers;
  const SnipResponsesCompanion({
    this.id = const Value.absent(),
    this.answer = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.date = const Value.absent(),
    this.uid = const Value.absent(),
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
    required int lastUpdatedMillis,
    required String discussionUsers,
  })  : answer = Value(answer),
        snippetId = Value(snippetId),
        displayName = Value(displayName),
        date = Value(date),
        uid = Value(uid),
        lastUpdatedMillis = Value(lastUpdatedMillis),
        discussionUsers = Value(discussionUsers);
  static Insertable<SnipResponse> custom({
    Expression<int>? id,
    Expression<String>? answer,
    Expression<String>? snippetId,
    Expression<String>? displayName,
    Expression<DateTime>? date,
    Expression<String>? uid,
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
      Value<int>? lastUpdatedMillis,
      Value<String>? discussionUsers}) {
    return SnipResponsesCompanion(
      id: id ?? this.id,
      answer: answer ?? this.answer,
      snippetId: snippetId ?? this.snippetId,
      displayName: displayName ?? this.displayName,
      date: date ?? this.date,
      uid: uid ?? this.uid,
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
  final int index;
  final bool answered;
  final String type;
  final int lastUpdatedMillis;
  final int lastRecievedMillis;
  const SnippetsDataData(
      {required this.id,
      required this.snippetId,
      required this.question,
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
          int? index,
          bool? answered,
          String? type,
          int? lastUpdatedMillis,
          int? lastRecievedMillis}) =>
      SnippetsDataData(
        id: id ?? this.id,
        snippetId: snippetId ?? this.snippetId,
        question: question ?? this.question,
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
          ..write('index: $index, ')
          ..write('answered: $answered, ')
          ..write('type: $type, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('lastRecievedMillis: $lastRecievedMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, snippetId, question, index, answered,
      type, lastUpdatedMillis, lastRecievedMillis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnippetsDataData &&
          other.id == this.id &&
          other.snippetId == this.snippetId &&
          other.question == this.question &&
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
  final Value<int> index;
  final Value<bool> answered;
  final Value<String> type;
  final Value<int> lastUpdatedMillis;
  final Value<int> lastRecievedMillis;
  const SnippetsDataCompanion({
    this.id = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.question = const Value.absent(),
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
    required int index,
    required bool answered,
    required String type,
    required int lastUpdatedMillis,
    required int lastRecievedMillis,
  })  : snippetId = Value(snippetId),
        question = Value(question),
        index = Value(index),
        answered = Value(answered),
        type = Value(type),
        lastUpdatedMillis = Value(lastUpdatedMillis),
        lastRecievedMillis = Value(lastRecievedMillis);
  static Insertable<SnippetsDataData> custom({
    Expression<int>? id,
    Expression<String>? snippetId,
    Expression<String>? question,
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
      Value<int>? index,
      Value<bool>? answered,
      Value<String>? type,
      Value<int>? lastUpdatedMillis,
      Value<int>? lastRecievedMillis}) {
    return SnippetsDataCompanion(
      id: id ?? this.id,
      snippetId: snippetId ?? this.snippetId,
      question: question ?? this.question,
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
      [id, blank, status, answers, week, lastUpdatedMillis];
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
  final DateTime week;
  final int lastUpdatedMillis;
  const BOTWDataTableData(
      {required this.id,
      required this.blank,
      required this.status,
      required this.answers,
      required this.week,
      required this.lastUpdatedMillis});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['blank'] = Variable<String>(blank);
    map['status'] = Variable<String>(status);
    map['answers'] = Variable<String>(answers);
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
      'week': serializer.toJson<DateTime>(week),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
    };
  }

  BOTWDataTableData copyWith(
          {int? id,
          String? blank,
          String? status,
          String? answers,
          DateTime? week,
          int? lastUpdatedMillis}) =>
      BOTWDataTableData(
        id: id ?? this.id,
        blank: blank ?? this.blank,
        status: status ?? this.status,
        answers: answers ?? this.answers,
        week: week ?? this.week,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      );
  BOTWDataTableData copyWithCompanion(BOTWDataTableCompanion data) {
    return BOTWDataTableData(
      id: data.id.present ? data.id.value : this.id,
      blank: data.blank.present ? data.blank.value : this.blank,
      status: data.status.present ? data.status.value : this.status,
      answers: data.answers.present ? data.answers.value : this.answers,
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
          ..write('week: $week, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, blank, status, answers, week, lastUpdatedMillis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BOTWDataTableData &&
          other.id == this.id &&
          other.blank == this.blank &&
          other.status == this.status &&
          other.answers == this.answers &&
          other.week == this.week &&
          other.lastUpdatedMillis == this.lastUpdatedMillis);
}

class BOTWDataTableCompanion extends UpdateCompanion<BOTWDataTableData> {
  final Value<int> id;
  final Value<String> blank;
  final Value<String> status;
  final Value<String> answers;
  final Value<DateTime> week;
  final Value<int> lastUpdatedMillis;
  const BOTWDataTableCompanion({
    this.id = const Value.absent(),
    this.blank = const Value.absent(),
    this.status = const Value.absent(),
    this.answers = const Value.absent(),
    this.week = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
  });
  BOTWDataTableCompanion.insert({
    this.id = const Value.absent(),
    required String blank,
    required String status,
    required String answers,
    required DateTime week,
    required int lastUpdatedMillis,
  })  : blank = Value(blank),
        status = Value(status),
        answers = Value(answers),
        week = Value(week),
        lastUpdatedMillis = Value(lastUpdatedMillis);
  static Insertable<BOTWDataTableData> custom({
    Expression<int>? id,
    Expression<String>? blank,
    Expression<String>? status,
    Expression<String>? answers,
    Expression<DateTime>? week,
    Expression<int>? lastUpdatedMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blank != null) 'blank': blank,
      if (status != null) 'status': status,
      if (answers != null) 'answers': answers,
      if (week != null) 'week': week,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
    });
  }

  BOTWDataTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? blank,
      Value<String>? status,
      Value<String>? answers,
      Value<DateTime>? week,
      Value<int>? lastUpdatedMillis}) {
    return BOTWDataTableCompanion(
      id: id ?? this.id,
      blank: blank ?? this.blank,
      status: status ?? this.status,
      answers: answers ?? this.answers,
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
        username,
        searchKey,
        userId,
        lastUpdatedMillis,
        votesLeft,
        snippetsRespondedTo,
        messagesSent,
        discussionsStarted
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
      snippetsRespondedTo: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}snippets_responded_to'])!,
      messagesSent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}messages_sent'])!,
      discussionsStarted: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}discussions_started'])!,
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
  final String username;
  final String searchKey;
  final String userId;
  final int lastUpdatedMillis;
  final int votesLeft;
  final int snippetsRespondedTo;
  final int messagesSent;
  final int discussionsStarted;
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
      required this.username,
      required this.searchKey,
      required this.userId,
      required this.lastUpdatedMillis,
      required this.votesLeft,
      required this.snippetsRespondedTo,
      required this.messagesSent,
      required this.discussionsStarted});
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
    map['username'] = Variable<String>(username);
    map['search_key'] = Variable<String>(searchKey);
    map['user_id'] = Variable<String>(userId);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    map['votes_left'] = Variable<int>(votesLeft);
    map['snippets_responded_to'] = Variable<int>(snippetsRespondedTo);
    map['messages_sent'] = Variable<int>(messagesSent);
    map['discussions_started'] = Variable<int>(discussionsStarted);
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
      username: Value(username),
      searchKey: Value(searchKey),
      userId: Value(userId),
      lastUpdatedMillis: Value(lastUpdatedMillis),
      votesLeft: Value(votesLeft),
      snippetsRespondedTo: Value(snippetsRespondedTo),
      messagesSent: Value(messagesSent),
      discussionsStarted: Value(discussionsStarted),
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
      username: serializer.fromJson<String>(json['username']),
      searchKey: serializer.fromJson<String>(json['searchKey']),
      userId: serializer.fromJson<String>(json['userId']),
      lastUpdatedMillis: serializer.fromJson<int>(json['lastUpdatedMillis']),
      votesLeft: serializer.fromJson<int>(json['votesLeft']),
      snippetsRespondedTo:
          serializer.fromJson<int>(json['snippetsRespondedTo']),
      messagesSent: serializer.fromJson<int>(json['messagesSent']),
      discussionsStarted: serializer.fromJson<int>(json['discussionsStarted']),
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
      'username': serializer.toJson<String>(username),
      'searchKey': serializer.toJson<String>(searchKey),
      'userId': serializer.toJson<String>(userId),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
      'votesLeft': serializer.toJson<int>(votesLeft),
      'snippetsRespondedTo': serializer.toJson<int>(snippetsRespondedTo),
      'messagesSent': serializer.toJson<int>(messagesSent),
      'discussionsStarted': serializer.toJson<int>(discussionsStarted),
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
          String? username,
          String? searchKey,
          String? userId,
          int? lastUpdatedMillis,
          int? votesLeft,
          int? snippetsRespondedTo,
          int? messagesSent,
          int? discussionsStarted}) =>
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
        username: username ?? this.username,
        searchKey: searchKey ?? this.searchKey,
        userId: userId ?? this.userId,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
        votesLeft: votesLeft ?? this.votesLeft,
        snippetsRespondedTo: snippetsRespondedTo ?? this.snippetsRespondedTo,
        messagesSent: messagesSent ?? this.messagesSent,
        discussionsStarted: discussionsStarted ?? this.discussionsStarted,
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
      username: data.username.present ? data.username.value : this.username,
      searchKey: data.searchKey.present ? data.searchKey.value : this.searchKey,
      userId: data.userId.present ? data.userId.value : this.userId,
      lastUpdatedMillis: data.lastUpdatedMillis.present
          ? data.lastUpdatedMillis.value
          : this.lastUpdatedMillis,
      votesLeft: data.votesLeft.present ? data.votesLeft.value : this.votesLeft,
      snippetsRespondedTo: data.snippetsRespondedTo.present
          ? data.snippetsRespondedTo.value
          : this.snippetsRespondedTo,
      messagesSent: data.messagesSent.present
          ? data.messagesSent.value
          : this.messagesSent,
      discussionsStarted: data.discussionsStarted.present
          ? data.discussionsStarted.value
          : this.discussionsStarted,
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
          ..write('username: $username, ')
          ..write('searchKey: $searchKey, ')
          ..write('userId: $userId, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('votesLeft: $votesLeft, ')
          ..write('snippetsRespondedTo: $snippetsRespondedTo, ')
          ..write('messagesSent: $messagesSent, ')
          ..write('discussionsStarted: $discussionsStarted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
      username,
      searchKey,
      userId,
      lastUpdatedMillis,
      votesLeft,
      snippetsRespondedTo,
      messagesSent,
      discussionsStarted);
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
          other.username == this.username &&
          other.searchKey == this.searchKey &&
          other.userId == this.userId &&
          other.lastUpdatedMillis == this.lastUpdatedMillis &&
          other.votesLeft == this.votesLeft &&
          other.snippetsRespondedTo == this.snippetsRespondedTo &&
          other.messagesSent == this.messagesSent &&
          other.discussionsStarted == this.discussionsStarted);
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
  final Value<String> username;
  final Value<String> searchKey;
  final Value<String> userId;
  final Value<int> lastUpdatedMillis;
  final Value<int> votesLeft;
  final Value<int> snippetsRespondedTo;
  final Value<int> messagesSent;
  final Value<int> discussionsStarted;
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
    this.username = const Value.absent(),
    this.searchKey = const Value.absent(),
    this.userId = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
    this.votesLeft = const Value.absent(),
    this.snippetsRespondedTo = const Value.absent(),
    this.messagesSent = const Value.absent(),
    this.discussionsStarted = const Value.absent(),
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
    required String username,
    required String searchKey,
    required String userId,
    required int lastUpdatedMillis,
    required int votesLeft,
    required int snippetsRespondedTo,
    required int messagesSent,
    required int discussionsStarted,
  })  : FCMToken = Value(FCMToken),
        displayName = Value(displayName),
        BOTWStatus = Value(BOTWStatus),
        description = Value(description),
        discussions = Value(discussions),
        email = Value(email),
        friends = Value(friends),
        friendRequests = Value(friendRequests),
        outgoingFriendRequests = Value(outgoingFriendRequests),
        username = Value(username),
        searchKey = Value(searchKey),
        userId = Value(userId),
        lastUpdatedMillis = Value(lastUpdatedMillis),
        votesLeft = Value(votesLeft),
        snippetsRespondedTo = Value(snippetsRespondedTo),
        messagesSent = Value(messagesSent),
        discussionsStarted = Value(discussionsStarted);
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
    Expression<String>? username,
    Expression<String>? searchKey,
    Expression<String>? userId,
    Expression<int>? lastUpdatedMillis,
    Expression<int>? votesLeft,
    Expression<int>? snippetsRespondedTo,
    Expression<int>? messagesSent,
    Expression<int>? discussionsStarted,
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
      if (username != null) 'username': username,
      if (searchKey != null) 'search_key': searchKey,
      if (userId != null) 'user_id': userId,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
      if (votesLeft != null) 'votes_left': votesLeft,
      if (snippetsRespondedTo != null)
        'snippets_responded_to': snippetsRespondedTo,
      if (messagesSent != null) 'messages_sent': messagesSent,
      if (discussionsStarted != null) 'discussions_started': discussionsStarted,
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
      Value<String>? username,
      Value<String>? searchKey,
      Value<String>? userId,
      Value<int>? lastUpdatedMillis,
      Value<int>? votesLeft,
      Value<int>? snippetsRespondedTo,
      Value<int>? messagesSent,
      Value<int>? discussionsStarted}) {
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
      username: username ?? this.username,
      searchKey: searchKey ?? this.searchKey,
      userId: userId ?? this.userId,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      votesLeft: votesLeft ?? this.votesLeft,
      snippetsRespondedTo: snippetsRespondedTo ?? this.snippetsRespondedTo,
      messagesSent: messagesSent ?? this.messagesSent,
      discussionsStarted: discussionsStarted ?? this.discussionsStarted,
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
    if (snippetsRespondedTo.present) {
      map['snippets_responded_to'] = Variable<int>(snippetsRespondedTo.value);
    }
    if (messagesSent.present) {
      map['messages_sent'] = Variable<int>(messagesSent.value);
    }
    if (discussionsStarted.present) {
      map['discussions_started'] = Variable<int>(discussionsStarted.value);
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
          ..write('username: $username, ')
          ..write('searchKey: $searchKey, ')
          ..write('userId: $userId, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('votesLeft: $votesLeft, ')
          ..write('snippetsRespondedTo: $snippetsRespondedTo, ')
          ..write('messagesSent: $messagesSent, ')
          ..write('discussionsStarted: $discussionsStarted')
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [chats, snipResponses, snippetsData, bOTWDataTable, userDataTable];
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
}

typedef $$SnipResponsesTableCreateCompanionBuilder = SnipResponsesCompanion
    Function({
  Value<int> id,
  required String answer,
  required String snippetId,
  required String displayName,
  required DateTime date,
  required String uid,
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
  required DateTime week,
  required int lastUpdatedMillis,
});
typedef $$BOTWDataTableTableUpdateCompanionBuilder = BOTWDataTableCompanion
    Function({
  Value<int> id,
  Value<String> blank,
  Value<String> status,
  Value<String> answers,
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
            Value<DateTime> week = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
          }) =>
              BOTWDataTableCompanion(
            id: id,
            blank: blank,
            status: status,
            answers: answers,
            week: week,
            lastUpdatedMillis: lastUpdatedMillis,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String blank,
            required String status,
            required String answers,
            required DateTime week,
            required int lastUpdatedMillis,
          }) =>
              BOTWDataTableCompanion.insert(
            id: id,
            blank: blank,
            status: status,
            answers: answers,
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
  required String username,
  required String searchKey,
  required String userId,
  required int lastUpdatedMillis,
  required int votesLeft,
  required int snippetsRespondedTo,
  required int messagesSent,
  required int discussionsStarted,
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
  Value<String> username,
  Value<String> searchKey,
  Value<String> userId,
  Value<int> lastUpdatedMillis,
  Value<int> votesLeft,
  Value<int> snippetsRespondedTo,
  Value<int> messagesSent,
  Value<int> discussionsStarted,
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
            Value<String> username = const Value.absent(),
            Value<String> searchKey = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
            Value<int> votesLeft = const Value.absent(),
            Value<int> snippetsRespondedTo = const Value.absent(),
            Value<int> messagesSent = const Value.absent(),
            Value<int> discussionsStarted = const Value.absent(),
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
            username: username,
            searchKey: searchKey,
            userId: userId,
            lastUpdatedMillis: lastUpdatedMillis,
            votesLeft: votesLeft,
            snippetsRespondedTo: snippetsRespondedTo,
            messagesSent: messagesSent,
            discussionsStarted: discussionsStarted,
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
            required String username,
            required String searchKey,
            required String userId,
            required int lastUpdatedMillis,
            required int votesLeft,
            required int snippetsRespondedTo,
            required int messagesSent,
            required int discussionsStarted,
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
            username: username,
            searchKey: searchKey,
            userId: userId,
            lastUpdatedMillis: lastUpdatedMillis,
            votesLeft: votesLeft,
            snippetsRespondedTo: snippetsRespondedTo,
            messagesSent: messagesSent,
            discussionsStarted: discussionsStarted,
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
}
