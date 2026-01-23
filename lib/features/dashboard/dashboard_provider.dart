import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/data/parties_repository.dart';
import 'package:goldbook_desktop/features/inventory/items_provider.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';

class DashboardSummary {
  final double goldRate;
  final double silverRate;
  final double totalGoldStock;
  final double totalSilverStock;
  final double customerGoldBalance;
  final double customerCashBalance;
  final double supplierGoldBalance;
  final double supplierCashBalance;

  DashboardSummary({
    required this.goldRate,
    required this.silverRate,
    required this.totalGoldStock,
    required this.totalSilverStock,
    required this.customerGoldBalance,
    required this.customerCashBalance,
    required this.supplierGoldBalance,
    required this.supplierCashBalance,
  });
}

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  // Get all parties
  final partiesRepo = ref.read(partiesRepositoryProvider);
  final customers = await partiesRepo.getParties('Customer');
  final suppliers = await partiesRepo.getParties('Supplier');

  // Calculate customer balances
  double customerGoldBalance = 0;
  double customerCashBalance = 0;
  for (var customer in customers) {
    customerGoldBalance += customer.goldBalance;
    customerCashBalance += customer.cashBalance;
  }

  // Calculate supplier balances
  double supplierGoldBalance = 0;
  double supplierCashBalance = 0;
  for (var supplier in suppliers) {
    supplierGoldBalance += supplier.goldBalance;
    supplierCashBalance += supplier.cashBalance;
  }

  // Get all items
  final items = await ref.read(itemsListProvider.future);
  double totalGoldStock = 0;
  double totalSilverStock = 0;
  for (var item in items) {
    if (item.metalType == 'Gold') {
      totalGoldStock += item.stockWeight;
    } else {
      totalSilverStock += item.stockWeight;
    }
  }

  // Get recent transactions for sales chart (used in salesChartDataProvider)
  // final transactions = await ref.read(transactionsRepositoryProvider).watchTransactions().first;

  // Default gold and silver rates (can be made configurable)
  const double goldRate = 6450.00;
  const double silverRate = 78.50;

  return DashboardSummary(
    goldRate: goldRate,
    silverRate: silverRate,
    totalGoldStock: totalGoldStock,
    totalSilverStock: totalSilverStock,
    customerGoldBalance: customerGoldBalance,
    customerCashBalance: customerCashBalance,
    supplierGoldBalance: supplierGoldBalance,
    supplierCashBalance: supplierCashBalance,
  );
});

// Sales chart data provider
final salesChartDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final transactions = await ref.read(transactionsRepositoryProvider).watchTransactions().first;
  final sales = transactions.where((t) => t.transaction.type == 'Sale').toList();

  // Group by day for last 7 days
  final now = DateTime.now();
  final Map<String, double> dailySales = {};

  for (var i = 6; i >= 0; i--) {
    final date = now.subtract(Duration(days: i));
    final dayKey = '${date.day}/${date.month}';
    dailySales[dayKey] = 0;
  }

  for (var sale in sales) {
    final saleDate = sale.transaction.date;
    if (saleDate.isAfter(now.subtract(const Duration(days: 7)))) {
      final dayKey = '${saleDate.day}/${saleDate.month}';
      dailySales[dayKey] = (dailySales[dayKey] ?? 0) + sale.transaction.totalAmount;
    }
  }

  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return dailySales.entries.map((entry) {
    final index = dailySales.keys.toList().indexOf(entry.key);
    return {
      'day': index < days.length ? days[index] : entry.key,
      'amount': entry.value,
    };
  }).toList();
});

// Top customers provider
final topCustomersProvider = FutureProvider<List<Party>>((ref) async {
  final customers = await ref.read(partiesRepositoryProvider).getParties('Customer');
  customers.sort((a, b) => b.goldBalance.compareTo(a.goldBalance));
  return customers.take(5).toList();
});
