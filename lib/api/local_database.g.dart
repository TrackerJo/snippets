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
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
      'uid', aliasedName, false,
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
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMillisMeta =
      const VerificationMeta('lastUpdatedMillis');
  @override
  late final GeneratedColumn<int> lastUpdatedMillis = GeneratedColumn<int>(
      'last_updated_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        answer,
        snippetId,
        uid,
        displayName,
        date,
        lastUpdated,
        lastUpdatedMillis
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
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
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
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
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
  SnipResponse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnipResponse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      snippetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snippet_id'])!,
      uid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uid'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      lastUpdatedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_millis'])!,
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
  final String uid;
  final String displayName;
  final DateTime date;
  final DateTime lastUpdated;
  final int lastUpdatedMillis;
  const SnipResponse(
      {required this.id,
      required this.answer,
      required this.snippetId,
      required this.uid,
      required this.displayName,
      required this.date,
      required this.lastUpdated,
      required this.lastUpdatedMillis});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['answer'] = Variable<String>(answer);
    map['snippet_id'] = Variable<String>(snippetId);
    map['uid'] = Variable<String>(uid);
    map['display_name'] = Variable<String>(displayName);
    map['date'] = Variable<DateTime>(date);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    return map;
  }

  SnipResponsesCompanion toCompanion(bool nullToAbsent) {
    return SnipResponsesCompanion(
      id: Value(id),
      answer: Value(answer),
      snippetId: Value(snippetId),
      uid: Value(uid),
      displayName: Value(displayName),
      date: Value(date),
      lastUpdated: Value(lastUpdated),
      lastUpdatedMillis: Value(lastUpdatedMillis),
    );
  }

  factory SnipResponse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnipResponse(
      id: serializer.fromJson<int>(json['id']),
      answer: serializer.fromJson<String>(json['answer']),
      snippetId: serializer.fromJson<String>(json['snippetId']),
      uid: serializer.fromJson<String>(json['uid']),
      displayName: serializer.fromJson<String>(json['displayName']),
      date: serializer.fromJson<DateTime>(json['date']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      lastUpdatedMillis: serializer.fromJson<int>(json['lastUpdatedMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'answer': serializer.toJson<String>(answer),
      'snippetId': serializer.toJson<String>(snippetId),
      'uid': serializer.toJson<String>(uid),
      'displayName': serializer.toJson<String>(displayName),
      'date': serializer.toJson<DateTime>(date),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
    };
  }

  SnipResponse copyWith(
          {int? id,
          String? answer,
          String? snippetId,
          String? uid,
          String? displayName,
          DateTime? date,
          DateTime? lastUpdated,
          int? lastUpdatedMillis}) =>
      SnipResponse(
        id: id ?? this.id,
        answer: answer ?? this.answer,
        snippetId: snippetId ?? this.snippetId,
        uid: uid ?? this.uid,
        displayName: displayName ?? this.displayName,
        date: date ?? this.date,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      );
  SnipResponse copyWithCompanion(SnipResponsesCompanion data) {
    return SnipResponse(
      id: data.id.present ? data.id.value : this.id,
      answer: data.answer.present ? data.answer.value : this.answer,
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      uid: data.uid.present ? data.uid.value : this.uid,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      date: data.date.present ? data.date.value : this.date,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      lastUpdatedMillis: data.lastUpdatedMillis.present
          ? data.lastUpdatedMillis.value
          : this.lastUpdatedMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnipResponse(')
          ..write('id: $id, ')
          ..write('answer: $answer, ')
          ..write('snippetId: $snippetId, ')
          ..write('uid: $uid, ')
          ..write('displayName: $displayName, ')
          ..write('date: $date, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, answer, snippetId, uid, displayName, date,
      lastUpdated, lastUpdatedMillis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnipResponse &&
          other.id == this.id &&
          other.answer == this.answer &&
          other.snippetId == this.snippetId &&
          other.uid == this.uid &&
          other.displayName == this.displayName &&
          other.date == this.date &&
          other.lastUpdated == this.lastUpdated &&
          other.lastUpdatedMillis == this.lastUpdatedMillis);
}

class SnipResponsesCompanion extends UpdateCompanion<SnipResponse> {
  final Value<int> id;
  final Value<String> answer;
  final Value<String> snippetId;
  final Value<String> uid;
  final Value<String> displayName;
  final Value<DateTime> date;
  final Value<DateTime> lastUpdated;
  final Value<int> lastUpdatedMillis;
  const SnipResponsesCompanion({
    this.id = const Value.absent(),
    this.answer = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.uid = const Value.absent(),
    this.displayName = const Value.absent(),
    this.date = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
  });
  SnipResponsesCompanion.insert({
    this.id = const Value.absent(),
    required String answer,
    required String snippetId,
    required String uid,
    required String displayName,
    required DateTime date,
    required DateTime lastUpdated,
    required int lastUpdatedMillis,
  })  : answer = Value(answer),
        snippetId = Value(snippetId),
        uid = Value(uid),
        displayName = Value(displayName),
        date = Value(date),
        lastUpdated = Value(lastUpdated),
        lastUpdatedMillis = Value(lastUpdatedMillis);
  static Insertable<SnipResponse> custom({
    Expression<int>? id,
    Expression<String>? answer,
    Expression<String>? snippetId,
    Expression<String>? uid,
    Expression<String>? displayName,
    Expression<DateTime>? date,
    Expression<DateTime>? lastUpdated,
    Expression<int>? lastUpdatedMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (answer != null) 'answer': answer,
      if (snippetId != null) 'snippet_id': snippetId,
      if (uid != null) 'uid': uid,
      if (displayName != null) 'display_name': displayName,
      if (date != null) 'date': date,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
    });
  }

  SnipResponsesCompanion copyWith(
      {Value<int>? id,
      Value<String>? answer,
      Value<String>? snippetId,
      Value<String>? uid,
      Value<String>? displayName,
      Value<DateTime>? date,
      Value<DateTime>? lastUpdated,
      Value<int>? lastUpdatedMillis}) {
    return SnipResponsesCompanion(
      id: id ?? this.id,
      answer: answer ?? this.answer,
      snippetId: snippetId ?? this.snippetId,
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      date: date ?? this.date,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
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
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (lastUpdatedMillis.present) {
      map['last_updated_millis'] = Variable<int>(lastUpdatedMillis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnipResponsesCompanion(')
          ..write('id: $id, ')
          ..write('answer: $answer, ')
          ..write('snippetId: $snippetId, ')
          ..write('uid: $uid, ')
          ..write('displayName: $displayName, ')
          ..write('date: $date, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
          ..write(')'))
        .toString();
  }
}

class $SnippetsTable extends Snippets with TableInfo<$SnippetsTable, Snippet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _lastRecievedMeta =
      const VerificationMeta('lastRecieved');
  @override
  late final GeneratedColumn<DateTime> lastRecieved = GeneratedColumn<DateTime>(
      'last_recieved', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
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
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
      'theme', aliasedName, false,
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
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
      'uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
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
        lastRecieved,
        snippetId,
        question,
        theme,
        index,
        answered,
        uid,
        type,
        lastUpdated,
        lastUpdatedMillis,
        lastRecievedMillis
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets';
  @override
  VerificationContext validateIntegrity(Insertable<Snippet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_recieved')) {
      context.handle(
          _lastRecievedMeta,
          lastRecieved.isAcceptableOrUnknown(
              data['last_recieved']!, _lastRecievedMeta));
    } else if (isInserting) {
      context.missing(_lastRecievedMeta);
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
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    } else if (isInserting) {
      context.missing(_themeMeta);
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
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
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
  Snippet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snippet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lastRecieved: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_recieved'])!,
      snippetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snippet_id'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      answered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}answered'])!,
      uid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uid'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      lastUpdatedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_millis'])!,
      lastRecievedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_recieved_millis'])!,
    );
  }

  @override
  $SnippetsTable createAlias(String alias) {
    return $SnippetsTable(attachedDatabase, alias);
  }
}

class Snippet extends DataClass implements Insertable<Snippet> {
  final int id;
  final DateTime lastRecieved;
  final String snippetId;
  final String question;
  final String theme;
  final int index;
  final bool answered;
  final String uid;
  final String type;
  final DateTime lastUpdated;
  final int lastUpdatedMillis;
  final int lastRecievedMillis;
  const Snippet(
      {required this.id,
      required this.lastRecieved,
      required this.snippetId,
      required this.question,
      required this.theme,
      required this.index,
      required this.answered,
      required this.uid,
      required this.type,
      required this.lastUpdated,
      required this.lastUpdatedMillis,
      required this.lastRecievedMillis});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['last_recieved'] = Variable<DateTime>(lastRecieved);
    map['snippet_id'] = Variable<String>(snippetId);
    map['question'] = Variable<String>(question);
    map['theme'] = Variable<String>(theme);
    map['index'] = Variable<int>(index);
    map['answered'] = Variable<bool>(answered);
    map['uid'] = Variable<String>(uid);
    map['type'] = Variable<String>(type);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    map['last_recieved_millis'] = Variable<int>(lastRecievedMillis);
    return map;
  }

  SnippetsCompanion toCompanion(bool nullToAbsent) {
    return SnippetsCompanion(
      id: Value(id),
      lastRecieved: Value(lastRecieved),
      snippetId: Value(snippetId),
      question: Value(question),
      theme: Value(theme),
      index: Value(index),
      answered: Value(answered),
      uid: Value(uid),
      type: Value(type),
      lastUpdated: Value(lastUpdated),
      lastUpdatedMillis: Value(lastUpdatedMillis),
      lastRecievedMillis: Value(lastRecievedMillis),
    );
  }

  factory Snippet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snippet(
      id: serializer.fromJson<int>(json['id']),
      lastRecieved: serializer.fromJson<DateTime>(json['lastRecieved']),
      snippetId: serializer.fromJson<String>(json['snippetId']),
      question: serializer.fromJson<String>(json['question']),
      theme: serializer.fromJson<String>(json['theme']),
      index: serializer.fromJson<int>(json['index']),
      answered: serializer.fromJson<bool>(json['answered']),
      uid: serializer.fromJson<String>(json['uid']),
      type: serializer.fromJson<String>(json['type']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      lastUpdatedMillis: serializer.fromJson<int>(json['lastUpdatedMillis']),
      lastRecievedMillis: serializer.fromJson<int>(json['lastRecievedMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastRecieved': serializer.toJson<DateTime>(lastRecieved),
      'snippetId': serializer.toJson<String>(snippetId),
      'question': serializer.toJson<String>(question),
      'theme': serializer.toJson<String>(theme),
      'index': serializer.toJson<int>(index),
      'answered': serializer.toJson<bool>(answered),
      'uid': serializer.toJson<String>(uid),
      'type': serializer.toJson<String>(type),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
      'lastRecievedMillis': serializer.toJson<int>(lastRecievedMillis),
    };
  }

  Snippet copyWith(
          {int? id,
          DateTime? lastRecieved,
          String? snippetId,
          String? question,
          String? theme,
          int? index,
          bool? answered,
          String? uid,
          String? type,
          DateTime? lastUpdated,
          int? lastUpdatedMillis,
          int? lastRecievedMillis}) =>
      Snippet(
        id: id ?? this.id,
        lastRecieved: lastRecieved ?? this.lastRecieved,
        snippetId: snippetId ?? this.snippetId,
        question: question ?? this.question,
        theme: theme ?? this.theme,
        index: index ?? this.index,
        answered: answered ?? this.answered,
        uid: uid ?? this.uid,
        type: type ?? this.type,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
        lastRecievedMillis: lastRecievedMillis ?? this.lastRecievedMillis,
      );
  Snippet copyWithCompanion(SnippetsCompanion data) {
    return Snippet(
      id: data.id.present ? data.id.value : this.id,
      lastRecieved: data.lastRecieved.present
          ? data.lastRecieved.value
          : this.lastRecieved,
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      question: data.question.present ? data.question.value : this.question,
      theme: data.theme.present ? data.theme.value : this.theme,
      index: data.index.present ? data.index.value : this.index,
      answered: data.answered.present ? data.answered.value : this.answered,
      uid: data.uid.present ? data.uid.value : this.uid,
      type: data.type.present ? data.type.value : this.type,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
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
    return (StringBuffer('Snippet(')
          ..write('id: $id, ')
          ..write('lastRecieved: $lastRecieved, ')
          ..write('snippetId: $snippetId, ')
          ..write('question: $question, ')
          ..write('theme: $theme, ')
          ..write('index: $index, ')
          ..write('answered: $answered, ')
          ..write('uid: $uid, ')
          ..write('type: $type, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('lastRecievedMillis: $lastRecievedMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      lastRecieved,
      snippetId,
      question,
      theme,
      index,
      answered,
      uid,
      type,
      lastUpdated,
      lastUpdatedMillis,
      lastRecievedMillis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snippet &&
          other.id == this.id &&
          other.lastRecieved == this.lastRecieved &&
          other.snippetId == this.snippetId &&
          other.question == this.question &&
          other.theme == this.theme &&
          other.index == this.index &&
          other.answered == this.answered &&
          other.uid == this.uid &&
          other.type == this.type &&
          other.lastUpdated == this.lastUpdated &&
          other.lastUpdatedMillis == this.lastUpdatedMillis &&
          other.lastRecievedMillis == this.lastRecievedMillis);
}

class SnippetsCompanion extends UpdateCompanion<Snippet> {
  final Value<int> id;
  final Value<DateTime> lastRecieved;
  final Value<String> snippetId;
  final Value<String> question;
  final Value<String> theme;
  final Value<int> index;
  final Value<bool> answered;
  final Value<String> uid;
  final Value<String> type;
  final Value<DateTime> lastUpdated;
  final Value<int> lastUpdatedMillis;
  final Value<int> lastRecievedMillis;
  const SnippetsCompanion({
    this.id = const Value.absent(),
    this.lastRecieved = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.question = const Value.absent(),
    this.theme = const Value.absent(),
    this.index = const Value.absent(),
    this.answered = const Value.absent(),
    this.uid = const Value.absent(),
    this.type = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
    this.lastRecievedMillis = const Value.absent(),
  });
  SnippetsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime lastRecieved,
    required String snippetId,
    required String question,
    required String theme,
    required int index,
    required bool answered,
    required String uid,
    required String type,
    required DateTime lastUpdated,
    required int lastUpdatedMillis,
    required int lastRecievedMillis,
  })  : lastRecieved = Value(lastRecieved),
        snippetId = Value(snippetId),
        question = Value(question),
        theme = Value(theme),
        index = Value(index),
        answered = Value(answered),
        uid = Value(uid),
        type = Value(type),
        lastUpdated = Value(lastUpdated),
        lastUpdatedMillis = Value(lastUpdatedMillis),
        lastRecievedMillis = Value(lastRecievedMillis);
  static Insertable<Snippet> custom({
    Expression<int>? id,
    Expression<DateTime>? lastRecieved,
    Expression<String>? snippetId,
    Expression<String>? question,
    Expression<String>? theme,
    Expression<int>? index,
    Expression<bool>? answered,
    Expression<String>? uid,
    Expression<String>? type,
    Expression<DateTime>? lastUpdated,
    Expression<int>? lastUpdatedMillis,
    Expression<int>? lastRecievedMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastRecieved != null) 'last_recieved': lastRecieved,
      if (snippetId != null) 'snippet_id': snippetId,
      if (question != null) 'question': question,
      if (theme != null) 'theme': theme,
      if (index != null) 'index': index,
      if (answered != null) 'answered': answered,
      if (uid != null) 'uid': uid,
      if (type != null) 'type': type,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
      if (lastRecievedMillis != null)
        'last_recieved_millis': lastRecievedMillis,
    });
  }

  SnippetsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? lastRecieved,
      Value<String>? snippetId,
      Value<String>? question,
      Value<String>? theme,
      Value<int>? index,
      Value<bool>? answered,
      Value<String>? uid,
      Value<String>? type,
      Value<DateTime>? lastUpdated,
      Value<int>? lastUpdatedMillis,
      Value<int>? lastRecievedMillis}) {
    return SnippetsCompanion(
      id: id ?? this.id,
      lastRecieved: lastRecieved ?? this.lastRecieved,
      snippetId: snippetId ?? this.snippetId,
      question: question ?? this.question,
      theme: theme ?? this.theme,
      index: index ?? this.index,
      answered: answered ?? this.answered,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      lastUpdated: lastUpdated ?? this.lastUpdated,
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
    if (lastRecieved.present) {
      map['last_recieved'] = Variable<DateTime>(lastRecieved.value);
    }
    if (snippetId.present) {
      map['snippet_id'] = Variable<String>(snippetId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (answered.present) {
      map['answered'] = Variable<bool>(answered.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
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
    return (StringBuffer('SnippetsCompanion(')
          ..write('id: $id, ')
          ..write('lastRecieved: $lastRecieved, ')
          ..write('snippetId: $snippetId, ')
          ..write('question: $question, ')
          ..write('theme: $theme, ')
          ..write('index: $index, ')
          ..write('answered: $answered, ')
          ..write('uid: $uid, ')
          ..write('type: $type, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis, ')
          ..write('lastRecievedMillis: $lastRecievedMillis')
          ..write(')'))
        .toString();
  }
}

class $BOTWTable extends BOTW with TableInfo<$BOTWTable, BOTWData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BOTWTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
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
      [id, blank, status, answers, lastUpdated, week, lastUpdatedMillis];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'botw';
  @override
  VerificationContext validateIntegrity(Insertable<BOTWData> instance,
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
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
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
  BOTWData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BOTWData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      blank: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blank'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      answers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answers'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      week: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}week'])!,
      lastUpdatedMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_updated_millis'])!,
    );
  }

  @override
  $BOTWTable createAlias(String alias) {
    return $BOTWTable(attachedDatabase, alias);
  }
}

class BOTWData extends DataClass implements Insertable<BOTWData> {
  final int id;
  final String blank;
  final String status;
  final String answers;
  final DateTime lastUpdated;
  final DateTime week;
  final int lastUpdatedMillis;
  const BOTWData(
      {required this.id,
      required this.blank,
      required this.status,
      required this.answers,
      required this.lastUpdated,
      required this.week,
      required this.lastUpdatedMillis});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['blank'] = Variable<String>(blank);
    map['status'] = Variable<String>(status);
    map['answers'] = Variable<String>(answers);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['week'] = Variable<DateTime>(week);
    map['last_updated_millis'] = Variable<int>(lastUpdatedMillis);
    return map;
  }

  BOTWCompanion toCompanion(bool nullToAbsent) {
    return BOTWCompanion(
      id: Value(id),
      blank: Value(blank),
      status: Value(status),
      answers: Value(answers),
      lastUpdated: Value(lastUpdated),
      week: Value(week),
      lastUpdatedMillis: Value(lastUpdatedMillis),
    );
  }

  factory BOTWData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BOTWData(
      id: serializer.fromJson<int>(json['id']),
      blank: serializer.fromJson<String>(json['blank']),
      status: serializer.fromJson<String>(json['status']),
      answers: serializer.fromJson<String>(json['answers']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
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
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'week': serializer.toJson<DateTime>(week),
      'lastUpdatedMillis': serializer.toJson<int>(lastUpdatedMillis),
    };
  }

  BOTWData copyWith(
          {int? id,
          String? blank,
          String? status,
          String? answers,
          DateTime? lastUpdated,
          DateTime? week,
          int? lastUpdatedMillis}) =>
      BOTWData(
        id: id ?? this.id,
        blank: blank ?? this.blank,
        status: status ?? this.status,
        answers: answers ?? this.answers,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        week: week ?? this.week,
        lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
      );
  BOTWData copyWithCompanion(BOTWCompanion data) {
    return BOTWData(
      id: data.id.present ? data.id.value : this.id,
      blank: data.blank.present ? data.blank.value : this.blank,
      status: data.status.present ? data.status.value : this.status,
      answers: data.answers.present ? data.answers.value : this.answers,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      week: data.week.present ? data.week.value : this.week,
      lastUpdatedMillis: data.lastUpdatedMillis.present
          ? data.lastUpdatedMillis.value
          : this.lastUpdatedMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BOTWData(')
          ..write('id: $id, ')
          ..write('blank: $blank, ')
          ..write('status: $status, ')
          ..write('answers: $answers, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('week: $week, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, blank, status, answers, lastUpdated, week, lastUpdatedMillis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BOTWData &&
          other.id == this.id &&
          other.blank == this.blank &&
          other.status == this.status &&
          other.answers == this.answers &&
          other.lastUpdated == this.lastUpdated &&
          other.week == this.week &&
          other.lastUpdatedMillis == this.lastUpdatedMillis);
}

class BOTWCompanion extends UpdateCompanion<BOTWData> {
  final Value<int> id;
  final Value<String> blank;
  final Value<String> status;
  final Value<String> answers;
  final Value<DateTime> lastUpdated;
  final Value<DateTime> week;
  final Value<int> lastUpdatedMillis;
  const BOTWCompanion({
    this.id = const Value.absent(),
    this.blank = const Value.absent(),
    this.status = const Value.absent(),
    this.answers = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.week = const Value.absent(),
    this.lastUpdatedMillis = const Value.absent(),
  });
  BOTWCompanion.insert({
    this.id = const Value.absent(),
    required String blank,
    required String status,
    required String answers,
    required DateTime lastUpdated,
    required DateTime week,
    required int lastUpdatedMillis,
  })  : blank = Value(blank),
        status = Value(status),
        answers = Value(answers),
        lastUpdated = Value(lastUpdated),
        week = Value(week),
        lastUpdatedMillis = Value(lastUpdatedMillis);
  static Insertable<BOTWData> custom({
    Expression<int>? id,
    Expression<String>? blank,
    Expression<String>? status,
    Expression<String>? answers,
    Expression<DateTime>? lastUpdated,
    Expression<DateTime>? week,
    Expression<int>? lastUpdatedMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blank != null) 'blank': blank,
      if (status != null) 'status': status,
      if (answers != null) 'answers': answers,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (week != null) 'week': week,
      if (lastUpdatedMillis != null) 'last_updated_millis': lastUpdatedMillis,
    });
  }

  BOTWCompanion copyWith(
      {Value<int>? id,
      Value<String>? blank,
      Value<String>? status,
      Value<String>? answers,
      Value<DateTime>? lastUpdated,
      Value<DateTime>? week,
      Value<int>? lastUpdatedMillis}) {
    return BOTWCompanion(
      id: id ?? this.id,
      blank: blank ?? this.blank,
      status: status ?? this.status,
      answers: answers ?? this.answers,
      lastUpdated: lastUpdated ?? this.lastUpdated,
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
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
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
    return (StringBuffer('BOTWCompanion(')
          ..write('id: $id, ')
          ..write('blank: $blank, ')
          ..write('status: $status, ')
          ..write('answers: $answers, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('week: $week, ')
          ..write('lastUpdatedMillis: $lastUpdatedMillis')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $SnipResponsesTable snipResponses = $SnipResponsesTable(this);
  late final $SnippetsTable snippets = $SnippetsTable(this);
  late final $BOTWTable botw = $BOTWTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [chats, snipResponses, snippets, botw];
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
  required String uid,
  required String displayName,
  required DateTime date,
  required DateTime lastUpdated,
  required int lastUpdatedMillis,
});
typedef $$SnipResponsesTableUpdateCompanionBuilder = SnipResponsesCompanion
    Function({
  Value<int> id,
  Value<String> answer,
  Value<String> snippetId,
  Value<String> uid,
  Value<String> displayName,
  Value<DateTime> date,
  Value<DateTime> lastUpdated,
  Value<int> lastUpdatedMillis,
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
            Value<String> uid = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
          }) =>
              SnipResponsesCompanion(
            id: id,
            answer: answer,
            snippetId: snippetId,
            uid: uid,
            displayName: displayName,
            date: date,
            lastUpdated: lastUpdated,
            lastUpdatedMillis: lastUpdatedMillis,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String answer,
            required String snippetId,
            required String uid,
            required String displayName,
            required DateTime date,
            required DateTime lastUpdated,
            required int lastUpdatedMillis,
          }) =>
              SnipResponsesCompanion.insert(
            id: id,
            answer: answer,
            snippetId: snippetId,
            uid: uid,
            displayName: displayName,
            date: date,
            lastUpdated: lastUpdated,
            lastUpdatedMillis: lastUpdatedMillis,
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

  ColumnFilters<String> get uid => $state.composableBuilder(
      column: $state.table.uid,
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

  ColumnFilters<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
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

  ColumnOrderings<String> get uid => $state.composableBuilder(
      column: $state.table.uid,
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

  ColumnOrderings<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastUpdatedMillis => $state.composableBuilder(
      column: $state.table.lastUpdatedMillis,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SnippetsTableCreateCompanionBuilder = SnippetsCompanion Function({
  Value<int> id,
  required DateTime lastRecieved,
  required String snippetId,
  required String question,
  required String theme,
  required int index,
  required bool answered,
  required String uid,
  required String type,
  required DateTime lastUpdated,
  required int lastUpdatedMillis,
  required int lastRecievedMillis,
});
typedef $$SnippetsTableUpdateCompanionBuilder = SnippetsCompanion Function({
  Value<int> id,
  Value<DateTime> lastRecieved,
  Value<String> snippetId,
  Value<String> question,
  Value<String> theme,
  Value<int> index,
  Value<bool> answered,
  Value<String> uid,
  Value<String> type,
  Value<DateTime> lastUpdated,
  Value<int> lastUpdatedMillis,
  Value<int> lastRecievedMillis,
});

class $$SnippetsTableTableManager extends RootTableManager<
    _$AppDb,
    $SnippetsTable,
    Snippet,
    $$SnippetsTableFilterComposer,
    $$SnippetsTableOrderingComposer,
    $$SnippetsTableCreateCompanionBuilder,
    $$SnippetsTableUpdateCompanionBuilder> {
  $$SnippetsTableTableManager(_$AppDb db, $SnippetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SnippetsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SnippetsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> lastRecieved = const Value.absent(),
            Value<String> snippetId = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<int> index = const Value.absent(),
            Value<bool> answered = const Value.absent(),
            Value<String> uid = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
            Value<int> lastRecievedMillis = const Value.absent(),
          }) =>
              SnippetsCompanion(
            id: id,
            lastRecieved: lastRecieved,
            snippetId: snippetId,
            question: question,
            theme: theme,
            index: index,
            answered: answered,
            uid: uid,
            type: type,
            lastUpdated: lastUpdated,
            lastUpdatedMillis: lastUpdatedMillis,
            lastRecievedMillis: lastRecievedMillis,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime lastRecieved,
            required String snippetId,
            required String question,
            required String theme,
            required int index,
            required bool answered,
            required String uid,
            required String type,
            required DateTime lastUpdated,
            required int lastUpdatedMillis,
            required int lastRecievedMillis,
          }) =>
              SnippetsCompanion.insert(
            id: id,
            lastRecieved: lastRecieved,
            snippetId: snippetId,
            question: question,
            theme: theme,
            index: index,
            answered: answered,
            uid: uid,
            type: type,
            lastUpdated: lastUpdated,
            lastUpdatedMillis: lastUpdatedMillis,
            lastRecievedMillis: lastRecievedMillis,
          ),
        ));
}

class $$SnippetsTableFilterComposer
    extends FilterComposer<_$AppDb, $SnippetsTable> {
  $$SnippetsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastRecieved => $state.composableBuilder(
      column: $state.table.lastRecieved,
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

  ColumnFilters<String> get theme => $state.composableBuilder(
      column: $state.table.theme,
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

  ColumnFilters<String> get uid => $state.composableBuilder(
      column: $state.table.uid,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
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

class $$SnippetsTableOrderingComposer
    extends OrderingComposer<_$AppDb, $SnippetsTable> {
  $$SnippetsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastRecieved => $state.composableBuilder(
      column: $state.table.lastRecieved,
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

  ColumnOrderings<String> get theme => $state.composableBuilder(
      column: $state.table.theme,
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

  ColumnOrderings<String> get uid => $state.composableBuilder(
      column: $state.table.uid,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
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

typedef $$BOTWTableCreateCompanionBuilder = BOTWCompanion Function({
  Value<int> id,
  required String blank,
  required String status,
  required String answers,
  required DateTime lastUpdated,
  required DateTime week,
  required int lastUpdatedMillis,
});
typedef $$BOTWTableUpdateCompanionBuilder = BOTWCompanion Function({
  Value<int> id,
  Value<String> blank,
  Value<String> status,
  Value<String> answers,
  Value<DateTime> lastUpdated,
  Value<DateTime> week,
  Value<int> lastUpdatedMillis,
});

class $$BOTWTableTableManager extends RootTableManager<
    _$AppDb,
    $BOTWTable,
    BOTWData,
    $$BOTWTableFilterComposer,
    $$BOTWTableOrderingComposer,
    $$BOTWTableCreateCompanionBuilder,
    $$BOTWTableUpdateCompanionBuilder> {
  $$BOTWTableTableManager(_$AppDb db, $BOTWTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BOTWTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BOTWTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> blank = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> answers = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
            Value<DateTime> week = const Value.absent(),
            Value<int> lastUpdatedMillis = const Value.absent(),
          }) =>
              BOTWCompanion(
            id: id,
            blank: blank,
            status: status,
            answers: answers,
            lastUpdated: lastUpdated,
            week: week,
            lastUpdatedMillis: lastUpdatedMillis,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String blank,
            required String status,
            required String answers,
            required DateTime lastUpdated,
            required DateTime week,
            required int lastUpdatedMillis,
          }) =>
              BOTWCompanion.insert(
            id: id,
            blank: blank,
            status: status,
            answers: answers,
            lastUpdated: lastUpdated,
            week: week,
            lastUpdatedMillis: lastUpdatedMillis,
          ),
        ));
}

class $$BOTWTableFilterComposer extends FilterComposer<_$AppDb, $BOTWTable> {
  $$BOTWTableFilterComposer(super.$state);
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

  ColumnFilters<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
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

class $$BOTWTableOrderingComposer
    extends OrderingComposer<_$AppDb, $BOTWTable> {
  $$BOTWTableOrderingComposer(super.$state);
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

  ColumnOrderings<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
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

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$SnipResponsesTableTableManager get snipResponses =>
      $$SnipResponsesTableTableManager(_db, _db.snipResponses);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db, _db.snippets);
  $$BOTWTableTableManager get botw => $$BOTWTableTableManager(_db, _db.botw);
}
