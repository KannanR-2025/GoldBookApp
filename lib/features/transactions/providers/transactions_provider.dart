import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';

// List Stream
final transactionsListProvider =
    StreamProvider.autoDispose<List<TransactionWithParty>>((ref) {
      return ref.watch(transactionsRepositoryProvider).watchTransactions();
    });

// Controller
class TransactionsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // No state
  }

  Future<void> createTransaction({
    required TransactionsCompanion header,
    required List<TransactionLinesCompanion> lines,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(transactionsRepositoryProvider)
          .createTransaction(header: header, lines: lines);
    });
  }

  Future<void> updateTransaction({
    required int id,
    required TransactionsCompanion header,
    required List<TransactionLinesCompanion> lines,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(transactionsRepositoryProvider)
          .updateTransaction(id: id, header: header, lines: lines);
    });
  }
}

final transactionsControllerProvider =
    AsyncNotifierProvider<TransactionsController, void>(
      TransactionsController.new,
    );
