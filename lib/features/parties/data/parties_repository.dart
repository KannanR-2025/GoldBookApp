import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/core/database/database.dart';

class PartiesRepository {
  final AppDatabase _db;

  PartiesRepository(this._db);

  // Get all parties by type (Customer/Supplier)
  Future<List<Party>> getParties(String type) {
    return (_db.select(
      _db.parties,
    )..where((tbl) => tbl.type.equals(type))).get();
  }

  // Stream parties for real-time updates
  Stream<List<Party>> watchParties(String type) {
    return (_db.select(
      _db.parties,
    )..where((tbl) => tbl.type.equals(type))).watch();
  }

  // Get single party
  Future<Party?> getPartyById(int id) {
    return (_db.select(
      _db.parties,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Add party
  Future<int> addParty(PartiesCompanion party) {
    return _db.into(_db.parties).insert(party);
  }

  // Update party
  Future<bool> updateParty(Party party) {
    return _db.update(_db.parties).replace(party);
  }

  // Update party from companion
  Future<int> updatePartyFromCompanion(PartiesCompanion party) {
    return (_db.update(
      _db.parties,
    )..where((t) => t.id.equals(party.id.value))).write(party);
  }

  // Delete party
  Future<int> deleteParty(int id) {
    return (_db.delete(_db.parties)..where((tbl) => tbl.id.equals(id))).go();
  }
}

final partiesRepositoryProvider = Provider((ref) {
  return PartiesRepository(ref.watch(databaseProvider));
});
