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
    );
  }
}

class ItemEntryScreen extends ConsumerStatefulWidget {
  final int? itemId;
  const ItemEntryScreen({super.key, this.itemId});

  @override
  ConsumerState<ItemEntryScreen> createState() => _ItemEntryScreenState();
}

class _ItemEntryScreenState extends ConsumerState<ItemEntryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Basic Info
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  String _metalType = 'Gold';
  final _purityController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Pricing
  final _costPriceController = TextEditingController(text: '0');
  final _sellingPriceController = TextEditingController(text: '0');
  final _makingChargesController = TextEditingController(text: '0');
  final _wastageController = TextEditingController(text: '0');

  // Stock
  final _stockQtyController = TextEditingController(text: '0');
  final _stockWeightController = TextEditingController(text: '0');
  final _minStockController = TextEditingController(text: '0');
  final _reorderLevelController = TextEditingController(text: '0');
  String _unitOfMeasurement = 'g';

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
    _tabController = TabController(length: 4, vsync: this);

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
      _purityController.text = item.purity ?? '';
      _categoryController.text = item.category ?? '';
      _descriptionController.text = item.description ?? '';
      _hsnCodeController.text = item.hsnCode ?? '';
      _costPriceController.text = item.costPrice.toString();
      _sellingPriceController.text = item.sellingPrice.toString();
      _makingChargesController.text = item.makingCharges.toString();
      _wastageController.text = item.wastagePercentage.toString();
      _stockQtyController.text = item.stockQty.toString();
      _stockWeightController.text = item.stockWeight.toString();
      _minStockController.text = item.minimumStockLevel.toString();
      _reorderLevelController.text = item.reorderLevel.toString();
      _unitOfMeasurement = item.unitOfMeasurement;
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
    _tabController.dispose();
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(widget.itemId == null ? 'Add New Item' : 'Edit Item'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              color: AppTheme.backgroundWhite,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryAction, // Blue
                unselectedLabelColor: AppTheme.textSecondary,
                indicatorColor: AppTheme.primaryAction,
                tabs: const [
                  Tab(text: 'Basic Info'),
                  Tab(text: 'Pricing'),
                  Tab(text: 'Stock'),
                  Tab(text: 'Additional'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(),
                  _buildPricingTab(),
                  _buildStockTab(),
                  _buildAdditionalTab(),
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

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildTwoColumnRow(
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item Name *'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Item Code/SKU'),
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            DropdownButtonFormField<String>(
              initialValue: _metalType,
              decoration: const InputDecoration(labelText: 'Metal Type *'),
              items: const [
                DropdownMenuItem(value: 'Gold', child: Text('Gold')),
                DropdownMenuItem(value: 'Silver', child: Text('Silver')),
              ],
              onChanged: (v) => setState(() => _metalType = v!),
            ),
            TextFormField(
              controller: _purityController,
              decoration: const InputDecoration(
                labelText: 'Purity (e.g. 916, 750)',
                hintText: '916',
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'Ring, Necklace, Earring, etc.',
              ),
            ),
            TextFormField(
              controller: _hsnCodeController,
              decoration: const InputDecoration(
                labelText: 'HSN Code',
                hintText: 'For GST compliance',
              ),
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
        ],
      ),
    );
  }

  Widget _buildPricingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _costPriceController,
              decoration: const InputDecoration(
                labelText: 'Cost Price (₹)',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _sellingPriceController,
              decoration: const InputDecoration(
                labelText: 'Selling Price (₹)',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _makingChargesController,
              decoration: const InputDecoration(
                labelText: 'Making Charges (₹)',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _wastageController,
              decoration: const InputDecoration(
                labelText: 'Wastage Percentage (%)',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stock Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _stockQtyController,
              decoration: const InputDecoration(labelText: 'Stock Quantity'),
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
          const SizedBox(height: 16),
          _buildTwoColumnRow(
            TextFormField(
              controller: _minStockController,
              decoration: const InputDecoration(
                labelText: 'Minimum Stock Level',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _reorderLevelController,
              decoration: const InputDecoration(labelText: 'Reorder Level'),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _unitOfMeasurement,
                  decoration: const InputDecoration(
                    labelText: 'Unit of Measurement',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'g', child: Text('Grams (g)')),
                    DropdownMenuItem(value: 'pcs', child: Text('Pieces')),
                    DropdownMenuItem(
                      value: 'kg',
                      child: Text('Kilograms (kg)'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _unitOfMeasurement = v!),
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

  Widget _buildAdditionalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
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
                DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
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
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
              alignLabelWithHint: true,
            ),
          ),
        ],
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
