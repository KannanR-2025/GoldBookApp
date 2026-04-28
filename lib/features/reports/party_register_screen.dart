import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/data/parties_repository.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:intl/intl.dart';

class PartyRegisterScreen extends ConsumerStatefulWidget {
  final String partyType; // 'Customer' or 'Supplier'
  const PartyRegisterScreen({super.key, required this.partyType});

  @override
  ConsumerState<PartyRegisterScreen> createState() =>
      _PartyRegisterScreenState();
}

class _PartyRegisterScreenState extends ConsumerState<PartyRegisterScreen> {
  int? _selectedPartyId;
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  List<TransactionWithParty> _transactions = [];
  Party? _selectedParty;
  bool _isLoading = false;

  void _loadTransactions() async {
    if (_selectedPartyId == null) return;
    setState(() => _isLoading = true);

    final allTxns = await ref
        .read(transactionsRepositoryProvider)
        .watchTransactions()
        .first;

    final filtered = allTxns.where((t) {
      final txn = t.transaction;
      return txn.partyId == _selectedPartyId &&
          !txn.date.isBefore(_startDate) &&
          !txn.date.isAfter(_endDate.add(const Duration(days: 1)));
    }).toList();

    // Sort by date ascending for running balance
    filtered.sort((a, b) => a.transaction.date.compareTo(b.transaction.date));

    setState(() {
      _transactions = filtered;
      _isLoading = false;
    });
  }

  /// Returns (goldIn, goldOut, cashIn, cashOut) for a transaction
  ({double goldIn, double goldOut, double cashIn, double cashOut})
      _txnImpact(Transaction txn) {
    double goldIn = 0, goldOut = 0, cashIn = 0, cashOut = 0;
    final goldWt = txn.totalGoldWeight.abs();
    final amount = txn.totalAmount.abs();

    switch (txn.type) {
      case 'Sale':
        goldOut = goldWt;
        cashIn = amount;
        break;
      case 'Purchase':
        goldIn = goldWt;
        cashOut = amount;
        break;
      case 'Receipt':
        cashIn = amount;
        break;
      case 'Payment':
        cashOut = amount;
        break;
      case 'MetalTransaction':
        // totalGoldWeight: positive = net gold out (party owes us), negative = net gold in
        if (txn.totalGoldWeight >= 0) {
          goldOut = txn.totalGoldWeight;
        } else {
          goldIn = txn.totalGoldWeight.abs();
        }
        // totalAmount for metal txn (rate cut cash)
        if (txn.totalAmount > 0) {
          cashIn = txn.totalAmount;
        } else if (txn.totalAmount < 0) {
          cashOut = txn.totalAmount.abs();
        }
        break;
      default:
        // RateCut, Stock Transfer, etc.
        if (txn.totalGoldWeight >= 0) {
          goldOut = txn.totalGoldWeight;
        } else {
          goldIn = txn.totalGoldWeight.abs();
        }
        if (txn.totalAmount > 0) {
          cashIn = txn.totalAmount;
        } else if (txn.totalAmount < 0) {
          cashOut = txn.totalAmount.abs();
        }
    }
    return (goldIn: goldIn, goldOut: goldOut, cashIn: cashIn, cashOut: cashOut);
  }

  @override
  Widget build(BuildContext context) {
    final partiesFuture = ref
        .read(partiesRepositoryProvider)
        .getParties(widget.partyType);
    final currFmt = NumberFormat.currency(symbol: '₹');
    final isCustomer = widget.partyType == 'Customer';

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.partyType} Register'),
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: FutureBuilder<List<Party>>(
              future: partiesFuture,
              builder: (context, snap) {
                final parties = snap.data ?? [];
                return Row(
                  children: [
                    // Party Dropdown
                    SizedBox(
                      width: 280,
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        initialValue: _selectedPartyId,
                        decoration: InputDecoration(
                          labelText: '${widget.partyType} *',
                          isDense: true,
                        ),
                        items: parties
                            .map((p) => DropdownMenuItem(
                                  value: p.id,
                                  child: Text(p.name,
                                      overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedPartyId = v;
                            _selectedParty =
                                parties.where((p) => p.id == v).firstOrNull;
                          });
                          _loadTransactions();
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Date Range
                    const Text('From: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          setState(() => _startDate = d);
                          _loadTransactions();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child:
                            Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('To: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          setState(() => _endDate = d);
                          _loadTransactions();
                        }
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
                      onPressed: _loadTransactions,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                );
              },
            ),
          ),

          // Content
          Expanded(
            child: _selectedPartyId == null
                ? Center(
                    child: Text(
                      'Select a ${widget.partyType.toLowerCase()} to view register',
                      style: const TextStyle(
                          fontSize: 16, color: AppTheme.textSecondary),
                    ),
                  )
                : _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildRegisterContent(currFmt, isCustomer),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterContent(NumberFormat currFmt, bool isCustomer) {
    final openingGold = _selectedParty?.openingGoldBalance ?? 0;
    final openingCash = _selectedParty?.openingCashBalance ?? 0;

    // Calculate totals
    double totalGoldIn = 0, totalGoldOut = 0;
    double totalCashIn = 0, totalCashOut = 0;

    for (var t in _transactions) {
      final impact = _txnImpact(t.transaction);
      totalGoldIn += impact.goldIn;
      totalGoldOut += impact.goldOut;
      totalCashIn += impact.cashIn;
      totalCashOut += impact.cashOut;
    }

    final closingGold = openingGold + totalGoldIn - totalGoldOut;
    final closingCash = openingCash + totalCashIn - totalCashOut;

    return Column(
      children: [
        // Summary Cards
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Opening Balance',
                  goldValue: '${openingGold.toStringAsFixed(3)} g',
                  cashValue: currFmt.format(openingCash),
                  color: Colors.blue,
                  icon: Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Total Gold/Cash In',
                  goldValue: '${totalGoldIn.toStringAsFixed(3)} g',
                  cashValue: currFmt.format(totalCashIn),
                  color: Colors.green,
                  icon: Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Total Gold/Cash Out',
                  goldValue: '${totalGoldOut.toStringAsFixed(3)} g',
                  cashValue: currFmt.format(totalCashOut),
                  color: Colors.red,
                  icon: Icons.arrow_upward,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Closing Balance',
                  goldValue: '${closingGold.toStringAsFixed(3)} g',
                  cashValue: currFmt.format(closingCash),
                  color: AppTheme.primaryGoldDark,
                  icon: Icons.account_balance,
                ),
              ),
            ],
          ),
        ),

        // Transaction Table
        Expanded(
          child: _transactions.isEmpty
              ? const Center(child: Text('No transactions found for this period'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTable(currFmt, openingGold, openingCash),
                ),
        ),
      ],
    );
  }

  Widget _buildTable(
      NumberFormat currFmt, double openingGold, double openingCash) {
    double runningGold = openingGold;
    double runningCash = openingCash;

    final rows = <DataRow>[];

    // Opening balance row
    rows.add(DataRow(
      color: WidgetStateProperty.all(Colors.blue.shade50),
      cells: [
        const DataCell(Text('')),
        const DataCell(Text('')),
        const DataCell(Text('Opening Balance',
            style: TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        DataCell(Text(
          runningGold.toStringAsFixed(3),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: runningGold >= 0 ? Colors.green : Colors.red,
          ),
        )),
        DataCell(Text(
          currFmt.format(runningCash),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: runningCash >= 0 ? Colors.green : Colors.red,
          ),
        )),
      ],
    ));

    for (var t in _transactions) {
      final txn = t.transaction;
      final impact = _txnImpact(txn);
      runningGold += impact.goldIn - impact.goldOut;
      runningCash += impact.cashIn - impact.cashOut;

      rows.add(DataRow(cells: [
        DataCell(Text(DateFormat('dd/MM/yyyy').format(txn.date))),
        DataCell(Text(txn.transactionNumber ?? '-')),
        DataCell(Text(txn.type)),
        DataCell(Text(
          impact.goldIn > 0 ? impact.goldIn.toStringAsFixed(3) : '-',
          style: const TextStyle(color: Colors.green),
        )),
        DataCell(Text(
          impact.goldOut > 0 ? impact.goldOut.toStringAsFixed(3) : '-',
          style: const TextStyle(color: Colors.red),
        )),
        DataCell(Text(
          impact.cashIn > 0 ? currFmt.format(impact.cashIn) : '-',
          style: const TextStyle(color: Colors.green),
        )),
        DataCell(Text(
          impact.cashOut > 0 ? currFmt.format(impact.cashOut) : '-',
          style: const TextStyle(color: Colors.red),
        )),
        DataCell(Text(
          runningGold.toStringAsFixed(3),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: runningGold >= 0 ? Colors.green.shade700 : Colors.red,
          ),
        )),
        DataCell(Text(
          currFmt.format(runningCash),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: runningCash >= 0 ? Colors.green.shade700 : Colors.red,
          ),
        )),
      ]));
    }

    // Closing balance row
    rows.add(DataRow(
      color: WidgetStateProperty.all(
          AppTheme.primaryGold.withValues(alpha: 0.1)),
      cells: [
        const DataCell(Text('')),
        const DataCell(Text('')),
        const DataCell(Text('Closing Balance',
            style: TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        const DataCell(Text('-')),
        DataCell(Text(
          runningGold.toStringAsFixed(3),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: runningGold >= 0 ? Colors.green.shade800 : Colors.red,
          ),
        )),
        DataCell(Text(
          currFmt.format(runningCash),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: runningCash >= 0 ? Colors.green.shade800 : Colors.red,
          ),
        )),
      ],
    ));

    return Card(
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          AppTheme.primaryGold.withValues(alpha: 0.1),
        ),
        columnSpacing: 20,
        columns: const [
          DataColumn(
              label: Text('Date',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Voucher No.',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Type',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Gold In (g)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Gold Out (g)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Cash In (₹)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Cash Out (₹)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Gold Bal.',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Cash Bal.',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: rows,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String goldValue;
  final String cashValue;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.goldValue,
    required this.cashValue,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.monetization_on,
                  size: 14, color: AppTheme.primaryGoldDark),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  goldValue,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.primaryGoldDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.currency_rupee,
                  size: 14, color: AppTheme.textPrimary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  cashValue,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
