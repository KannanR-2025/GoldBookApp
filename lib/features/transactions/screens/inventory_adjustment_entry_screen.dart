import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/inventory/items_provider.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:intl/intl.dart';

class InventoryAdjustmentEntryScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  const InventoryAdjustmentEntryScreen({super.key, this.transactionId});

  @override
  ConsumerState<InventoryAdjustmentEntryScreen> createState() =>
      _InventoryAdjustmentEntryScreenState();
}

class _InventoryAdjustmentEntryScreenState
    extends ConsumerState<InventoryAdjustmentEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Header State
  final String _type = 'Inventory Adjustment';
  DateTime _date = DateTime.now();

  final _transactionNumberCtrl = TextEditingController();
  final _remarksController = TextEditingController();

  // Lines State
  final List<TransactionLineState> _lines = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _lines.add(TransactionLineState());

    if (widget.transactionId != null) {
      _loadTransaction();
    } else {
      _generateTransactionNumber();
    }
  }

  void _generateTransactionNumber() {
    _transactionNumberCtrl.text =
        'ADJ-${DateFormat('yyyyMMdd-HHmmss').format(DateTime.now())}';
  }

  Future<void> _loadTransaction() async {
    setState(() => _isLoading = true);
    final repo = ref.read(transactionsRepositoryProvider);
    final txn = await repo.getTransaction(widget.transactionId!);
    if (txn != null) {
      final lines = await repo.getTransactionLines(widget.transactionId!);

      setState(() {
        _date = txn.date;
        _transactionNumberCtrl.text = txn.transactionNumber ?? '';
        _remarksController.text = txn.remarks ?? '';

        _lines.clear();
        for (var line in lines) {
          _lines.add(
            TransactionLineState(
              itemId: line.itemId,
              description: line.description,
              qty: line.qty, // Will be negative for loss, positive for found
              grossWeight: line.grossWeight,
              netWeight: line.netWeight,
            ),
          );
        }
        if (_lines.isEmpty) _lines.add(TransactionLineState());
      });
    }
    setState(() => _isLoading = false);
  }

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
              ? 'New Inventory Adjustment'
              : 'Edit Inventory Adjustment',
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
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 16),
                    _buildLinesSection(),
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

  Widget _buildHeaderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Internal Party ID Hidden
            Row(
              children: [
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
                const SizedBox(width: 16),
                Expanded(child: Container()), // Spacer for grid if needed
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _transactionNumberCtrl,
              decoration: const InputDecoration(labelText: 'Adjustment Ref No'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _remarksController,
              decoration: const InputDecoration(labelText: 'Reason / Remarks'),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinesSection() {
    final items = ref.watch(itemsListProvider).asData?.value ?? [];

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adjustment Items',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      setState(() => _lines.add(TransactionLineState())),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Row'),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _lines.length,
            separatorBuilder: (c, i) => const Divider(),
            itemBuilder: (context, index) {
              final line = _lines[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Selection
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<int>(
                        initialValue: line.itemId,
                        decoration: const InputDecoration(labelText: 'Item'),
                        items: items.map((i) {
                          return DropdownMenuItem(
                            value: i.id,
                            child: Text('${i.name} (Cur: ${i.stockQty})'),
                          );
                        }).toList(),
                        onChanged: (v) async {
                          setState(() => line.itemId = v);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Qty
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: line.qty?.toString() ?? '0',
                        decoration: const InputDecoration(
                          labelText: 'Adj Qty (+/-)',
                          helperText: '-Loss, +Found',
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                        ),
                        onChanged: (v) {
                          line.qty = double.tryParse(v);
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Net Wt
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: line.netWeight?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Adj Wt (+/-)',
                          helperText: 'Grams',
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                        ),
                        onChanged: (v) {
                          line.netWeight = double.tryParse(v);
                          setState(() {});
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _lines.removeAt(index)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.backgroundWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Save Adjustment'),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add at least one item')));
      return;
    }

    // Get System Party
    final repo = ref.read(transactionsRepositoryProvider);
    int partyId;
    try {
      partyId = await repo.getOrCreateSystemParty();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting System Party: $e')),
        );
      }
      return;
    }

    final header = TransactionsCompanion(
      id: widget.transactionId != null
          ? drift.Value(widget.transactionId!)
          : const drift.Value.absent(),
      transactionNumber: drift.Value(_transactionNumberCtrl.text),
      date: drift.Value(_date),
      partyId: drift.Value(partyId), // Link to System Party
      type: drift.Value(_type),
      remarks: drift.Value(_remarksController.text),
      totalGoldWeight: const drift.Value(0), // No financial impact yet
      totalSilverWeight: const drift.Value(0),
      totalAmount: const drift.Value(0),
      status: const drift.Value('Completed'),
    );

    final lines = _lines.map((l) {
      return TransactionLinesCompanion(
        itemId: drift.Value(l.itemId),
        description: drift.Value(l.description),
        qty: drift.Value(l.qty ?? 0),
        grossWeight: const drift.Value(0),
        netWeight: drift.Value(l.netWeight ?? 0),
        amount: const drift.Value(0),
      );
    }).toList();

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

class TransactionLineState {
  int? itemId;
  String? description;
  double? qty;
  double? grossWeight;
  double? netWeight;

  TransactionLineState({
    this.itemId,
    this.description,
    this.qty = 0,
    this.grossWeight,
    this.netWeight,
  });
}
