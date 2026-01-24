import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/data/parties_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase database;
  late PartiesRepository repository;

  setUp(() {
    database = createTestDatabase();
    repository = PartiesRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('PartiesRepository', () {
    group('addParty', () {
      test('should add a customer party and return its id', () async {
        final party = PartiesCompanion.insert(
          name: 'Test Customer',
          mobile: '9876543210',
          type: 'Customer',
        );

        final id = await repository.addParty(party);

        expect(id, isPositive);
      });

      test('should add a supplier party and return its id', () async {
        final party = PartiesCompanion.insert(
          name: 'Test Supplier',
          mobile: '9876543211',
          type: 'Supplier',
        );

        final id = await repository.addParty(party);

        expect(id, isPositive);
      });

      test('should add party with all fields', () async {
        final party = PartiesCompanion.insert(
          name: 'Full Customer',
          mobile: '9876543210',
          type: 'Customer',
          email: const Value('test@example.com'),
          companyName: const Value('Test Company'),
          gstin: const Value('22AAAAA0000A1Z5'),
          panNumber: const Value('ABCDE1234F'),
          city: const Value('Mumbai'),
          state: const Value('Maharashtra'),
          openingGoldBalance: const Value(100.5),
          openingSilverBalance: const Value(500.0),
          openingCashBalance: const Value(10000.0),
        );

        final id = await repository.addParty(party);
        final savedParty = await repository.getPartyById(id);

        expect(savedParty, isNotNull);
        expect(savedParty!.name, equals('Full Customer'));
        expect(savedParty.email, equals('test@example.com'));
        expect(savedParty.gstin, equals('22AAAAA0000A1Z5'));
        expect(savedParty.openingGoldBalance, equals(100.5));
      });
    });

    group('getParties', () {
      test('should return only customers when type is Customer', () async {
        await repository.addParty(PartiesCompanion.insert(
          name: 'Customer 1',
          mobile: '1111111111',
          type: 'Customer',
        ));
        await repository.addParty(PartiesCompanion.insert(
          name: 'Supplier 1',
          mobile: '2222222222',
          type: 'Supplier',
        ));
        await repository.addParty(PartiesCompanion.insert(
          name: 'Customer 2',
          mobile: '3333333333',
          type: 'Customer',
        ));

        final customers = await repository.getParties('Customer');

        expect(customers.length, equals(2));
        expect(customers.every((p) => p.type == 'Customer'), isTrue);
      });

      test('should return only suppliers when type is Supplier', () async {
        await repository.addParty(PartiesCompanion.insert(
          name: 'Customer 1',
          mobile: '1111111111',
          type: 'Customer',
        ));
        await repository.addParty(PartiesCompanion.insert(
          name: 'Supplier 1',
          mobile: '2222222222',
          type: 'Supplier',
        ));

        final suppliers = await repository.getParties('Supplier');

        expect(suppliers.length, equals(1));
        expect(suppliers.first.name, equals('Supplier 1'));
      });

      test('should return empty list when no parties of type exist', () async {
        final parties = await repository.getParties('Customer');

        expect(parties, isEmpty);
      });
    });

    group('getPartyById', () {
      test('should return party when it exists', () async {
        final id = await repository.addParty(PartiesCompanion.insert(
          name: 'Test Party',
          mobile: '9876543210',
          type: 'Customer',
        ));

        final party = await repository.getPartyById(id);

        expect(party, isNotNull);
        expect(party!.id, equals(id));
        expect(party.name, equals('Test Party'));
      });

      test('should return null when party does not exist', () async {
        final party = await repository.getPartyById(999);

        expect(party, isNull);
      });
    });

    group('updatePartyFromCompanion', () {
      test('should update party fields', () async {
        final id = await repository.addParty(PartiesCompanion.insert(
          name: 'Original Name',
          mobile: '9876543210',
          type: 'Customer',
        ));

        await repository.updatePartyFromCompanion(PartiesCompanion(
          id: Value(id),
          name: const Value('Updated Name'),
          mobile: const Value('1111111111'),
          email: const Value('updated@example.com'),
        ));

        final updatedParty = await repository.getPartyById(id);

        expect(updatedParty!.name, equals('Updated Name'));
        expect(updatedParty.mobile, equals('1111111111'));
        expect(updatedParty.email, equals('updated@example.com'));
      });
    });

    group('deleteParty', () {
      test('should delete party and return 1', () async {
        final id = await repository.addParty(PartiesCompanion.insert(
          name: 'To Delete',
          mobile: '9876543210',
          type: 'Customer',
        ));

        final deletedCount = await repository.deleteParty(id);
        final party = await repository.getPartyById(id);

        expect(deletedCount, equals(1));
        expect(party, isNull);
      });

      test('should return 0 when party does not exist', () async {
        final deletedCount = await repository.deleteParty(999);

        expect(deletedCount, equals(0));
      });
    });

    group('watchParties', () {
      test('should emit parties when data changes', () async {
        final stream = repository.watchParties('Customer');

        // First emission should be empty
        expect(
          stream,
          emitsInOrder([
            isEmpty, // Initial empty state
            hasLength(1), // After adding one party
          ]),
        );

        // Add a party after a small delay to ensure stream is listening
        await Future.delayed(const Duration(milliseconds: 50));
        await repository.addParty(PartiesCompanion.insert(
          name: 'Stream Test',
          mobile: '9876543210',
          type: 'Customer',
        ));
      });
    });
  });
}
