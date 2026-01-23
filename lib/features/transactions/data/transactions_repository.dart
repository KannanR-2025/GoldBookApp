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
          // Logic to deduce stock would go here
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
