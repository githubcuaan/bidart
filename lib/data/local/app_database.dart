import 'package:drift/drift.dart';

import 'database_connection_native.dart'
    if (dart.library.js_interop) 'database_connection_web.dart' as platform;

part 'app_database.g.dart';

/// Durable tables. Aggregates are stored as JSON snapshots so the full
/// Room -> GameSession -> Turn graph, rule versions, roster, events,
/// transactions and undo barriers survive restarts without lossy mapping.
/// Columns beside [payload] support ordering, filtering and revision guards.
class RoomRows extends Table {
  TextColumn get id => text()();
  TextColumn get payload => text()();
  IntColumn get revision => integer()();
  TextColumn get status => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  String get tableName => 'rooms';

  @override
  Set<Column> get primaryKey => {id};
}

class ReceiptRows extends Table {
  TextColumn get commandId => text()();
  TextColumn get type => text()();
  TextColumn get roomId => text()();
  IntColumn get roomRevision => integer()();
  TextColumn get payload => text()();
  IntColumn get createdAt => integer()();

  @override
  String get tableName => 'command_receipts';

  @override
  Set<Column> get primaryKey => {commandId};
}

class TemplateRows extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get payload => text()();
  IntColumn get createdAt => integer()();

  @override
  String get tableName => 'rule_templates';

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [RoomRows, ReceiptRows, TemplateRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? platform.openDatabase());

  AppDatabase.memory() : super(platform.openMemoryDatabase());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
      );

}
