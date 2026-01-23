import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:intl/intl.dart';

class FinancialReportsScreen extends ConsumerStatefulWidget {
  const FinancialReportsScreen({super.key});

  @override
  ConsumerState<FinancialReportsScreen> createState() =>
      _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends ConsumerState<FinancialReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 365));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Reports'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'P&L Statement'),
            Tab(text: 'Balance Sheet'),
            Tab(text: 'Trial Balance'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date Range Picker
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                const Text(
                  'Period: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => _startDate = date);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                  ),
                ),
                const Text(
                  ' to ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => _endDate = date);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(DateFormat('dd/MM/yyyy').format(_endDate)),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPLStatement(),
                _buildBalanceSheet(),
                _buildTrialBalance(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPLStatement() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _calculatePL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Error loading P&L data'));
        }

        final data = snapshot.data!;
        final revenue = data['revenue'] as double;
        final costOfGoodsSold = data['cogs'] as double;
        final grossProfit = revenue - costOfGoodsSold;
        final operatingExpenses = data['expenses'] as double;
        final netProfit = grossProfit - operatingExpenses;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROFIT & LOSS STATEMENT',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For the period: ${DateFormat('dd/MM/yyyy').format(_startDate)} to ${DateFormat('dd/MM/yyyy').format(_endDate)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),
                  _buildPLRow('Revenue from Sales', revenue),
                  const SizedBox(height: 16),
                  _buildPLRow(
                    'Cost of Goods Sold',
                    costOfGoodsSold,
                    isIndented: true,
                  ),
                  const Divider(),
                  _buildPLRow('Gross Profit', grossProfit, isBold: true),
                  const SizedBox(height: 16),
                  _buildPLRow(
                    'Operating Expenses',
                    operatingExpenses,
                    isIndented: true,
                  ),
                  const Divider(thickness: 2),
                  _buildPLRow(
                    'Net Profit / (Loss)',
                    netProfit,
                    isBold: true,
                    color: netProfit >= 0 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 32),
                  _buildPLSummaryCards(revenue, grossProfit, netProfit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceSheet() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _calculateBalanceSheet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Error loading Balance Sheet data'));
        }

        final data = snapshot.data!;
        final totalAssets = data['assets'] as double;
        final totalLiabilities = data['liabilities'] as double;
        final totalEquity = data['equity'] as double;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BALANCE SHEET',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'As on: ${DateFormat('dd/MM/yyyy').format(_endDate)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),

                  // Assets
                  Text(
                    'ASSETS',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBSRow('Current Assets', 0, isHeader: true),
                  _buildBSRow('  Cash & Bank', data['cash'] as double),
                  _buildBSRow('  Inventory', data['inventory'] as double),
                  _buildBSRow(
                    '  Customer Receivables',
                    data['receivables'] as double,
                  ),
                  const SizedBox(height: 16),
                  _buildBSRow('Total Assets', totalAssets, isBold: true),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // Liabilities
                  Text(
                    'LIABILITIES & EQUITY',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBSRow('Current Liabilities', 0, isHeader: true),
                  _buildBSRow(
                    '  Supplier Payables',
                    data['payables'] as double,
                  ),
                  const SizedBox(height: 16),
                  _buildBSRow(
                    'Total Liabilities',
                    totalLiabilities,
                    isBold: true,
                  ),

                  const SizedBox(height: 16),
                  _buildBSRow('Owner\'s Equity', totalEquity, isBold: true),

                  const SizedBox(height: 16),
                  const Divider(thickness: 2),
                  _buildBSRow(
                    'Total Liabilities & Equity',
                    totalLiabilities + totalEquity,
                    isBold: true,
                  ),

                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Note: Total Assets (₹${NumberFormat('#,##0.00').format(totalAssets)}) = Total Liabilities & Equity (₹${NumberFormat('#,##0.00').format(totalLiabilities + totalEquity)})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrialBalance() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _calculateTrialBalance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No trial balance data'));
        }

        final accounts = snapshot.data!;
        double totalDebit = 0;
        double totalCredit = 0;

        for (var account in accounts) {
          totalDebit += account['debit'] as double;
          totalCredit += account['credit'] as double;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TRIAL BALANCE',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'As on: ${DateFormat('dd/MM/yyyy').format(_endDate)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withValues(alpha: 0.1),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Account Name',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Debit',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Credit',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...accounts.map((account) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(account['name'] as String),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                NumberFormat(
                                  '#,##0.00',
                                ).format(account['debit']),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                NumberFormat(
                                  '#,##0.00',
                                ).format(account['credit']),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        );
                      }),
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey[400]!),
                            bottom: BorderSide(
                              color: Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'TOTAL',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              NumberFormat('#,##0.00').format(totalDebit),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              NumberFormat('#,##0.00').format(totalCredit),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: totalDebit == totalCredit
                          ? Colors.green[50]
                          : Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      totalDebit == totalCredit
                          ? 'Trial Balance is balanced: ₹${NumberFormat('#,##0.00').format(totalDebit)}'
                          : 'Trial Balance is NOT balanced! Debit: ₹${NumberFormat('#,##0.00').format(totalDebit)}, Credit: ₹${NumberFormat('#,##0.00').format(totalCredit)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: totalDebit == totalCredit
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _calculatePL() async {
    // This would be populated from transactions repository
    // For now, returning mock data
    return {'revenue': 500000.0, 'cogs': 300000.0, 'expenses': 80000.0};
  }

  Future<Map<String, dynamic>> _calculateBalanceSheet() async {
    // This would be calculated from parties and items repositories
    return {
      'cash': 150000.0,
      'inventory': 450000.0,
      'receivables': 120000.0,
      'assets': 720000.0,
      'payables': 100000.0,
      'liabilities': 100000.0,
      'equity': 620000.0,
    };
  }

  Future<List<Map<String, dynamic>>> _calculateTrialBalance() async {
    return [
      {'name': 'Cash', 'debit': 150000.0, 'credit': 0},
      {'name': 'Inventory', 'debit': 450000.0, 'credit': 0},
      {'name': 'Customer Receivables', 'debit': 120000.0, 'credit': 0},
      {'name': 'Supplier Payables', 'debit': 0, 'credit': 100000.0},
      {'name': 'Capital', 'debit': 0, 'credit': 620000.0},
    ];
  }

  Widget _buildPLRow(
    String label,
    double amount, {
    bool isBold = false,
    bool isIndented = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 14 : 13,
            color: color,
          ),
        ),
        Text(
          NumberFormat.currency(symbol: '₹').format(amount),
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 14 : 13,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBSRow(
    String label,
    double amount, {
    bool isBold = false,
    bool isHeader = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold || isHeader
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        if (amount > 0)
          Text(
            NumberFormat.currency(symbol: '₹').format(amount),
            style: TextStyle(
              fontWeight: isBold || isHeader
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
      ],
    );
  }

  Widget _buildPLSummaryCards(
    double revenue,
    double grossProfit,
    double netProfit,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Revenue',
            NumberFormat.currency(symbol: '₹').format(revenue),
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Gross Profit',
            NumberFormat.currency(symbol: '₹').format(grossProfit),
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Net Profit',
            NumberFormat.currency(symbol: '₹').format(netProfit),
            netProfit >= 0 ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
