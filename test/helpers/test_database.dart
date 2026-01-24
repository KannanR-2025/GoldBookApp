import 'package:drift/native.dart';
import 'package:goldbook_desktop/core/database/database.dart';

/// Creates an in-memory database for testing purposes.
/// This database is isolated and does not affect the real database.
AppDatabase createTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
