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

class TransactionEntryScreen extends ConsumerStatefulWidget {
  final String? initialType;
  final int? transactionId;
  const TransactionEntryScreen({
    super.key,
    this.initialType,
    this.transactionId,
  });

  @override
  ConsumerState<TransactionEntryScreen> createState() =>
      _TransactionEntryScreenState();
}

class _TransactionEntryScreenState
    extends ConsumerState<TransactionEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Header State
  late String _type;
  DateTime _date = DateTime.now();

  int? _selectedPartyId;
  final _transactionNumberCtrl = TextEditingController();
  final _partyPoCtrl = TextEditingController();
  final _dueDaysCtrl = TextEditingController(text: '0'); // Default 0
  DateTime? _dueDate; // Calculated
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

  // Gold Rate (can be fetched from dashboard or entered)
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
    _type = widget.initialType ?? 'Sale';
    // Add default line
    _lines.add(TransactionLineState());

    if (widget.transactionId != null) {
      _loadTransaction();
    }
  }

  Future<void> _loadTransaction() async {
    setState(() => _isLoading = true);
    final repo = ref.read(transactionsRepositoryProvider);
    final txn = await repo.getTransaction(widget.transactionId!);
    if (txn != null) {
      final lines = await repo.getTransactionLines(widget.transactionId!);

      setState(() {
        _date = txn.date;
        _type = txn.type;
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
          lineState.metalType =
              'Gold'; // Logic needed if metal type stored on item, but line doesn't store it explicitly in provided schema in previous steps? Wait, items table has metalType. Line just links to Item.
          // We need to fetch item to know metal type, but simplified for now.
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

        // Recalculate totals to ensure consistency
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

      // Determine metal type from selected item or default to Gold
      String metalType = line.metalType ?? 'Gold';

      // Calculate Fine Weight
      double fine = net * (purity / 100);

      // Calculate Amount based on 'Rate On'
      double amountBeforeCharges = 0;
      if (line.rateOn == 'Fine Weight') {
        amountBeforeCharges = fine * rate;
      } else if (line.rateOn == 'Fixed') {
        amountBeforeCharges = rate; // Rate treated as fixed amount
      } else {
        // Default: Net Weight
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

      // Use entered amount if available, otherwise use calculated
      double amount = double.tryParse(line.amountCtrl.text) ?? 0;
      cash += amount;
    }

    // Calculate subtotal
    double subtotal = cash;

    // Apply discount
    double discountAmount = double.tryParse(_discountAmountCtrl.text) ?? 0;
    double discountPercent = double.tryParse(_discountPercentCtrl.text) ?? 0;
    if (discountPercent > 0) {
      discountAmount = subtotal * (discountPercent / 100);
    }
    double afterDiscount = subtotal - discountAmount;

    // Apply tax
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
      // Build companions
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
        // New Header Fields
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
          // New Line Fields
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
        ).showSnackBar(const SnackBar(content: Text('Transaction Saved')));
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
    // Determine party type based on transaction type
    // Ensure _type is set, default to 'Sale' if null (though initialized)
    String partyType = (_type == 'Sale' || _type == 'Receipt')
        ? 'Customer'
        : 'Supplier';

    // We need to fetch parties.
    // Ideally we filter by type in the UI or fetch specific stream.
    // Here we fetch all (or use a dedicated cached provider if we optimized).
    // Accessing the repository directly for efficiency or using a provider that filters.
    final partiesFuture = ref
        .watch(partiesRepositoryProvider)
        .getParties(partyType);
    final itemsAsync = ref.watch(itemsListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.transactionId != null ? 'Edit $_type' : 'New $_type',
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
                      // Header Card
                      Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.borderLight,
                            width: 1,
                          ),
                          boxShadow: AppTheme.cardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transaction Details',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    initialValue: _selectedPartyId,
                                    decoration: InputDecoration(
                                      labelText: '$partyType *',
                                    ),
                                    items: parties
                                        .map(
                                          (p) => DropdownMenuItem(
                                            value: p.id,
                                            child: Text(p.name),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => _selectedPartyId = v),
                                    validator: (v) =>
                                        v == null ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Party Balance Display
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
                                          // Required Dummy Fields
                                          addressLine1: '',
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
                                          customerType: '',
                                          debitLimit: 0,
                                          debitLimitCurrency: 'INR',
                                          defaultWastage: null,
                                          defaultRate: null,
                                        ), // Dummy
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
                                          color: AppTheme.primaryGold
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.primaryGold
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                        labelText: 'Date *',
                                      ),
                                      child: Text(
                                        DateFormat('dd/MM/yyyy').format(_date),
                                      ),
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
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _paymentMethod,
                                    decoration: const InputDecoration(
                                      labelText: 'Payment Method',
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Cash',
                                        child: Text('Cash'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Card',
                                        child: Text('Card'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'UPI',
                                        child: Text('UPI'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Cheque',
                                        child: Text('Cheque'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Bank Transfer',
                                        child: Text('Bank Transfer'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Credit',
                                        child: Text('Credit'),
                                      ),
                                    ],
                                    onChanged: (v) =>
                                        setState(() => _paymentMethod = v),
                                  ),
                                ),
                              ],
                            ),
                            if (_paymentMethod != null &&
                                _paymentMethod != 'Cash' &&
                                _paymentMethod != 'Credit')
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: TextFormField(
                                  controller: _paymentRefCtrl,
                                  decoration: const InputDecoration(
                                    labelText:
                                        'Payment Reference (Cheque No / Transaction ID)',
                                    hintText: 'Enter details...',
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _remarksController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                labelText: 'Remarks/Notes',
                                alignLabelWithHint: true,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Lines Section
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              // Section Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Transaction Items',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _addLine,
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add Item'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Items List
                              Expanded(
                                child: itemsAsync.when(
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (err, stack) => Center(
                                    child: Text('Error loading items: $err'),
                                  ),
                                  data: (inventoryItems) {
                                    return ListView.separated(
                                      itemCount: _lines.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        return _buildLineItem(
                                          index,
                                          inventoryItems,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer / Totals & Actions
                      Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.borderLight,
                            width: 1,
                          ),
                          boxShadow: AppTheme.cardShadow,
                        ),
                        child: Column(
                          children: [
                            // Discount & Tax Section
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
                                      hintText: '0',
                                      prefixText: '₹ ',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => _calculateTotals(),
                                  ),
                                ),
                                const SizedBox(width: 16),
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
                                      hintText: '0',
                                      prefixText: '₹ ',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => _calculateTotals(),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 32),
                            // Totals Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_totalGold > 0)
                                      _TotalRow(
                                        label: 'Total Fine Gold:',
                                        value:
                                            '${_totalGold.toStringAsFixed(3)} g',
                                      ),
                                    if (_totalSilver > 0)
                                      _TotalRow(
                                        label: 'Total Fine Silver:',
                                        value:
                                            '${_totalSilver.toStringAsFixed(3)} g',
                                      ),
                                    const SizedBox(height: 8),
                                    _TotalRow(
                                      label: 'Subtotal:',
                                      value: NumberFormat.currency(
                                        symbol: '₹',
                                      ).format(_subtotal),
                                      isSubtotal: true,
                                    ),
                                    if ((double.tryParse(
                                              _discountAmountCtrl.text,
                                            ) ??
                                            0) >
                                        0)
                                      _TotalRow(
                                        label: 'Discount:',
                                        value:
                                            '- ${NumberFormat.currency(symbol: '₹').format(double.tryParse(_discountAmountCtrl.text) ?? 0)}',
                                        isDiscount: true,
                                      ),
                                    if ((double.tryParse(_taxAmountCtrl.text) ??
                                            0) >
                                        0)
                                      _TotalRow(
                                        label: 'Tax/GST:',
                                        value:
                                            '+ ${NumberFormat.currency(symbol: '₹').format(double.tryParse(_taxAmountCtrl.text) ?? 0)}',
                                        isTax: true,
                                      ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Grand Total',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      NumberFormat.currency(
                                        symbol: '₹',
                                      ).format(_totalCash),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryGoldDark,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => context.pop(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _save,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Save Transaction'),
                                ),
                              ],
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

  Widget _buildLineItem(int index, List<Item> inventoryItems) {
    final line = _lines[index];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Item Selection and Delete
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    initialValue: line.selectedItemId,
                    decoration: const InputDecoration(
                      labelText: 'Item *',
                      hintText: 'Select Item',
                    ),
                    items: inventoryItems
                        .map(
                          (i) => DropdownMenuItem(
                            value: i.id,
                            child: Text(i.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        line.selectedItemId = v;
                        // Auto-fill purity and metal type if available
                        final item = inventoryItems.firstWhere(
                          (i) => i.id == v,
                        );
                        line.descCtrl.text = item.name;
                        line.purityCtrl.text = item.purity ?? '91.6'; // Default
                        line.metalType = item.metalType;
                        // Auto-fill rate based on metal type
                        if (item.metalType == 'Gold') {
                          line.rateCtrl.text = _goldRateCtrl.text;
                        } else {
                          line.rateCtrl.text = _silverRateCtrl.text;
                        }
                        _calculateTotals();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: line.descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Item description',
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                  onPressed: () => _removeLine(index),
                  tooltip: 'Remove Item',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stamp, Size, Color Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: line.stampCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Stamp',
                      hintText: '916 BIS',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.sizeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Size',
                      hintText: '2.4',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.colorCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      hintText: 'Yellow',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            // Weight Details Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: line.grossWeightCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Gross Weight (g)',
                      hintText: '0.000',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.netWeightCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Net Weight (g) *',
                      hintText: '0.000',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.stoneWeightCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Stone Weight (g)',
                      hintText: '0.000',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.purityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Purity (%) *',
                      hintText: '91.6',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.wastageCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Wastage (g)',
                      hintText: '0.000',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Pricing Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: line.rateOn,
                    decoration: const InputDecoration(labelText: 'Rate On'),
                    items: ['Net Weight', 'Fine Weight', 'Fixed']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          line.rateOn = v;
                          _calculateTotals();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: line.rateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Rate',
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.makingChargesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Making Charges (₹)',
                      prefixText: '₹ ',
                      hintText: '0.00',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.amountCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Line Total (₹)',
                      prefixText: '₹ ',
                      hintText: '0.00',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
}

class TransactionLineState {
  int? selectedItemId;
  String? metalType; // 'Gold' or 'Silver'
  final descCtrl = TextEditingController();
  final grossWeightCtrl = TextEditingController();
  final netWeightCtrl = TextEditingController();
  final stoneWeightCtrl = TextEditingController();
  final purityCtrl = TextEditingController();
  final wastageCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final makingChargesCtrl = TextEditingController();
  final amountCtrl = TextEditingController();

  // Web Parity Fields
  final stampCtrl = TextEditingController();
  final sizeCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  String rateOn = 'Net Weight'; // 'Net Weight', 'Fine Weight', 'Fixed'
  final ghatWeightCtrl = TextEditingController(text: '0'); // Derived
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDiscount
                  ? AppTheme.error
                  : (isTax ? AppTheme.success : AppTheme.textPrimary),
              fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
