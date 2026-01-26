import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/core/database/database.dart';

class TransactionWithParty {
  final Transaction transaction;
  final Party party;

  TransactionWithParty(this.transaction, this.party);
}

class TransactionsRepository {
  final AppDatabase _db;
  TransactionsRepository(this._db);

  Stream<List<TransactionWithParty>> watchTransactions() {
    final query = _db.select(_db.transactions).join([
      innerJoin(
        _db.parties,
        _db.parties.id.equalsExp(_db.transactions.partyId),
      ),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithParty(
          row.readTable(_db.transactions),
          row.readTable(_db.parties),
        );
      }).toList();
    });
  }

  Future<int> getOrCreateSystemParty() async {
    final party = await (_db.select(
      _db.parties,
    )..where((t) => t.name.equals('Stock Adjustments'))).getSingleOrNull();
    if (party != null) return party.id;

    return _db
        .into(_db.parties)
        .insert(
          PartiesCompanion(
            name: const Value('Stock Adjustments'),
            type: const Value('System'), // Tag as System
            city: const Value('Internal'),
            mobile: const Value(''),
          ),
        );
  }

  Future<void> createTransaction({
    required TransactionsCompanion header,
    required List<TransactionLinesCompanion> lines,
  }) {
    return _db.transaction(() async {
      // 1. Insert Header
      final transactionId = await _db.into(_db.transactions).insert(header);

      // 2. Insert Lines
      for (var line in lines) {
        await _db
            .into(_db.transactionLines)
            .insert(line.copyWith(transactionId: Value(transactionId)));

        // Update Item Stock if applicable
        if (line.itemId.value != null) {
          final item = await (_db.select(
            _db.items,
          )..where((t) => t.id.equals(line.itemId.value!))).getSingle();

          double qtyChange = 0;
          double weightChange = 0;

          if (header.type.value == 'Inventory Adjustment') {
            // Positive Qty = Stock Increase (e.g. Found)
            // Negative Qty = Stock Decrease (e.g. Loss)
            qtyChange = line.qty.value;
            weightChange = line.netWeight.value;
          } else if (header.type.value == 'Stock Transfer') {
            // Journal Style
            final type = line.lineType.value;
            if (type == 'Debit') {
              // Outward / Issue -> Stock Decrease
              qtyChange = -(line.qty.value);
              weightChange = -line.netWeight.value;
            } else if (type == 'Credit') {
              // Inward / Receipt -> Stock Increase
              qtyChange = line.qty.value;
              weightChange = line.netWeight.value;
            }
          } else if (header.type.value == 'Sale' ||
              header.type.value == 'Metal Issue') {
            // Deduct stock
            qtyChange = -(line.qty.value);
            weightChange = -line.netWeight.value;
          } else if (header.type.value == 'Purchase' ||
              header.type.value == 'Metal Receipt') {
            // Add stock
            qtyChange = line.qty.value;
            weightChange = line.netWeight.value;
          }

          if (qtyChange != 0 || weightChange != 0) {
            await _db
                .update(_db.items)
                .replace(
                  item.copyWith(
                    stockQty: item.stockQty + qtyChange,
                    stockWeight: item.stockWeight + weightChange,
                  ),
                );
          }
        }
      }

      // 3. Update Party Balance
      final partyId = header.partyId.value;
      final party = await (_db.select(
        _db.parties,
      )..where((t) => t.id.equals(partyId))).getSingle();

      // Calculate impact based on transaction type
      double goldImpact = 0;
      double silverImpact = 0;
      double cashImpact = 0;

      final type = header.type.value; // Sale, Purchase, Receipt, Payment
      final totalGold = header.totalGoldWeight.value;
      final totalSilver = header.totalSilverWeight.value;
      final totalAmount = header.totalAmount.value;

      if (type == 'Sale') {
        goldImpact = -totalGold; // Party owes gold (debit) or we gave gold?
        // Typically in gold accounting: Sale -> Party Debit (receivable).
        // Let's assume positive balance = Receivable

        // Usually: Sale 100g
        // Party Balance += 100g (He owes us)
        // Stock -= 100g
        goldImpact = totalGold;
        silverImpact = totalSilver;
        cashImpact =
            totalAmount; // If cash sale? Or credit? defaulting to credit/receivable logic
      } else if (type == 'Purchase') {
        goldImpact = -totalGold; // We owe him
        silverImpact = -totalSilver;
        cashImpact = -totalAmount;
      } else if (type == 'Receipt') {
        // We received metal/cash
        goldImpact = -totalGold; // Reduces his debt
        silverImpact = -totalSilver;
        cashImpact = -totalAmount;
      } else if (type == 'Payment') {
        // We gave metal/cash
        goldImpact = totalGold; // Increases his debt / reduces our payable
        silverImpact = totalSilver;
        cashImpact = totalAmount;
      } else if (type == 'Stock Transfer') {
        // Mixed usage: Sum up lines based on type
        // This is tricky because calculateImpact is based on Header Totals usually.
        // But for Stock Transfer, the Header Totals might be "Net Difference" or meaningless.
        // We should traverse lines to get exact impact.
        // HOWEVER, to be efficient, let's assume the UI calculates a Net Difference and stores it in Header.
        // OR better: We simply re-query lines here? No, 'lines' argument is the list of companions.

        for (var line in lines) {
          final lType = line.lineType.value;
          if (lType == 'Debit') {
            goldImpact += line.netWeight.value; // Add to Receivable
          } else if (lType == 'Credit') {
            goldImpact -= line.netWeight.value; // Reduce Receivable
          }
        }
      } else if (type == 'Inventory Adjustment') {
        // No Party Impact for Internal Adjustment
        goldImpact = 0;
        silverImpact = 0;
        cashImpact = 0;
      }

      await _db
          .update(_db.parties)
          .replace(
            party.copyWith(
              goldBalance: party.goldBalance + goldImpact,
              silverBalance: party.silverBalance + silverImpact,
              cashBalance: party.cashBalance + cashImpact,
            ),
          );
    });
  }

  Future<Transaction?> getTransaction(int id) {
    return (_db.select(
      _db.transactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<TransactionLine>> getTransactionLines(int id) {
    return (_db.select(
      _db.transactionLines,
    )..where((t) => t.transactionId.equals(id))).get();
  }

  Future<List<TransactionLine>> getTransactionLinesByItemId(int itemId) {
    return (_db.select(
      _db.transactionLines,
    )..where((t) => t.itemId.equals(itemId))).get();
  }

  Future<String?> getLastTransactionNumberForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final transactions = await (_db.select(
      _db.transactions,
    )
      ..where((t) => t.date.isBiggerOrEqualValue(startOfDay))
      ..where((t) => t.date.isSmallerThanValue(endOfDay))
      ..where((t) => t.type.equals('Sale'))
      ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .get();
    
    if (transactions.isEmpty) return null;
    
    // Find the last transaction with a number
    for (var txn in transactions) {
      if (txn.transactionNumber != null && txn.transactionNumber!.isNotEmpty) {
        return txn.transactionNumber;
      }
    }
    
    return null;
  }

  Future<void> deleteTransaction(int id) {
    return _db.transaction(() async {
      // 1. Fetch Transaction to reverse balance
      final txn = await (_db.select(
        _db.transactions,
      )..where((t) => t.id.equals(id))).getSingle();

      final party = await (_db.select(
        _db.parties,
      )..where((t) => t.id.equals(txn.partyId))).getSingle();

      // 2. Fetch lines to reverse stock
      final lines = await (_db.select(
        _db.transactionLines,
      )..where((t) => t.transactionId.equals(id))).get();

      // 3. Reverse Stock for each line item
      for (var line in lines) {
        if (line.itemId != null) {
          final item = await (_db.select(
            _db.items,
          )..where((t) => t.id.equals(line.itemId!))).getSingle();

          double qtyChange = 0;
          double weightChange = 0;

          if (txn.type == 'Inventory Adjustment') {
            // Reverse: negative of original
            qtyChange = -line.qty;
            weightChange = -line.netWeight;
          } else if (txn.type == 'Stock Transfer') {
            final type = line.lineType;
            if (type == 'Debit') {
              // Was decrease, reverse to increase
              qtyChange = line.qty;
              weightChange = line.netWeight;
            } else if (type == 'Credit') {
              // Was increase, reverse to decrease
              qtyChange = -line.qty;
              weightChange = -line.netWeight;
            }
          } else if (txn.type == 'Sale' || txn.type == 'Metal Issue') {
            // Was decrease, reverse to increase
            qtyChange = line.qty;
            weightChange = line.netWeight;
          } else if (txn.type == 'Purchase' || txn.type == 'Metal Receipt') {
            // Was increase, reverse to decrease
            qtyChange = -line.qty;
            weightChange = -line.netWeight;
          }

          if (qtyChange != 0 || weightChange != 0) {
            await _db
                .update(_db.items)
                .replace(
                  item.copyWith(
                    stockQty: item.stockQty + qtyChange,
                    stockWeight: item.stockWeight + weightChange,
                  ),
                );
          }
        }
      }

      // 4. Reverse Party Balance
      double revGold = 0;
      double revSilver = 0;
      double revCash = 0;

      if (txn.type == 'Sale') {
        revGold = -txn.totalGoldWeight;
        revSilver = -txn.totalSilverWeight;
        revCash = -txn.totalAmount;
      } else if (txn.type == 'Purchase') {
        revGold = txn.totalGoldWeight;
        revSilver = txn.totalSilverWeight;
        revCash = txn.totalAmount;
      } else if (txn.type == 'Receipt') {
        revGold = txn.totalGoldWeight;
        revSilver = txn.totalSilverWeight;
        revCash = txn.totalAmount;
      } else if (txn.type == 'Payment') {
        revGold = -txn.totalGoldWeight;
        revSilver = -txn.totalSilverWeight;
        revCash = -txn.totalAmount;
      } else if (txn.type == 'Stock Transfer') {
        for (var line in lines) {
          final lType = line.lineType;
          if (lType == 'Debit') {
            revGold -= line.netWeight;
          } else if (lType == 'Credit') {
            revGold += line.netWeight;
          }
        }
      }

      await _db
          .update(_db.parties)
          .replace(
            party.copyWith(
              goldBalance: party.goldBalance + revGold,
              silverBalance: party.silverBalance + revSilver,
              cashBalance: party.cashBalance + revCash,
            ),
          );

      // 5. Delete transaction lines
      await (_db.delete(
        _db.transactionLines,
      )..where((t) => t.transactionId.equals(id))).go();

      // 6. Delete transaction
      await (_db.delete(
        _db.transactions,
      )..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> updateTransaction({
    required int id,
    required TransactionsCompanion header,
    required List<TransactionLinesCompanion> lines,
  }) {
    return _db.transaction(() async {
      // 1. Fetch Old Transaction to reverse balance
      final oldTxn = await (_db.select(
        _db.transactions,
      )..where((t) => t.id.equals(id))).getSingle();
      final oldParty = await (_db.select(
        _db.parties,
      )..where((t) => t.id.equals(oldTxn.partyId))).getSingle();

      // Reverse Old Impact
      double revGold = 0;
      double revSilver = 0;
      double revCash = 0;
      final oldType = oldTxn.type;

      if (oldType == 'Sale') {
        revGold = -oldTxn.totalGoldWeight;
        revSilver = -oldTxn.totalSilverWeight;
        revCash = -oldTxn.totalAmount;
      } else if (oldType == 'Purchase') {
        revGold = oldTxn.totalGoldWeight;
        revSilver = oldTxn.totalSilverWeight;
        revCash = oldTxn.totalAmount;
      } else if (oldType == 'Receipt') {
        revGold = oldTxn.totalGoldWeight;
        revSilver = oldTxn.totalSilverWeight;
        revCash = oldTxn.totalAmount;
      } else if (oldType == 'Payment') {
        revGold = -oldTxn.totalGoldWeight;
        revSilver = -oldTxn.totalSilverWeight;
        revCash = -oldTxn.totalAmount;
      } else if (oldType == 'Stock Transfer') {
        // Fetch old lines to reverse mixed impact
        final oldLines = await (_db.select(
          _db.transactionLines,
        )..where((t) => t.transactionId.equals(id))).get();

        for (var line in oldLines) {
          final lType = line.lineType;
          if (lType == 'Debit') {
            // Was +Receivable, so Reversal is -Receivable
            revGold -= line.netWeight;
          } else if (lType == 'Credit') {
            // Was -Receivable, so Reversal is +Receivable
            revGold += line.netWeight;
          }
        }
      }

      await _db
          .update(_db.parties)
          .replace(
            oldParty.copyWith(
              goldBalance: oldParty.goldBalance + revGold,
              silverBalance: oldParty.silverBalance + revSilver,
              cashBalance: oldParty.cashBalance + revCash,
            ),
          );

      // 2. Update Header
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(id))).write(header);

      // 3. Replace Lines
      await (_db.delete(
        _db.transactionLines,
      )..where((t) => t.transactionId.equals(id))).go();
      for (var line in lines) {
        await _db
            .into(_db.transactionLines)
            .insert(line.copyWith(transactionId: Value(id)));
      }

      // 4. Apply New Impact
      // Fetch latest party state (after reversal)
      final currentParty = await (_db.select(
        _db.parties,
      )..where((t) => t.id.equals(header.partyId.value))).getSingle();

      double newGold = 0;
      double newSilver = 0;
      double newCash = 0;
      final newType = header.type.value;
      final tGold = header.totalGoldWeight.value;
      final tSilver = header.totalSilverWeight.value;
      final tCash = header.totalAmount.value;

      if (newType == 'Sale') {
        newGold = tGold;
        newSilver = tSilver;
        newCash = tCash;
      } else if (newType == 'Purchase') {
        newGold = -tGold;
        newSilver = -tSilver;
        newCash = -tCash;
      } else if (newType == 'Receipt') {
        newGold = -tGold;
        newSilver = -tSilver;
        newCash = -tCash;
      } else if (newType == 'Payment') {
        newGold = tGold;
        newSilver = tSilver;
        newCash = tCash;
      }

      await _db
          .update(_db.parties)
          .replace(
            currentParty.copyWith(
              goldBalance: currentParty.goldBalance + newGold,
              silverBalance: currentParty.silverBalance + newSilver,
              cashBalance: currentParty.cashBalance + newCash,
            ),
          );
    });
  }
}

final transactionsRepositoryProvider = Provider((ref) {
  return TransactionsRepository(ref.watch(databaseProvider));
});
