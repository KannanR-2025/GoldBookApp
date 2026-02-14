import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/data/parties_repository.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:goldbook_desktop/features/transactions/providers/transactions_provider.dart';
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Rate Cut Line Item Model
// ─────────────────────────────────────────────────────────────────────────────

class _RateCutLine {
  String metalType;
  final TextEditingController rateCtrl;
  final TextEditingController fineCtrl;
  String fineUnit = 'g';
  String fineTerm;
  final TextEditingController amountCtrl;
  String amountTerm;
  final TextEditingController descCtrl;

  _RateCutLine({
    this.metalType = 'Gold',
    String? rate,
    String? fine,
    this.fineTerm = 'Receivable',
    String? amount,
    this.amountTerm = 'Payable',
    String? desc,
  })  : rateCtrl = TextEditingController(text: rate ?? ''),
        fineCtrl = TextEditingController(text: fine ?? ''),
        amountCtrl = TextEditingController(text: amount ?? ''),
        descCtrl = TextEditingController(text: desc ?? '');

  void dispose() {
    rateCtrl.dispose();
    fineCtrl.dispose();
    amountCtrl.dispose();
    descCtrl.dispose();
  }

  void calculateAmount() {
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final fine = double.tryParse(fineCtrl.text) ?? 0;
    final amt = rate * fine;
    if (amt > 0) {
      amountCtrl.text = amt.toStringAsFixed(2);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rate Cut Entry Screen
// ─────────────────────────────────────────────────────────────────────────────

class RateCutEntryScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  const RateCutEntryScreen({super.key, this.transactionId});

  @override
  ConsumerState<RateCutEntryScreen> createState() =>
      _RateCutEntryScreenState();
}

class _RateCutEntryScreenState extends ConsumerState<RateCutEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // ── Header / Party ──
  int? _selectedPartyId;
  String _partyType = 'Customer';

  // ── Voucher ──
  DateTime _date = DateTime.now();
  final _voucherNoCtrl = TextEditingController();
  final _referenceNoCtrl = TextEditingController();

  // ── Lines ──
  final List<_RateCutLine> _lines = [];

  // ── Notes ──
  final _notesCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addLine();
    if (widget.transactionId != null) {
      _loadTransaction();
    }
  }

  @override
  void dispose() {
    _voucherNoCtrl.dispose();
    _referenceNoCtrl.dispose();
    _notesCtrl.dispose();
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  // ── Line Management ──────────────────────────────────────────────────────

  void _addLine() {
    final line = _RateCutLine();
    line.rateCtrl.addListener(() => _onLineChanged(line));
    line.fineCtrl.addListener(() => _onLineChanged(line));
    _lines.add(line);
  }

  void _onLineChanged(_RateCutLine line) {
    line.calculateAmount();
    setState(() {});
  }

  void _removeLine(int index) {
    if (_lines.length <= 1) return;
    setState(() {
      _lines[index].dispose();
      _lines.removeAt(index);
    });
  }

  // ── Load Existing Transaction ────────────────────────────────────────────

  Future<void> _loadTransaction() async {
    setState(() => _isLoading = true);
    final repo = ref.read(transactionsRepositoryProvider);
    final txn = await repo.getTransaction(widget.transactionId!);
    if (txn != null) {
      final dbLines = await repo.getTransactionLines(widget.transactionId!);
      setState(() {
        _date = txn.date;
        _selectedPartyId = txn.partyId;
        _voucherNoCtrl.text = txn.transactionNumber ?? '';
        _notesCtrl.text = txn.remarks ?? '';

        for (final l in _lines) {
          l.dispose();
        }
        _lines.clear();

        for (final l in dbLines) {
          String metal = 'Gold';
          String fineTerm = 'Receivable';
          String amountTerm = 'Payable';

          final desc = l.description ?? '';
          final metalMatch = RegExp(r'Metal:(\w+)').firstMatch(desc);
          if (metalMatch != null) metal = metalMatch.group(1) ?? metal;
          final fineMatch = RegExp(r'FineType:(\w+)').firstMatch(desc);
          if (fineMatch != null) fineTerm = fineMatch.group(1) ?? fineTerm;
          final amtMatch = RegExp(r'AmountType:(\w+)').firstMatch(desc);
          if (amtMatch != null) amountTerm = amtMatch.group(1) ?? amountTerm;

          String userDesc = '';
          if (desc.contains('Desc:')) {
            final descMatch = RegExp(r'Desc:(.*)$').firstMatch(desc);
            if (descMatch != null) userDesc = descMatch.group(1) ?? '';
          }

          final line = _RateCutLine(
            metalType: metal,
            rate: l.rate.toStringAsFixed(2),
            fine: l.netWeight.toStringAsFixed(3),
            fineTerm: fineTerm,
            amount: l.amount.toStringAsFixed(2),
            amountTerm: amountTerm,
            desc: userDesc,
          );
          line.rateCtrl.addListener(() => _onLineChanged(line));
          line.fineCtrl.addListener(() => _onLineChanged(line));
          _lines.add(line);
        }

        if (_lines.isEmpty) _addLine();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  // ── Save ─────────────────────────────────────────────────────────────────

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPartyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a party'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final validLines =
        _lines.where((l) => (double.tryParse(l.fineCtrl.text) ?? 0) > 0).toList();
    if (validLines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one rate-cut line'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double totalGold = 0;
    double totalSilver = 0;
    double totalAmount = 0;

    for (final l in validLines) {
      final fine = double.tryParse(l.fineCtrl.text) ?? 0;
      final amount = double.tryParse(l.amountCtrl.text) ?? 0;
      final signedFine = l.fineTerm == 'Payable' ? -fine : fine;
      final signedAmt = l.amountTerm == 'Receivable' ? amount : -amount;

      if (l.metalType == 'Gold') {
        totalGold += signedFine;
      } else {
        totalSilver += signedFine;
      }
      totalAmount += signedAmt;
    }

    final header = TransactionsCompanion(
      transactionNumber: drift.Value(
        _voucherNoCtrl.text.isEmpty ? null : _voucherNoCtrl.text,
      ),
      date: drift.Value(_date),
      partyId: drift.Value(_selectedPartyId!),
      type: const drift.Value('RateCut'),
      totalGoldWeight: drift.Value(totalGold),
      totalSilverWeight: drift.Value(totalSilver),
      subtotal: drift.Value(totalAmount.abs()),
      totalAmount: drift.Value(totalAmount),
      remarks: drift.Value(
        _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
      ),
      status: const drift.Value('Completed'),
    );

    final txnLines = validLines.map((l) {
      final fine = double.tryParse(l.fineCtrl.text) ?? 0;
      final amount = double.tryParse(l.amountCtrl.text) ?? 0;
      final rate = double.tryParse(l.rateCtrl.text) ?? 0;
      final userDesc = l.descCtrl.text.trim();

      return TransactionLinesCompanion(
        description: drift.Value(
          'R-Cut:Rate Cut @ ${rate.toStringAsFixed(2)}'
          '|Metal:${l.metalType}|FineType:${l.fineTerm}|AmountType:${l.amountTerm}'
          '${userDesc.isNotEmpty ? '|Desc:$userDesc' : ''}',
        ),
        netWeight: drift.Value(fine),
        amount: drift.Value(amount),
        rate: drift.Value(rate),
        lineType: drift.Value(
          l.fineTerm == 'Payable' ? 'Debit' : 'Credit',
        ),
      );
    }).toList();

    try {
      if (widget.transactionId != null) {
        await ref
            .read(transactionsControllerProvider.notifier)
            .updateTransaction(
              id: widget.transactionId!,
              header: header,
              lines: txnLines,
            );
      } else {
        await ref
            .read(transactionsControllerProvider.notifier)
            .createTransaction(header: header, lines: txnLines);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rate Cut saved successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── Totals Helpers ───────────────────────────────────────────────────────

  double get _totalGoldFine {
    double t = 0;
    for (final l in _lines) {
      if (l.metalType == 'Gold') {
        t += double.tryParse(l.fineCtrl.text) ?? 0;
      }
    }
    return t;
  }

  double get _totalSilverFine {
    double t = 0;
    for (final l in _lines) {
      if (l.metalType == 'Silver') {
        t += double.tryParse(l.fineCtrl.text) ?? 0;
      }
    }
    return t;
  }

  double get _totalAmount {
    double t = 0;
    for (final l in _lines) {
      t += double.tryParse(l.amountCtrl.text) ?? 0;
    }
    return t;
  }

  /// Signed gold fine: respects Receivable (+) / Payable (-)
  double get _signedGoldFine {
    double t = 0;
    for (final l in _lines) {
      if (l.metalType == 'Gold') {
        final fine = double.tryParse(l.fineCtrl.text) ?? 0;
        t += l.fineTerm == 'Payable' ? -fine : fine;
      }
    }
    return t;
  }

  double get _signedSilverFine {
    double t = 0;
    for (final l in _lines) {
      if (l.metalType == 'Silver') {
        final fine = double.tryParse(l.fineCtrl.text) ?? 0;
        t += l.fineTerm == 'Payable' ? -fine : fine;
      }
    }
    return t;
  }

  double get _signedAmount {
    double t = 0;
    for (final l in _lines) {
      final amount = double.tryParse(l.amountCtrl.text) ?? 0;
      t += l.amountTerm == 'Receivable' ? amount : -amount;
    }
    return t;
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final customersFuture =
        ref.watch(partiesRepositoryProvider).getParties('Customer');
    final suppliersFuture =
        ref.watch(partiesRepositoryProvider).getParties('Supplier');

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.transactionId != null ? 'Edit Rate Cut' : 'New Rate Cut',
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
          : FutureBuilder<List<List<Party>>>(
              future: Future.wait([customersFuture, suppliersFuture]),
              builder: (context, snapshot) {
                final customers = snapshot.data?[0] ?? [];
                final suppliers = snapshot.data?[1] ?? [];
                final parties =
                    _partyType == 'Customer' ? customers : suppliers;

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Scrollable content area
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Top Row: Party Info + Voucher Info ──
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildPartyInformation(parties),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: _buildVoucherInformation(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // ── Info Banner ──
                              _buildInfoBanner(),
                              const SizedBox(height: 16),
                              // ── Items Table ──
                              _buildItemsSection(),
                              const SizedBox(height: 16),
                              // ── Bottom Row: Notes + Summary ──
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildNotesSection(),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: _buildSummarySection(parties),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ── Bottom Action Bar ──
                      _buildBottomActionBar(),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PARTY INFORMATION SECTION
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildPartyInformation(List<Party> parties) {
    Party? selectedParty;
    if (_selectedPartyId != null) {
      try {
        selectedParty = parties.firstWhere((p) => p.id == _selectedPartyId);
      } catch (_) {
        selectedParty = null;
      }
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

          // Party Type Toggle
          Row(
            children: [
              _buildPartyTypeChip('Customer'),
              const SizedBox(width: 8),
              _buildPartyTypeChip('Supplier'),
            ],
          ),
          const SizedBox(height: 12),

          // Party search row: Autocomplete + Dropdown
          Row(
            children: [
              Expanded(
                child: Autocomplete<Party>(
                  key: ValueKey('party_search_${_partyType}_${_selectedPartyId ?? 'none'}'),
                  displayStringForOption: (Party party) {
                    if (party.code != null && party.code!.isNotEmpty) {
                      return '${party.code} - ${party.name}';
                    }
                    return party.name;
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return parties.where(
                        (p) => p.code != null && p.code!.isNotEmpty,
                      );
                    }
                    final query = textEditingValue.text.toLowerCase();
                    return parties.where((party) {
                      final codeMatch = party.code != null &&
                          party.code!.toLowerCase().contains(query);
                      final nameMatch =
                          party.name.toLowerCase().contains(query);
                      return codeMatch || nameMatch;
                    });
                  },
                  onSelected: (Party party) {
                    setState(() {
                      _selectedPartyId = party.id;
                    });
                  },
                  fieldViewBuilder: (
                    BuildContext ctx,
                    TextEditingController textCtrl,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    if (_selectedPartyId != null && !focusNode.hasFocus) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        try {
                          final sp =
                              parties.firstWhere((p) => p.id == _selectedPartyId);
                          final display = sp.code != null && sp.code!.isNotEmpty
                              ? '${sp.code} - ${sp.name}'
                              : sp.name;
                          if (textCtrl.text != display) {
                            textCtrl.text = display;
                          }
                        } catch (_) {}
                      });
                    }
                    return TextFormField(
                      controller: textCtrl,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Search Code / Name',
                        isDense: true,
                        hintText: 'Search by code or name...',
                        suffixIcon: Icon(Icons.search, size: 18),
                      ),
                      onFieldSubmitted: (_) => onFieldSubmitted(),
                    );
                  },
                  optionsViewBuilder: (ctx, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (ctx, index) {
                              final party = options.elementAt(index);
                              return InkWell(
                                onTap: () => onSelected(party),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        party.code != null &&
                                                party.code!.isNotEmpty
                                            ? '${party.code} - ${party.name}'
                                            : party.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (party.mobile.isNotEmpty)
                                        Text(
                                          party.mobile,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<int>(
                  initialValue: _selectedPartyId,
                  decoration: const InputDecoration(
                    labelText: 'Party Name *',
                    isDense: true,
                  ),
                  items: parties
                      .map((p) =>
                          DropdownMenuItem(value: p.id, child: Text(p.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPartyId = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // View Party Details link
          if (_selectedPartyId != null)
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, size: 18),
              label: const Text("View Party's Details"),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryAction,
              ),
            ),

          // Opening Balance
          if (selectedParty != null) ...[
            const SizedBox(height: 12),
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
                    selectedParty.goldBalance.toStringAsFixed(3),
                    selectedParty.goldBalance < 0 ? 'Dr' : 'Cr',
                  ),
                  _buildBalanceRow(
                    'Silver:',
                    selectedParty.silverBalance.toStringAsFixed(3),
                    selectedParty.silverBalance < 0 ? 'Dr' : 'Cr',
                  ),
                  _buildBalanceRow(
                    'Cash:',
                    selectedParty.cashBalance.toStringAsFixed(2),
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

  Widget _buildPartyTypeChip(String type) {
    final isSelected = _partyType == type;
    return ChoiceChip(
      label: Text(type),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _partyType = type;
            _selectedPartyId = null;
          });
        }
      },
      selectedColor: AppTheme.primaryAction.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryAction : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryAction : AppTheme.borderInput,
        ),
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
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
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

  // ─────────────────────────────────────────────────────────────────────────
  // VOUCHER INFORMATION SECTION
  // ─────────────────────────────────────────────────────────────────────────

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
            controller: _voucherNoCtrl,
            decoration: const InputDecoration(
              labelText: 'Voucher No.',
              hintText: 'Auto-generated',
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

  // ─────────────────────────────────────────────────────────────────────────
  // INFO BANNER
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Enter metal rate of 1 unit (gm or kg). Amount = Rate x Fine weight.',
              style: TextStyle(fontSize: 13, color: Colors.blue.shade900),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ITEMS TABLE SECTION
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildItemsSection() {
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
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rate Cut Items',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _addLine()),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Row'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAction,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildDataTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: AppTheme.cardShadow,
      ),
      child: DataTable(
        headingRowHeight: 48,
        dataRowMinHeight: 56,
        dataRowMaxHeight: 72,
        columnSpacing: 12,
        horizontalMargin: 16,
        headingRowColor: WidgetStateProperty.all(
          AppTheme.primaryAction.withValues(alpha: 0.05),
        ),
        columns: const [
          DataColumn(label: Text('#', style: _colHeaderStyle)),
          DataColumn(label: Text('Metal', style: _colHeaderStyle)),
          DataColumn(label: Text('Metal Rate', style: _colHeaderStyle)),
          DataColumn(label: Text('Fine Wt', style: _colHeaderStyle)),
          DataColumn(label: Text('Unit', style: _colHeaderStyle)),
          DataColumn(label: Text('Fine Term', style: _colHeaderStyle)),
          DataColumn(label: Text('Amount', style: _colHeaderStyle)),
          DataColumn(label: Text('Amount Term', style: _colHeaderStyle)),
          DataColumn(label: Text('Description', style: _colHeaderStyle)),
          DataColumn(label: Text('', style: _colHeaderStyle)),
        ],
        rows: List.generate(_lines.length, (i) => _buildDataRow(i)),
      ),
    );
  }

  DataRow _buildDataRow(int index) {
    final line = _lines[index];
    return DataRow(
      cells: [
        // # row number
        DataCell(Text('${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.w500))),

        // Metal dropdown
        DataCell(
          SizedBox(
            width: 110,
            child: DropdownButtonFormField<String>(
              initialValue: line.metalType,
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: InputBorder.none,
              ),
              items: const [
                DropdownMenuItem(value: 'Gold', child: Text('Gold')),
                DropdownMenuItem(value: 'Silver', child: Text('Silver')),
              ],
              onChanged: (v) => setState(() => line.metalType = v!),
            ),
          ),
        ),

        // Metal Rate
        DataCell(
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: line.rateCtrl,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                hintText: '0.00',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),

        // Fine Wt
        DataCell(
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: line.fineCtrl,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                hintText: '0.000',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),

        // Unit dropdown
        DataCell(
          SizedBox(
            width: 80,
            child: DropdownButtonFormField<String>(
              initialValue: line.fineUnit,
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                border: InputBorder.none,
              ),
              items: const [
                DropdownMenuItem(value: 'g', child: Text('g')),
                DropdownMenuItem(value: 'kg', child: Text('kg')),
              ],
              onChanged: (v) => setState(() => line.fineUnit = v!),
            ),
          ),
        ),

        // Fine Term dropdown
        DataCell(
          SizedBox(
            width: 130,
            child: DropdownButtonFormField<String>(
              initialValue: line.fineTerm,
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                border: InputBorder.none,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Receivable',
                  child: Text('Receivable', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: 'Payable',
                  child: Text('Payable', style: TextStyle(fontSize: 12)),
                ),
              ],
              onChanged: (v) {
                setState(() {
                  line.fineTerm = v!;
                  line.amountTerm =
                      v == 'Receivable' ? 'Payable' : 'Receivable';
                });
              },
            ),
          ),
        ),

        // Amount (auto-calculated)
        DataCell(
          SizedBox(
            width: 130,
            child: TextFormField(
              controller: line.amountCtrl,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                hintText: '0.00',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),

        // Amount Term (display only)
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: line.amountTerm == 'Payable'
                  ? Colors.red.withValues(alpha: 0.08)
                  : Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              line.amountTerm,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: line.amountTerm == 'Payable'
                    ? Colors.red.shade700
                    : Colors.green.shade700,
              ),
            ),
          ),
        ),

        // Description
        DataCell(
          SizedBox(
            width: 180,
            child: TextFormField(
              controller: line.descCtrl,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                hintText: 'Notes...',
              ),
            ),
          ),
        ),

        // Delete button
        DataCell(
          _lines.length > 1
              ? IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: Colors.red.shade400, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _removeLine(index),
                  tooltip: 'Remove row',
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SUMMARY SECTION
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildSummarySection(List<Party> parties) {
    Party? selectedParty;
    if (_selectedPartyId != null) {
      try {
        selectedParty = parties.firstWhere((p) => p.id == _selectedPartyId);
      } catch (_) {
        selectedParty = null;
      }
    }

    final goldFine = _signedGoldFine;
    final silverFine = _signedSilverFine;
    final cashAmount = _signedAmount;

    final closingGold = (selectedParty?.goldBalance ?? 0) + goldFine;
    final closingSilver = (selectedParty?.silverBalance ?? 0) + silverFine;
    final closingCash = (selectedParty?.cashBalance ?? 0) + cashAmount;

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
            'Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // ── Column Headers ──
          _buildSummaryHeader(),
          const Divider(height: 12),

          // ── Total Due ──
          _buildSummaryDataRow(
            label: 'Total Due',
            gold: _totalGoldFine,
            goldDrCr: goldFine < 0 ? 'Dr' : (goldFine > 0 ? 'Cr' : ''),
            silver: _totalSilverFine,
            silverDrCr: silverFine < 0 ? 'Dr' : (silverFine > 0 ? 'Cr' : ''),
            cash: _totalAmount,
            cashDrCr: cashAmount < 0 ? 'Dr' : (cashAmount > 0 ? 'Cr' : ''),
          ),
          const Divider(height: 16),

          // ── Closing Balance ──
          if (selectedParty != null)
            _buildSummaryDataRow(
              label: 'Closing Bal',
              gold: closingGold.abs(),
              goldDrCr: closingGold < 0 ? 'Dr' : (closingGold > 0 ? 'Cr' : ''),
              silver: closingSilver.abs(),
              silverDrCr: closingSilver < 0
                  ? 'Dr'
                  : (closingSilver > 0 ? 'Cr' : ''),
              cash: closingCash.abs(),
              cashDrCr: closingCash < 0 ? 'Dr' : (closingCash > 0 ? 'Cr' : ''),
              isBold: true,
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text('', style: TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Gold',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              'Silver',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              'Cash',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDataRow({
    required String label,
    required double gold,
    String goldDrCr = '',
    required double silver,
    String silverDrCr = '',
    required double cash,
    String cashDrCr = '',
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildSummaryValue(
              gold.toStringAsFixed(3),
              goldDrCr,
              isBold: isBold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _buildSummaryValue(
              silver.toStringAsFixed(3),
              silverDrCr,
              isBold: isBold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _buildSummaryValue(
              NumberFormat('#,##0.00').format(cash),
              cashDrCr,
              isBold: isBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryValue(String value, String drCr, {bool isBold = false}) {
    final Color color;
    if (drCr == 'Dr') {
      color = Colors.red;
    } else if (drCr == 'Cr') {
      color = Colors.green;
    } else {
      color = AppTheme.textPrimary;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: drCr.isNotEmpty ? color : null,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (drCr.isNotEmpty) ...[
          const SizedBox(width: 3),
          Text(
            drCr,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // NOTES SECTION
  // ─────────────────────────────────────────────────────────────────────────

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
            controller: _notesCtrl,
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

  // ─────────────────────────────────────────────────────────────────────────
  // BOTTOM ACTION BAR
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Close'),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: _save,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Save & Print'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAction,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CONSTANTS
  // ─────────────────────────────────────────────────────────────────────────

  static const _colHeaderStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: AppTheme.textSecondary,
  );
}
