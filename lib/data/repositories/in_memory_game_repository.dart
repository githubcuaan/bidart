import 'package:bidart/domain/models/scoring/ball_point_config.dart';
import 'package:bidart/domain/models/scoring/room.dart';
import 'package:bidart/domain/models/scoring/room_status.dart';
import 'package:bidart/domain/models/scoring/rule_template.dart';
import 'package:bidart/domain/repositories/game_repository_interface.dart';
import 'package:bidart/domain/repositories/rule_template_repository.dart';

/// Single-isolate fake. Check-and-commit has no await, so concurrent Future
/// callers cannot interleave writes. Not durable storage or cross-isolate sync.
class InMemoryGameRepository
    implements GameRepository, RuleTemplateRepository {
  InMemoryGameRepository({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Map<String, Room> _rooms = {};
  final Map<String, CommandReceipt> _receipts = {};
  final Map<String, RuleTemplate> _templates = {};
  PersistenceFailure? _nextFailure;

  /// Fails the next otherwise-valid, non-retry write before any mutation.
  void failNextWrite([String message = 'Injected save failure']) {
    _nextFailure = PersistenceFailure(message);
  }

  // Freezed views alone do not detach mutable collections supplied by callers.
  Room _copy(Room room) => Room.fromJson(room.toJson());

  CommandReceipt _copyReceipt(CommandReceipt receipt) => CommandReceipt(
    commandId: receipt.commandId,
    type: receipt.type,
    room: _copy(receipt.room),
  );

  @override
  Future<List<Room>> listRooms({RoomStatus? status}) async {
    final rooms =
        _rooms.values
            .where((room) => status == null || room.status == status)
            .map(_copy)
            .toList()
          ..sort((a, b) {
            final date = b.createdAt.compareTo(a.createdAt);
            return date != 0 ? date : a.id.compareTo(b.id);
          });
    return List.unmodifiable(rooms);
  }

  @override
  Future<Room> getRoom(String roomId) async {
    final room = _rooms[roomId];
    if (room == null) throw RoomNotFoundFailure(roomId);
    return _copy(room);
  }

  @override
  Future<CommandReceipt?> getCommandReceipt(String commandId) async {
    final receipt = _receipts[commandId];
    return receipt == null ? null : _copyReceipt(receipt);
  }

  @override
  Future<CommandReceipt> createRoom({
    required String commandId,
    required Room room,
  }) async => _write(commandId, room, RoomCommandType.create);

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

  CommandReceipt _write(
    String commandId,
    Room room,
    RoomCommandType type, [
    int? expectedRevision,
  ]) {
    final prior = _receipts[commandId];
    if (prior != null) {
      if (prior.type != type || prior.room.id != room.id) {
        throw RepositoryValidationFailure(
          'Command ID belongs to another operation',
        );
      }
      return _copyReceipt(prior);
    }
    if (commandId.trim().isEmpty ||
        room.id.trim().isEmpty ||
        room.revision < 0) {
      throw RepositoryValidationFailure(
        'Nonempty IDs and nonnegative revision required',
      );
    }
    final stored = _rooms[room.id];
    if (type == RoomCommandType.create) {
      if (stored != null) {
        throw RepositoryValidationFailure('Room ID already exists');
      }
    } else {
      if (stored == null) throw RoomNotFoundFailure(room.id);
      if (stored.revision != expectedRevision) {
        throw StaleRevisionFailure(
          expected: expectedRevision!,
          actual: stored.revision,
        );
      }
      if (room.revision != expectedRevision! + 1) {
        throw RepositoryValidationFailure(
          'Update must increment revision by one',
        );
      }
    }
    if (room.status == RoomStatus.active) {
      for (final other in _rooms.values) {
        if (other.id != room.id && other.status == RoomStatus.active) {
          throw ActiveRoomExistsFailure(other.id);
        }
      }
    }
    final detached = _copy(room);
    final receipt = CommandReceipt(
      commandId: commandId,
      type: type,
      room: detached,
    );
    // Prepare the returned copy before mutating storage, too.
    final result = _copyReceipt(receipt);
    final failure = _nextFailure;
    if (failure != null) {
      _nextFailure = null;
      throw failure;
    }
    _rooms[room.id] = detached;
    _receipts[commandId] = receipt;
    return result;
  }

  RuleTemplate _copyTemplate(RuleTemplate template) =>
      RuleTemplate.fromJson(template.toJson());

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
    final detached = _copyTemplate(template);
    _templates[detached.id] = detached;
    return _copyTemplate(detached);
  }

  @override
  Future<List<RuleTemplate>> listRuleTemplates() async {
    final templates = _templates.values.map(_copyTemplate).toList()
      ..sort((a, b) {
        final date = b.createdAt.compareTo(a.createdAt);
        return date != 0 ? date : a.id.compareTo(b.id);
      });
    return List.unmodifiable(templates);
  }

  @override
  Future<RuleTemplate> getRuleTemplate(String templateId) async {
    final template = _templates[templateId];
    if (template == null) throw RuleTemplateNotFoundFailure(templateId);
    return _copyTemplate(template);
  }

  @override
  Future<void> deleteRuleTemplate(String templateId) async {
    _templates.remove(templateId);
  }
}
