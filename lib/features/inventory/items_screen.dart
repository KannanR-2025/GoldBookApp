// ignore_for_file: deprecated_member_use
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/inventory/items_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class ItemsScreen extends ConsumerWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/items/new'),
              icon: const Icon(Icons.add),
              label: const Text('New Item'),
            ),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) => _buildTable(context, items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Item> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No items found. Add one to get started.'),
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
                  'Code',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Metal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Purity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Stock Qty',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Weight (g)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Selling Price',
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
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: items.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item.code ?? '-')),
                  DataCell(
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(Text(item.category ?? '-')),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: item.metalType == 'Gold'
                            ? Colors.amber.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.metalType,
                        style: TextStyle(
                          color: item.metalType == 'Gold'
                              ? Colors.amber.shade900
                              : Colors.grey.shade800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(item.purity ?? '-')),
                  DataCell(Text(item.stockQty.toString())),
                  DataCell(Text('${item.stockWeight.toStringAsFixed(3)} g')),
                  DataCell(
                    Text(
                      item.sellingPrice > 0
                          ? NumberFormat.currency(
                              symbol: '₹',
                            ).format(item.sellingPrice)
                          : '-',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.status == 'Active'
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          color: item.status == 'Active'
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppTheme.primaryGold),
                      onPressed: () => context.go('/items/edit/${item.id}'),
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
}

class ItemEntryScreen extends ConsumerStatefulWidget {
  final int? itemId;
  const ItemEntryScreen({super.key, this.itemId});

  @override
  ConsumerState<ItemEntryScreen> createState() => _ItemEntryScreenState();
}

class _ItemEntryScreenState extends ConsumerState<ItemEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  String _metalType = 'Gold';
  String _itemType = 'Goods';
  String _maintainStockIn = 'Grams';
  bool _isStudded = false;
  bool _fetchGoldRate = false;
  String? _defaultGoldRate;
  final _purityController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _photoPathController = TextEditingController();

  // Pricing
  final _costPriceController = TextEditingController(text: '0');
  final _sellingPriceController = TextEditingController(text: '0');
  final _makingChargesController = TextEditingController(text: '0');
  final _wastageController = TextEditingController(text: '0');
  final _defaultTouchController = TextEditingController(text: '0');
  String _taxPreference = 'Taxable';
  final _purchaseWastageController = TextEditingController(text: '0');
  final _purchaseMakingChargesController = TextEditingController(text: '0');
  final _jobworkRateController = TextEditingController(text: '0');
  final _discountLedgerController = TextEditingController();

  // Stock
  final _stockQtyController = TextEditingController(text: '0');
  final _stockWeightController = TextEditingController(text: '0');
  final _minStockController = TextEditingController(text: '0');
  final _reorderLevelController = TextEditingController(text: '0');
  String _unitOfMeasurement = 'g';
  String _stockMethod = 'Loose';
  final _tagPrefixController = TextEditingController();
  final _minStockPcsController = TextEditingController(text: '0');
  final _maxStockGmController = TextEditingController(text: '0');
  final _maxStockPcsController = TextEditingController(text: '0');

  // Additional Details
  final _brandController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _stampController = TextEditingController();
  final _stoneDetailsController = TextEditingController();
  final _hsnCodeController = TextEditingController();
  String _status = 'Active';
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.itemId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadItemData();
      });
    }
  }

  Future<void> _loadItemData() async {
    if (widget.itemId == null) return;

    final item = await ref.read(itemByIdProvider(widget.itemId!).future);
    if (item != null && mounted) {
      _populateFields(item);
    }
  }

  void _populateFields(Item item) {
    setState(() {
      _nameController.text = item.name;
      _codeController.text = item.code ?? '';
      _metalType = item.metalType;
      _itemType = item.itemType;
      _maintainStockIn = item.maintainStockIn;
      _isStudded = item.isStudded;
      _fetchGoldRate = item.fetchGoldRate;
      _defaultGoldRate = item.defaultGoldRate;
      _purityController.text = item.purity ?? '';
      _categoryController.text = item.category ?? '';
      _descriptionController.text = item.description ?? '';
      _hsnCodeController.text = item.hsnCode ?? '';
      _photoPathController.text = item.photoPath ?? '';
      _costPriceController.text = item.costPrice.toString();
      _sellingPriceController.text = item.sellingPrice.toString();
      _makingChargesController.text = item.makingCharges.toString();
      _wastageController.text = item.wastagePercentage.toString();
      _defaultTouchController.text = item.defaultTouch.toString();
      _taxPreference = item.taxPreference;
      _purchaseWastageController.text = item.purchaseWastage.toString();
      _purchaseMakingChargesController.text = item.purchaseMakingCharges
          .toString();
      _jobworkRateController.text = item.jobworkRate.toString();
      _discountLedgerController.text = item.discountLedger ?? '';
      _stockQtyController.text = item.stockQty.toString();
      _stockWeightController.text = item.stockWeight.toString();
      _minStockController.text = item.minimumStockLevel.toString();
      _reorderLevelController.text = item.reorderLevel.toString();
      _unitOfMeasurement = item.unitOfMeasurement;
      _stockMethod = item.stockMethod;
      _tagPrefixController.text = item.tagPrefix ?? '';
      _minStockPcsController.text = item.minStockPcs.toString();
      _maxStockGmController.text = item.maxStockGm.toString();
      _maxStockPcsController.text = item.maxStockPcs.toString();
      _brandController.text = item.brand ?? '';
      _manufacturerController.text = item.manufacturer ?? '';
      _sizeController.text = item.size ?? '';
      _colorController.text = item.color ?? '';
      _stampController.text = item.stamp ?? '';
      _stoneDetailsController.text = item.stoneDetails ?? '';
      _status = item.status;
      _notesController.text = item.notes ?? '';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.itemId != null;

      final companion = ItemsCompanion(
        id: isEdit ? drift.Value(widget.itemId!) : const drift.Value.absent(),
        name: drift.Value(_nameController.text),
        code: drift.Value(
          _codeController.text.isEmpty ? null : _codeController.text,
        ),
        metalType: drift.Value(_metalType),
        itemType: drift.Value(_itemType),
        maintainStockIn: drift.Value(_maintainStockIn),
        isStudded: drift.Value(_isStudded),
        fetchGoldRate: drift.Value(_fetchGoldRate),
        defaultGoldRate: drift.Value(_defaultGoldRate),
        purity: drift.Value(
          _purityController.text.isEmpty ? null : _purityController.text,
        ),
        category: drift.Value(
          _categoryController.text.isEmpty ? null : _categoryController.text,
        ),
        description: drift.Value(
          _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
        ),
        hsnCode: drift.Value(
          _hsnCodeController.text.isEmpty ? null : _hsnCodeController.text,
        ),
        photoPath: drift.Value(
          _photoPathController.text.isEmpty ? null : _photoPathController.text,
        ),
        costPrice: drift.Value(double.tryParse(_costPriceController.text) ?? 0),
        sellingPrice: drift.Value(
          double.tryParse(_sellingPriceController.text) ?? 0,
        ),
        makingCharges: drift.Value(
          double.tryParse(_makingChargesController.text) ?? 0,
        ),
        wastagePercentage: drift.Value(
          double.tryParse(_wastageController.text) ?? 0,
        ),
        defaultTouch: drift.Value(
          double.tryParse(_defaultTouchController.text) ?? 0,
        ),
        taxPreference: drift.Value(_taxPreference),
        purchaseWastage: drift.Value(
          double.tryParse(_purchaseWastageController.text) ?? 0,
        ),
        purchaseMakingCharges: drift.Value(
          double.tryParse(_purchaseMakingChargesController.text) ?? 0,
        ),
        jobworkRate: drift.Value(
          double.tryParse(_jobworkRateController.text) ?? 0,
        ),
        discountLedger: drift.Value(
          _discountLedgerController.text.isEmpty
              ? null
              : _discountLedgerController.text,
        ),
        // Fix: stockQty is double
        stockQty: drift.Value(double.tryParse(_stockQtyController.text) ?? 0),
        stockWeight: drift.Value(
          double.tryParse(_stockWeightController.text) ?? 0,
        ),
        // Fix: minimumStockLevel is double and correct name
        minimumStockLevel: drift.Value(
          double.tryParse(_minStockController.text) ?? 0,
        ),
        reorderLevel: drift.Value(
          double.tryParse(_reorderLevelController.text) ?? 0,
        ),
        unitOfMeasurement: drift.Value(_unitOfMeasurement),
        stockMethod: drift.Value(_stockMethod),
        tagPrefix: drift.Value(
          _tagPrefixController.text.isEmpty ? null : _tagPrefixController.text,
        ),
        minStockPcs: drift.Value(
          double.tryParse(_minStockPcsController.text) ?? 0,
        ),
        maxStockGm: drift.Value(
          double.tryParse(_maxStockGmController.text) ?? 0,
        ),
        maxStockPcs: drift.Value(
          double.tryParse(_maxStockPcsController.text) ?? 0,
        ),
        brand: drift.Value(
          _brandController.text.isEmpty ? null : _brandController.text,
        ),
        manufacturer: drift.Value(
          _manufacturerController.text.isEmpty
              ? null
              : _manufacturerController.text,
        ),
        size: drift.Value(
          _sizeController.text.isEmpty ? null : _sizeController.text,
        ),
        color: drift.Value(
          _colorController.text.isEmpty ? null : _colorController.text,
        ),
        stamp: drift.Value(
          _stampController.text.isEmpty ? null : _stampController.text,
        ),
        stoneDetails: drift.Value(
          _stoneDetailsController.text.isEmpty
              ? null
              : _stoneDetailsController.text,
        ),
        status: drift.Value(_status),
        notes: drift.Value(
          _notesController.text.isEmpty ? null : _notesController.text,
        ),
        updatedAt: drift.Value(DateTime.now()),
      );

      try {
        if (isEdit) {
          final updateCompanion = companion.copyWith(
            id: drift.Value(widget.itemId!),
          );
          await ref
              .read(itemsControllerProvider.notifier)
              .updateItem(updateCompanion);
        } else {
          await ref.read(itemsControllerProvider.notifier).addItem(companion);
        }

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Item ${isEdit ? 'updated' : 'added'} successfully',
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          title: Text(widget.itemId == null ? 'Add New Item' : 'Edit Item'),
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppTheme.primaryAction,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryAction,
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Accounting'),
              Tab(text: 'Inventory'),
              Tab(text: 'Notes'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    _buildGeneralTab(),
                    _buildAccountingTab(),
                    _buildInventoryTab(),
                    _buildNotesTab(),
                  ],
                ),
              ),
              // Actions
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
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Form Fields
              Expanded(
                flex: 7,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    side: BorderSide(color: AppTheme.borderLight),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Type - Radio Buttons
                        Text(
                          'Item Type *',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Goods',
                              groupValue: _itemType,
                              onChanged: (v) => setState(() => _itemType = v!),
                              activeColor: AppTheme.primaryAction,
                            ),
                            const Text('Goods'),
                            const SizedBox(width: 24),
                            Radio<String>(
                              value: 'Service',
                              groupValue: _itemType,
                              onChanged: (v) => setState(() => _itemType = v!),
                              activeColor: AppTheme.primaryAction,
                            ),
                            const Text('Service'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Row 1: Code, Name, Category
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _codeController,
                                decoration: const InputDecoration(
                                  labelText: 'Code *',
                                  hintText: 'e.g. RING-001',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Item Name *',
                                  hintText: 'e.g. Gold Ring 22k',
                                ),
                                validator: (v) =>
                                    v!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _categoryController,
                                      decoration: const InputDecoration(
                                        labelText: 'Item Category *',
                                        hintText: 'Select or Type',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed:
                                        () {}, // TODO: Implement add category dialog
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: AppTheme.primaryAction,
                                    ),
                                    tooltip: 'Add Category',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Row 2a: Metal Type, Maintain Stock In
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _metalType,
                                decoration: const InputDecoration(
                                  labelText: 'Metal Type',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Gold',
                                    child: Text('Gold'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Silver',
                                    child: Text('Silver'),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _metalType = v!),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _maintainStockIn,
                                decoration: const InputDecoration(
                                  labelText: 'Maintain Stock in?',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Grams',
                                    child: Text('Grams'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Pcs',
                                    child: Text('Pcs'),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _maintainStockIn = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Row 2b: Unit, Is Studded
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _unitOfMeasurement,
                                decoration: const InputDecoration(
                                  labelText: 'Unit',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'g',
                                    child: Text('Grams (g)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'pcs',
                                    child: Text('Pieces'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'kg',
                                    child: Text('Kilograms (kg)'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Pair',
                                    child: Text('Pair'),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _unitOfMeasurement = v!),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _isStudded ? 'Yes' : 'No',
                                decoration: const InputDecoration(
                                  labelText: 'Is studded?',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Yes',
                                    child: Text('Yes'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'No',
                                    child: Text('No'),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _isStudded = v == 'Yes'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Row 3: Fetch Gold Rate, Default Gold Rate
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _fetchGoldRate ? 'Yes' : 'No',
                                decoration: const InputDecoration(
                                  labelText: 'Fetch Gold Rate?',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Yes',
                                    child: Text('Yes'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'No',
                                    child: Text('No'),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _fetchGoldRate = v == 'Yes'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _defaultGoldRate,
                                decoration: const InputDecoration(
                                  labelText: 'Default Gold Rate',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: '22k',
                                    child: Text('22k'),
                                  ),
                                  DropdownMenuItem(
                                    value: '18k',
                                    child: Text('18k'),
                                  ),
                                  DropdownMenuItem(
                                    value: '24k',
                                    child: Text('24k'),
                                  ),
                                  DropdownMenuItem(
                                    value: '18k',
                                    child: Text('18k'),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _defaultGoldRate = v),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Right Column - Photo
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Photo(s)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundWhite,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_photoPathController.text.isNotEmpty)
                            const Center(
                              child: Icon(
                                Icons.image,
                                size: 64,
                                color: AppTheme.textSecondary,
                              ),
                            ) // TODO: Show actual image
                          else
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 48,
                                  color: AppTheme.textSecondary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Drop files here to upload',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {}, // TODO: Implement image picker
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAction,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Upload'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              _buildSectionCard(
                title: 'Pricing Details',
                icon: Icons.currency_rupee,
                children: [
                  _buildTwoColumnRow(
                    TextFormField(
                      controller: _costPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Cost Price (₹)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _sellingPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price (₹)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTwoColumnRow(
                    TextFormField(
                      controller: _makingChargesController,
                      decoration: const InputDecoration(
                        labelText: 'Sale Making Charges (₹)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _wastageController,
                      decoration: const InputDecoration(
                        labelText: 'Sale Wastage (%)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'Purchase & Tax Information',
                icon: Icons.receipt_long,
                children: [
                  _buildTwoColumnRow(
                    TextFormField(
                      controller: _purchaseMakingChargesController,
                      decoration: const InputDecoration(
                        labelText: 'Purchase M.C. (₹)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _purchaseWastageController,
                      decoration: const InputDecoration(
                        labelText: 'Purchase Wastage (%)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTwoColumnRow(
                    TextFormField(
                      controller: _jobworkRateController,
                      decoration: const InputDecoration(
                        labelText: 'Jobwork Rate',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _defaultTouchController,
                      decoration: const InputDecoration(
                        labelText: 'Default Touch',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTwoColumnRow(
                    DropdownButtonFormField<String>(
                      initialValue: _taxPreference,
                      decoration: const InputDecoration(
                        labelText: 'Tax Preference',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Taxable',
                          child: Text('Taxable'),
                        ),
                        DropdownMenuItem(
                          value: 'Exempt',
                          child: Text('Exempt'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _taxPreference = v!),
                    ),
                    TextFormField(
                      controller: _hsnCodeController,
                      decoration: const InputDecoration(labelText: 'HSN Code'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _discountLedgerController,
                    decoration: const InputDecoration(
                      labelText: 'Discount Ledger',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              _buildSectionCard(
                title: 'Stock Balances',
                icon: Icons.inventory_2_outlined,
                children: [
                  _buildTwoColumnRow(
                    TextFormField(
                      controller: _stockQtyController,
                      decoration: const InputDecoration(
                        labelText: 'Stock Quantity',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _stockWeightController,
                      decoration: const InputDecoration(
                        labelText: 'Total Weight',
                        suffixText: 'g',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'Stock Management',
                icon: Icons.settings_input_component,
                children: [
                  _buildTwoColumnRow(
                    DropdownButtonFormField<String>(
                      initialValue: _stockMethod,
                      decoration: const InputDecoration(
                        labelText: 'Stock Method',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Loose', child: Text('Loose')),
                        DropdownMenuItem(value: 'Tag', child: Text('Tag')),
                      ],
                      onChanged: (v) => setState(() => _stockMethod = v!),
                    ),
                    TextFormField(
                      controller: _tagPrefixController,
                      decoration: const InputDecoration(
                        labelText: 'Tag Prefix',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Minimum Levels',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  _buildTwoColumnRow(
                    TextFormField(
                      controller: _minStockController,
                      decoration: const InputDecoration(labelText: 'Min (gm)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _minStockPcsController,
                      decoration: const InputDecoration(labelText: 'Min (pcs)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Maximum Levels',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  _buildTwoColumnRow(
                    TextFormField(
                      controller: _maxStockGmController,
                      decoration: const InputDecoration(labelText: 'Max (gm)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _maxStockPcsController,
                      decoration: const InputDecoration(labelText: 'Max (pcs)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTwoColumnRow(
                    TextFormField(
                      controller: _reorderLevelController,
                      decoration: const InputDecoration(
                        labelText: 'Reorder Level',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _buildSectionCard(
            title: 'Attributes & Notes',
            icon: Icons.note_alt_outlined,
            children: [
              _buildTwoColumnRow(
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Brand'),
                ),
                TextFormField(
                  controller: _manufacturerController,
                  decoration: const InputDecoration(
                    labelText: 'Manufacturer/Supplier',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTwoColumnRow(
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    labelText: 'Size/Variant',
                    hintText: 'e.g., Small, Medium, Large',
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(
                      value: 'Inactive',
                      child: Text('Inactive'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _status = v!),
                ),
              ),
              const SizedBox(height: 16),
              _buildTwoColumnRow(
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    hintText: 'e.g., Yellow, Rose, White',
                  ),
                ),
                TextFormField(
                  controller: _stampController,
                  decoration: const InputDecoration(
                    labelText: 'Stamp/Hallmark',
                    hintText: 'e.g., 916 BIS',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTwoColumnRow(
                TextFormField(
                  controller: _purityController,
                  decoration: const InputDecoration(
                    labelText: 'Purity (e.g. 916)',
                  ),
                ),
                const SizedBox(),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _stoneDetailsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Stone Details',
                  hintText: 'Diamond, Ruby, etc.',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        side: BorderSide(color: AppTheme.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryAction, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 24),
            ...children,
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
