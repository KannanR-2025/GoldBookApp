import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/providers/parties_provider.dart';

class PartiesScreen extends ConsumerStatefulWidget {
  final String partyType; // 'Customer' or 'Supplier'

  const PartiesScreen({super.key, required this.partyType});

  @override
  ConsumerState<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends ConsumerState<PartiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(partyTypeFilterProvider.notifier).setType(widget.partyType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final partiesAsync = ref.watch(partiesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.partyType}s'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context),
              icon: const Icon(Icons.add),
              label: Text('New ${widget.partyType}'),
            ),
          ),
        ],
      ),
      body: partiesAsync.when(
        data: (parties) => _buildTable(parties),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading ${widget.partyType.toLowerCase()}s',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    '$err',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTable(List<Party> parties) {
    if (parties.isEmpty) {
      return Center(
        child: Text(
          'No ${widget.partyType.toLowerCase()}s found. Add one to get started.',
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppTheme.backgroundGrey),
            headingRowHeight: 56,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 72,
            columns: const [
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Mobile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'WhatsApp',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'City',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Gold Bal (g)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Cash Bal (₹)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: parties.map((party) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        if (party.title != null && party.title!.isNotEmpty)
                          Text(
                            '${party.title} ',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        Text(
                          party.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(party.mobile)),
                  DataCell(Text(party.whatsappNumber ?? '-')),
                  DataCell(Text(party.city ?? '-')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: party.status == 'Active'
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        party.status,
                        style: TextStyle(
                          color: party.status == 'Active'
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      party.goldBalance.toStringAsFixed(3),
                      style: TextStyle(
                        color: party.goldBalance > 0
                            ? Colors.green
                            : (party.goldBalance < 0
                                  ? Colors.red
                                  : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      party.cashBalance.toStringAsFixed(2),
                      style: TextStyle(
                        color: party.cashBalance > 0
                            ? Colors.green
                            : (party.cashBalance < 0
                                  ? Colors.red
                                  : Colors.black),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppTheme.primaryGold),
                      onPressed: () => _showAddDialog(context, party: party),
                      tooltip: 'Edit',
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, {Party? party}) {
    try {
      final base = '${widget.partyType.toLowerCase()}s';
      if (party != null) {
        // Edit existing party
        context.go('/$base/edit/${party.id}');
      } else {
        // Add new party
        context.go('/$base/new');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class PartyEntryScreen extends ConsumerStatefulWidget {
  final String type; // Customer or Supplier
  final int? partyId;

  const PartyEntryScreen({super.key, required this.type, this.partyId});

  @override
  ConsumerState<PartyEntryScreen> createState() => _PartyEntryScreenState();
}

class _PartyEntryScreenState extends ConsumerState<PartyEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // General Info
  final _companyNameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController(); // Display Name

  // Financial
  final _opGoldCtrl = TextEditingController(text: '0');
  final _opSilverCtrl = TextEditingController(text: '0');
  final _opCashCtrl = TextEditingController(text: '0');
  final _limitGoldCtrl = TextEditingController(text: '0');
  final _limitCashCtrl = TextEditingController(text: '0');
  final _defaultWastageCtrl = TextEditingController(text: '0');
  final _defaultRateCtrl = TextEditingController(text: '0');
  final _discountCtrl = TextEditingController(text: '0');
  final _paymentTermsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _status = 'Active';

  @override
  void initState() {
    super.initState();

    // Load data if editing
    if (widget.partyId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPartyData();
      });
    }
  }

  Future<void> _loadPartyData() async {
    if (widget.partyId == null) return;

    try {
      final party = await ref.read(partyByIdProvider(widget.partyId!).future);
      if (party != null && mounted) {
        _populateFields(party);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Party not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading party: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _populateFields(Party p) {
    setState(() {
      // General
      _codeCtrl.text = p.code ?? '';
      _nameCtrl.text = p.name;
      _companyNameCtrl.text = p.companyName ?? '';

      // Financial
      _status = p.status;
      _discountCtrl.text = p.discountPercentage.toString();
      _paymentTermsCtrl.text = p.paymentTerms ?? '';
      _opGoldCtrl.text = p.openingGoldBalance.toString();
      _opSilverCtrl.text = p.openingSilverBalance.toString();
      _opCashCtrl.text = p.openingCashBalance.toString();
      _limitGoldCtrl.text = p.creditLimitGold.toString();
      _limitCashCtrl.text = p.creditLimitCash.toString();
      _defaultWastageCtrl.text = p.defaultWastage?.toString() ?? '0';
      _defaultRateCtrl.text = p.defaultRate?.toString() ?? '0';
      _notesCtrl.text = p.notes ?? '';
    });
  }

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _opGoldCtrl.dispose();
    _opSilverCtrl.dispose();
    _opCashCtrl.dispose();
    _limitGoldCtrl.dispose();
    _limitCashCtrl.dispose();
    _defaultWastageCtrl.dispose();
    _defaultRateCtrl.dispose();
    _discountCtrl.dispose();
    _paymentTermsCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.partyId != null;
      final name = _nameCtrl.text.trim();

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Display Name is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final companion = PartiesCompanion(
        id: isEdit ? drift.Value(widget.partyId!) : const drift.Value.absent(),
        type: drift.Value(widget.type),
        code: drift.Value(_codeCtrl.text.isEmpty ? null : _codeCtrl.text),
        name: drift.Value(name),
        mobile: const drift.Value(
          '',
        ), // Empty string for mobile (not used but required)
        companyName: drift.Value(
          _companyNameCtrl.text.isEmpty ? null : _companyNameCtrl.text,
        ),
        status: drift.Value(_status),
        discountPercentage: drift.Value(
          double.tryParse(_discountCtrl.text) ?? 0,
        ),
        paymentTerms: drift.Value(
          _paymentTermsCtrl.text.isEmpty ? null : _paymentTermsCtrl.text,
        ),
        notes: drift.Value(_notesCtrl.text.isEmpty ? null : _notesCtrl.text),
        openingGoldBalance: drift.Value(double.tryParse(_opGoldCtrl.text) ?? 0),
        openingSilverBalance: drift.Value(
          double.tryParse(_opSilverCtrl.text) ?? 0,
        ),
        openingCashBalance: drift.Value(double.tryParse(_opCashCtrl.text) ?? 0),
        creditLimitGold: drift.Value(double.tryParse(_limitGoldCtrl.text) ?? 0),
        creditLimitCash: drift.Value(double.tryParse(_limitCashCtrl.text) ?? 0),
        defaultWastage: drift.Value(double.tryParse(_defaultWastageCtrl.text)),
        defaultRate: drift.Value(double.tryParse(_defaultRateCtrl.text)),
      );

      try {
        if (isEdit) {
          await ref
              .read(partiesControllerProvider.notifier)
              .updateParty(companion);
        } else {
          await ref
              .read(partiesControllerProvider.notifier)
              .addParty(companion);
        }

        final controllerState = ref.read(partiesControllerProvider);
        if (controllerState.hasError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${controllerState.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${widget.type} ${isEdit ? 'updated' : 'added'} successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.partyId == null
              ? 'Add New ${widget.type}'
              : 'Edit ${widget.type}',
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // General Info Section
                    _buildSectionCard(
                      title: 'General Info',
                      child: Column(
                        children: [
                          _buildTwoColumnRow(
                            TextFormField(
                              controller: _companyNameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Company Name',
                              ),
                            ),
                            TextFormField(
                              controller: _codeCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Code',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _nameCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Display Name *',
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Display Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _status,
                                  decoration: const InputDecoration(
                                    labelText: 'Status',
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Active',
                                      child: Text('Active'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Inactive',
                                      child: Text('Inactive'),
                                    ),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _status = v!),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Financial Section
                    _buildSectionCard(
                      title: 'Financial',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Opening Balances',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _opGoldCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Gold Fine (g)',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _opSilverCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Silver Fine (g)',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _opCashCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Cash Amount (₹)',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Credit Limits',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTwoColumnRow(
                            TextFormField(
                              controller: _limitGoldCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Debit Limit - Gold (g)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _limitCashCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Debit Limit - Cash (₹)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Defaults & Discounts',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTwoColumnRow(
                            TextFormField(
                              controller: _defaultWastageCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Default Wastage (%)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _defaultRateCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Default Rate (₹)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTwoColumnRow(
                            TextFormField(
                              controller: _discountCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Discount (%)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _paymentTermsCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Payment Terms',
                                hintText: 'Net 30, Due on Receipt, etc.',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _notesCtrl,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Internal Notes',
                              alignLabelWithHint: true,
                              hintText: 'Add any notes about this party...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action buttons at bottom
            Container(
              padding: const EdgeInsets.all(24),
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
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _submit, child: const Text('Save')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppTheme.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTwoColumnRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }
}
