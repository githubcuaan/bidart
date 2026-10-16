import 'dart:convert';

import 'package:bidart/data/local/app_database.dart';
import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/repositories/rule_template_repository.dart';
import 'package:drift/drift.dart';

/// Drift/SQLite implementation of the storage boundary.
///
/// Stores the full Room aggregate as JSON so scores, balls, orders, rule
/// versions, events and undo barriers restore exactly after app restarts.
/// Room + receipt commit in one transaction; retries with the same command ID
/// return the original receipt before revision checks.
class DriftGameRepository
    implements GameRepository, RuleTemplateRepository {
  DriftGameRepository({required AppDatabase database, DateTime Function()? clock})
      : _db = database,
        _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;
  PersistenceFailure? _nextFailure;

  /// Fails the next otherwise-valid, non-retry write. Test hook mirroring
  /// [InMemoryGameRepository.failNextWrite].
  void failNextWrite([String message = 'Injected save failure']) {
    _nextFailure = PersistenceFailure(message);
  }

  Room _decodeRoom(String payload) {
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      return Room.fromJson(json);
    } on FormatException catch (e) {
      throw PersistenceFailure('Dữ liệu phòng bị hỏng: ${e.message}');
    } on TypeError catch (e) {
      throw PersistenceFailure('Dữ liệu phòng bị hỏng: $e');
    } on ArgumentError catch (e) {
      throw PersistenceFailure('Dữ liệu phòng bị hỏng: $e');
    }
  }

  String _encodeRoom(Room room) => jsonEncode(room.toJson());

  RuleTemplate _decodeTemplate(String payload) {
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      return RuleTemplate.fromJson(json);
    } on FormatException catch (e) {
      throw PersistenceFailure('Dữ liệu mẫu luật bị hỏng: ${e.message}');
    } on TypeError catch (e) {
      throw PersistenceFailure('Dữ liệu mẫu luật bị hỏng: $e');
    } on ArgumentError catch (e) {
      throw PersistenceFailure('Dữ liệu mẫu luật bị hỏng: $e');
    }
  }

  // Freezed views alone do not detach mutable collections supplied by callers.
  Room _detach(Room room) => Room.fromJson(room.toJson());

  CommandReceipt _detachReceipt(CommandReceipt receipt) => CommandReceipt(
        commandId: receipt.commandId,
        type: receipt.type,
        room: _detach(receipt.room),
      );

  Future<CommandReceipt?> _findReceipt(String commandId) async {
    final row = await (_db.select(_db.receiptRows)
          ..where((t) => t.commandId.equals(commandId)))
        .getSingleOrNull();
    if (row == null) return null;
    return CommandReceipt(
      commandId: row.commandId,
      type: RoomCommandType.values.byName(row.type),
      room: _decodeRoom(row.payload),
    );
  }

  @override
  Future<List<Room>> listRooms({RoomStatus? status}) async {
    final query = _db.select(_db.roomRows)
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
        (t) => OrderingTerm.asc(t.id),
      ]);
    if (status != null) {
      query.where((t) => t.status.equals(status.name));
    }
    final rows = await query.get();
    // Decode outside the query so one corrupted row surfaces as an explicit
    // error instead of silently disappearing from the list.
    final rooms = [for (final row in rows) _decodeRoom(row.payload)];
    return List<Room>.unmodifiable(rooms);
  }

  @override
  Future<Room> getRoom(String roomId) async {
    final row = await (_db.select(_db.roomRows)
          ..where((t) => t.id.equals(roomId)))
        .getSingleOrNull();
    if (row == null) throw RoomNotFoundFailure(roomId);
    return _decodeRoom(row.payload);
  }

  @override
  Future<CommandReceipt?> getCommandReceipt(String commandId) async =>
      _findReceipt(commandId);

  @override
  Future<CommandReceipt> createRoom({
    required String commandId,
    required Room room,
  }) async =>
      _write(commandId, room, RoomCommandType.create, null);

  @override
  Future<CommandReceipt> updateRoom({
    required String commandId,
    required int expectedRevision,
    required Room room,
    RoomCommandType type = RoomCommandType.update,
  }) async {
    if (type == RoomCommandType.create) {
      throw RepositoryValidationFailure('Create type is not an update');
    }
    return _write(commandId, room, type, expectedRevision);
  }

  Future<CommandReceipt> _write(
    String commandId,
    Room room,
    RoomCommandType type,
    int? expectedRevision,
  ) async {
    final detached = _detach(room);
    return _db.transaction(() async {
      final prior = await _findReceipt(commandId);
      if (prior != null) {
        if (prior.type != type || prior.room.id != detached.id) {
          throw RepositoryValidationFailure(
            'Command ID belongs to another operation',
          );
        }
        return _detachReceipt(prior);
      }
      if (commandId.trim().isEmpty ||
          detached.id.trim().isEmpty ||
          detached.revision < 0) {
        throw RepositoryValidationFailure(
          'Nonempty IDs and nonnegative revision required',
        );
      }
      final stored = await (_db.select(_db.roomRows)
            ..where((t) => t.id.equals(detached.id)))
          .getSingleOrNull();
      if (type == RoomCommandType.create) {
        if (stored != null) {
          throw RepositoryValidationFailure('Room ID already exists');
        }
      } else {
        if (stored == null) throw RoomNotFoundFailure(detached.id);
        final storedRoom = _decodeRoom(stored.payload);
        if (storedRoom.revision != expectedRevision) {
          throw StaleRevisionFailure(
            expected: expectedRevision!,
            actual: storedRoom.revision,
          );
        }
        if (detached.revision != expectedRevision! + 1) {
          throw RepositoryValidationFailure(
            'Update must increment revision by one',
          );
        }
      }
      if (detached.status == RoomStatus.active) {
        final activeRows = await (_db.select(_db.roomRows)
              ..where((t) => t.status.equals(RoomStatus.active.name)))
            .get();
        for (final other in activeRows) {
          if (other.id != detached.id) {
            throw ActiveRoomExistsFailure(other.id);
          }
        }
      }
      final failure = _nextFailure;
      if (failure != null) {
        _nextFailure = null;
        throw failure;
      }
      final now = _clock().microsecondsSinceEpoch;
      final payload = _encodeRoom(detached);
      if (type == RoomCommandType.create) {
        await _db.into(_db.roomRows).insert(RoomRowsCompanion.insert(
              id: detached.id,
              payload: payload,
              revision: detached.revision,
              status: detached.status.name,
              createdAt: detached.createdAt.microsecondsSinceEpoch,
              updatedAt: now,
            ));
      } else {
        await (_db.update(_db.roomRows)
              ..where((t) => t.id.equals(detached.id)))
            .write(RoomRowsCompanion(
          payload: Value(payload),
          revision: Value(detached.revision),
          status: Value(detached.status.name),
          updatedAt: Value(now),
        ));
      }
      await _db.into(_db.receiptRows).insert(
            ReceiptRowsCompanion.insert(
              commandId: commandId,
              type: type.name,
              roomId: detached.id,
              roomRevision: detached.revision,
              payload: payload,
              createdAt: now,
            ),
          );
      final receipt = CommandReceipt(
        commandId: commandId,
        type: type,
        room: detached,
      );
      return _detachReceipt(receipt);
    });
  }

  @override
  Future<RuleTemplate> saveRuleTemplate({
    required String templateId,
    required String name,
    required Map<int, BallPointConfig> ballPoints,
  }) async {
    final template = buildRuleTemplate(
      templateId: templateId,
      name: name,
      ballPoints: ballPoints,
      now: _clock(),
    );
    final payload = jsonEncode(template.toJson());
    await _db.into(_db.templateRows).insertOnConflictUpdate(
          TemplateRowsCompanion.insert(
            id: template.id,
            name: template.name,
            payload: payload,
            createdAt: template.createdAt.microsecondsSinceEpoch,
          ),
        );
    return RuleTemplate.fromJson(template.toJson());
  }

  @override
  Future<List<RuleTemplate>> listRuleTemplates() async {
    final rows = await (_db.select(_db.templateRows)
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
    return List<RuleTemplate>.unmodifiable(
      [for (final row in rows) _decodeTemplate(row.payload)],
    );
  }

  @override
  Future<RuleTemplate> getRuleTemplate(String templateId) async {
    final row = await (_db.select(_db.templateRows)
          ..where((t) => t.id.equals(templateId)))
        .getSingleOrNull();
    if (row == null) throw RuleTemplateNotFoundFailure(templateId);
    return _decodeTemplate(row.payload);
  }
}
