import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/core/database/database.dart';

// --- Repository ---

class ItemsRepository {
  final AppDatabase _db;
  ItemsRepository(this._db);

  Stream<List<Item>> watchItems() {
    return _db.select(_db.items).watch();
  }

  Future<int> addItem(ItemsCompanion item) {
    return _db.into(_db.items).insert(item);
  }

  Future<bool> updateItem(Item item) {
    return _db.update(_db.items).replace(item);
  }

  Future<int> updateItemFromCompanion(ItemsCompanion item) {
    return (_db.update(
      _db.items,
    )..where((t) => t.id.equals(item.id.value))).write(item);
  }

  Future<int> deleteItem(int id) {
    return (_db.delete(_db.items)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Item?> getItemById(int id) {
    return (_db.select(
      _db.items,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}

final itemsRepositoryProvider = Provider((ref) {
  return ItemsRepository(ref.watch(databaseProvider));
});

// --- Controller ---

final itemsListProvider = StreamProvider<List<Item>>((ref) {
  return ref.watch(itemsRepositoryProvider).watchItems();
});

final itemByIdProvider = FutureProvider.family.autoDispose<Item?, int>((
  ref,
  id,
) {
  return ref.watch(itemsRepositoryProvider).getItemById(id);
});

class ItemsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // No state
  }

  Future<void> addItem(ItemsCompanion item) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).addItem(item);
    });
  }

  Future<void> updateItem(ItemsCompanion item) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(itemsRepositoryProvider).updateItemFromCompanion(item);
    });
  }
}

final itemsControllerProvider = AsyncNotifierProvider<ItemsController, void>(
  ItemsController.new,
);
