import 'package:drift/drift.dart';
import 'package:goldbook_desktop/core/database/database.dart';

/// Helper class to create test purchase entries with metal receipt and payment
/// This can be used to test the purchase entry functionality
class TestPurchaseCreator {
  final AppDatabase db;

  TestPurchaseCreator(this.db);

  /// Creates a test purchase entry similar to the format from GoldBook website
  /// Includes regular items, metal receipt, and metal payment
  Future<int> createTestPurchase({
    required int supplierId,
    int? itemId1,
    int? itemId2,
    DateTime? date,
  }) async {
    final now = date ?? DateTime.now();

    // Create the purchase transaction header
    final purchaseId = await db
        .into(db.transactions)
        .insert(
          TransactionsCompanion(
            transactionNumber: Value(
              'PUR-TEST-${DateTime.now().millisecondsSinceEpoch}',
            ),
            partyPoNumber: const Value('PO-TEST-123'),
            date: Value(now),
            partyId: Value(supplierId),
            type: const Value('Purchase'),
            paymentMethod: const Value('Cash'),
            paymentReference: const Value('CHQ-12345'),
            totalGoldWeight: const Value(150.0), // Will be recalculated
            totalSilverWeight: const Value(0.0),
            subtotal: const Value(960000.0),
            discountAmount: const Value(5000.0),
            discountPercentage: const Value(0.52),
            taxAmount: const Value(0.0),
            taxPercentage: const Value(0.0),
            totalAmount: const Value(955000.0),
            status: const Value('Completed'),
            dueDays: const Value(15),
            dueDate: Value(now.add(const Duration(days: 15))),
            remarks: const Value(
              'Test purchase with metal receipt and payment',
            ),
          ),
        );

    // Regular purchase line items
    final lines = <TransactionLinesCompanion>[];

    if (itemId1 != null) {
      lines.add(
        TransactionLinesCompanion(
          transactionId: Value(purchaseId),
          itemId: Value(itemId1),
          description: const Value('Gold Ring Men'),
          grossWeight: const Value(10.0),
          netWeight: const Value(10.0),
          purity: const Value(916),
          rate: const Value(6400),
          amount: const Value(64000),
          makingCharges: const Value(500),
          qty: const Value(1.0),
        ),
      );
    }

    if (itemId2 != null) {
      lines.add(
        TransactionLinesCompanion(
          transactionId: Value(purchaseId),
          itemId: Value(itemId2),
          description: const Value('Gold Chain 22K'),
          grossWeight: const Value(90.0),
          netWeight: const Value(90.0),
          purity: const Value(916),
          rate: const Value(6400),
          amount: const Value(576000),
          makingCharges: const Value(4500),
          qty: const Value(1.0),
        ),
      );
    }

    // Metal Receipt Line (M-Rec:)
    // Gross: 52.000, Less: 0.500, Net: 51.500, Touch: 99.50, Wastage: 0.50
    // Fine weight = net * ((touch + wastage) / 100) = 51.5 * ((99.5 + 0.5) / 100) = 51.5
    final metalReceiptNetWeight = 51.5;
    final metalReceiptTouch = 99.5;
    final metalReceiptWastage = 0.5;
    final metalReceiptFineWeight =
        metalReceiptNetWeight *
        ((metalReceiptTouch + metalReceiptWastage) / 100);

    lines.add(
      TransactionLinesCompanion(
        transactionId: Value(purchaseId),
        itemId: const Value(null),
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
    // Gross: 25.000, Less: 0.200, Net: 24.800, Touch: 99.00, Wastage: 1.00
    // Fine weight = net * ((touch + wastage) / 100) = 24.8 * ((99.0 + 1.0) / 100) = 24.8
    final metalPaymentNetWeight = 24.8;
    final metalPaymentTouch = 99.0;
    final metalPaymentWastage = 1.0;
    final metalPaymentFineWeight =
        metalPaymentNetWeight *
        ((metalPaymentTouch + metalPaymentWastage) / 100);

    lines.add(
      TransactionLinesCompanion(
        transactionId: Value(purchaseId),
        itemId: const Value(null),
        description: const Value('M-Pay:Fine Gold'),
        grossWeight: const Value(25.0),
        netWeight: Value(metalPaymentFineWeight), // Fine weight stored here
        purity: Value(metalPaymentTouch),
        wastage: Value(metalPaymentWastage),
        lineType: const Value('Debit'), // Metal payment is debit
        qty: const Value(1.0),
      ),
    );

    // Insert all lines
    await db.batch((batch) {
      for (var line in lines) {
        batch.insert(db.transactionLines, line);
      }
    });

    return purchaseId;
  }
}
