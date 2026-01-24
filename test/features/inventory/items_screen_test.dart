import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/inventory/items_provider.dart';
import 'package:goldbook_desktop/features/inventory/items_screen.dart';

void main() {
  group('ItemsScreen', () {
    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsListProvider.overrideWith((ref) {
              return Stream<List<Item>>.empty();
            }),
          ],
          child: const MaterialApp(home: ItemsScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty message when no items exist', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsListProvider.overrideWith((ref) {
              return Stream.value(<Item>[]);
            }),
          ],
          child: const MaterialApp(home: ItemsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('No items found. Add one to get started.'),
        findsOneWidget,
      );
    });

    testWidgets('displays correct title and add button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsListProvider.overrideWith((ref) {
              return Stream.value(<Item>[]);
            }),
          ],
          child: const MaterialApp(home: ItemsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Items'), findsOneWidget);
      expect(find.text('New Item'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('displays data table headers when items exist', (tester) async {
      // Set desktop screen size to avoid overflow
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testItem = Item(
        id: 1,
        name: 'Gold Ring',
        metalType: 'Gold',
        status: 'Active',
        costPrice: 50000,
        sellingPrice: 60000,
        makingCharges: 3000,
        wastagePercentage: 2.0,
        stockQty: 5,
        stockWeight: 25.0,
        minimumStockLevel: 2,
        reorderLevel: 3,
        unitOfMeasurement: 'g',
        itemType: 'Goods',
        maintainStockIn: 'Grams',
        isStudded: false,
        fetchGoldRate: false,
        defaultTouch: 0,
        taxPreference: 'Taxable',
        purchaseWastage: 0,
        purchaseMakingCharges: 0,
        jobworkRate: 0,
        stockMethod: 'Loose',
        minStockPcs: 0,
        maxStockGm: 0,
        maxStockPcs: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsListProvider.overrideWith((ref) {
              return Stream.value([testItem]);
            }),
          ],
          child: const MaterialApp(home: ItemsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Check table headers
      expect(find.text('Code'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Metal'), findsOneWidget);
      expect(find.text('Purity'), findsOneWidget);
      expect(find.text('Stock Qty'), findsOneWidget);
      expect(find.text('Weight (g)'), findsOneWidget);
      expect(find.text('Selling Price'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Actions'), findsOneWidget);
    });

    testWidgets('displays item data in table', (tester) async {
      // Set desktop screen size to avoid overflow
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testItem = Item(
        id: 1,
        name: 'Diamond Necklace',
        code: 'DN-001',
        metalType: 'Gold',
        purity: '916',
        category: 'Necklace',
        status: 'Active',
        costPrice: 50000,
        sellingPrice: 75000,
        makingCharges: 5000,
        wastagePercentage: 2.5,
        stockQty: 3,
        stockWeight: 45.5,
        minimumStockLevel: 1,
        reorderLevel: 2,
        unitOfMeasurement: 'g',
        itemType: 'Goods',
        maintainStockIn: 'Grams',
        isStudded: false,
        fetchGoldRate: false,
        defaultTouch: 0,
        taxPreference: 'Taxable',
        purchaseWastage: 0,
        purchaseMakingCharges: 0,
        jobworkRate: 0,
        stockMethod: 'Loose',
        minStockPcs: 0,
        maxStockGm: 0,
        maxStockPcs: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsListProvider.overrideWith((ref) {
              return Stream.value([testItem]);
            }),
          ],
          child: const MaterialApp(home: ItemsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Check item data is displayed
      expect(find.text('DN-001'), findsOneWidget);
      expect(find.text('Diamond Necklace'), findsOneWidget);
      expect(find.text('Necklace'), findsOneWidget);
      expect(find.text('Gold'), findsOneWidget);
      expect(find.text('916'), findsOneWidget);
      expect(find.text('3.0'), findsOneWidget); // Stock Qty
      expect(find.text('45.500 g'), findsOneWidget); // Weight
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('displays edit button for each item', (tester) async {
      // Set desktop screen size to avoid overflow
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testItem = Item(
        id: 1,
        name: 'Test Item',
        metalType: 'Gold',
        status: 'Active',
        costPrice: 0,
        sellingPrice: 0,
        makingCharges: 0,
        wastagePercentage: 0,
        stockQty: 0,
        stockWeight: 0,
        minimumStockLevel: 0,
        reorderLevel: 0,
        unitOfMeasurement: 'g',
        itemType: 'Goods',
        maintainStockIn: 'Grams',
        isStudded: false,
        fetchGoldRate: false,
        defaultTouch: 0,
        taxPreference: 'Taxable',
        purchaseWastage: 0,
        purchaseMakingCharges: 0,
        jobworkRate: 0,
        stockMethod: 'Loose',
        minStockPcs: 0,
        maxStockGm: 0,
        maxStockPcs: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsListProvider.overrideWith((ref) {
              return Stream.value([testItem]);
            }),
          ],
          child: const MaterialApp(home: ItemsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('displays error message on error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itemsListProvider.overrideWith((ref) {
              return Stream<List<Item>>.error('Database error');
            }),
          ],
          child: const MaterialApp(home: ItemsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });
  });

  // Note: ItemEntryScreen tests are limited because the screen uses
  // DropdownButtonFormField with 'initialValue' which is not a valid parameter.
  // It should use 'value' instead. This is a bug that needs to be fixed.
  group('ItemEntryScreen', () {
    testWidgets('displays correct title for new item', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ItemEntryScreen())),
      );

      await tester.pump();

      expect(find.text('Add New Item'), findsOneWidget);
    });

    testWidgets('displays all tabs', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ItemEntryScreen())),
      );

      await tester.pump();

      expect(find.text('Basic Info'), findsOneWidget);
      expect(find.text('Pricing'), findsOneWidget);
      expect(find.text('Stock'), findsOneWidget);
      expect(find.text('Additional'), findsOneWidget);
    });

    testWidgets('displays Save and Cancel buttons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ItemEntryScreen())),
      );

      await tester.pump();

      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
