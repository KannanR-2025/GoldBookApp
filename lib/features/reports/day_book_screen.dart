import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:goldbook_desktop/features/transactions/providers/transactions_provider.dart';
import 'package:intl/intl.dart';

class DayBookScreen extends ConsumerWidget {
  const DayBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Book'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // TODO: Implement date range filter
                  },
                  tooltip: 'Filter by Date Range',
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    // TODO: Export to Excel/PDF
                  },
                  tooltip: 'Export',
                ),
              ],
            ),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          // Group by date
          final groupedByDate = <String, List<TransactionWithParty>>{};
          for (var txn in transactions) {
            final dateKey = DateFormat(
              'yyyy-MM-dd',
            ).format(txn.transaction.date);
            groupedByDate.putIfAbsent(dateKey, () => []).add(txn);
          }

          final sortedDates = groupedByDate.keys.toList()
            ..sort((a, b) => b.compareTo(a)); // Most recent first

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final dayTransactions = groupedByDate[date]!;

              // Calculate daily totals
              double dayGold = 0;
              double daySilver = 0;
              double dayCash = 0;

              for (var txn in dayTransactions) {
                dayGold += txn.transaction.totalGoldWeight;
                daySilver += txn.transaction.totalSilverWeight;
                dayCash += txn.transaction.totalAmount;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Header
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 12,
                      top: index == 0 ? 0 : 24,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primaryGold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: AppTheme.primaryGoldDark,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'EEEE, MMMM d, yyyy',
                              ).format(DateTime.parse(date)),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGoldDark,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${dayTransactions.length} transactions',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Transactions for this date
                  ...dayTransactions.map((item) => _buildTransactionRow(item)),

                  // Daily Summary
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Daily Total:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 24),
                        if (dayGold > 0) ...[
                          Text(
                            'Gold: ${dayGold.toStringAsFixed(3)} g',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGoldDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (daySilver > 0) ...[
                          Text(
                            'Silver: ${daySilver.toStringAsFixed(3)} g',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Text(
                          'Cash: ${NumberFormat.currency(symbol: '₹').format(dayCash)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.success,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildTransactionRow(TransactionWithParty item) {
    final txn = item.transaction;
    final party = item.party;

    IconData icon;
    Color iconColor;

    switch (txn.type) {
      case 'Sale':
        icon = Icons.sell;
        iconColor = Colors.green;
        break;
      case 'Purchase':
        icon = Icons.shopping_bag;
        iconColor = Colors.blue;
        break;
      case 'Receipt':
        icon = Icons.arrow_downward;
        iconColor = Colors.teal;
        break;
      case 'Payment':
        icon = Icons.arrow_upward;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.receipt;
        iconColor = AppTheme.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),

          // Transaction Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  party.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  txn.type,
                  style: TextStyle(fontSize: 12, color: iconColor),
                ),
              ],
            ),
          ),

          // Transaction Number
          Expanded(
            child: Text(
              txn.transactionNumber ?? '-',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // Payment Method
          Expanded(
            child: Text(
              txn.paymentMethod ?? '-',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // Amounts
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (txn.totalGoldWeight > 0)
                  Text(
                    '${txn.totalGoldWeight.toStringAsFixed(3)} g',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryGoldDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(width: 16),
                Text(
                  NumberFormat.currency(symbol: '₹').format(txn.totalAmount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
