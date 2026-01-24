import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:goldbook_desktop/features/transactions/providers/transactions_provider.dart';
import 'package:intl/intl.dart';

class TransactionsListScreen extends ConsumerWidget {
  final String? typeFilter; // 'Sale', 'Purchase', 'Receipt', 'Payment'
  const TransactionsListScreen({super.key, this.typeFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(typeFilter != null ? '${typeFilter}s' : 'Transactions'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                final type = typeFilter ?? 'Sale';
                final route = type == 'Sale'
                    ? '/sales/new'
                    : type == 'Purchase'
                    ? '/purchases/new'
                    : type == 'Receipt'
                    ? '/receipts/new'
                    : type == 'Stock Transfer'
                    ? '/stock-transfer/new'
                    : type == 'Inventory Adjustment'
                    ? '/inventory-adjustment/new'
                    : '/payments/new';
                context.push(route);
              },
              icon: const Icon(Icons.add),
              label: Text('New ${typeFilter ?? 'Transaction'}'),
            ),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          final filtered = typeFilter == null
              ? transactions
              : transactions
                    .where((t) => t.transaction.type == typeFilter)
                    .toList();
          return _buildList(filtered);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildList(List<TransactionWithParty> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No transactions found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        final txn = item.transaction;
        final party = item.party;

        return Card(
          elevation: 1,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryGold.withValues(alpha: 0.2),
              child: Icon(
                txn.type == 'Sale'
                    ? Icons.sell
                    : (txn.type == 'Purchase'
                          ? Icons.shopping_bag
                          : txn.type == 'Stock Transfer'
                          ? Icons.inventory_2
                          : Icons.payment),
                color: AppTheme.primaryGoldDark,
                size: 20,
              ),
            ),
            title: Text(
              party.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${txn.type} • ${DateFormat('dd MMM yyyy').format(txn.date)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${txn.totalGoldWeight.toStringAsFixed(3)} g',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '₹ ${txn.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: AppTheme.primaryGold,
                  ),
                  onPressed: () {
                    final route = txn.type == 'Sale'
                        ? '/sales/edit/${txn.id}'
                        : txn.type == 'Purchase'
                        ? '/purchases/edit/${txn.id}'
                        : txn.type == 'Receipt'
                        ? '/receipts/edit/${txn.id}'
                        : txn.type == 'Stock Transfer'
                        ? '/stock-transfer/edit/${txn.id}'
                        : txn.type == 'Inventory Adjustment'
                        ? '/inventory-adjustment/edit/${txn.id}'
                        : '/payments/edit/${txn.id}';
                    context.push(route);
                  },
                  tooltip: 'Edit Transaction',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
