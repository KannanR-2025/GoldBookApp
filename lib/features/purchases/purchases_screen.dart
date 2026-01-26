import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/features/transactions/providers/transactions_provider.dart';
import 'package:intl/intl.dart';

class PurchasesScreen extends ConsumerWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/transactions/new', extra: {'type': 'Purchase'});
              },
              icon: const Icon(Icons.add),
              label: const Text('New Purchase'),
            ),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (allTransactions) {
          final purchases = allTransactions
              .where((t) => t.transaction.type == 'Purchase')
              .toList();

          if (purchases.isEmpty) {
            return const Center(
              child: Text('No purchase transactions found. Create a new purchase to get started.'),
            );
          }

          // Calculate totals
          double totalGold = 0;
          double totalAmount = 0;
          for (var purchase in purchases) {
            totalGold += purchase.transaction.totalGoldWeight;
            totalAmount += purchase.transaction.totalAmount;
          }

          return Column(
            children: [
              // Summary Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Total Purchases',
                        value: NumberFormat.currency(symbol: '₹').format(totalAmount),
                        icon: Icons.shopping_bag,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Total Gold Purchased',
                        value: '${totalGold.toStringAsFixed(3)} g',
                        icon: Icons.monetization_on,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryCard(
                        title: 'No. of Purchases',
                        value: '${purchases.length}',
                        icon: Icons.receipt,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              // Purchases List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: purchases.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final purchase = purchases[index];
                    return Dismissible(
                      key: Key('purchase_${purchase.transaction.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Purchase'),
                            content: Text(
                              'Are you sure you want to delete this purchase from ${purchase.party.name}?\n\nThis will reverse the stock and balance changes.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ) ?? false;
                      },
                      onDismissed: (direction) {
                        ref
                            .read(transactionsControllerProvider.notifier)
                            .deleteTransaction(purchase.transaction.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Purchase from ${purchase.party.name} deleted'),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 1,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.withValues(alpha: 0.2),
                            child: const Icon(
                              Icons.shopping_bag,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            purchase.party.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            DateFormat('dd MMM yyyy').format(purchase.transaction.date),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${purchase.transaction.totalGoldWeight.toStringAsFixed(3)} g',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '₹ ${purchase.transaction.totalAmount.toStringAsFixed(0)}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () {
                            // TODO: View/Edit purchase details
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
