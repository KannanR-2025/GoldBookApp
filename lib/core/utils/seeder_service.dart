import 'package:drift/drift.dart';
import 'package:goldbook_desktop/core/database/database.dart';

class SeederService {
  final AppDatabase db;

  SeederService(this.db);

  Future<void> seedData() async {
    await _seedParties();
    await _seedItems();
    await _seedTransactions();
  }

  Future<void> _seedParties() async {
    final count = await db.parties.count().getSingle();
    if (count > 0) return; // Already seeded

    final parties = [
      PartiesCompanion(
        type: const Value('Customer'),
        name: const Value('Ravi Jewellers'),
        companyName: const Value('Ravi Jewellers Pvt Ltd'),
        mobile: const Value('9876543210'),
        city: const Value('Chennai'),
        state: const Value('Tamil Nadu'),
        status: const Value('Active'),
        goldBalance: const Value(150.500), // Opening Balance
        cashBalance: const Value(-50000), // Credit
        openingGoldBalance: const Value(150.500),
        openingCashBalance: const Value(-50000),
        defaultWastage: const Value(1.5),
        defaultRate: const Value(0),
      ),
      PartiesCompanion(
        type: const Value('Customer'),
        name: const Value('Lakshmi Gold House'),
        companyName: const Value('Lakshmi Gold House'),
        mobile: const Value('9988776655'),
        city: const Value('Madurai'),
        state: const Value('Tamil Nadu'),
        status: const Value('Active'),
        goldBalance: const Value(0),
        cashBalance: const Value(0),
      ),
      PartiesCompanion(
        type: const Value('Customer'),
        name: const Value('Priya S.'),
        mobile: const Value('8877665544'),
        city: const Value('Trichy'),
        state: const Value('Tamil Nadu'),
        status: const Value('Active'),
        title: const Value('Ms'),
        gender: const Value('Female'),
      ),
      // Suppliers
      PartiesCompanion(
        type: const Value('Supplier'),
        name: const Value('KGC Bullion'),
        companyName: const Value('KGC Bullion Refineries'),
        mobile: const Value('9112233445'),
        city: const Value('Mumbai'),
        state: const Value('Maharashtra'),
        status: const Value('Active'),
        goldBalance: const Value(-1000.000), // We owe them gold
      ),
    ];

    await db.batch((batch) {
      batch.insertAll(db.parties, parties);
    });
  }

  Future<void> _seedItems() async {
    final count = await db.items.count().getSingle();
    if (count > 0) return;

    final items = [
      ItemsCompanion(
        name: const Value('Gold Chain 22K'),
        code: const Value('GC-001'),
        metalType: const Value('Gold'),
        purity: const Value('916'),
        category: const Value('Chain'),
        stockQty: const Value(50),
        stockWeight: const Value(500.000),
        unitOfMeasurement: const Value('g'),
        makingCharges: const Value(450), // per gram
        sellingPrice: const Value(0), // Dependent on rate
        status: const Value('Active'),
      ),
      ItemsCompanion(
        name: const Value('Silver Anklet'),
        code: const Value('SA-001'),
        metalType: const Value('Silver'),
        purity: const Value('925'),
        category: const Value('Anklet'),
        stockQty: const Value(100),
        stockWeight: const Value(1000.000),
        color: const Value('White'),
        makingCharges: const Value(50),
        status: const Value('Active'),
      ),
      ItemsCompanion(
        name: const Value('Gold Ring Men'),
        code: const Value('GR-002'),
        metalType: const Value('Gold'),
        purity: const Value('916'),
        category: const Value('Ring'),
        stockQty: const Value(20),
        stockWeight: const Value(100.000),
        stamp: const Value('916 BIS'),
        status: const Value('Active'),
      ),
      ItemsCompanion(
        name: const Value('Diamond Earring'),
        code: const Value('DE-005'),
        metalType: const Value('Gold'),
        purity: const Value('750'),
        stockQty: const Value(10),
        stockWeight: const Value(50.000),
        stoneDetails: const Value('10 cents per piece'),
        category: const Value('Earring'),
        status: const Value('Active'),
      ),
    ];

    await db.batch((batch) {
      batch.insertAll(db.items, items);
    });
  }

  Future<void> _seedTransactions() async {
    final count = await db.transactions.count().getSingle();
    if (count > 0) return;

    // Get IDs
    final ravi = await (db.select(
      db.parties,
    )..where((t) => t.name.equals('Ravi Jewellers'))).getSingleOrNull();
    final kgc = await (db.select(
      db.parties,
    )..where((t) => t.name.equals('KGC Bullion'))).getSingleOrNull();
    final chain = await (db.select(
      db.items,
    )..where((t) => t.name.equals('Gold Chain 22K'))).getSingleOrNull();
    final anklet = await (db.select(
      db.items,
    )..where((t) => t.name.equals('Silver Anklet'))).getSingleOrNull();

    if (ravi == null || kgc == null || chain == null || anklet == null) return;

    final now = DateTime.now();

    // 1. Sale to Ravi Jewellers
    // Selling 2 Chains (20g) and 5 Anklets (50g)
    final saleId = await db
        .into(db.transactions)
        .insert(
          TransactionsCompanion(
            transactionNumber: const Value('INV-001'),
            date: Value(now.subtract(const Duration(days: 1))),
            partyId: Value(ravi.id),
            type: const Value('Sale'),
            totalGoldWeight: const Value(20.0),
            totalSilverWeight: const Value(50.0),
            totalAmount: const Value(150000.0),
            status: const Value('Completed'),
            dueDays: const Value(7),
            dueDate: Value(now.add(const Duration(days: 6))),
          ),
        );

    await db.batch((batch) {
      batch.insertAll(db.transactionLines, [
        TransactionLinesCompanion(
          transactionId: Value(saleId),
          itemId: Value(chain.id),
          description: const Value('Gold Chain 22K'),
          grossWeight: const Value(20.0),
          netWeight: const Value(20.0),
          purity: const Value(916),
          rate: const Value(6000),
          amount: const Value(120000),
          makingCharges: const Value(500),
        ),
        TransactionLinesCompanion(
          transactionId: Value(saleId),
          itemId: Value(anklet.id),
          description: const Value('Silver Anklet'),
          grossWeight: const Value(50.0),
          netWeight: const Value(50.0),
          purity: const Value(92.5),
          rate: const Value(80),
          amount: const Value(4000),
          makingCharges: const Value(50),
        ),
      ]);
    });

    // Update Ravi's Balance (Debit: He owes us)
    await db
        .update(db.parties)
        .replace(
          ravi.copyWith(
            goldBalance: ravi.goldBalance + 20.0,
            silverBalance: ravi.silverBalance + 50.0,
            cashBalance: ravi.cashBalance + 150000.0,
          ),
        );

    // 2. Purchase from KGC Bullion
    // Buying 100g Gold Bar
    final purchaseId = await db
        .into(db.transactions)
        .insert(
          TransactionsCompanion(
            transactionNumber: const Value('PUR-001'),
            partyPoNumber: const Value('PO-9988'),
            date: Value(now.subtract(const Duration(days: 3))),
            partyId: Value(kgc.id),
            type: const Value('Purchase'),
            totalGoldWeight: const Value(100.0),
            totalSilverWeight: const Value(0.0),
            totalAmount: const Value(640000.0),
            status: const Value('Completed'),
          ),
        );

    await db
        .into(db.transactionLines)
        .insert(
          TransactionLinesCompanion(
            transactionId: Value(purchaseId),
            description: const Value('Gold Bar 24K'),
            grossWeight: const Value(100.0),
            netWeight: const Value(100.0),
            purity: const Value(999),
            rate: const Value(6400),
            amount: const Value(640000),
          ),
        );

    // Update KGC's Balance (Credit: We owe them)
    // Purchase adds to our stock, but "credits" the supplier.
    // In our logic: Supplier Credit is Negative balance (usually).
    // Or if we follow standard accounting: Credit = Payable.
    // Let's stick to the logic seen in repo: Purchase -> goldImpact = -totalGold.
    await db
        .update(db.parties)
        .replace(
          kgc.copyWith(
            goldBalance: kgc.goldBalance - 100.0,
            cashBalance: kgc.cashBalance - 640000.0,
          ),
        );

    // 3. Test Purchase with Metal Receipt and Payment
    // This purchase includes regular items, metal receipt, and metal payment
    final testPurchaseId = await db
        .into(db.transactions)
        .insert(
          TransactionsCompanion(
            transactionNumber: const Value('PUR-TEST-001'),
            partyPoNumber: const Value('PO-TEST-123'),
            date: Value(now.subtract(const Duration(days: 1))),
            partyId: Value(kgc.id),
            type: const Value('Purchase'),
            paymentMethod: const Value('Cash'),
            paymentReference: const Value('CHQ-12345'),
            totalGoldWeight: const Value(150.0), // 100g items + 50g metal receipt - 0g metal payment
            totalSilverWeight: const Value(0.0),
            subtotal: const Value(960000.0),
            discountAmount: const Value(5000.0),
            discountPercentage: const Value(0.52),
            taxAmount: const Value(0.0),
            taxPercentage: const Value(0.0),
            totalAmount: const Value(955000.0),
            status: const Value('Completed'),
            dueDays: const Value(15),
            dueDate: Value(now.add(const Duration(days: 14))),
            remarks: const Value('Test purchase with metal receipt and payment'),
          ),
        );

    // Regular purchase items
    final ring = await (db.select(
      db.items,
    )..where((t) => t.name.equals('Gold Ring Men'))).getSingleOrNull();
    
    if (ring != null) {
      await db.batch((batch) {
        // Regular purchase line items
        batch.insertAll(db.transactionLines, [
          TransactionLinesCompanion(
            transactionId: Value(testPurchaseId),
            itemId: Value(ring.id),
            description: const Value('Gold Ring Men'),
            grossWeight: const Value(10.0),
            netWeight: const Value(10.0),
            purity: const Value(916),
            rate: const Value(6400),
            amount: const Value(64000),
            makingCharges: const Value(500),
            qty: const Value(1.0),
          ),
          TransactionLinesCompanion(
            transactionId: Value(testPurchaseId),
            itemId: Value(chain.id),
            description: const Value('Gold Chain 22K'),
            grossWeight: const Value(90.0),
            netWeight: const Value(90.0),
            purity: const Value(916),
            rate: const Value(6400),
            amount: const Value(576000),
            makingCharges: const Value(4500),
            qty: const Value(1.0),
          ),
        ]);

        // Metal Receipt Line (M-Rec:)
        // Gross: 52.000, Less: 0.500, Net: 51.500, Touch: 99.50, Wastage: 0.50
        // Fine weight = net * ((touch + wastage) / 100) = 51.5 * ((99.5 + 0.5) / 100) = 51.5
        final metalReceiptNetWeight = 51.5; // Net weight
        final metalReceiptTouch = 99.5;
        final metalReceiptWastage = 0.5;
        final metalReceiptFineWeight = metalReceiptNetWeight * ((metalReceiptTouch + metalReceiptWastage) / 100); // 51.5
        
        batch.insert(
          db.transactionLines,
          TransactionLinesCompanion(
            transactionId: Value(testPurchaseId),
            itemId: const Value(null), // Can be null for metal receipt
            description: const Value('M-Rec:Fine Gold'),
            grossWeight: const Value(52.0),
            netWeight: Value(metalReceiptFineWeight), // Fine weight stored here
            purity: Value(metalReceiptTouch),
            wastage: Value(metalReceiptWastage),
            lineType: const Value('Credit'), // Metal receipt is credit
            qty: const Value(1.0),
          ),
        );

        // Metal Payment Line (M-Pay:)
        // Gross: 25.000, Less: 0.200, Net: 24.800, Touch: 99.00, Wastage: 1.00, Fine: 24.800
        final metalPaymentNetWeight = 24.8; // Net weight
        final metalPaymentTouch = 99.0;
        final metalPaymentWastage = 1.0;
        final metalPaymentFineWeight = metalPaymentNetWeight * ((metalPaymentTouch + metalPaymentWastage) / 100); // 24.8
        
        batch.insert(
          db.transactionLines,
          TransactionLinesCompanion(
            transactionId: Value(testPurchaseId),
            itemId: const Value(null), // Can be null for metal payment
            description: const Value('M-Pay:Fine Gold'),
            grossWeight: const Value(25.0),
            netWeight: Value(metalPaymentFineWeight), // Fine weight stored here
            purity: Value(metalPaymentTouch),
            wastage: Value(metalPaymentWastage),
            lineType: const Value('Debit'), // Metal payment is debit
            qty: const Value(1.0),
          ),
        );
      });
    }

    // Update KGC's Balance for test purchase
    final testPurchaseGoldImpact = 100.0 + 51.515 - 24.8; // Items + Receipt - Payment
    await db
        .update(db.parties)
        .replace(
          kgc.copyWith(
            goldBalance: kgc.goldBalance - testPurchaseGoldImpact,
            cashBalance: kgc.cashBalance - 955000.0,
          ),
        );
  }
}
