import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/providers/parties_provider.dart';

class SupplierEntryScreen extends ConsumerStatefulWidget {
  final int? partyId;

  const SupplierEntryScreen({super.key, this.partyId});

  @override
  ConsumerState<SupplierEntryScreen> createState() =>
      _SupplierEntryScreenState();
}

class _SupplierEntryScreenState extends ConsumerState<SupplierEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // General
  String _supplierType = 'Business'; // Business, Karigar / Individual
  final _companyNameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _status = 'Active';

  // Financials
  final _opGoldCtrl = TextEditingController(text: '0');
  final _opSilverCtrl = TextEditingController(text: '0');
  final _opCashCtrl = TextEditingController(text: '0');
  final _limitGoldCtrl = TextEditingController(text: '0');
  final _limitCashCtrl = TextEditingController(text: '0');
  final _defaultWastageCtrl = TextEditingController(text: '0');
  final _defaultRateCtrl = TextEditingController(text: '0');
  final _discountCtrl = TextEditingController(text: '0');
  final _paymentTermsCtrl = TextEditingController();


  // Notes
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

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
            content: Text('Error: Supplier not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading supplier: $e'),
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
      _status = p.status;

      // Financials
      _discountCtrl.text = p.discountPercentage.toString();
      _paymentTermsCtrl.text = p.paymentTerms ?? '';
      _opGoldCtrl.text = p.openingGoldBalance.toString();
      _opSilverCtrl.text = p.openingSilverBalance.toString();
      _opCashCtrl.text = p.openingCashBalance.toString();
      _limitGoldCtrl.text = p.creditLimitGold.toString();
      _limitCashCtrl.text = p.creditLimitCash.toString();
      _defaultWastageCtrl.text = p.defaultWastage?.toString() ?? '0';
      _defaultRateCtrl.text = p.defaultRate?.toString() ?? '0';
      // Notes
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
        type: const drift.Value('Supplier'),
        code: drift.Value(_codeCtrl.text.isEmpty ? null : _codeCtrl.text),
        name: drift.Value(name),
        mobile: const drift.Value(''),
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
        taxPreference: const drift.Value('Taxable'),
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
                'Supplier ${isEdit ? 'updated' : 'added'} successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
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
          widget.partyId == null ? 'Add New Supplier' : 'Edit Supplier',
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
                          RadioGroup<String>(
                            groupValue: _supplierType,
                            onChanged: (v) =>
                                setState(() => _supplierType = v!),
                            child: Row(
                              children: [
                                const Text(
                                  'Supplier Type: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 16),
                                const Radio<String>(value: 'Business'),
                                const Text('Business'),
                                const SizedBox(width: 16),
                                const Radio<String>(
                                    value: 'Karigar / Individual'),
                                const Text('Karigar / Individual'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
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
                          _buildTwoColumnRow(
                            TextFormField(
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
                            DropdownButtonFormField<String>(
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
                              hintText:
                                  'Add any notes about this supplier...',
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
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Save'),
                  ),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
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
