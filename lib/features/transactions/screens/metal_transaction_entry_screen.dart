import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/inventory/items_provider.dart';
import 'package:goldbook_desktop/features/parties/data/parties_repository.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:goldbook_desktop/features/transactions/providers/transactions_provider.dart';
import 'package:intl/intl.dart';

class MetalTransactionEntryScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  const MetalTransactionEntryScreen({super.key, this.transactionId});

  @override
  ConsumerState<MetalTransactionEntryScreen> createState() =>
      _MetalTransactionEntryScreenState();
}

class _MetalTransactionEntryScreenState
    extends ConsumerState<MetalTransactionEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Header State
  final String _type = 'MetalTransaction';
  DateTime _date = DateTime.now();
  int? _selectedPartyId;
  final _transactionNumberCtrl = TextEditingController();
  final _referenceNoCtrl = TextEditingController();
  final _remarksController = TextEditingController();

  // Lines State
  final List<MetalTxnLineState> _lines = [];

  // Sub-Transactions Stats
  double _rateCutGold = 0;
  double _rateCutCash = 0;
  double _rateCutMetalRate = 0;

  String _rateCutFineType = 'Payable';
  String _rateCutAmountType = 'Receivable';
  String _rateCutMetalType = 'Gold';
  String _rateCutFineUnit = 'g';
  String _rateCutAmountUnit = '₹';

  // Sub-Transaction Controllers (for dialogs)
  final _rateCutMetalRateCtrl = TextEditingController();
  final _rateCutFineCtrl = TextEditingController();
  final _rateCutAmountCtrl = TextEditingController();

  // Totals
  double _totalGoldIn = 0;
  double _totalGoldOut = 0;
  double _subTotalGold = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rateCutMetalRateCtrl.addListener(_calculateRateCutAmount);
    _rateCutFineCtrl.addListener(_calculateRateCutAmount);
    if (widget.transactionId != null) {
      _loadTransaction();
    } else {
      _lines.add(MetalTxnLineState()..type = 'Metal Issue');
    }
  }

  @override
  void dispose() {
    _rateCutMetalRateCtrl.removeListener(_calculateRateCutAmount);
    _rateCutFineCtrl.removeListener(_calculateRateCutAmount);
    _transactionNumberCtrl.dispose();
    _referenceNoCtrl.dispose();
    _remarksController.dispose();
    _rateCutMetalRateCtrl.dispose();
    _rateCutFineCtrl.dispose();
    _rateCutAmountCtrl.dispose();
    super.dispose();
  }

  void _calculateRateCutAmount() {
    final metalRate = double.tryParse(_rateCutMetalRateCtrl.text) ?? 0;
    final fine = double.tryParse(_rateCutFineCtrl.text) ?? 0;
    final amount = metalRate * fine;
    if (amount > 0 && _rateCutAmountCtrl.text != amount.toStringAsFixed(2)) {
      _rateCutAmountCtrl.text = amount.toStringAsFixed(2);
    }
    setState(() {
      _rateCutGold = fine;
      _rateCutCash = double.tryParse(_rateCutAmountCtrl.text) ?? 0;
      _rateCutMetalRate = metalRate;
    });
    _calculateTotals();
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
        for (var l in lines) {
          final desc = l.description ?? '';
          if (desc.startsWith('M-Rec:') || desc.startsWith('M-Pay:')) {
            // Skip legacy metal receipt/payment lines
          } else if (desc.startsWith('R-Cut:')) {
            _rateCutGold = l.netWeight;
            _rateCutCash = l.amount;
            _rateCutMetalRate = l.rate;
            _rateCutMetalRateCtrl.text = l.rate.toString();
            _rateCutFineCtrl.text = l.netWeight.toString();
            _rateCutAmountCtrl.text = l.amount.toString();

            // Re-parse types from description if possible, else default
            if (desc.contains('|FineType:')) {
              _rateCutFineType = desc.split('|FineType:')[1].split('|')[0];
            }
            if (desc.contains('|AmountType:')) {
              _rateCutAmountType = desc.split('|AmountType:')[1].split('|')[0];
            }
            if (desc.contains('|MetalType:')) {
              _rateCutMetalType = desc.split('|MetalType:')[1].split('|')[0];
            }
            if (desc.contains('|FineUnit:')) {
              _rateCutFineUnit = desc.split('|FineUnit:')[1].split('|')[0];
            }
            if (desc.contains('|AmountUnit:')) {
              _rateCutAmountUnit = desc.split('|AmountUnit:')[1].split('|')[0];
            }
          } else {
            final lineState = MetalTxnLineState();
            lineState.type = l.lineType == 'Credit'
                ? 'Metal Receipt'
                : 'Metal Issue';
            lineState.selectedItemId = l.itemId;
            lineState.descCtrl.text = l.description ?? '';
            lineState.grossWeightCtrl.text = l.grossWeight.toString();
            final lessWt = l.grossWeight - l.netWeight;
            lineState.lessWeightCtrl.text = lessWt > 0 ? lessWt.toString() : '0';
            lineState.netWeightCtrl.text = l.netWeight.toString();
            lineState.purityCtrl.text = l.purity.toString();
            lineState.stoneWeightCtrl.text = l.stoneWeight.toString();
            lineState.wastageCtrl.text = l.wastage.toString();
            final fine = l.netWeight * ((l.purity ?? 0) + l.wastage) / 100;
            lineState.fineWeightCtrl.text = fine.toStringAsFixed(3);
            lineState.rateCtrl.text = l.rate.toString();
            lineState.amountCtrl.text = l.amount.toString();
            lineState.stampCtrl.text = l.stamp ?? '';
            _lines.add(lineState);
          }
        }
        if (_lines.isEmpty) {
          _lines.add(MetalTxnLineState()..type = 'Metal Issue');
        }
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => _calculateTotals());
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _addLine() {
    setState(() {
      _lines.add(MetalTxnLineState()..type = 'Metal Issue');
    });
  }

  void _removeLine(int index) {
    if (_lines.length > 1) {
      setState(() {
        _lines.removeAt(index);
        _calculateTotals();
      });
    }
  }

  void _calculateTotals() {
    double goldIn = 0;
    double goldOut = 0;
    for (var line in _lines) {
      double fine = double.tryParse(line.fineWeightCtrl.text) ?? 0;

      if (line.type == 'Metal Receipt') {
        goldIn += fine;
      } else {
        goldOut += fine;
      }
    }

    setState(() {
      _totalGoldIn = goldIn;
      _totalGoldOut = goldOut;
      // Net gold change from table lines
      _subTotalGold = goldOut - goldIn;
      // Grand total impact (Gold and Cash)
      // Note: goldImpact is how much the party OWES us.
      // Gold Out (Issue) -> Party owes us (+)
      // Gold In (Receipt) -> Party owes us less (-)
      // Rate Cut -> Reduces Gold owed (In), Increases Cash owed (+)
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPartyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer or supplier')),
      );
      return;
    }
    {
      final header = TransactionsCompanion(
        transactionNumber: drift.Value(
          _transactionNumberCtrl.text.isEmpty
              ? null
              : _transactionNumberCtrl.text,
        ),
        date: drift.Value(_date),
        partyId: drift.Value(_selectedPartyId!),
        type: drift.Value(_type),
        totalGoldWeight: drift.Value(_subTotalGold), // Simplified net gold
        totalSilverWeight: const drift.Value(0),
        totalAmount: drift.Value(
          (_rateCutGold > 0 || _rateCutCash > 0
                  ? (_rateCutAmountType == 'Receivable'
                        ? _rateCutCash
                        : -_rateCutCash)
                  : 0) +
              _lines
                  .where((l) => l.type == 'Rate Cut')
                  .fold(
                    0.0,
                    (sum, l) => sum + (double.tryParse(l.amountCtrl.text) ?? 0),
                  ),
        ),
        remarks: drift.Value(_remarksController.text),
        status: drift.Value('Completed'),
      );

      final List<TransactionLinesCompanion> lines = [];

      // Main lines
      for (var l in _lines) {
        if (l.selectedItemId == null) continue;
        lines.add(
          TransactionLinesCompanion(
            itemId: drift.Value(l.selectedItemId),
            description: drift.Value(l.descCtrl.text),
            grossWeight: drift.Value(
              double.tryParse(l.grossWeightCtrl.text) ?? 0,
            ),
            netWeight: drift.Value(double.tryParse(l.netWeightCtrl.text) ?? 0),
            purity: drift.Value(double.tryParse(l.purityCtrl.text) ?? 0),
            stoneWeight: drift.Value(
              double.tryParse(l.stoneWeightCtrl.text) ?? 0,
            ),
            wastage: drift.Value(double.tryParse(l.wastageCtrl.text) ?? 0),
            rate: drift.Value(double.tryParse(l.rateCtrl.text) ?? 0),
            amount: drift.Value(double.tryParse(l.amountCtrl.text) ?? 0),
            lineType: drift.Value(
              l.type == 'Metal Receipt' ? 'Credit' : 'Debit',
            ),
            qty: drift.Value(1.0),
          ),
        );
      }

      // Special lines
      if (_rateCutGold > 0 || _rateCutCash > 0) {
        lines.add(
          TransactionLinesCompanion(
            description: drift.Value(
              'R-Cut:Rate Cut|MetalType:$_rateCutMetalType|FineType:$_rateCutFineType|FineUnit:$_rateCutFineUnit|AmountType:$_rateCutAmountType|AmountUnit:$_rateCutAmountUnit',
            ),
            netWeight: drift.Value(_rateCutGold),
            amount: drift.Value(_rateCutCash),
            rate: drift.Value(_rateCutMetalRate),
            lineType: drift.Value(
              _rateCutFineType == 'Payable' ? 'Debit' : 'Credit',
            ),
            qty: drift.Value(1.0),
          ),
        );
      }

      final repo = ref.read(transactionsControllerProvider.notifier);
      if (widget.transactionId != null) {
        await repo.updateTransaction(
          id: widget.transactionId!,
          header: header,
          lines: lines,
        );
      } else {
        await repo.createTransaction(header: header, lines: lines);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Metal Transaction Saved')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(partiesRepositoryProvider);
    final partiesFuture = Future.wait([
      repo.getParties('Customer'),
      repo.getParties('Supplier'),
    ]).then((results) => [...results[0], ...results[1]]);
    final itemsAsync = ref.watch(itemsListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.transactionId != null
              ? 'Edit Metal Transaction'
              : 'New Metal Transaction',
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Party>>(
              future: partiesFuture,
              builder: (context, snapshot) {
                final parties = snapshot.data ?? [];
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    _buildHeaderSection(parties),
                                    const SizedBox(height: 24),
                                    _buildItemsSection(itemsAsync),
                                    const SizedBox(height: 24),
                                    _buildRemarksSection(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildRateCutSection(),
                                    const SizedBox(height: 24),
                                    _buildSummarySection(parties),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomBar(),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildHeaderSection(List<Party> parties) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _selectedPartyId,
                  decoration: const InputDecoration(
                    labelText: 'Customer / Supplier *',
                  ),
                  items: parties
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text('${p.name} (${p.type})'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPartyId = v),
                  validator: (v) => v == null ? 'Required' : null,
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
                    decoration: const InputDecoration(labelText: 'Date *'),
                    child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _transactionNumberCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Voucher No.',
                    hintText: 'Auto-generated',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _referenceNoCtrl,
                  decoration: const InputDecoration(labelText: 'Ref No.'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(AsyncValue<List<Item>> itemsAsync) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _addLine,
                icon: const Icon(Icons.add),
                label: const Text('Add Line'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          itemsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Error: $e'),
            data: (items) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
              defaultColumnWidth: const FixedColumnWidth(110),
              columnWidths: const {
                0: FixedColumnWidth(90),  // Type
                1: FixedColumnWidth(140), // Item
                2: FixedColumnWidth(100), // Gross
                3: FixedColumnWidth(100), // Less
                4: FixedColumnWidth(100), // Net
                5: FixedColumnWidth(90),  // Touch
                6: FixedColumnWidth(90),  // Wastage
                7: FixedColumnWidth(110), // Fine Wt
                8: IntrinsicColumnWidth(), // Action
              },
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Gross Wt', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Less Wt', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Net Wt', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Touch', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Wastage', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Fine Wt', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(),
                  ],
                ),
                ...List.generate(
                  _lines.length,
                  (index) => _buildItemRow(index, items),
                ),
              ],
            ),
          ),
            ),
        ],
      ),
    );
  }

  void _recalcLine(MetalTxnLineState line) {
    final gross = double.tryParse(line.grossWeightCtrl.text) ?? 0;
    final less = double.tryParse(line.lessWeightCtrl.text) ?? 0;
    final net = gross - less;
    line.netWeightCtrl.text = net.toStringAsFixed(3);
    final touch = double.tryParse(line.purityCtrl.text) ?? 0;
    final wastage = double.tryParse(line.wastageCtrl.text) ?? 0;
    final fine = net * (touch + wastage) / 100;
    line.fineWeightCtrl.text = fine.toStringAsFixed(3);
    _calculateTotals();
  }

  TableRow _buildItemRow(int index, List<Item> items) {
    final line = _lines[index];
    return TableRow(
      children: [
        // Type
        Padding(
          padding: const EdgeInsets.all(4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: line.type,
              items: const [
                DropdownMenuItem(value: 'Metal Issue', child: Text('Out')),
                DropdownMenuItem(value: 'Metal Receipt', child: Text('In')),
              ],
              onChanged: (v) => setState(() {
                line.type = v!;
                _calculateTotals();
              }),
            ),
          ),
        ),
        // Item
        Padding(
          padding: const EdgeInsets.all(4),
          child: DropdownButtonFormField<int>(
            isExpanded: true,
            initialValue: line.selectedItemId,
            items: items
                .map((i) => DropdownMenuItem(value: i.id, child: Text(i.name, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (v) => setState(() {
              line.selectedItemId = v;
            }),
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        // Gross Wt
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextFormField(
            controller: line.grossWeightCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() => _recalcLine(line)),
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        // Less Wt
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextFormField(
            controller: line.lessWeightCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() => _recalcLine(line)),
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        // Net Wt (read-only, calculated)
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextFormField(
            controller: line.netWeightCtrl,
            readOnly: true,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        // Touch
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextFormField(
            controller: line.purityCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() => _recalcLine(line)),
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        // Wastage
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextFormField(
            controller: line.wastageCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() => _recalcLine(line)),
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        // Fine Wt (read-only, calculated)
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextFormField(
            controller: line.fineWeightCtrl,
            readOnly: true,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        // Delete
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          onPressed: () => _removeLine(index),
        ),
      ],
    );
  }

  Widget _buildRemarksSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: TextFormField(
        controller: _remarksController,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Remarks',
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildRateCutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cut, size: 20, color: AppTheme.primaryAction),
              const SizedBox(width: 8),
              Text(
                'Rate Cut Adjustment',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Enter metal rate of 1 unit (gm or kg).',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Rate of? (Gold/Silver)
          Text('Rate of?', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          RadioGroup<String>(
            groupValue: _rateCutMetalType,
            onChanged: (v) => setState(() => _rateCutMetalType = v!),
            child: Row(
              children: [
                Radio<String>(value: 'Gold'),
                const Text('Gold'),
                const SizedBox(width: 16),
                Radio<String>(value: 'Silver'),
                const Text('Silver'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Metal Rate
          TextFormField(
            controller: _rateCutMetalRateCtrl,
            decoration: const InputDecoration(
              labelText: 'Metal Rate',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          // Fine + Unit + Type
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _rateCutFineCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Fine',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _rateCutFineUnit,
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
                  items: const [
                    DropdownMenuItem(value: 'g', child: Text('g')),
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                  ],
                  onChanged: (v) { if (v != null) setState(() => _rateCutFineUnit = v); },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  initialValue: _rateCutFineType,
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 12)),
                  items: const [
                    DropdownMenuItem(value: 'Payable', child: Text('Payable', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Receivable', child: Text('Receivable', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) { if (v != null) setState(() => _rateCutFineType = v); },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Amount + Unit + Type
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _rateCutAmountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    setState(() {
                      _rateCutCash = double.tryParse(_rateCutAmountCtrl.text) ?? 0;
                    });
                    _calculateTotals();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _rateCutAmountUnit,
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
                  items: const [
                    DropdownMenuItem(value: '₹', child: Text('₹')),
                    DropdownMenuItem(value: '%', child: Text('%')),
                  ],
                  onChanged: (v) { if (v != null) setState(() => _rateCutAmountUnit = v); },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  initialValue: _rateCutAmountType,
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 12)),
                  items: const [
                    DropdownMenuItem(value: 'Payable', child: Text('Payable', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Receivable', child: Text('Receivable', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) { if (v != null) setState(() => _rateCutAmountType = v); },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(List<Party> parties) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Gold In'),
              Text(
                '${_totalGoldIn.toStringAsFixed(3)} g',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Gold Out'),
              Text(
                '${_totalGoldOut.toStringAsFixed(3)} g',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Net Meta Impact',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${_subTotalGold.toStringAsFixed(3)} g',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _subTotalGold >= 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          if (_rateCutCash != 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rate Cut Cash'),
                Text(
                  '₹${_rateCutCash.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: _rateCutAmountType == 'Receivable'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        border: Border(top: BorderSide(color: AppTheme.borderLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save Transaction'),
          ),
        ],
      ),
    );
  }

}

class MetalTxnLineState {
  String type = 'Metal Issue';
  int? selectedItemId;
  final descCtrl = TextEditingController();
  final grossWeightCtrl = TextEditingController(text: '0');
  final lessWeightCtrl = TextEditingController(text: '0');
  final netWeightCtrl = TextEditingController(text: '0');
  final purityCtrl = TextEditingController(text: '100');
  final stoneWeightCtrl = TextEditingController(text: '0');
  final wastageCtrl = TextEditingController(text: '0');
  final fineWeightCtrl = TextEditingController(text: '0');
  final rateCtrl = TextEditingController(text: '0');
  final amountCtrl = TextEditingController(text: '0');
  final stampCtrl = TextEditingController();
}

