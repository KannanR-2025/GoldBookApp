import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardSummary {
  final double goldRate;
  final double silverRate;
  final double totalGoldStock;
  final double totalSilverStock;
  final double customerGoldBalance;
  final double customerCashBalance;

  DashboardSummary({
    required this.goldRate,
    required this.silverRate,
    required this.totalGoldStock,
    required this.totalSilverStock,
    required this.customerGoldBalance,
    required this.customerCashBalance,
  });
}

class MockDataService {
  Future<DashboardSummary> getDashboardSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DashboardSummary(
      goldRate: 6450.00,
      silverRate: 78.50,
      totalGoldStock: 1250.450,
      totalSilverStock: 5400.000,
      customerGoldBalance:
          -450.200, // Negative means receivable usually in this domain
      customerCashBalance: 1500000.00,
    );
  }

  Future<List<Map<String, dynamic>>> getSalesGraphData() async {
    // Mock 7 days data
    return [
      {'day': 'Mon', 'amount': 120},
      {'day': 'Tue', 'amount': 150},
      {'day': 'Wed', 'amount': 80},
      {'day': 'Thu', 'amount': 200},
      {'day': 'Fri', 'amount': 250},
      {'day': 'Sat', 'amount': 300},
      {'day': 'Sun', 'amount': 100},
    ];
  }
}

final mockDataServiceProvider = Provider((ref) => MockDataService());
