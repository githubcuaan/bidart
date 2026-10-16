import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor openDatabase() => LazyDatabase(() async {
      final result = await WasmDatabase.open(
        databaseName: 'bidart',
        sqlite3Uri: Uri.base.resolve('sqlite3.wasm'),
        driftWorkerUri: Uri.base.resolve('drift_worker.js'),
      );
      if (result.chosenImplementation == WasmStorageImplementation.inMemory) {
        await result.resolvedExecutor.close();
        throw StateError(
          'Trình duyệt không hỗ trợ lưu dữ liệu bền vững. '
          'Hãy cho phép lưu trữ hoặc dùng trình duyệt khác.',
        );
      }
      return result.resolvedExecutor;
    });

QueryExecutor openMemoryDatabase() => throw UnsupportedError(
      'AppDatabase.memory chỉ dùng cho native tests.',
    );
