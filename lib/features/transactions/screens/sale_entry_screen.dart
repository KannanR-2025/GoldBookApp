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

class SaleEntryScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  const SaleEntryScreen({super.key, this.transactionId});

  @override
  ConsumerState<SaleEntryScreen> createState() => _SaleEntryScreenState();
}

class _SaleEntryScreenState extends ConsumerState<SaleEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Header State
  final String _type = 'Sale';
  DateTime _date = DateTime.now();

  int? _selectedPartyId;
  final _partyCodeCtrl = TextEditingController();
  final _transactionNumberCtrl = TextEditingController();
  final _partyPoCtrl = TextEditingController();
  final _dueDaysCtrl = TextEditingController(text: '0');
  DateTime? _dueDate;
  final _remarksController = TextEditingController();
  final _referenceNoCtrl = TextEditingController();
  final _partyWastageCtrl = TextEditingController();
  final _partyRateCtrl = TextEditingController();
  final _barcodeCtrl = TextEditingController();

  // Payment & Discount
  String? _paymentMethod;
  final _paymentRefCtrl = TextEditingController();
  final _discountAmountCtrl = TextEditingController(text: '0');
  final _discountPercentCtrl = TextEditingController(text: '0');
  final _taxAmountCtrl = TextEditingController(text: '0');
  final _taxPercentCtrl = TextEditingController(text: '0');

  // Lines State
  final List<TransactionLineState> _lines = [];
  
  // Search controllers for item dropdowns
  final Map<int, TextEditingController> _itemSearchControllers = {};

  // Gold Rate
  final _goldRateCtrl = TextEditingController(text: '6450.00');
  final _silverRateCtrl = TextEditingController(text: '78.50');

  // Totals
  double _totalGold = 0;
  double _totalSilver = 0;
  double _subtotal = 0;
  double _totalCash = 0;
  double _metalReceiptGold = 0; // M-Rec:Fine Gold

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
    _calculateTotals();
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
          amount: drift.Value(_calculateLineTotal(l)),
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
        ).showSnackBar(const SnackBar(content: Text('Sale Saved')));
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
    const String partyType = 'Customer';

    final partiesFuture = ref
        .watch(partiesRepositoryProvider)
        .getParties(partyType);
    final itemsAsync = ref.watch(itemsListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.transactionId != null ? 'Edit Invoice' : 'New Invoice',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: AppTheme.backgroundWhite,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
            tooltip: 'Close',
          ),
        ],
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
                      // Single scrollable page with all sections
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Party Information and Voucher Information
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Party Information Section
                                  Expanded(
                                    flex: 1,
                                    child: _buildPartyInformation(parties),
                                  ),
                                  const SizedBox(width: 16),
                                  // Voucher Information Section
                                  Expanded(
                                    flex: 1,
                                    child: _buildVoucherInformation(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Items Section
                              _buildItemsSection(itemsAsync),
                              const SizedBox(height: 16),
                              // Bottom Row: Additional Buttons and Summary
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Additional issue/receive buttons
                                  Expanded(
                                    flex: 2,
                                    child: _buildAdditionalButtons(),
                                  ),
                                  const SizedBox(width: 16),
                                  // Summary Section
                                  Expanded(
                                    flex: 1,
                                    child: _buildSummarySection(parties),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Notes Section
                              _buildNotesSection(),
                            ],
                          ),
                        ),
                      ),
                      // Action buttons
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
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
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Close'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: _save,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Save & Print'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryAction,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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

  Widget _buildPartyInformation(List<Party> parties) {
    const String partyType = 'Customer';
    Party? selectedParty;
    if (_selectedPartyId != null) {
      selectedParty = parties.firstWhere(
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
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Party Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _partyCodeCtrl,
            decoration: const InputDecoration(
              labelText: 'Code',
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: _selectedPartyId,
            decoration: InputDecoration(
              labelText: 'Party Name *',
              isDense: true,
            ),
            items: parties
                .map(
                  (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                )
                .toList(),
            onChanged: (v) => setState(() => _selectedPartyId = v),
            validator: (v) => v == null ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _partyWastageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Wast.',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _partyRateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Rate.',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedPartyId != null)
            TextButton.icon(
              onPressed: () {
                // View party details
              },
              icon: const Icon(Icons.info_outline, size: 18),
              label: const Text('View Party\'s Details'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryAction,
              ),
            ),
          if (selectedParty != null && selectedParty.id != -1) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OPENING BALANCE:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBalanceRow(
                    'Gold:',
                    '${selectedParty.goldBalance.toStringAsFixed(3)}',
                    selectedParty.goldBalance < 0 ? 'Dr' : 'Cr',
                  ),
                  _buildBalanceRow(
                    'Silver:',
                    '${selectedParty.silverBalance.toStringAsFixed(3)}',
                    selectedParty.silverBalance < 0 ? 'Dr' : 'Cr',
                  ),
                  _buildBalanceRow(
                    'Cash:',
                    '${selectedParty.cashBalance.toStringAsFixed(2)}',
                    selectedParty.cashBalance < 0 ? 'Dr' : 'Cr',
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceRow(String label, String value, String drCr) {
    final isDr = drCr == 'Dr';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                drCr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDr ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherInformation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voucher Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _transactionNumberCtrl,
            decoration: const InputDecoration(
              labelText: 'Invoice No.',
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
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
                isDense: true,
              ),
              child: Text(DateFormat('dd-MMM-yyyy').format(_date)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _dueDaysCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Due Day',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) setState(() => _dueDate = d);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      isDense: true,
                    ),
                    child: Text(
                      _dueDate != null
                          ? DateFormat('dd-MMM-yyyy').format(_dueDate!)
                          : DateFormat('dd-MMM-yyyy').format(_date),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _partyPoCtrl,
            decoration: const InputDecoration(
              labelText: 'Party PO No.',
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _referenceNoCtrl,
            decoration: const InputDecoration(
              labelText: 'Reference No.',
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildItemsSection(AsyncValue<List<Item>> itemsAsync) {
    return itemsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Error: $err'),
        ),
      ),
      data: (inventoryItems) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Scan Multiple Tags'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _addLine,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Item'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAction,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _barcodeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Scan Barcode / QR here',
                  isDense: true,
                  prefixIcon: Icon(Icons.qr_code_scanner),
                ),
              ),
              const SizedBox(height: 16),
              // Items Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildItemsTable(inventoryItems),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemsTable(List<Item> inventoryItems) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.cardShadow,
      ),
      child: DataTable(
      headingRowHeight: 48,
      dataRowMinHeight: 60,
      dataRowMaxHeight: 80,
        columnSpacing: 10,
        horizontalMargin: 12,
        headingRowColor: WidgetStateProperty.all(
          AppTheme.primaryAction.withValues(alpha: 0.05),
        ),
        dividerThickness: 1,
        columns: [
          DataColumn(
            label: Text(
              '#',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Item',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Remarks',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Stamp',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Colour',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Unit',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Size',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Gross Wt.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Less Wt.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Net Wt.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Touch',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Wast.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Ghat Wt.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Fine Wt.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Rate On?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Rate',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Charges',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Discount',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Total Amt',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
        rows: [
          ..._lines.asMap().entries.map((entry) {
            final index = entry.key;
            final line = entry.value;
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return AppTheme.primaryAction.withValues(alpha: 0.03);
                  }
                  return index % 2 == 0
                      ? AppTheme.backgroundWhite
                      : AppTheme.backgroundLight.withValues(alpha: 0.3);
                },
              ),
              cells: [
              DataCell(
                Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 150,
                  child: _buildSearchableItemDropdown(
                    line: line,
                    index: index,
                    inventoryItems: inventoryItems,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: line.descCtrl,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: line.stampCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: line.colorCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '0',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    controller: line.sizeCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: line.grossWeightCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '0',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      double gross = double.tryParse(v) ?? 0;
                      double stone = double.tryParse(line.stoneWeightCtrl.text) ?? 0;
                      line.netWeightCtrl.text = (gross - stone).toStringAsFixed(3);
                      _calculateTotals();
                    },
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: line.stoneWeightCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '0',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      double gross = double.tryParse(line.grossWeightCtrl.text) ?? 0;
                      double stone = double.tryParse(v) ?? 0;
                      line.netWeightCtrl.text = (gross - stone).toStringAsFixed(3);
                      _calculateTotals();
                    },
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: line.netWeightCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '0',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 70,
                  child: TextFormField(
                    controller: line.purityCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '92.00',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 70,
                  child: TextFormField(
                    controller: line.wastageCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '0',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: line.ghatWeightCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '0',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    _calculateFineWeight(line).toStringAsFixed(3),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppTheme.primaryGoldDark,
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<String>(
                    value: line.rateOn,
                    isExpanded: true,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                    dropdownColor: AppTheme.backgroundWhite,
                    items: const [
                      DropdownMenuItem(
                        value: 'Net Weight',
                        child: Text(
                          'Net Wt',
                          style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Fine Weight',
                        child: Text(
                          'Fine Wt',
                          style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Fixed',
                        child: Text(
                          'Fixed',
                          style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() => line.rateOn = v!);
                      _calculateTotals();
                    },
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: line.rateCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '0.00',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: line.makingChargesCtrl,
                          style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: AppTheme.backgroundWhite,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                            ),
                            hintText: '0.00',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _calculateTotals(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 14),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: line.discountCtrl,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppTheme.backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
                      ),
                      hintText: '0.00',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    _calculateLineTotal(line).toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    onPressed: () => _removeLine(index),
                    tooltip: 'Delete row',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    hoverColor: Colors.red.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        // Gold Totals Row
        DataRow(
          color: WidgetStateProperty.all(
            AppTheme.primaryAction.withValues(alpha: 0.1),
          ),
          cells: [
            const DataCell(Text('')),
            DataCell(
              Text(
                'Gold Totals',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
            DataCell(
              Center(
                child: Text(
                  _calculateTotalUnits().toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const DataCell(Text('')),
            DataCell(
              Center(
                child: Text(
                  _calculateTotalGrossWeight().toStringAsFixed(3),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  _calculateTotalLessWeight().toStringAsFixed(3),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  _calculateTotalNetWeight().toStringAsFixed(3),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const DataCell(Text('')),
            const DataCell(Text('')),
            const DataCell(Text('')),
            DataCell(
              Center(
                child: Text(
                  _totalGold.toStringAsFixed(3),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppTheme.primaryGoldDark,
                  ),
                ),
              ),
            ),
            const DataCell(Text('')),
            const DataCell(Text('')),
            DataCell(
              Center(
                child: Text(
                  _calculateTotalCharges().toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const DataCell(Text('')),
            DataCell(
              Center(
                child: Text(
                  _calculateTotalAmount().toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.primaryAction,
                  ),
                ),
              ),
            ),
            const DataCell(Text('')),
          ],
        ),
      ],
    ),
    );
  }

  double _calculateFineWeight(TransactionLineState line) {
    double net = double.tryParse(line.netWeightCtrl.text) ?? 0;
    double purity = double.tryParse(line.purityCtrl.text) ?? 0;
    return net * (purity / 100);
  }

  double _calculateTotalUnits() {
    return _lines.length.toDouble();
  }

  double _calculateTotalGrossWeight() {
    return _lines.fold(0.0, (sum, line) => sum + (double.tryParse(line.grossWeightCtrl.text) ?? 0));
  }

  double _calculateTotalLessWeight() {
    return _lines.fold(0.0, (sum, line) => sum + (double.tryParse(line.stoneWeightCtrl.text) ?? 0));
  }

  double _calculateTotalNetWeight() {
    return _lines.fold(0.0, (sum, line) => sum + (double.tryParse(line.netWeightCtrl.text) ?? 0));
  }

  double _calculateTotalCharges() {
    return _lines.fold(0.0, (sum, line) => sum + (double.tryParse(line.makingChargesCtrl.text) ?? 0));
  }

  double _calculateLineTotal(TransactionLineState line) {
    double net = double.tryParse(line.netWeightCtrl.text) ?? 0;
    double purity = double.tryParse(line.purityCtrl.text) ?? 0;
    double rate = double.tryParse(line.rateCtrl.text) ?? 0;
    double charges = double.tryParse(line.makingChargesCtrl.text) ?? 0;
    double discount = double.tryParse(line.discountCtrl.text) ?? 0;
    
    double fineWeight = net * (purity / 100);
    double amountBeforeCharges = 0;
    
    if (line.rateOn == 'Fine Weight') {
      amountBeforeCharges = fineWeight * rate;
    } else if (line.rateOn == 'Fixed') {
      amountBeforeCharges = rate;
    } else {
      amountBeforeCharges = net * rate;
    }
    
    return amountBeforeCharges + charges - discount;
  }

  double _calculateTotalAmount() {
    return _lines.fold(0.0, (sum, line) => sum + _calculateLineTotal(line));
  }

  Widget _buildSearchableItemDropdown({
    required TransactionLineState line,
    required int index,
    required List<Item> inventoryItems,
  }) {
    // Initialize search controller for this line if not exists
    if (!_itemSearchControllers.containsKey(index)) {
      final selectedItem = inventoryItems.firstWhere(
        (i) => i.id == line.selectedItemId,
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
      _itemSearchControllers[index] = TextEditingController(
        text: selectedItem.id != -1 ? selectedItem.name : '',
      );
    }

    return Autocomplete<Item>(
      displayStringForOption: (Item item) => item.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return inventoryItems;
        }
        final query = textEditingValue.text.toLowerCase();
        return inventoryItems.where((item) {
          return item.name.toLowerCase().contains(query);
        });
      },
      onSelected: (Item item) {
        setState(() {
          line.selectedItemId = item.id;
          final controller = _itemSearchControllers[index];
          if (controller != null) {
            controller.text = item.name;
          }
          line.descCtrl.text = item.description ?? '';
          line.metalType = item.metalType;
          line.purityCtrl.text = item.purity ?? '91.6';
        });
        _calculateTotals();
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        // Sync controller with our stored controller
        final storedController = _itemSearchControllers[index];
        if (storedController != null && storedController != textEditingController) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (textEditingController.text != storedController.text) {
              textEditingController.text = storedController.text;
            }
          });
        } else if (storedController == null) {
          // Initialize with selected item name
          final selectedItem = inventoryItems.firstWhere(
            (i) => i.id == line.selectedItemId,
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
          if (selectedItem.id != -1) {
            textEditingController.text = selectedItem.name;
            _itemSearchControllers[index] = textEditingController;
          }
        }
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppTheme.backgroundWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: AppTheme.borderInput, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: AppTheme.primaryAction, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            hintText: 'Search item...',
            suffixIcon: const Icon(Icons.search, size: 18),
          ),
          onChanged: (String value) {
            // Update stored controller
            final storedController = _itemSearchControllers[index];
            if (storedController != null && storedController != textEditingController) {
              storedController.text = value;
            }
          },
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<Item> onSelected,
        Iterable<Item> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Item option = options.elementAt(index);
                    final bool isSelected = option.id == line.selectedItemId;
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryAction.withValues(alpha: 0.1)
                              : AppTheme.backgroundWhite,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected
                                      ? AppTheme.primaryAction
                                      : AppTheme.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                size: 18,
                                color: AppTheme.primaryAction,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdditionalButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional issue/receive to this transaction',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(Icons.money, 'Cash Receipt', Colors.green),
              _buildActionButton(Icons.money_off, 'Cash Payment', Colors.red),
              _buildActionButton(Icons.account_balance, 'Bank Receipt', Colors.green),
              _buildActionButton(Icons.account_balance_wallet, 'Bank Payment', Colors.red),
              _buildActionButton(Icons.diamond, 'Metal Receipt', Colors.blue),
              _buildActionButton(Icons.diamond_outlined, 'Metal Payment', Colors.orange),
              _buildActionButton(Icons.trending_down, 'Rate-Cut', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildSummarySection(List<Party> parties) {
    Party? selectedParty;
    if (_selectedPartyId != null) {
      selectedParty = parties.firstWhere(
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
    }

    final subTotalGold = _totalGold;
    final voucherTotalGold = subTotalGold - _metalReceiptGold;
    final totalDueGold = voucherTotalGold;
    final closingBalanceGold = (selectedParty?.goldBalance ?? 0) + totalDueGold;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Sub-Total', subTotalGold, 0, 0, isDr: subTotalGold < 0),
          _buildSummaryRow('M-Rec:Fine Gold', _metalReceiptGold, 0, 0, isCr: _metalReceiptGold > 0),
          _buildSummaryRow('Voucher Total', voucherTotalGold, 0, 0, isDr: voucherTotalGold < 0),
          _buildSummaryRow('Total Due', totalDueGold, 0, 0, isDr: totalDueGold < 0),
          const Divider(height: 20),
          _buildSummaryRow('Closing Balance', closingBalanceGold, 0, 0, isDr: closingBalanceGold < 0, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double gold, double silver, double cash, {bool isDr = false, bool isCr = false, bool isBold = false}) {
    final drCr = isCr ? 'Cr' : (isDr ? 'Dr' : '');
    final drCrColor = isCr ? Colors.green : (isDr ? Colors.red : AppTheme.textPrimary);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Row(
            children: [
              Text(
                gold.toStringAsFixed(3),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (drCr.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  drCr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: drCrColor,
                  ),
                ),
              ],
              const SizedBox(width: 12),
              Text(
                silver.toStringAsFixed(3),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                cash.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _remarksController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Audio Remarks',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Discount Section - Web app style with card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discount',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
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
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Tax Section - Web app style with card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tax / GST',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
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
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Totals Summary - Web app style
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
              boxShadow: AppTheme.cardShadow,
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
  final discountCtrl = TextEditingController(text: '0.00');
}
