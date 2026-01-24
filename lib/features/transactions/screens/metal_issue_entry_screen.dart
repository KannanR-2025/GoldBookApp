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

class MetalIssueEntryScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  const MetalIssueEntryScreen({super.key, this.transactionId});

  @override
  ConsumerState<MetalIssueEntryScreen> createState() =>
      _MetalIssueEntryScreenState();
}

class _MetalIssueEntryScreenState extends ConsumerState<MetalIssueEntryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Header State
  final String _type = 'MetalIssue';
  DateTime _date = DateTime.now();

  int? _selectedPartyId;
  final _transactionNumberCtrl = TextEditingController();
  final _partyPoCtrl = TextEditingController();
  final _dueDaysCtrl = TextEditingController(text: '0');
  DateTime? _dueDate;
  final _remarksController = TextEditingController();

  // Payment & Discount
  String? _paymentMethod;
  final _paymentRefCtrl = TextEditingController();
  final _discountAmountCtrl = TextEditingController(text: '0');
  final _discountPercentCtrl = TextEditingController(text: '0');
  final _taxAmountCtrl = TextEditingController(text: '0');
  final _taxPercentCtrl = TextEditingController(text: '0');

  // Lines State
  final List<TransactionLineState> _lines = [];

  // Gold Rate
  final _goldRateCtrl = TextEditingController(text: '6450.00');
  final _silverRateCtrl = TextEditingController(text: '78.50');

  // Totals
  double _totalGold = 0;
  double _totalSilver = 0;
  double _subtotal = 0;
  double _totalCash = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _lines.add(TransactionLineState());

    if (widget.transactionId != null) {
      _loadTransaction();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        _paymentMethod = txn.paymentMethod;
        _paymentRefCtrl.text = txn.paymentReference ?? '';
        _partyPoCtrl.text = txn.partyPoNumber ?? '';
        _dueDaysCtrl.text = txn.dueDays?.toString() ?? '0';
        _dueDate = txn.dueDate;
        _remarksController.text = txn.remarks ?? '';
        _discountAmountCtrl.text = txn.discountAmount.toString();
        _discountPercentCtrl.text = txn.discountPercentage.toString();
        _taxAmountCtrl.text = txn.taxAmount.toString();
        _taxPercentCtrl.text = txn.taxPercentage.toString();

        _lines.clear();
        for (var l in lines) {
          final lineState = TransactionLineState();
          lineState.selectedItemId = l.itemId;
          lineState.descCtrl.text = l.description ?? '';
          lineState.metalType = 'Gold';
          lineState.grossWeightCtrl.text = l.grossWeight.toString();
          lineState.netWeightCtrl.text = l.netWeight.toString();
          lineState.purityCtrl.text = l.purity.toString();
          lineState.stoneWeightCtrl.text = l.stoneWeight.toString();
          lineState.wastageCtrl.text = l.wastage.toString();
          lineState.makingChargesCtrl.text = l.makingCharges.toString();
          lineState.rateCtrl.text = l.rate.toString();
          lineState.amountCtrl.text = l.amount.toString();
          lineState.stampCtrl.text = l.stamp ?? '';
          lineState.sizeCtrl.text = l.size ?? '';
          lineState.colorCtrl.text = l.color ?? '';
          lineState.ghatWeightCtrl.text = l.ghatWeight.toString();
          lineState.rateOn = l.rateOn ?? 'Net Weight';
          _lines.add(lineState);
        }
        if (_lines.isEmpty) _lines.add(TransactionLineState());
        _isLoading = false;

        WidgetsBinding.instance.addPostFrameCallback((_) => _calculateTotals());
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _addLine() {
    setState(() {
      _lines.add(TransactionLineState());
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
    double gold = 0;
    double silver = 0;
    double cash = 0;

    for (var line in _lines) {
      double purity = double.tryParse(line.purityCtrl.text) ?? 0;
      double net = double.tryParse(line.netWeightCtrl.text) ?? 0;
      double rate = double.tryParse(line.rateCtrl.text) ?? 0;
      double makingCharges = double.tryParse(line.makingChargesCtrl.text) ?? 0;

      String metalType = line.metalType ?? 'Gold';

      double fine = net * (purity / 100);

      double amountBeforeCharges = 0;
      if (line.rateOn == 'Fine Weight') {
        amountBeforeCharges = fine * rate;
      } else if (line.rateOn == 'Fixed') {
        amountBeforeCharges = rate;
      } else {
        amountBeforeCharges = net * rate;
      }

      if (rate > 0) {
        double calculatedAmount = amountBeforeCharges + makingCharges;
        line.amountCtrl.text = calculatedAmount.toStringAsFixed(2);
      }

      if (metalType == 'Gold') {
        gold += fine;
      } else {
        silver += fine;
      }

      double amount = double.tryParse(line.amountCtrl.text) ?? 0;
      cash += amount;
    }

    double subtotal = cash;

    double discountAmount = double.tryParse(_discountAmountCtrl.text) ?? 0;
    double discountPercent = double.tryParse(_discountPercentCtrl.text) ?? 0;
    if (discountPercent > 0) {
      discountAmount = subtotal * (discountPercent / 100);
    }
    double afterDiscount = subtotal - discountAmount;

    double taxAmount = double.tryParse(_taxAmountCtrl.text) ?? 0;
    double taxPercent = double.tryParse(_taxPercentCtrl.text) ?? 0;
    if (taxPercent > 0) {
      taxAmount = afterDiscount * (taxPercent / 100);
    }
    double finalAmount = afterDiscount + taxAmount;

    setState(() {
      _totalGold = gold;
      _totalSilver = silver;
      _subtotal = subtotal;
      _totalCash = finalAmount;
    });
  }

  void _save() async {
    if (_formKey.currentState!.validate() && _selectedPartyId != null) {
      final header = TransactionsCompanion(
        transactionNumber: drift.Value(
          _transactionNumberCtrl.text.isEmpty
              ? null
              : _transactionNumberCtrl.text,
        ),
        date: drift.Value(_date),
        partyId: drift.Value(_selectedPartyId!),
        type: drift.Value(_type),
        paymentMethod: drift.Value(_paymentMethod),
        paymentReference: drift.Value(
          _paymentRefCtrl.text.isEmpty ? null : _paymentRefCtrl.text,
        ),
        dueDays: drift.Value(int.tryParse(_dueDaysCtrl.text)),
        dueDate: drift.Value(_dueDate),
        partyPoNumber: drift.Value(
          _partyPoCtrl.text.isEmpty ? null : _partyPoCtrl.text,
        ),
        discountAmount: drift.Value(
          double.tryParse(_discountAmountCtrl.text) ?? 0,
        ),
        discountPercentage: drift.Value(
          double.tryParse(_discountPercentCtrl.text) ?? 0,
        ),
        taxAmount: drift.Value(double.tryParse(_taxAmountCtrl.text) ?? 0),
        taxPercentage: drift.Value(double.tryParse(_taxPercentCtrl.text) ?? 0),
        totalGoldWeight: drift.Value(_totalGold),
        totalSilverWeight: drift.Value(_totalSilver),
        subtotal: drift.Value(_subtotal),
        totalAmount: drift.Value(_totalCash),
        remarks: drift.Value(_remarksController.text),
        status: drift.Value('Completed'),
      );

      final lines = _lines.map((l) {
        return TransactionLinesCompanion(
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
          makingCharges: drift.Value(
            double.tryParse(l.makingChargesCtrl.text) ?? 0,
          ),
          rate: drift.Value(double.tryParse(l.rateCtrl.text) ?? 0),
          amount: drift.Value(double.tryParse(l.amountCtrl.text) ?? 0),
          stamp: drift.Value(
            l.stampCtrl.text.isEmpty ? null : l.stampCtrl.text,
          ),
          size: drift.Value(l.sizeCtrl.text.isEmpty ? null : l.sizeCtrl.text),
          color: drift.Value(
            l.colorCtrl.text.isEmpty ? null : l.colorCtrl.text,
          ),
          rateOn: drift.Value(l.rateOn),
          ghatWeight: drift.Value(double.tryParse(l.ghatWeightCtrl.text) ?? 0),
        );
      }).toList();

      if (widget.transactionId != null) {
        await ref
            .read(transactionsControllerProvider.notifier)
            .updateTransaction(
              id: widget.transactionId!,
              header: header,
              lines: lines,
            );
      } else {
        await ref
            .read(transactionsControllerProvider.notifier)
            .createTransaction(header: header, lines: lines);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('MetalIssue Saved')));
        context.pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String partyType = 'Supplier';

    final partiesFuture = ref
        .watch(partiesRepositoryProvider)
        .getParties(partyType);
    final itemsAsync = ref.watch(itemsListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.transactionId != null ? 'Edit MetalIssue' : 'New MetalIssue',
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
                      // Tab Bar
                      Container(
                        color: AppTheme.backgroundWhite,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: AppTheme.primaryAction,
                          unselectedLabelColor: AppTheme.textSecondary,
                          indicatorColor: AppTheme.primaryAction,
                          tabs: const [
                            Tab(text: 'Header Info'),
                            Tab(text: 'Items'),
                            Tab(text: 'Totals'),
                          ],
                        ),
                      ),
                      // Tab Content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildHeaderTab(parties),
                            _buildItemsTab(itemsAsync),
                            _buildTotalsTab(),
                          ],
                        ),
                      ),
                      // Action buttons
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundWhite,
                          border: Border(
                            top: BorderSide(color: AppTheme.borderLight),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => context.pop(),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _save,
                              child: const Text('Save MetalIssue'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildHeaderTab(List<Party> parties) {
    const String partyType = 'Supplier';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Party Section
          Text('Party & Date', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _selectedPartyId,
                  decoration: InputDecoration(labelText: '$partyType *'),
                  items: parties
                      .map(
                        (p) =>
                            DropdownMenuItem(value: p.id, child: Text(p.name)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPartyId = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              if (_selectedPartyId != null)
                Builder(
                  builder: (context) {
                    final party = parties.firstWhere(
                      (p) => p.id == _selectedPartyId,
                      orElse: () => Party(
                        id: -1,
                        name: '',
                        type: '',
                        mobile: '',
                        createdAt: DateTime.now(),
                        addressLine1: '',
                        customerType: '',
                        debitLimit: 0,
                        debitLimitCurrency: 'INR',
                        city: '',
                        state: '',
                        pinCode: '',
                        country: 'India',
                        status: 'Active',
                        openingGoldBalance: 0,
                        openingSilverBalance: 0,
                        openingCashBalance: 0,
                        goldBalance: 0,
                        silverBalance: 0,
                        cashBalance: 0,
                        creditLimitGold: 0,
                        creditLimitCash: 0,
                        discountPercentage: 0,
                        taxPreference: 'Taxable',
                        defaultWastage: null,
                        defaultRate: null,
                      ),
                    );
                    if (party.id == -1) {
                      return const SizedBox();
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primaryGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Gold: ${party.goldBalance.toStringAsFixed(3)} g',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGoldDark,
                            ),
                          ),
                          Text(
                            'Silver: ${party.silverBalance.toStringAsFixed(3)} g',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            'Cash: ₹${party.cashBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.success,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
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
                    decoration: const InputDecoration(labelText: 'Date *'),
                    child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _transactionNumberCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Transaction/Invoice #',
                    hintText: 'Auto-generated if empty',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Rates Section
          Text('Metal Rates', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _goldRateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Gold Rate (24k) per gram',
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _silverRateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Silver Rate per gram',
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Payment Section
          Text(
            'Payment Details',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _paymentMethod,
            decoration: const InputDecoration(labelText: 'Payment Method'),
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'Card', child: Text('Card')),
              DropdownMenuItem(value: 'UPI', child: Text('UPI')),
              DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
              DropdownMenuItem(
                value: 'Bank Transfer',
                child: Text('Bank Transfer'),
              ),
              DropdownMenuItem(value: 'Credit', child: Text('Credit')),
            ],
            onChanged: (v) => setState(() => _paymentMethod = v),
          ),
          if (_paymentMethod != null &&
              _paymentMethod != 'Cash' &&
              _paymentMethod != 'Credit')
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                controller: _paymentRefCtrl,
                decoration: const InputDecoration(
                  labelText: 'Payment Reference (Cheque No / Transaction ID)',
                  hintText: 'Enter details...',
                ),
              ),
            ),
          const SizedBox(height: 32),
          // Due Date & PO Section
          Text(
            'Terms & References',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _dueDaysCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Due Days',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _partyPoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Party PO Number',
                    hintText: 'Optional',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _remarksController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Remarks/Notes',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTab(AsyncValue<List<Item>> itemsAsync) {
    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (inventoryItems) {
        return Column(
          children: [
            // Add Item Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MetalIssue Items',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: _addLine,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
            ),
            // Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _lines.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildLineItem(index, inventoryItems);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTotalsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discount Section
          Text('Discount', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _discountPercentCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Discount (%)',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _discountAmountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Discount Amount (₹)',
                    prefixText: '₹ ',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Tax Section
          Text('Tax / GST', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _taxPercentCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tax/GST (%)',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _taxAmountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tax Amount (₹)',
                    prefixText: '₹ ',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Totals Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_totalGold > 0)
                  _TotalRow(
                    label: 'Total Fine Gold:',
                    value: '${_totalGold.toStringAsFixed(3)} g',
                  ),
                if (_totalSilver > 0)
                  _TotalRow(
                    label: 'Total Fine Silver:',
                    value: '${_totalSilver.toStringAsFixed(3)} g',
                  ),
                if (_totalGold > 0 || _totalSilver > 0)
                  const Divider(height: 20),
                _TotalRow(
                  label: 'Subtotal:',
                  value: NumberFormat.currency(symbol: '₹').format(_subtotal),
                  isSubtotal: true,
                ),
                if ((double.tryParse(_discountAmountCtrl.text) ?? 0) > 0)
                  _TotalRow(
                    label: 'Discount:',
                    value:
                        '- ${NumberFormat.currency(symbol: '₹').format(double.tryParse(_discountAmountCtrl.text) ?? 0)}',
                    isDiscount: true,
                  ),
                if ((double.tryParse(_taxAmountCtrl.text) ?? 0) > 0)
                  _TotalRow(
                    label: 'Tax/GST:',
                    value:
                        '+ ${NumberFormat.currency(symbol: '₹').format(double.tryParse(_taxAmountCtrl.text) ?? 0)}',
                    isTax: true,
                  ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grand Total',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      NumberFormat.currency(symbol: '₹').format(_totalCash),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGoldDark,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItem(int index, List<Item> inventoryItems) {
    final line = _lines[index];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<int>(
                  initialValue: line.selectedItemId,
                  decoration: const InputDecoration(
                    labelText: 'Item *',
                    isDense: true,
                  ),
                  items: inventoryItems
                      .map(
                        (i) => DropdownMenuItem(
                          value: i.id,
                          child: Text(i.name, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      line.selectedItemId = v;
                      final item = inventoryItems.firstWhere(
                        (i) => i.id == v,
                        orElse: () => Item(
                          id: -1,
                          name: '',
                          metalType: 'Gold',
                          costPrice: 0,
                          sellingPrice: 0,
                          makingCharges: 0,
                          wastagePercentage: 0,
                          stockQty: 0,
                          stockWeight: 0,
                          minimumStockLevel: 0,
                          reorderLevel: 0,
                          unitOfMeasurement: 'g',
                          status: 'Active',
                          itemType: 'Goods',
                          maintainStockIn: 'Grams',
                          isStudded: false,
                          fetchGoldRate: false,
                          defaultTouch: 0,
                          taxPreference: 'Taxable',
                          purchaseWastage: 0,
                          purchaseMakingCharges: 0,
                          jobworkRate: 0,
                          stockMethod: 'Loose',
                          minStockPcs: 0,
                          maxStockGm: 0,
                          maxStockPcs: 0,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      );
                      if (item.id != -1) {
                        line.descCtrl.text = item.description ?? '';
                        line.metalType = item.metalType;
                        line.purityCtrl.text = item.purity ?? '91.6';
                      }
                    });
                  },
                  validator: (v) => v == null ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: line.descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _removeLine(index),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: line.grossWeightCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Gross Wt',
                    isDense: true,
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    double gross = double.tryParse(v) ?? 0;
                    double stone =
                        double.tryParse(line.stoneWeightCtrl.text) ?? 0;
                    line.netWeightCtrl.text = (gross - stone).toStringAsFixed(
                      3,
                    );
                    _calculateTotals();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: line.stoneWeightCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Stone Wt',
                    isDense: true,
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    double gross =
                        double.tryParse(line.grossWeightCtrl.text) ?? 0;
                    double stone = double.tryParse(v) ?? 0;
                    line.netWeightCtrl.text = (gross - stone).toStringAsFixed(
                      3,
                    );
                    _calculateTotals();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: line.netWeightCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Net Wt *',
                    isDense: true,
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                  validator: (v) =>
                      (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Invalid' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: line.purityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Purity %',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: line.makingChargesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'MC (Rs)',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: line.rateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Rate',
                    isDense: true,
                    prefixText: '₹',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: line.rateOn,
                  decoration: const InputDecoration(
                    labelText: 'Rate On',
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Net Weight',
                      child: Text('Net Wt'),
                    ),
                    DropdownMenuItem(
                      value: 'Fine Weight',
                      child: Text('Fine Wt'),
                    ),
                    DropdownMenuItem(value: 'Fixed', child: Text('Fixed Amt')),
                  ],
                  onChanged: (v) {
                    setState(() => line.rateOn = v!);
                    _calculateTotals();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: line.amountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    isDense: true,
                    prefixText: '₹',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateTotals(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ExpansionTile(
            title: const Text(
              'More Details (Stamp, Size, Color, Ghat)',
              style: TextStyle(fontSize: 12),
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: line.stampCtrl,
                      decoration: const InputDecoration(labelText: 'Stamp'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: line.sizeCtrl,
                      decoration: const InputDecoration(labelText: 'Size'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: line.colorCtrl,
                      decoration: const InputDecoration(labelText: 'Color'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: line.ghatWeightCtrl,
                      decoration: const InputDecoration(labelText: 'Ghat Wt'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isSubtotal;
  final bool isDiscount;
  final bool isTax;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isSubtotal = false,
    this.isDiscount = false,
    this.isTax = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color = AppTheme.textPrimary;
    FontWeight weight = FontWeight.normal;

    if (isSubtotal) {
      weight = FontWeight.bold;
    } else if (isDiscount) {
      color = AppTheme.success;
    } else if (isTax) {
      color = AppTheme.error;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: weight,
              color: AppTheme.textSecondary,
            ),
          ),
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

class TransactionLineState {
  int? selectedItemId;
  String? metalType;
  String rateOn = 'Net Weight';

  final descCtrl = TextEditingController();
  final grossWeightCtrl = TextEditingController(text: '0');
  final netWeightCtrl = TextEditingController(text: '0');
  final purityCtrl = TextEditingController(text: '91.6');
  final stoneWeightCtrl = TextEditingController(text: '0');
  final wastageCtrl = TextEditingController(text: '0');
  final makingChargesCtrl = TextEditingController(text: '0');
  final rateCtrl = TextEditingController(text: '0');
  final amountCtrl = TextEditingController(text: '0');

  final stampCtrl = TextEditingController();
  final sizeCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final ghatWeightCtrl = TextEditingController(text: '0');
}
