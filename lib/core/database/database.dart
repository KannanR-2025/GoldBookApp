import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// --- Tables ---

class Parties extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get mobile => text().withLength(min: 0, max: 20)();
  TextColumn get email => text().nullable()();
  TextColumn get companyName => text().nullable()();

  // Extra Details
  TextColumn get code => text().nullable()();
  TextColumn get title => text().nullable()(); // Mr, Mrs, Ms, Dr
  TextColumn get contactPerson => text().nullable()();
  TextColumn get workPhone => text().nullable()(); // Additional to mobile
  TextColumn get whatsappNumber => text().nullable()();
  TextColumn get alternatePhone => text().nullable()();
  TextColumn get courier => text().nullable()();
  TextColumn get notes => text().nullable()();

  // Personal Details
  TextColumn get gender => text().nullable()(); // Male, Female, Other
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  DateTimeColumn get anniversaryDate => dateTime().nullable()();

  // Business Details
  TextColumn get referredBy => text().nullable()(); // Reference/Referred By
  TextColumn get status =>
      text().withDefault(const Constant('Active'))(); // Active, Inactive
  RealColumn get discountPercentage =>
      real().withDefault(const Constant(0.0))();
  TextColumn get paymentTerms =>
      text().nullable()(); // e.g., "Net 30", "Due on Receipt"

  // Bank Details
  TextColumn get bankName => text().nullable()();
  TextColumn get bankAccountNumber => text().nullable()();
  TextColumn get ifscCode => text().nullable()();

  // Tracking
  DateTimeColumn get lastVisitDate => dateTime().nullable()();

  // Tax
  TextColumn get taxPreference =>
      text().withDefault(const Constant('Taxable'))(); // Taxable, Exempt

  // Address Extras
  TextColumn get landmark => text().nullable()();
  TextColumn get country => text().withDefault(const Constant('India'))();

  // Address
  TextColumn get address =>
      text().nullable()(); // Keeping for backward compat, or map to Line 1
  TextColumn get addressLine1 => text().nullable()();
  TextColumn get addressLine2 => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get pinCode => text().nullable()();

  TextColumn get type => text()(); // 'Customer' or 'Supplier'

  // Tax & Identity
  TextColumn get gstin => text().nullable()();
  TextColumn get panNumber => text().nullable()();

  // Balances
  RealColumn get openingGoldBalance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get openingSilverBalance =>
      real().withDefault(const Constant(0.0))();
  RealColumn get openingCashBalance =>
      real().withDefault(const Constant(0.0))();

  RealColumn get goldBalance => real().withDefault(const Constant(0.0))();
  RealColumn get silverBalance => real().withDefault(const Constant(0.0))();
  RealColumn get cashBalance => real().withDefault(const Constant(0.0))();

  // Limits
  RealColumn get creditLimitGold => real().withDefault(const Constant(0.0))();
  RealColumn get creditLimitCash => real().withDefault(const Constant(0.0))();

  // Metadata
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Default Values
  RealColumn get defaultWastage => real().nullable()();
  RealColumn get defaultRate => real().nullable()();
}

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()(); // Item Code/SKU
  TextColumn get metalType => text()(); // 'Gold' or 'Silver'
  TextColumn get purity => text().nullable()(); // e.g. '916', '750'
  TextColumn get category =>
      text().nullable()(); // Ring, Necklace, Earring, etc.
  TextColumn get description => text().nullable()();

  // Tax & Compliance
  TextColumn get hsnCode => text().nullable()(); // HSN Code for GST

  // Pricing
  RealColumn get costPrice => real().withDefault(const Constant(0.0))();
  RealColumn get sellingPrice => real().withDefault(const Constant(0.0))();
  RealColumn get makingCharges => real().withDefault(const Constant(0.0))();
  RealColumn get wastagePercentage => real().withDefault(const Constant(0.0))();

  // Stock
  RealColumn get stockQty => real().withDefault(const Constant(0.0))();
  RealColumn get stockWeight =>
      real().withDefault(const Constant(0.0))(); // Total Weight
  RealColumn get minimumStockLevel => real().withDefault(const Constant(0.0))();
  RealColumn get reorderLevel => real().withDefault(const Constant(0.0))();
  TextColumn get unitOfMeasurement =>
      text().withDefault(const Constant('g'))(); // g, pcs, etc.

  // Additional Details
  TextColumn get brand => text().nullable()();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get size => text().nullable()(); // Size/Variant
  TextColumn get color => text().nullable()();
  TextColumn get stamp => text().nullable()();
  TextColumn get stoneDetails => text().nullable()(); // Stone information
  TextColumn get status =>
      text().withDefault(const Constant('Active'))(); // Active, Inactive
  TextColumn get notes => text().nullable()();

  // Web Parity Fields
  TextColumn get itemType =>
      text().withDefault(const Constant('Goods'))(); // Goods, Service
  TextColumn get maintainStockIn =>
      text().withDefault(const Constant('Grams'))(); // Grams, Pcs, etc.
  BoolColumn get isStudded =>
      boolean().withDefault(const Constant(false))(); // Yes/No
  BoolColumn get fetchGoldRate =>
      boolean().withDefault(const Constant(false))(); // Yes/No
  TextColumn get defaultGoldRate => text().nullable()(); // 22k, 18k, etc.
  RealColumn get defaultTouch => real().withDefault(const Constant(0.0))();

  // Tax & Accounting
  TextColumn get taxPreference =>
      text().withDefault(const Constant('Taxable'))(); // Taxable, Exempt
  RealColumn get purchaseWastage => real().withDefault(const Constant(0.0))();
  RealColumn get purchaseMakingCharges =>
      real().withDefault(const Constant(0.0))();
  RealColumn get jobworkRate => real().withDefault(const Constant(0.0))();
  TextColumn get discountLedger => text().nullable()();

  // Inventory Control
  TextColumn get stockMethod =>
      text().withDefault(const Constant('Loose'))(); // Loose, Tag
  TextColumn get tagPrefix => text().nullable()();

  // Detailed Stock Limits
  RealColumn get minStockPcs => real().withDefault(const Constant(0.0))();
  RealColumn get maxStockGm => real().withDefault(const Constant(0.0))();
  RealColumn get maxStockPcs => real().withDefault(const Constant(0.0))();
  TextColumn get photoPath => text().nullable()(); // For image path

  // Metadata
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get transactionNumber =>
      text().nullable()(); // Invoice/Transaction Number
  DateTimeColumn get date => dateTime()();
  IntColumn get partyId => integer().references(Parties, #id)();
  TextColumn get type => text()(); // 'Sale', 'Purchase', 'Receipt', 'Payment'

  // Payment Details
  TextColumn get paymentMethod =>
      text().nullable()(); // Cash, Card, UPI, Cheque, etc.
  TextColumn get paymentReference =>
      text().nullable()(); // Cheque No, Transaction ID, etc.
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get discountPercentage =>
      real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get taxPercentage => real().withDefault(const Constant(0.0))();

  // Totals
  RealColumn get totalGoldWeight => real().withDefault(const Constant(0.0))();
  RealColumn get totalSilverWeight => real().withDefault(const Constant(0.0))();
  RealColumn get subtotal =>
      real().withDefault(const Constant(0.0))(); // Before discount/tax
  RealColumn get totalAmount =>
      real().withDefault(const Constant(0.0))(); // Final amount

  TextColumn get remarks => text().nullable()();
  TextColumn get status => text().withDefault(
    const Constant('Draft'),
  )(); // Draft, Completed, Cancelled

  // Additional Fields
  IntColumn get dueDays => integer().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get partyPoNumber => text().nullable()();
}

class TransactionLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get itemId => integer().nullable().references(Items, #id)();

  // Details
  TextColumn get description =>
      text().nullable()(); // Item Name copy or description
  RealColumn get grossWeight => real().withDefault(const Constant(0.0))();
  RealColumn get netWeight => real().withDefault(const Constant(0.0))();
  RealColumn get purity => real().nullable()(); // Numeric for calculation
  RealColumn get stoneWeight => real().withDefault(const Constant(0.0))();
  RealColumn get wastage => real().withDefault(const Constant(0.0))();
  RealColumn get makingCharges => real().withDefault(const Constant(0.0))();
  RealColumn get rate => real().withDefault(const Constant(0.0))();
  RealColumn get amount => real().withDefault(const Constant(0.0))();

  // Additional Fields
  TextColumn get stamp => text().nullable()();
  TextColumn get size => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get rateOn =>
      text().nullable()(); // 'Net Weight', 'Fine Weight', 'Fixed'
  RealColumn get ghatWeight => real().withDefault(const Constant(0.0))();

  // Stock
  RealColumn get qty => real().withDefault(const Constant(0.0))();

  // Journal/Transfer
  TextColumn get lineType => text().nullable()(); // 'Debit', 'Credit'
}

// --- Database ---

@DriftDatabase(tables: [Parties, Items, Transactions, TransactionLines])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for testing with a custom executor (e.g., in-memory database)
  AppDatabase.forTesting(super.executor);

  @override
  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 4) {
          // ... (existing migrations)
        }
        // ... (existing migrations)
        if (from < 8) {
          // Add new columns for version 8 (Web Parity)
          await m.addColumn(transactions, transactions.dueDays);
          await m.addColumn(transactions, transactions.dueDate);
          await m.addColumn(transactions, transactions.partyPoNumber);

          await m.addColumn(transactionLines, transactionLines.stamp);
          await m.addColumn(transactionLines, transactionLines.size);
          await m.addColumn(transactionLines, transactionLines.color);
          await m.addColumn(transactionLines, transactionLines.rateOn);
          await m.addColumn(transactionLines, transactionLines.ghatWeight);

          await m.addColumn(parties, parties.defaultWastage);
          await m.addColumn(parties, parties.defaultRate);
        }
        if (from < 9) {
          // Add color and stamp columns to Items table
          await m.addColumn(items, items.stamp);
        }
        if (from < 10) {
          // Version 10: Sync with Web App Fields
          await m.addColumn(items, items.itemType);
          await m.addColumn(items, items.maintainStockIn);
          await m.addColumn(items, items.isStudded);
          await m.addColumn(items, items.fetchGoldRate);
          await m.addColumn(items, items.defaultGoldRate);
          await m.addColumn(items, items.defaultTouch);
          await m.addColumn(items, items.taxPreference);
          await m.addColumn(items, items.purchaseWastage);
          await m.addColumn(items, items.purchaseMakingCharges);
          await m.addColumn(items, items.jobworkRate);
          await m.addColumn(items, items.discountLedger);
          await m.addColumn(items, items.stockMethod);
          await m.addColumn(items, items.tagPrefix);
          await m.addColumn(items, items.minStockPcs);
          await m.addColumn(items, items.maxStockGm);
          await m.addColumn(items, items.maxStockPcs);
          await m.addColumn(items, items.photoPath);
        }
        if (from < 11) {
          // Version 11: Transaction Lines Quantity
          await m.addColumn(transactionLines, transactionLines.qty);
        }
        if (from < 13) {
          // Version 13: Transaction Lines Line Type (Debit/Credit)
          await m.addColumn(transactionLines, transactionLines.lineType);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'goldbook_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// --- Provider ---

// Singleton instance to ensure only one database connection
AppDatabase? _databaseInstance;

AppDatabase getDatabaseInstance() {
  _databaseInstance ??= AppDatabase();
  return _databaseInstance!;
}

// --- Provider ---

final databaseProvider = Provider<AppDatabase>((ref) {
  // Use the singleton instance to avoid multiple database connections
  final db = getDatabaseInstance();
  ref.onDispose(() {
    // Only close if this is the last reference
    // In a real app, you might want more sophisticated lifecycle management
  });
  return db;
});
