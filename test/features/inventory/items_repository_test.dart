import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/inventory/items_provider.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late ItemsRepository repository;

  setUp(() {
    database = createTestDatabase();
    repository = ItemsRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('ItemsRepository', () {
    group('addItem', () {
      test('should add a gold item and return its id', () async {
        final item = ItemsCompanion.insert(
          name: 'Gold Ring',
          metalType: 'Gold',
        );

        final id = await repository.addItem(item);

        expect(id, isPositive);
      });

      test('should add a silver item and return its id', () async {
        final item = ItemsCompanion.insert(
          name: 'Silver Bracelet',
          metalType: 'Silver',
        );

        final id = await repository.addItem(item);

        expect(id, isPositive);
      });

      test('should add item with all fields', () async {
        final item = ItemsCompanion.insert(
          name: 'Diamond Necklace',
          metalType: 'Gold',
          code: const Value('GN-001'),
          purity: const Value('916'),
          category: const Value('Necklace'),
          description: const Value('Beautiful diamond necklace'),
          hsnCode: const Value('7113'),
          costPrice: const Value(50000.0),
          sellingPrice: const Value(60000.0),
          makingCharges: const Value(5000.0),
          wastagePercentage: const Value(2.5),
          stockQty: const Value(5.0),
          stockWeight: const Value(25.5),
          minimumStockLevel: const Value(2.0),
          brand: const Value('Premium'),
          status: const Value('Active'),
        );

        final id = await repository.addItem(item);
        final savedItem = await repository.getItemById(id);

        expect(savedItem, isNotNull);
        expect(savedItem!.name, equals('Diamond Necklace'));
        expect(savedItem.code, equals('GN-001'));
        expect(savedItem.purity, equals('916'));
        expect(savedItem.costPrice, equals(50000.0));
        expect(savedItem.sellingPrice, equals(60000.0));
        expect(savedItem.stockWeight, equals(25.5));
      });
    });

    group('getItemById', () {
      test('should return item when it exists', () async {
        final id = await repository.addItem(ItemsCompanion.insert(
          name: 'Test Item',
          metalType: 'Gold',
        ));

        final item = await repository.getItemById(id);

        expect(item, isNotNull);
        expect(item!.id, equals(id));
        expect(item.name, equals('Test Item'));
        expect(item.metalType, equals('Gold'));
      });

      test('should return null when item does not exist', () async {
        final item = await repository.getItemById(999);

        expect(item, isNull);
      });
    });

    group('updateItem', () {
      test('should update item using replace', () async {
        final id = await repository.addItem(ItemsCompanion.insert(
          name: 'Original Item',
          metalType: 'Gold',
        ));

        final originalItem = await repository.getItemById(id);
        final updatedItem = originalItem!.copyWith(
          name: 'Updated Item',
          sellingPrice: 75000.0,
        );

        final result = await repository.updateItem(updatedItem);
        final fetchedItem = await repository.getItemById(id);

        expect(result, isTrue);
        expect(fetchedItem!.name, equals('Updated Item'));
        expect(fetchedItem.sellingPrice, equals(75000.0));
      });
    });

    group('updateItemFromCompanion', () {
      test('should update specific item fields', () async {
        final id = await repository.addItem(ItemsCompanion.insert(
          name: 'Original Name',
          metalType: 'Gold',
        ));

        await repository.updateItemFromCompanion(ItemsCompanion(
          id: Value(id),
          name: const Value('Updated Name'),
          stockQty: const Value(10.0),
          stockWeight: const Value(50.0),
        ));

        final updatedItem = await repository.getItemById(id);

        expect(updatedItem!.name, equals('Updated Name'));
        expect(updatedItem.stockQty, equals(10.0));
        expect(updatedItem.stockWeight, equals(50.0));
      });
    });

    group('deleteItem', () {
      test('should delete item and return 1', () async {
        final id = await repository.addItem(ItemsCompanion.insert(
          name: 'To Delete',
          metalType: 'Silver',
        ));

        final deletedCount = await repository.deleteItem(id);
        final item = await repository.getItemById(id);

        expect(deletedCount, equals(1));
        expect(item, isNull);
      });

      test('should return 0 when item does not exist', () async {
        final deletedCount = await repository.deleteItem(999);

        expect(deletedCount, equals(0));
      });
    });

    group('watchItems', () {
      test('should emit items when data changes', () async {
        final stream = repository.watchItems();

        expect(
          stream,
          emitsInOrder([
            isEmpty, // Initial empty state
            hasLength(1), // After adding one item
          ]),
        );

        await Future.delayed(const Duration(milliseconds: 50));
        await repository.addItem(ItemsCompanion.insert(
          name: 'Stream Test Item',
          metalType: 'Gold',
        ));
      });
    });

    group('business logic scenarios', () {
      test('should handle multiple items with different metal types', () async {
        await repository.addItem(ItemsCompanion.insert(
          name: 'Gold Ring',
          metalType: 'Gold',
          purity: const Value('916'),
        ));
        await repository.addItem(ItemsCompanion.insert(
          name: 'Silver Chain',
          metalType: 'Silver',
          purity: const Value('925'),
        ));
        await repository.addItem(ItemsCompanion.insert(
          name: 'Gold Necklace',
          metalType: 'Gold',
          purity: const Value('750'),
        ));

        // Get all items via stream first emission
        final items = await repository.watchItems().first;

        expect(items.length, equals(3));
        expect(items.where((i) => i.metalType == 'Gold').length, equals(2));
        expect(items.where((i) => i.metalType == 'Silver').length, equals(1));
      });

      test('should track stock levels correctly', () async {
        final id = await repository.addItem(ItemsCompanion.insert(
          name: 'Stock Test Item',
          metalType: 'Gold',
          stockQty: const Value(10.0),
          stockWeight: const Value(100.0),
          minimumStockLevel: const Value(5.0),
          reorderLevel: const Value(3.0),
        ));

        final item = await repository.getItemById(id);

        expect(item!.stockQty, equals(10.0));
        expect(item.stockWeight, equals(100.0));
        expect(item.minimumStockLevel, equals(5.0));
        expect(item.stockQty > item.minimumStockLevel, isTrue);
      });

      test('should calculate pricing fields correctly', () async {
        final id = await repository.addItem(ItemsCompanion.insert(
          name: 'Priced Item',
          metalType: 'Gold',
          costPrice: const Value(40000.0),
          sellingPrice: const Value(50000.0),
          makingCharges: const Value(3000.0),
          wastagePercentage: const Value(2.0),
        ));

        final item = await repository.getItemById(id);

        expect(item!.costPrice, equals(40000.0));
        expect(item.sellingPrice, equals(50000.0));
        expect(item.sellingPrice > item.costPrice, isTrue);
        expect(item.makingCharges, equals(3000.0));
        expect(item.wastagePercentage, equals(2.0));
      });
    });
  });
}
