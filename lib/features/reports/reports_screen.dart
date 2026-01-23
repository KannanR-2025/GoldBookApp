import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/data/parties_repository.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:goldbook_desktop/features/inventory/items_provider.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        title: const Text('Reports'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Sales Report'),
            Tab(text: 'Purchase Report'),
            Tab(text: 'Customer Statement'),
            Tab(text: 'Supplier Statement'),
            Tab(text: 'Inventory Report'),
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
                const Text('Date Range: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                  ),
                ),
                const Text(' to ', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        horizontal: 16, vertical: 8),
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
                    // Refresh reports
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Print/Export
                    _printReport();
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSalesReport(),
                _buildPurchaseReport(),
                _buildCustomerStatement(),
                _buildSupplierStatement(),
                _buildInventoryReport(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesReport() {
    return FutureBuilder<List<TransactionWithParty>>(
      future: _getTransactions('Sale'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No sales data found'));
        }

        final transactions = snapshot.data!;
        double totalGold = 0;
        double totalAmount = 0;

        for (var txn in transactions) {
          totalGold += txn.transaction.totalGoldWeight;
          totalAmount += txn.transaction.totalAmount;
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
                      title: 'Total Sales',
                      value: NumberFormat.currency(symbol: '₹')
                          .format(totalAmount),
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Gold Sold',
                      value: '${totalGold.toStringAsFixed(3)} g',
                      icon: Icons.monetization_on,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SummaryCard(
                      title: 'No. of Transactions',
                      value: '${transactions.length}',
                      icon: Icons.receipt,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            // Transactions Table
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildTransactionsTable(transactions),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPurchaseReport() {
    return FutureBuilder<List<TransactionWithParty>>(
      future: _getTransactions('Purchase'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No purchase data found'));
        }

        final transactions = snapshot.data!;
        double totalGold = 0;
        double totalAmount = 0;

        for (var txn in transactions) {
          totalGold += txn.transaction.totalGoldWeight;
          totalAmount += txn.transaction.totalAmount;
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Purchases',
                      value: NumberFormat.currency(symbol: '₹')
                          .format(totalAmount),
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
                      title: 'No. of Transactions',
                      value: '${transactions.length}',
                      icon: Icons.receipt,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildTransactionsTable(transactions),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerStatement() {
    return FutureBuilder<List<Party>>(
      future: ref.read(partiesRepositoryProvider).getParties('Customer'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No customers found'));
        }

        final customers = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppTheme.primaryGold.withValues(alpha: 0.1),
              ),
              columns: const [
                DataColumn(label: Text('Customer Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Gold Balance (g)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Silver Balance (g)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Cash Balance (₹)', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: customers.map((customer) {
                return DataRow(
                  cells: [
                    DataCell(Text(customer.name)),
                    DataCell(Text(
                      customer.goldBalance.toStringAsFixed(3),
                      style: TextStyle(
                        color: customer.goldBalance > 0
                            ? Colors.green
                            : (customer.goldBalance < 0
                                  ? Colors.red
                                  : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    DataCell(Text(
                      customer.silverBalance.toStringAsFixed(3),
                      style: TextStyle(
                        color: customer.silverBalance > 0
                            ? Colors.green
                            : (customer.silverBalance < 0
                                  ? Colors.red
                                  : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    DataCell(Text(
                      NumberFormat.currency(symbol: '₹')
                          .format(customer.cashBalance),
                      style: TextStyle(
                        color: customer.cashBalance > 0
                            ? Colors.green
                            : (customer.cashBalance < 0
                                  ? Colors.red
                                  : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSupplierStatement() {
    return FutureBuilder<List<Party>>(
      future: ref.read(partiesRepositoryProvider).getParties('Supplier'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No suppliers found'));
        }

        final suppliers = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppTheme.primaryGold.withValues(alpha: 0.1),
              ),
              columns: const [
                DataColumn(label: Text('Supplier Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Gold Balance (g)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Silver Balance (g)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Cash Balance (₹)', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: suppliers.map((supplier) {
                return DataRow(
                  cells: [
                    DataCell(Text(supplier.name)),
                    DataCell(Text(
                      supplier.goldBalance.toStringAsFixed(3),
                      style: TextStyle(
                        color: supplier.goldBalance < 0
                            ? Colors.green
                            : (supplier.goldBalance > 0
                                  ? Colors.red
                                  : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    DataCell(Text(
                      supplier.silverBalance.toStringAsFixed(3),
                      style: TextStyle(
                        color: supplier.silverBalance < 0
                            ? Colors.green
                            : (supplier.silverBalance > 0
                                  ? Colors.red
                                  : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    DataCell(Text(
                      NumberFormat.currency(symbol: '₹')
                          .format(supplier.cashBalance),
                      style: TextStyle(
                        color: supplier.cashBalance < 0
                            ? Colors.green
                            : (supplier.cashBalance > 0
                                  ? Colors.red
                                  : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInventoryReport() {
    final itemsAsync = ref.watch(itemsListProvider);
    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('No items found'));
        }

        double totalGoldWeight = 0;
        double totalSilverWeight = 0;

        for (var item in items) {
          if (item.metalType == 'Gold') {
            totalGoldWeight += item.stockWeight;
          } else {
            totalSilverWeight += item.stockWeight;
          }
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Gold Stock',
                      value: '${totalGoldWeight.toStringAsFixed(3)} g',
                      icon: Icons.monetization_on,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Silver Stock',
                      value: '${totalSilverWeight.toStringAsFixed(3)} g',
                      icon: Icons.layers,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Items',
                      value: '${items.length}',
                      icon: Icons.inventory_2,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      AppTheme.primaryGold.withValues(alpha: 0.1),
                    ),
                    columns: const [
                      DataColumn(label: Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Metal', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Purity', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Stock Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Weight (g)', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: items.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.name)),
                          DataCell(Text(item.metalType)),
                          DataCell(Text(item.purity ?? '-')),
                          DataCell(Text(item.stockQty.toString())),
                          DataCell(Text(item.stockWeight.toStringAsFixed(3))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionsTable(List<TransactionWithParty> transactions) {
    return Card(
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          AppTheme.primaryGold.withValues(alpha: 0.1),
        ),
        columns: const [
          DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Party', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Gold (g)', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Amount (₹)', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: transactions.map((txn) {
          return DataRow(
            cells: [
              DataCell(Text(DateFormat('dd/MM/yyyy').format(txn.transaction.date))),
              DataCell(Text(txn.party.name)),
              DataCell(Text(txn.transaction.totalGoldWeight.toStringAsFixed(3))),
              DataCell(Text(
                NumberFormat.currency(symbol: '₹')
                    .format(txn.transaction.totalAmount),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<List<TransactionWithParty>> _getTransactions(String type) async {
    final allTransactions = await ref
        .read(transactionsRepositoryProvider)
        .watchTransactions()
        .first;
    return allTransactions
        .where((txn) =>
            txn.transaction.type == type &&
            txn.transaction.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
            txn.transaction.date.isBefore(_endDate.add(const Duration(days: 1))))
        .toList();
  }

  void _printReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Print functionality coming soon')),
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

