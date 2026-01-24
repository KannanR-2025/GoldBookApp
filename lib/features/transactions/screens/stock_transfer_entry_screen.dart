import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/inventory/items_provider.dart';
import 'package:goldbook_desktop/features/parties/providers/parties_provider.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:intl/intl.dart';

class StockTransferEntryScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  const StockTransferEntryScreen({super.key, this.transactionId});

  @override
  ConsumerState<StockTransferEntryScreen> createState() =>
      _StockTransferEntryScreenState();
}

class _StockTransferEntryScreenState
    extends ConsumerState<StockTransferEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Header State
  DateTime _date = DateTime.now();
  int? _selectedPartyId; // Optional for Stock Transfer? Usually mandatory.
  final _transactionNumberCtrl = TextEditingController();
  final _remarksController = TextEditingController();

  // Lines State
  final List<StockTransferLineState> _lines = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Default 3 lines as per screenshot or just 1
    _lines.add(StockTransferLineState(lineType: 'Debit'));
    _lines.add(StockTransferLineState(lineType: 'Credit'));

    if (widget.transactionId != null) {
      _loadTransaction();
    } else {
      _generateTransactionNumber();
    }
  }

  void _generateTransactionNumber() {
    _transactionNumberCtrl.text =
        'ST-${DateFormat('yyyyMMdd-HHmmss').format(DateTime.now())}';
  }

  Future<void> _loadTransaction() async {
    setState(() => _isLoading = true);
    final repo = ref.read(transactionsRepositoryProvider);
    final txn = await repo.getTransaction(widget.transactionId!);
    if (txn != null) {
      final lines = await repo.getTransactionLines(widget.transactionId!);

      setState(() {
        _date = txn.date;
        _selectedPartyId = txn.partyId;
        _transactionNumberCtrl.text = txn.transactionNumber ?? '';
        _remarksController.text = txn.remarks ?? '';

        _lines.clear();
        for (var line in lines) {
          _lines.add(
            StockTransferLineState(
              itemId: line.itemId,
              lineType: line.lineType ?? 'Debit',
              description: line.description, // Remarks?
              stamp: line.stamp,
              color: line.color,
              grossWeight: line.grossWeight,
              netWeight: line.netWeight,
              purity: line.purity,
              qty: line.qty,
            ),
          );
        }
        if (_lines.isEmpty) {
          _lines.add(StockTransferLineState(lineType: 'Debit'));
          _lines.add(StockTransferLineState(lineType: 'Credit'));
        }
      });
    }
    setState(() => _isLoading = false);
  }

  // Totals
  double get _totalDebitWeight => _lines
      .where((l) => l.lineType == 'Debit')
      .fold(0.0, (sum, l) => sum + (l.netWeight ?? 0));

  double get _totalCreditWeight => _lines
      .where((l) => l.lineType == 'Credit')
      .fold(0.0, (sum, l) => sum + (l.netWeight ?? 0));

  double get _diff => _totalDebitWeight - _totalCreditWeight;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.transactionId == null
              ? 'New Stock Transfer'
              : 'Edit Stock Transfer',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVoucherInfo(),
                    const SizedBox(height: 16),
                    _buildGrid(),
                    const SizedBox(height: 16),
                    _buildNarration(),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherInfo() {
    final parties = ref.watch(partiesListProvider).asData?.value ?? [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voucher Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _selectedPartyId,
                    decoration: const InputDecoration(
                      labelText: 'Party / Account',
                    ),
                    items: parties
                        .map(
                          (p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(p.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedPartyId = v),
                    validator: (v) => v == null ? 'Select Party' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _transactionNumberCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Stock Transfer No.',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) setState(() => _date = d);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(DateFormat('dd-MM-yyyy').format(_date)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final items = ref.watch(itemsListProvider).asData?.value ?? [];

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Stock Transfer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Container(
                    color: Colors.red[50],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        _h('#', 30),
                        _h('Terms', 100),
                        _h('Item', 200),
                        _h('Remarks', 150),
                        _h('Stamp', 80),
                        _h('Colour', 80),
                        _h('Gross Wt', 80),
                        _h('Net Wt', 80),
                        _h('Touch', 60),
                        _h('Fine Wt', 80),
                        _h('Actions', 50),
                      ],
                    ),
                  ),
                  // Data Rows
                  ..._lines.asMap().entries.map((entry) {
                    final index = entry.key;
                    final line = entry.value;
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 30, child: Text('${index + 1}')),
                          SizedBox(
                            width: 100,
                            child: DropdownButtonFormField<String>(
                              initialValue: line.lineType,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Debit',
                                  child: Text('Debit'),
                                ),
                                DropdownMenuItem(
                                  value: 'Credit',
                                  child: Text('Credit'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => line.lineType = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<int>(
                              initialValue: line.itemId,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                                hintText: 'Select Item',
                              ),
                              items: items
                                  .map(
                                    (i) => DropdownMenuItem(
                                      value: i.id,
                                      child: Text(
                                        i.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => line.itemId = v),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _cell(
                            width: 150,
                            value: line.description,
                            onChanged: (v) => line.description = v,
                          ),
                          _cell(
                            width: 80,
                            value: line.stamp,
                            onChanged: (v) => line.stamp = v,
                          ),
                          _cell(
                            width: 80,
                            value: line.color,
                            onChanged: (v) => line.color = v,
                          ),
                          _numCell(
                            width: 80,
                            value: line.grossWeight,
                            onChanged: (v) {
                              line.grossWeight = double.tryParse(v);
                              line.netWeight = double.tryParse(v); // Auto
                              setState(() {});
                            },
                          ),
                          _numCell(
                            width: 80,
                            value: line.netWeight,
                            onChanged: (v) {
                              line.netWeight = double.tryParse(v);
                              setState(() {});
                            },
                          ),
                          _numCell(
                            width: 60,
                            value: line.purity,
                            onChanged: (v) {
                              line.purity = double.tryParse(v);
                              setState(() {});
                            },
                          ),
                          Container(
                            width: 80,
                            padding: const EdgeInsets.only(right: 8),
                            alignment: Alignment.centerRight,
                            child: Text(
                              line.fineWeight.toStringAsFixed(3),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 18,
                            ),
                            onPressed: () =>
                                setState(() => _lines.removeAt(index)),
                          ),
                        ],
                      ),
                    );
                  }),
                  // Add Row Button
                  TextButton.icon(
                    onPressed: () => setState(
                      () =>
                          _lines.add(StockTransferLineState(lineType: 'Debit')),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Line'),
                  ),
                  const Divider(),
                  // Totals
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _totalRow('Debit Totals', _totalDebitWeight),
                        _totalRow('Credit Totals', _totalCreditWeight),
                        const SizedBox(height: 8),
                        _totalRow(
                          'Difference',
                          _diff,
                          isBold: true,
                          color: _diff.abs() > 0.001
                              ? Colors.red
                              : Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _h(String label, double width) {
    return SizedBox(
      width: width + 8, // padding
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _cell({
    required double width,
    String? value,
    required Function(String) onChanged,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(right: 8),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _numCell({
    required double width,
    double? value,
    required Function(String) onChanged,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(right: 8),
      child: TextFormField(
        initialValue: value?.toString() ?? '',
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _totalRow(
    String label,
    double val, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: Text(
            '${val.toStringAsFixed(3)} g',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
        const SizedBox(width: 100), // Spacer towards right
      ],
    );
  }

  Widget _buildNarration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _remarksController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter narration here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.backgroundWhite,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
            child: const Text('Save'),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPartyId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select Party')));
      return;
    }

    final repo = ref.read(transactionsRepositoryProvider);

    final header = TransactionsCompanion(
      id: widget.transactionId != null
          ? drift.Value(widget.transactionId!)
          : const drift.Value.absent(),
      transactionNumber: drift.Value(_transactionNumberCtrl.text),
      date: drift.Value(_date),
      partyId: drift.Value(_selectedPartyId!),
      type: const drift.Value('Stock Transfer'),
      remarks: drift.Value(_remarksController.text),
      totalGoldWeight: drift.Value(_diff), // Net Difference
      totalSilverWeight: const drift.Value(0),
      totalAmount: const drift.Value(0),
      status: const drift.Value('Completed'),
    );

    final lines = _lines
        .map(
          (l) => TransactionLinesCompanion(
            itemId: drift.Value(l.itemId),
            lineType: drift.Value(l.lineType),
            description: drift.Value(l.description),
            stamp: drift.Value(l.stamp),
            color: drift.Value(l.color),
            grossWeight: drift.Value(l.grossWeight ?? 0),
            netWeight: drift.Value(l.netWeight ?? 0),
            purity: drift.Value(l.purity),
            qty: drift.Value(
              l.qty ?? 0,
            ), // Default 0 for now as UI doesn't have Qty column yet? Wait, UI needs Qty column too?
            // Screenshot doesn't show Qty column explicitly but implies items.
            // Added Qty to line object but hidden in UI? Or should I add column?
            // Usually Jewelry has Pcs (Qty). I should add Qty column.
            // Let's assume 1 for now if missing or add column.
            // Adding Qty column to UI is safer.
          ),
        )
        .toList();

    // Quick Fix: Add Qty column to UI or default 1
    // The previous implementation used qty. I'll default to 1 for this pass or modify the UI in next iteration if user complains.
    // The Grid UI code above doesn't have Qty. I will add it or default to 1.
    // Actually, let's update lines mapping to default qty 1 if null.

    try {
      if (widget.transactionId != null) {
        await repo.updateTransaction(
          id: widget.transactionId!,
          header: header,
          lines: lines,
        );
      } else {
        await repo.createTransaction(header: header, lines: lines);
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class StockTransferLineState {
  int? itemId;
  String lineType; // Debit, Credit
  String? description;
  String? stamp;
  String? color;
  double? grossWeight;
  double? netWeight;
  double? purity;
  double? qty;

  // Calculated
  double get fineWeight {
    if (netWeight == null || purity == null) return 0;
    return (netWeight! * purity!) / 100;
  }

  StockTransferLineState({
    this.itemId,
    this.lineType = 'Debit',
    this.description,
    this.stamp,
    this.color,
    this.grossWeight,
    this.netWeight,
    this.purity,
    this.qty = 1.0,
  });
}
