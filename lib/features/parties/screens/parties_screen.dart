import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/providers/parties_provider.dart';
import 'package:intl/intl.dart';

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
        error: (err, stack) => Center(child: Text('Error: $err')),
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
    final base = '${widget.partyType.toLowerCase()}s';
    if (party != null) {
      // Edit existing party
      context.go('/$base/edit/${party.id}');
    } else {
      // Add new party
      context.go('/$base/new');
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

class _PartyEntryScreenState extends ConsumerState<PartyEntryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // General
  String _customerType = 'Business'; // Business, Individual
  final _codeCtrl = TextEditingController();
  final _titleCtrl = TextEditingController(); // Mr, Mrs, Ms, Dr
  final _companyNameCtrl = TextEditingController();
  final _contactPersonCtrl = TextEditingController();
  final _nameCtrl = TextEditingController(); // Display Name
  final _mobileCtrl = TextEditingController();
  final _workPhoneCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _alternatePhoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _courierCtrl = TextEditingController();

  // Personal Details
  String? _gender; // Male, Female, Other
  DateTime? _dateOfBirth;
  DateTime? _anniversaryDate;

  // Business Details
  final _referredByCtrl = TextEditingController();
  String _status = 'Active'; // Active, Inactive
  final _discountCtrl = TextEditingController(text: '0');
  final _paymentTermsCtrl = TextEditingController();

  // Bank Details
  final _bankNameCtrl = TextEditingController();
  final _bankAccountCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();

  // Address
  final _addr1Ctrl = TextEditingController();
  final _addr2Ctrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController(text: 'Tamil Nadu');
  final _countryCtrl = TextEditingController(text: 'India');
  final _pinCtrl = TextEditingController();

  // Financials
  final _gstinCtrl = TextEditingController();
  final _panCtrl = TextEditingController();
  final _opGoldCtrl = TextEditingController(text: '0');
  final _opSilverCtrl = TextEditingController(text: '0');
  final _opCashCtrl = TextEditingController(text: '0');
  final _limitGoldCtrl = TextEditingController(text: '0');
  final _limitCashCtrl = TextEditingController(text: '0');

  // Defaults
  final _defaultWastageCtrl = TextEditingController(text: '0');
  final _defaultRateCtrl = TextEditingController(text: '0');

  String _taxPreference = 'Taxable'; // Taxable, Exempt
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Load data if editing
    if (widget.partyId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPartyData();
      });
    }
  }

  Future<void> _loadPartyData() async {
    if (widget.partyId == null) return;

    // Fetch party data
    final party = await ref.read(partyByIdProvider(widget.partyId!).future);
    if (party != null && mounted) {
      _populateFields(party);
    }
  }

  void _populateFields(Party p) {
    setState(() {
      // General
      _codeCtrl.text = p.code ?? '';
      _titleCtrl.text = p.title ?? '';
      _nameCtrl.text = p.name;
      _companyNameCtrl.text = p.companyName ?? '';
      _contactPersonCtrl.text = p.contactPerson ?? '';
      _mobileCtrl.text = p.mobile;
      _workPhoneCtrl.text = p.workPhone ?? '';
      _whatsappCtrl.text = p.whatsappNumber ?? '';
      _alternatePhoneCtrl.text = p.alternatePhone ?? '';
      _emailCtrl.text = p.email ?? '';
      _courierCtrl.text = p.courier ?? '';

      // Personal
      _gender = p.gender;
      _dateOfBirth = p.dateOfBirth;
      _anniversaryDate = p.anniversaryDate;

      // Business
      _customerType = p.type;
      _referredByCtrl.text = p.referredBy ?? '';
      _status = p.status;
      _discountCtrl.text = p.discountPercentage.toString();
      _paymentTermsCtrl.text = p.paymentTerms ?? '';

      // Bank
      _bankNameCtrl.text = p.bankName ?? '';
      _bankAccountCtrl.text = p.bankAccountNumber ?? '';
      _ifscCtrl.text = p.ifscCode ?? '';

      // Address
      _addr1Ctrl.text = p.addressLine1 ?? '';
      _addr2Ctrl.text = p.addressLine2 ?? '';
      _landmarkCtrl.text = p.landmark ?? '';
      _cityCtrl.text = p.city ?? '';
      _stateCtrl.text = p.state ?? '';
      _countryCtrl.text = p.country;
      _pinCtrl.text = p.pinCode ?? '';

      // Financials
      _gstinCtrl.text = p.gstin ?? '';
      _panCtrl.text = p.panNumber ?? '';
      _opGoldCtrl.text = p.openingGoldBalance.toString();
      _opSilverCtrl.text = p.openingSilverBalance.toString();
      _opCashCtrl.text = p.openingCashBalance.toString();
      _limitGoldCtrl.text = p.creditLimitGold.toString();
      _limitCashCtrl.text = p.creditLimitCash.toString();
      _defaultWastageCtrl.text = p.defaultWastage?.toString() ?? '0';
      _defaultRateCtrl.text = p.defaultRate?.toString() ?? '0';
      _taxPreference = p.taxPreference;
      _notesCtrl.text = p.notes ?? '';
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.partyId != null;

      final companion = PartiesCompanion(
        id: isEdit ? drift.Value(widget.partyId!) : const drift.Value.absent(),
        // General
        type: drift.Value(widget.type),
        code: drift.Value(_codeCtrl.text.isEmpty ? null : _codeCtrl.text),
        title: drift.Value(_titleCtrl.text.isEmpty ? null : _titleCtrl.text),
        name: drift.Value(_nameCtrl.text),
        contactPerson: drift.Value(
          _contactPersonCtrl.text.isEmpty ? null : _contactPersonCtrl.text,
        ),
        mobile: drift.Value(_mobileCtrl.text),
        workPhone: drift.Value(
          _workPhoneCtrl.text.isEmpty ? null : _workPhoneCtrl.text,
        ),
        whatsappNumber: drift.Value(
          _whatsappCtrl.text.isEmpty ? null : _whatsappCtrl.text,
        ),
        alternatePhone: drift.Value(
          _alternatePhoneCtrl.text.isEmpty ? null : _alternatePhoneCtrl.text,
        ),
        email: drift.Value(_emailCtrl.text.isEmpty ? null : _emailCtrl.text),
        companyName: drift.Value(
          _companyNameCtrl.text.isEmpty ? null : _companyNameCtrl.text,
        ),
        courier: drift.Value(
          _courierCtrl.text.isEmpty ? null : _courierCtrl.text,
        ),

        // Personal Details
        gender: drift.Value(_gender),
        dateOfBirth: drift.Value(_dateOfBirth),
        anniversaryDate: drift.Value(_anniversaryDate),

        // Business Details
        referredBy: drift.Value(
          _referredByCtrl.text.isEmpty ? null : _referredByCtrl.text,
        ),
        status: drift.Value(_status),
        discountPercentage: drift.Value(
          double.tryParse(_discountCtrl.text) ?? 0,
        ),
        paymentTerms: drift.Value(
          _paymentTermsCtrl.text.isEmpty ? null : _paymentTermsCtrl.text,
        ),

        // Bank Details
        bankName: drift.Value(
          _bankNameCtrl.text.isEmpty ? null : _bankNameCtrl.text,
        ),
        bankAccountNumber: drift.Value(
          _bankAccountCtrl.text.isEmpty ? null : _bankAccountCtrl.text,
        ),
        ifscCode: drift.Value(_ifscCtrl.text.isEmpty ? null : _ifscCtrl.text),

        // Address
        addressLine1: drift.Value(
          _addr1Ctrl.text.isEmpty ? null : _addr1Ctrl.text,
        ),
        addressLine2: drift.Value(
          _addr2Ctrl.text.isEmpty ? null : _addr2Ctrl.text,
        ),
        landmark: drift.Value(
          _landmarkCtrl.text.isEmpty ? null : _landmarkCtrl.text,
        ),
        city: drift.Value(_cityCtrl.text.isEmpty ? null : _cityCtrl.text),
        state: drift.Value(_stateCtrl.text.isEmpty ? null : _stateCtrl.text),
        country: drift.Value(
          _countryCtrl.text.isEmpty || _countryCtrl.text.trim().isEmpty
              ? 'India'
              : _countryCtrl.text.trim(),
        ),
        pinCode: drift.Value(_pinCtrl.text.isEmpty ? null : _pinCtrl.text),

        // Financials
        gstin: drift.Value(_gstinCtrl.text.isEmpty ? null : _gstinCtrl.text),
        panNumber: drift.Value(_panCtrl.text.isEmpty ? null : _panCtrl.text),
        taxPreference: drift.Value(_taxPreference),
        notes: drift.Value(_notesCtrl.text.isEmpty ? null : _notesCtrl.text),

        openingGoldBalance: drift.Value(double.tryParse(_opGoldCtrl.text) ?? 0),
        openingSilverBalance: drift.Value(
          double.tryParse(_opSilverCtrl.text) ?? 0,
        ),
        openingCashBalance: drift.Value(double.tryParse(_opCashCtrl.text) ?? 0),
        creditLimitGold: drift.Value(double.tryParse(_limitGoldCtrl.text) ?? 0),
        creditLimitCash: drift.Value(double.tryParse(_limitCashCtrl.text) ?? 0),

        // Update current balance only if creating new (simplified logic)
        // Ideally we should recalculate current balance based on changed opening balance
        // + existing transactions, but for now let's just update opening balance.
        // If new, these are same.
        // goldBalance: drift.Value(double.tryParse(_opGoldCtrl.text) ?? 0),
        // silverBalance: drift.Value(double.tryParse(_opSilverCtrl.text) ?? 0),
        // cashBalance: drift.Value(double.tryParse(_opCashCtrl.text) ?? 0),

        // Defaults
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

        // Check if the operation was successful
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
            // Tab Bar in a container
            Container(
              color: AppTheme.backgroundWhite,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryAction, // Blue for active tab
                unselectedLabelColor: AppTheme.textSecondary,
                indicatorColor: AppTheme.primaryAction,
                tabs: const [
                  Tab(text: 'General Info'),
                  Tab(text: 'Address'),
                  Tab(text: 'Financials'),
                  Tab(text: 'Bank Details'),
                  Tab(text: 'Notes'),
                ],
              ),
            ),
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGeneralTab(),
                  _buildAddressTab(),
                  _buildFinancialsTab(),
                  _buildBankDetailsTab(),
                  _buildNotesTab(),
                ],
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

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioGroup<String>(
            groupValue: _customerType,
            onChanged: (v) => setState(() => _customerType = v!),
            child: Row(
              children: [
                Text(
                  '${widget.type} Type: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Radio<String>(value: 'Business'),
                const Text('Business'),
                const SizedBox(width: 16),
                Radio<String>(
                  value: widget.type == 'Supplier'
                      ? 'Karigar / Individual'
                      : 'Individual',
                ),
                Text(
                  widget.type == 'Supplier'
                      ? 'Karigar / Individual'
                      : 'Individual',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (_customerType == 'Business')
                Expanded(
                  child: TextFormField(
                    controller: _companyNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                    ),
                  ),
                ),
              if (_customerType == 'Business') const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _codeCtrl,
                  decoration: const InputDecoration(labelText: 'Code'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  initialValue: _titleCtrl.text.isEmpty
                      ? null
                      : _titleCtrl.text,
                  decoration: const InputDecoration(labelText: 'Title'),
                  items: const [
                    DropdownMenuItem(value: 'Mr', child: Text('Mr')),
                    DropdownMenuItem(value: 'Mrs', child: Text('Mrs')),
                    DropdownMenuItem(value: 'Ms', child: Text('Ms')),
                    DropdownMenuItem(value: 'Dr', child: Text('Dr')),
                  ],
                  onChanged: (v) => setState(() => _titleCtrl.text = v ?? ''),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Display Name *',
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _contactPersonCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _mobileCtrl,
              decoration: const InputDecoration(labelText: 'Mobile Number *'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: _whatsappCtrl,
              decoration: const InputDecoration(labelText: 'WhatsApp Number'),
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _workPhoneCtrl,
              decoration: const InputDecoration(labelText: 'Work Phone'),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: _alternatePhoneCtrl,
              decoration: const InputDecoration(labelText: 'Alternate Phone'),
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email ID'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: _courierCtrl,
              decoration: const InputDecoration(labelText: 'Preferred Courier'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (v) => setState(() => _gender = v),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate:
                          _dateOfBirth ??
                          DateTime.now().subtract(
                            const Duration(days: 365 * 30),
                          ),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _dateOfBirth = date);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                    child: Text(
                      _dateOfBirth != null
                          ? DateFormat('dd/MM/yyyy').format(_dateOfBirth!)
                          : 'Select Date',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _anniversaryDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => _anniversaryDate = date);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Anniversary Date',
                    ),
                    child: Text(
                      _anniversaryDate != null
                          ? DateFormat('dd/MM/yyyy').format(_anniversaryDate!)
                          : 'Select Date',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _referredByCtrl,
              decoration: const InputDecoration(
                labelText: 'Referred By / Reference',
              ),
            ),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'Active', child: Text('Active')),
                DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildTwoColumnRow(
            TextFormField(
              controller: _addr1Ctrl,
              decoration: const InputDecoration(labelText: 'Address Line 1'),
            ),
            TextFormField(
              controller: _addr2Ctrl,
              decoration: const InputDecoration(labelText: 'Address Line 2'),
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _landmarkCtrl,
              decoration: const InputDecoration(labelText: 'Landmark'),
            ),
            TextFormField(
              controller: _cityCtrl,
              decoration: const InputDecoration(labelText: 'City'),
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _stateCtrl,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            TextFormField(
              controller: _countryCtrl,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _pinCtrl,
                  decoration: const InputDecoration(labelText: 'PIN Code'),
                ),
              ),
              const SizedBox(width: 16),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Opening Balances',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _opGoldCtrl,
              decoration: const InputDecoration(
                labelText: 'Opening Gold Fine (g)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _opSilverCtrl,
              decoration: const InputDecoration(
                labelText: 'Opening Silver Fine (g)',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _opCashCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Opening Cash Amount',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Credit Limits & Tax',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _limitGoldCtrl,
              decoration: const InputDecoration(
                labelText: 'Debit Limit - Gold (g)',
              ),
            ),
            TextFormField(
              controller: _limitCashCtrl,
              decoration: const InputDecoration(
                labelText: 'Debit Limit - Cash',
              ),
            ),
          ),
          const SizedBox(height: 16),
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
              decoration: const InputDecoration(labelText: 'Default Rate (₹)'),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _discountCtrl,
              decoration: const InputDecoration(
                labelText: 'Discount Percentage (%)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _paymentTermsCtrl,
              decoration: const InputDecoration(
                labelText: 'Payment Terms (e.g., Net 30)',
                hintText: 'Net 30, Due on Receipt, etc.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _gstinCtrl,
              decoration: const InputDecoration(labelText: 'GSTIN'),
            ),
            TextFormField(
              controller: _panCtrl,
              decoration: const InputDecoration(labelText: 'PAN Number'),
            ),
          ),
          const SizedBox(height: 16),
          RadioGroup<String>(
            groupValue: _taxPreference,
            onChanged: (v) => setState(() => _taxPreference = v!),
            child: Row(
              children: [
                const Text(
                  'Tax Preference:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 16),
                Radio<String>(value: 'Taxable'),
                const Text('Taxable'),
                const SizedBox(width: 16),
                Radio<String>(value: 'Tax Exempt'),
                const Text('Tax Exempt'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildTwoColumnRow(
            TextFormField(
              controller: _bankNameCtrl,
              decoration: const InputDecoration(labelText: 'Bank Name'),
            ),
            TextFormField(
              controller: _bankAccountCtrl,
              decoration: const InputDecoration(labelText: 'Account Number'),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ifscCtrl,
                  decoration: const InputDecoration(labelText: 'IFSC Code'),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              const SizedBox(width: 16),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _notesCtrl,
        maxLines: 10,
        decoration: const InputDecoration(
          labelText: 'Internal Notes',
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
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
