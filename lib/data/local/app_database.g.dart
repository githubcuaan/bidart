// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoomRowsTable extends RoomRows with TableInfo<$RoomRowsTable, RoomRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    payload,
    revision,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RoomRowsTable createAlias(String alias) {
    return $RoomRowsTable(attachedDatabase, alias);
  }
}

class RoomRow extends DataClass implements Insertable<RoomRow> {
  final String id;
  final String payload;
  final int revision;
  final String status;
  final int createdAt;
  final int updatedAt;
  const RoomRow({
    required this.id,
    required this.payload,
    required this.revision,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload'] = Variable<String>(payload);
    map['revision'] = Variable<int>(revision);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RoomRowsCompanion toCompanion(bool nullToAbsent) {
    return RoomRowsCompanion(
      id: Value(id),
      payload: Value(payload),
      revision: Value(revision),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoomRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomRow(
      id: serializer.fromJson<String>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      revision: serializer.fromJson<int>(json['revision']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payload': serializer.toJson<String>(payload),
      'revision': serializer.toJson<int>(revision),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RoomRow copyWith({
    String? id,
    String? payload,
    int? revision,
    String? status,
    int? createdAt,
    int? updatedAt,
  }) => RoomRow(
    id: id ?? this.id,
    payload: payload ?? this.payload,
    revision: revision ?? this.revision,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoomRow copyWithCompanion(RoomRowsCompanion data) {
    return RoomRow(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      revision: data.revision.present ? data.revision.value : this.revision,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomRow(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('revision: $revision, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, payload, revision, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomRow &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.revision == this.revision &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoomRowsCompanion extends UpdateCompanion<RoomRow> {
  final Value<String> id;
  final Value<String> payload;
  final Value<int> revision;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RoomRowsCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.revision = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomRowsCompanion.insert({
    required String id,
    required String payload,
    required int revision,
    required String status,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payload = Value(payload),
       revision = Value(revision),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoomRow> custom({
    Expression<String>? id,
    Expression<String>? payload,
    Expression<int>? revision,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (revision != null) 'revision': revision,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? payload,
    Value<int>? revision,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoomRowsCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      revision: revision ?? this.revision,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomRowsCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('revision: $revision, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceiptRowsTable extends ReceiptRows
    with TableInfo<$ReceiptRowsTable, ReceiptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _commandIdMeta = const VerificationMeta(
    'commandId',
  );
  @override
  late final GeneratedColumn<String> commandId = GeneratedColumn<String>(
    'command_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomRevisionMeta = const VerificationMeta(
    'roomRevision',
  );
  @override
  late final GeneratedColumn<int> roomRevision = GeneratedColumn<int>(
    'room_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    commandId,
    type,
    roomId,
    roomRevision,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'command_receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReceiptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('command_id')) {
      context.handle(
        _commandIdMeta,
        commandId.isAcceptableOrUnknown(data['command_id']!, _commandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_commandIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('room_revision')) {
      context.handle(
        _roomRevisionMeta,
        roomRevision.isAcceptableOrUnknown(
          data['room_revision']!,
          _roomRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_roomRevisionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {commandId};
  @override
  ReceiptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceiptRow(
      commandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      )!,
      roomRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_revision'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReceiptRowsTable createAlias(String alias) {
    return $ReceiptRowsTable(attachedDatabase, alias);
  }
}

class ReceiptRow extends DataClass implements Insertable<ReceiptRow> {
  final String commandId;
  final String type;
  final String roomId;
  final int roomRevision;
  final String payload;
  final int createdAt;
  const ReceiptRow({
    required this.commandId,
    required this.type,
    required this.roomId,
    required this.roomRevision,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['command_id'] = Variable<String>(commandId);
    map['type'] = Variable<String>(type);
    map['room_id'] = Variable<String>(roomId);
    map['room_revision'] = Variable<int>(roomRevision);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ReceiptRowsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptRowsCompanion(
      commandId: Value(commandId),
      type: Value(type),
      roomId: Value(roomId),
      roomRevision: Value(roomRevision),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory ReceiptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceiptRow(
      commandId: serializer.fromJson<String>(json['commandId']),
      type: serializer.fromJson<String>(json['type']),
      roomId: serializer.fromJson<String>(json['roomId']),
      roomRevision: serializer.fromJson<int>(json['roomRevision']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'commandId': serializer.toJson<String>(commandId),
      'type': serializer.toJson<String>(type),
      'roomId': serializer.toJson<String>(roomId),
      'roomRevision': serializer.toJson<int>(roomRevision),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ReceiptRow copyWith({
    String? commandId,
    String? type,
    String? roomId,
    int? roomRevision,
    String? payload,
    int? createdAt,
  }) => ReceiptRow(
    commandId: commandId ?? this.commandId,
    type: type ?? this.type,
    roomId: roomId ?? this.roomId,
    roomRevision: roomRevision ?? this.roomRevision,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  ReceiptRow copyWithCompanion(ReceiptRowsCompanion data) {
    return ReceiptRow(
      commandId: data.commandId.present ? data.commandId.value : this.commandId,
      type: data.type.present ? data.type.value : this.type,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      roomRevision: data.roomRevision.present
          ? data.roomRevision.value
          : this.roomRevision,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptRow(')
          ..write('commandId: $commandId, ')
          ..write('type: $type, ')
          ..write('roomId: $roomId, ')
          ..write('roomRevision: $roomRevision, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(commandId, type, roomId, roomRevision, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceiptRow &&
          other.commandId == this.commandId &&
          other.type == this.type &&
          other.roomId == this.roomId &&
          other.roomRevision == this.roomRevision &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class ReceiptRowsCompanion extends UpdateCompanion<ReceiptRow> {
  final Value<String> commandId;
  final Value<String> type;
  final Value<String> roomId;
  final Value<int> roomRevision;
  final Value<String> payload;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ReceiptRowsCompanion({
    this.commandId = const Value.absent(),
    this.type = const Value.absent(),
    this.roomId = const Value.absent(),
    this.roomRevision = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceiptRowsCompanion.insert({
    required String commandId,
    required String type,
    required String roomId,
    required int roomRevision,
    required String payload,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : commandId = Value(commandId),
       type = Value(type),
       roomId = Value(roomId),
       roomRevision = Value(roomRevision),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<ReceiptRow> custom({
    Expression<String>? commandId,
    Expression<String>? type,
    Expression<String>? roomId,
    Expression<int>? roomRevision,
    Expression<String>? payload,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (commandId != null) 'command_id': commandId,
      if (type != null) 'type': type,
      if (roomId != null) 'room_id': roomId,
      if (roomRevision != null) 'room_revision': roomRevision,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceiptRowsCompanion copyWith({
    Value<String>? commandId,
    Value<String>? type,
    Value<String>? roomId,
    Value<int>? roomRevision,
    Value<String>? payload,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ReceiptRowsCompanion(
      commandId: commandId ?? this.commandId,
      type: type ?? this.type,
      roomId: roomId ?? this.roomId,
      roomRevision: roomRevision ?? this.roomRevision,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (commandId.present) {
      map['command_id'] = Variable<String>(commandId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (roomRevision.present) {
      map['room_revision'] = Variable<int>(roomRevision.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptRowsCompanion(')
          ..write('commandId: $commandId, ')
          ..write('type: $type, ')
          ..write('roomId: $roomId, ')
          ..write('roomRevision: $roomRevision, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemplateRowsTable extends TemplateRows
    with TableInfo<$TemplateRowsTable, TemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, payload, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rule_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TemplateRowsTable createAlias(String alias) {
    return $TemplateRowsTable(attachedDatabase, alias);
  }
}

class TemplateRow extends DataClass implements Insertable<TemplateRow> {
  final String id;
  final String name;
  final String payload;
  final int createdAt;
  const TemplateRow({
    required this.id,
    required this.name,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  TemplateRowsCompanion toCompanion(bool nullToAbsent) {
    return TemplateRowsCompanion(
      id: Value(id),
      name: Value(name),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory TemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  TemplateRow copyWith({
    String? id,
    String? name,
    String? payload,
    int? createdAt,
  }) => TemplateRow(
    id: id ?? this.id,
    name: name ?? this.name,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  TemplateRow copyWithCompanion(TemplateRowsCompanion data) {
    return TemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class TemplateRowsCompanion extends UpdateCompanion<TemplateRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> payload;
  final Value<int> createdAt;
  final Value<int> rowid;
  const TemplateRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplateRowsCompanion.insert({
    required String id,
    required String name,
    required String payload,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<TemplateRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? payload,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplateRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? payload,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return TemplateRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoomRowsTable roomRows = $RoomRowsTable(this);
  late final $ReceiptRowsTable receiptRows = $ReceiptRowsTable(this);
  late final $TemplateRowsTable templateRows = $TemplateRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    roomRows,
    receiptRows,
    templateRows,
  ];
}

typedef $$RoomRowsTableCreateCompanionBuilder = RoomRowsCompanion Function({
  required String id,
  required String payload,
  required int revision,
  required String status,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$RoomRowsTableUpdateCompanionBuilder = RoomRowsCompanion Function({
  Value<String> id,
  Value<String> payload,
  Value<int> revision,
  Value<String> status,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$RoomRowsTableFilterComposer
    extends Composer<_$AppDatabase, $RoomRowsTable> {
  $$RoomRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomRowsTable> {
  $$RoomRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomRowsTable> {
  $$RoomRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RoomRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomRowsTable,
          RoomRow,
          $$RoomRowsTableFilterComposer,
          $$RoomRowsTableOrderingComposer,
          $$RoomRowsTableAnnotationComposer,
          $$RoomRowsTableCreateCompanionBuilder,
          $$RoomRowsTableUpdateCompanionBuilder,
          (RoomRow, BaseReferences<_$AppDatabase, $RoomRowsTable, RoomRow>),
          RoomRow,
          PrefetchHooks Function()
        > {
  $$RoomRowsTableTableManager(_$AppDatabase db, $RoomRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomRowsCompanion(
                id: id,
                payload: payload,
                revision: revision,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payload,
                required int revision,
                required String status,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoomRowsCompanion.insert(
                id: id,
                payload: payload,
                revision: revision,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomRowsTable, RoomRow>(table),
                  BaseReferences<_$AppDatabase, $RoomRowsTable, RoomRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomRowsTable,
      RoomRow,
      $$RoomRowsTableFilterComposer,
      $$RoomRowsTableOrderingComposer,
      $$RoomRowsTableAnnotationComposer,
      $$RoomRowsTableCreateCompanionBuilder,
      $$RoomRowsTableUpdateCompanionBuilder,
      (RoomRow, BaseReferences<_$AppDatabase, $RoomRowsTable, RoomRow>),
      RoomRow,
      PrefetchHooks Function()
    >;
typedef $$ReceiptRowsTableCreateCompanionBuilder =
    ReceiptRowsCompanion Function({
      required String commandId,
      required String type,
      required String roomId,
      required int roomRevision,
      required String payload,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$ReceiptRowsTableUpdateCompanionBuilder =
    ReceiptRowsCompanion Function({
      Value<String> commandId,
      Value<String> type,
      Value<String> roomId,
      Value<int> roomRevision,
      Value<String> payload,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$ReceiptRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptRowsTable> {
  $$ReceiptRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get commandId => $composableBuilder(
    column: $table.commandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roomRevision => $composableBuilder(
    column: $table.roomRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReceiptRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptRowsTable> {
  $$ReceiptRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get commandId => $composableBuilder(
    column: $table.commandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roomRevision => $composableBuilder(
    column: $table.roomRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReceiptRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptRowsTable> {
  $$ReceiptRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get commandId =>
      $composableBuilder(column: $table.commandId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<int> get roomRevision => $composableBuilder(
    column: $table.roomRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReceiptRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceiptRowsTable,
          ReceiptRow,
          $$ReceiptRowsTableFilterComposer,
          $$ReceiptRowsTableOrderingComposer,
          $$ReceiptRowsTableAnnotationComposer,
          $$ReceiptRowsTableCreateCompanionBuilder,
          $$ReceiptRowsTableUpdateCompanionBuilder,
          (
            ReceiptRow,
            BaseReferences<_$AppDatabase, $ReceiptRowsTable, ReceiptRow>,
          ),
          ReceiptRow,
          PrefetchHooks Function()
        > {
  $$ReceiptRowsTableTableManager(_$AppDatabase db, $ReceiptRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> commandId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<int> roomRevision = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReceiptRowsCompanion(
                commandId: commandId,
                type: type,
                roomId: roomId,
                roomRevision: roomRevision,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String commandId,
                required String type,
                required String roomId,
                required int roomRevision,
                required String payload,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReceiptRowsCompanion.insert(
                commandId: commandId,
                type: type,
                roomId: roomId,
                roomRevision: roomRevision,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReceiptRowsTable, ReceiptRow>(table),
                  BaseReferences<_$AppDatabase, $ReceiptRowsTable, ReceiptRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReceiptRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceiptRowsTable,
      ReceiptRow,
      $$ReceiptRowsTableFilterComposer,
      $$ReceiptRowsTableOrderingComposer,
      $$ReceiptRowsTableAnnotationComposer,
      $$ReceiptRowsTableCreateCompanionBuilder,
      $$ReceiptRowsTableUpdateCompanionBuilder,
      (
        ReceiptRow,
        BaseReferences<_$AppDatabase, $ReceiptRowsTable, ReceiptRow>,
      ),
      ReceiptRow,
      PrefetchHooks Function()
    >;
typedef $$TemplateRowsTableCreateCompanionBuilder =
    TemplateRowsCompanion Function({
      required String id,
      required String name,
      required String payload,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$TemplateRowsTableUpdateCompanionBuilder =
    TemplateRowsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> payload,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$TemplateRowsTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateRowsTable> {
  $$TemplateRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TemplateRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateRowsTable> {
  $$TemplateRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TemplateRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateRowsTable> {
  $$TemplateRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TemplateRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplateRowsTable,
          TemplateRow,
          $$TemplateRowsTableFilterComposer,
          $$TemplateRowsTableOrderingComposer,
          $$TemplateRowsTableAnnotationComposer,
          $$TemplateRowsTableCreateCompanionBuilder,
          $$TemplateRowsTableUpdateCompanionBuilder,
          (
            TemplateRow,
            BaseReferences<_$AppDatabase, $TemplateRowsTable, TemplateRow>,
          ),
          TemplateRow,
          PrefetchHooks Function()
        > {
  $$TemplateRowsTableTableManager(_$AppDatabase db, $TemplateRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplateRowsCompanion(
                id: id,
                name: name,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String payload,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TemplateRowsCompanion.insert(
                id: id,
                name: name,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TemplateRowsTable, TemplateRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TemplateRowsTable,
                    TemplateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TemplateRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplateRowsTable,
      TemplateRow,
      $$TemplateRowsTableFilterComposer,
      $$TemplateRowsTableOrderingComposer,
      $$TemplateRowsTableAnnotationComposer,
      $$TemplateRowsTableCreateCompanionBuilder,
      $$TemplateRowsTableUpdateCompanionBuilder,
      (
        TemplateRow,
        BaseReferences<_$AppDatabase, $TemplateRowsTable, TemplateRow>,
      ),
      TemplateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoomRowsTableTableManager get roomRows =>
      $$RoomRowsTableTableManager(_db, _db.roomRows);
  $$ReceiptRowsTableTableManager get receiptRows =>
      $$ReceiptRowsTableTableManager(_db, _db.receiptRows);
  $$TemplateRowsTableTableManager get templateRows =>
      $$TemplateRowsTableTableManager(_db, _db.templateRows);
}
