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

  // ─── Stock Change Helpers ───────────────────────────────────────────

  /// Calculate stock change for a line from a TransactionLinesCompanion (create/update new lines)
  ({double qty, double weight}) _calcStockChangeForCompanion(
    String txnType,
    TransactionLinesCompanion line,
  ) {
    final lineType = line.lineType.value;
    final desc = line.description.value ?? '';
    final qty = line.qty.value;
    final weight = line.netWeight.value;

    return _calcStockChange(txnType, lineType, desc, qty, weight);
  }

  /// Calculate stock change for a line from a TransactionLine (delete/update old lines)
  ({double qty, double weight}) _calcStockChangeForLine(
    String txnType,
    TransactionLine line,
  ) {
    final lineType = line.lineType ?? '';
    final desc = line.description ?? '';

    return _calcStockChange(txnType, lineType, desc, line.qty, line.netWeight);
  }

  /// Core stock calculation logic
  /// For Sale: regular lines decrease stock, M-Rec increases, M-Pay decreases
  /// For Purchase: regular lines increase stock, M-Rec increases, M-Pay decreases
  /// For MetalTransaction/StockTransfer: Credit increases, Debit decreases
  ({double qty, double weight}) _calcStockChange(
    String txnType,
    String? lineType,
    String desc,
    double qty,
    double weight,
  ) {
    if (txnType == 'Inventory Adjustment') {
      return (qty: qty, weight: weight);
    }

    if (txnType == 'Stock Transfer' || txnType == 'MetalTransaction') {
      if (lineType == 'Debit') {
        return (qty: -qty, weight: -weight);
      } else if (lineType == 'Credit') {
        return (qty: qty, weight: weight);
      }
      return (qty: 0, weight: 0);
    }

    // Sale / Purchase / Metal Issue / Metal Receipt
    final isSpecialLine = desc.startsWith('M-Rec:') ||
        desc.startsWith('M-Pay:') ||
        desc.startsWith('R-Cut:');

    if (isSpecialLine) {
      // M-Rec (Credit) adds stock, M-Pay (Debit) removes stock
      // R-Cut (Credit) adds stock (metal received via rate cut settlement)
      if (lineType == 'Credit') {
        return (qty: qty, weight: weight);
      } else if (lineType == 'Debit') {
        return (qty: -qty, weight: -weight);
      }
      return (qty: 0, weight: 0);
    }

    // Regular lines
    if (txnType == 'Sale' || txnType == 'Metal Issue') {
      return (qty: -qty, weight: -weight);
    } else if (txnType == 'Purchase' || txnType == 'Metal Receipt') {
      return (qty: qty, weight: weight);
    }

    return (qty: 0, weight: 0);
  }

  // ─── Party Balance Helpers ──────────────────────────────────────────

  /// Calculate party balance impact for new lines (TransactionLinesCompanion)
  ({double gold, double silver, double cash}) _calcBalanceImpactFromCompanions(
    String txnType,
    double totalGold,
    double totalSilver,
    double totalAmount,
    List<TransactionLinesCompanion> lines,
  ) {
    double goldImpact = 0;
    double silverImpact = 0;
    double cashImpact = 0;

    if (txnType == 'Sale') {
      // Sale: party owes us gold (+) and cash (+)
      goldImpact = totalGold;
      silverImpact = totalSilver;
      cashImpact = totalAmount;
      // Add M-Rec/M-Pay impact from special lines
      for (var line in lines) {
        final desc = line.description.value ?? '';
        if (desc.startsWith('M-Rec:')) {
          // Customer gives metal = reduces what they owe
          goldImpact -= line.netWeight.value;
        } else if (desc.startsWith('M-Pay:')) {
          // We give extra metal = increases what they owe
          goldImpact += line.netWeight.value;
        } else if (desc.startsWith('R-Cut:')) {
          final lType = line.lineType.value;
          if (lType == 'Debit') {
            goldImpact += line.netWeight.value;
          } else if (lType == 'Credit') {
            goldImpact -= line.netWeight.value;
          }
        }
      }
    } else if (txnType == 'Purchase') {
      // Purchase: we owe supplier (-) gold and cash
      goldImpact = -totalGold;
      silverImpact = -totalSilver;
      cashImpact = -totalAmount;
      // Add M-Rec/M-Pay impact from special lines
      for (var line in lines) {
        final desc = line.description.value ?? '';
        if (desc.startsWith('M-Rec:')) {
          // Supplier gives extra metal = we owe more
          goldImpact -= line.netWeight.value;
        } else if (desc.startsWith('M-Pay:')) {
          // We give metal as payment = we owe less
          goldImpact += line.netWeight.value;
        } else if (desc.startsWith('R-Cut:')) {
          final lType = line.lineType.value;
          if (lType == 'Debit') {
            goldImpact += line.netWeight.value;
          } else if (lType == 'Credit') {
            goldImpact -= line.netWeight.value;
          }
        }
      }
    } else if (txnType == 'Receipt') {
      goldImpact = -totalGold;
      silverImpact = -totalSilver;
      cashImpact = -totalAmount;
    } else if (txnType == 'Payment') {
      goldImpact = totalGold;
      silverImpact = totalSilver;
      cashImpact = totalAmount;
    } else if (txnType == 'Stock Transfer' || txnType == 'MetalTransaction') {
      for (var line in lines) {
        final lType = line.lineType.value;
        if (lType == 'Debit') {
          goldImpact += line.netWeight.value;
        } else if (lType == 'Credit') {
          goldImpact -= line.netWeight.value;
        }
      }
      if (txnType == 'MetalTransaction') {
        cashImpact = totalAmount;
      }
    } else if (txnType == 'Inventory Adjustment') {
      goldImpact = 0;
      silverImpact = 0;
      cashImpact = 0;
    }

    return (gold: goldImpact, silver: silverImpact, cash: cashImpact);
  }

  /// Calculate party balance impact from saved TransactionLines (for reversal)
  ({double gold, double silver, double cash}) _calcBalanceImpactFromLines(
    String txnType,
    double totalGold,
    double totalSilver,
    double totalAmount,
    List<TransactionLine> lines,
  ) {
    double goldImpact = 0;
    double silverImpact = 0;
    double cashImpact = 0;

    if (txnType == 'Sale') {
      goldImpact = totalGold;
      silverImpact = totalSilver;
      cashImpact = totalAmount;
      for (var line in lines) {
        final desc = line.description ?? '';
        if (desc.startsWith('M-Rec:')) {
          goldImpact -= line.netWeight;
        } else if (desc.startsWith('M-Pay:')) {
          goldImpact += line.netWeight;
        } else if (desc.startsWith('R-Cut:')) {
          final lType = line.lineType ?? '';
          if (lType == 'Debit') {
            goldImpact += line.netWeight;
          } else if (lType == 'Credit') {
            goldImpact -= line.netWeight;
          }
        }
      }
    } else if (txnType == 'Purchase') {
      goldImpact = -totalGold;
      silverImpact = -totalSilver;
      cashImpact = -totalAmount;
      for (var line in lines) {
        final desc = line.description ?? '';
        if (desc.startsWith('M-Rec:')) {
          goldImpact -= line.netWeight;
        } else if (desc.startsWith('M-Pay:')) {
          goldImpact += line.netWeight;
        } else if (desc.startsWith('R-Cut:')) {
          final lType = line.lineType ?? '';
          if (lType == 'Debit') {
            goldImpact += line.netWeight;
          } else if (lType == 'Credit') {
            goldImpact -= line.netWeight;
          }
        }
      }
    } else if (txnType == 'Receipt') {
      goldImpact = -totalGold;
      silverImpact = -totalSilver;
      cashImpact = -totalAmount;
    } else if (txnType == 'Payment') {
      goldImpact = totalGold;
      silverImpact = totalSilver;
      cashImpact = totalAmount;
    } else if (txnType == 'Stock Transfer' || txnType == 'MetalTransaction') {
      for (var line in lines) {
        final lType = line.lineType ?? '';
        if (lType == 'Debit') {
          goldImpact += line.netWeight;
        } else if (lType == 'Credit') {
          goldImpact -= line.netWeight;
        }
      }
      if (txnType == 'MetalTransaction') {
        cashImpact = totalAmount;
      }
    } else if (txnType == 'Inventory Adjustment') {
      goldImpact = 0;
      silverImpact = 0;
      cashImpact = 0;
    }

    return (gold: goldImpact, silver: silverImpact, cash: cashImpact);
  }

  // ─── CRUD Operations ───────────────────────────────────────────────

  Future<void> createTransaction({
    required TransactionsCompanion header,
    required List<TransactionLinesCompanion> lines,
  }) {
    return _db.transaction(() async {
      // 1. Insert Header
      final transactionId = await _db.into(_db.transactions).insert(header);
      final txnType = header.type.value;

      // 2. Insert Lines & Update Stock
      for (var line in lines) {
        await _db
            .into(_db.transactionLines)
            .insert(line.copyWith(transactionId: Value(transactionId)));

        if (line.itemId.value != null) {
          final item = await (_db.select(
            _db.items,
          )..where((t) => t.id.equals(line.itemId.value!))).getSingle();

          final change = _calcStockChangeForCompanion(txnType, line);

          if (change.qty != 0 || change.weight != 0) {
            await _db
                .update(_db.items)
                .replace(
                  item.copyWith(
                    stockQty: item.stockQty + change.qty,
                    stockWeight: item.stockWeight + change.weight,
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

      final impact = _calcBalanceImpactFromCompanions(
        txnType,
        header.totalGoldWeight.value,
        header.totalSilverWeight.value,
        header.totalAmount.value,
        lines,
      );

      await _db
          .update(_db.parties)
          .replace(
            party.copyWith(
              goldBalance: party.goldBalance + impact.gold,
              silverBalance: party.silverBalance + impact.silver,
              cashBalance: party.cashBalance + impact.cash,
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

    final transactions =
        await (_db.select(_db.transactions)
              ..where((t) => t.date.isBiggerOrEqualValue(startOfDay))
              ..where((t) => t.date.isSmallerThanValue(endOfDay))
              ..where((t) => t.type.equals('Sale'))
              ..orderBy([(t) => OrderingTerm.desc(t.id)]))
            .get();

    if (transactions.isEmpty) return null;

    for (var txn in transactions) {
      if (txn.transactionNumber != null && txn.transactionNumber!.isNotEmpty) {
        return txn.transactionNumber;
      }
    }

    return null;
  }

  Future<void> deleteTransaction(int id) {
    return _db.transaction(() async {
      // 1. Fetch Transaction
      final txn = await (_db.select(
        _db.transactions,
      )..where((t) => t.id.equals(id))).getSingle();

      final party = await (_db.select(
        _db.parties,
      )..where((t) => t.id.equals(txn.partyId))).getSingle();

      // 2. Fetch lines
      final lines = await (_db.select(
        _db.transactionLines,
      )..where((t) => t.transactionId.equals(id))).get();

      // 3. Reverse Stock for each line item
      for (var line in lines) {
        if (line.itemId != null) {
          final item = await (_db.select(
            _db.items,
          )..where((t) => t.id.equals(line.itemId!))).getSingle();

          final change = _calcStockChangeForLine(txn.type, line);

          // Reverse: negate the original change
          if (change.qty != 0 || change.weight != 0) {
            await _db
                .update(_db.items)
                .replace(
                  item.copyWith(
                    stockQty: item.stockQty - change.qty,
                    stockWeight: item.stockWeight - change.weight,
                  ),
                );
          }
        }
      }

      // 4. Reverse Party Balance
      final impact = _calcBalanceImpactFromLines(
        txn.type,
        txn.totalGoldWeight,
        txn.totalSilverWeight,
        txn.totalAmount,
        lines,
      );

      // Reverse: subtract original impact
      await _db
          .update(_db.parties)
          .replace(
            party.copyWith(
              goldBalance: party.goldBalance - impact.gold,
              silverBalance: party.silverBalance - impact.silver,
              cashBalance: party.cashBalance - impact.cash,
            ),
          );

      // 5. Delete transaction lines
      await (_db.delete(
        _db.transactionLines,
      )..where((t) => t.transactionId.equals(id))).go();

      // 6. Delete transaction
      await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> updateTransaction({
    required int id,
    required TransactionsCompanion header,
    required List<TransactionLinesCompanion> lines,
  }) {
    return _db.transaction(() async {
      // Fetch Old Transaction & Lines
      final oldTxn = await (_db.select(
        _db.transactions,
      )..where((t) => t.id.equals(id))).getSingle();

      final oldLines = await (_db.select(
        _db.transactionLines,
      )..where((t) => t.transactionId.equals(id))).get();

      // 1. Reverse old stock
      for (var line in oldLines) {
        if (line.itemId != null) {
          final item = await (_db.select(
            _db.items,
          )..where((t) => t.id.equals(line.itemId!))).getSingle();

          final change = _calcStockChangeForLine(oldTxn.type, line);

          if (change.qty != 0 || change.weight != 0) {
            await _db
                .update(_db.items)
                .replace(
                  item.copyWith(
                    stockQty: item.stockQty - change.qty,
                    stockWeight: item.stockWeight - change.weight,
                  ),
                );
          }
        }
      }

      // 2. Reverse old party balance
      final oldParty = await (_db.select(
        _db.parties,
      )..where((t) => t.id.equals(oldTxn.partyId))).getSingle();

      final oldImpact = _calcBalanceImpactFromLines(
        oldTxn.type,
        oldTxn.totalGoldWeight,
        oldTxn.totalSilverWeight,
        oldTxn.totalAmount,
        oldLines,
      );

      await _db
          .update(_db.parties)
          .replace(
            oldParty.copyWith(
              goldBalance: oldParty.goldBalance - oldImpact.gold,
              silverBalance: oldParty.silverBalance - oldImpact.silver,
              cashBalance: oldParty.cashBalance - oldImpact.cash,
            ),
          );

      // 3. Update Header
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(id))).write(header);

      // 4. Replace Lines & Apply new stock
      await (_db.delete(
        _db.transactionLines,
      )..where((t) => t.transactionId.equals(id))).go();

      final newType = header.type.value;
      for (var line in lines) {
        await _db
            .into(_db.transactionLines)
            .insert(line.copyWith(transactionId: Value(id)));

        if (line.itemId.value != null) {
          final item = await (_db.select(
            _db.items,
          )..where((t) => t.id.equals(line.itemId.value!))).getSingle();

          final change = _calcStockChangeForCompanion(newType, line);

          if (change.qty != 0 || change.weight != 0) {
            await _db
                .update(_db.items)
                .replace(
                  item.copyWith(
                    stockQty: item.stockQty + change.qty,
                    stockWeight: item.stockWeight + change.weight,
                  ),
                );
          }
        }
      }

      // 5. Apply new party balance
      final currentParty = await (_db.select(
        _db.parties,
      )..where((t) => t.id.equals(header.partyId.value))).getSingle();

      final newImpact = _calcBalanceImpactFromCompanions(
        newType,
        header.totalGoldWeight.value,
        header.totalSilverWeight.value,
        header.totalAmount.value,
        lines,
      );

      await _db
          .update(_db.parties)
          .replace(
            currentParty.copyWith(
              goldBalance: currentParty.goldBalance + newImpact.gold,
              silverBalance: currentParty.silverBalance + newImpact.silver,
              cashBalance: currentParty.cashBalance + newImpact.cash,
            ),
          );
    });
  }
}

final transactionsRepositoryProvider = Provider((ref) {
  return TransactionsRepository(ref.watch(databaseProvider));
});
