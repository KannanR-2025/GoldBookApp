import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:goldbook_desktop/features/transactions/providers/transactions_provider.dart';
import 'package:intl/intl.dart';

/// Combined Metal In/Out screen showing both Metal Issue and Metal Receipt
/// transactions in a unified list with tab-based filtering.
class MetalInOutScreen extends ConsumerStatefulWidget {
  const MetalInOutScreen({super.key});

  @override
  ConsumerState<MetalInOutScreen> createState() => _MetalInOutScreenState();
}

class _MetalInOutScreenState extends ConsumerState<MetalInOutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Filters: 0 = All, 1 = Metal Issue (Out), 2 = Metal Receipt (In)
  List<TransactionWithParty> _filterTransactions(
    List<TransactionWithParty> all,
  ) {
    // First filter by type
    List<TransactionWithParty> filtered;
    switch (_tabController.index) {
      case 1:
        filtered = all
            .where((t) =>
                t.transaction.type == 'MetalIssue' ||
                t.transaction.type == 'Metal Issue')
            .toList();
        break;
      case 2:
        filtered = all
            .where((t) =>
                t.transaction.type == 'MetalReceipt' ||
                t.transaction.type == 'Metal Receipt')
            .toList();
        break;
      default:
        filtered = all
            .where((t) =>
                t.transaction.type == 'MetalIssue' ||
                t.transaction.type == 'Metal Issue' ||
                t.transaction.type == 'MetalReceipt' ||
                t.transaction.type == 'Metal Receipt')
            .toList();
    }

    // Then filter by search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        final partyMatch = t.party.name.toLowerCase().contains(q);
        final numMatch = (t.transaction.transactionNumber ?? '')
            .toLowerCase()
            .contains(q);
        return partyMatch || numMatch;
      }).toList();
    }

    // Sort by date descending
    filtered.sort((a, b) => b.transaction.date.compareTo(a.transaction.date));
    return filtered;
  }

  String _getEditRoute(TransactionWithParty item) {
    final type = item.transaction.type;
    if (type == 'MetalIssue' || type == 'Metal Issue') {
      return '/metal-in-out/edit-issue/${item.transaction.id}';
    } else {
      return '/metal-in-out/edit-receipt/${item.transaction.id}';
    }
  }

  bool _isIssue(String type) =>
      type == 'MetalIssue' || type == 'Metal Issue';

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          // ── Header Bar ──
          _buildHeader(context),
          // ── Content ──
          Expanded(
            child: transactionsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Error: $err')),
              data: (allTransactions) {
                final filtered = _filterTransactions(allTransactions);
                return _buildContent(filtered, allTransactions);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderLight),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metal In / Out',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage metal issue and receipt transactions',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => context.push('/metal-in-out/new-receipt'),
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Metal In'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/metal-in-out/new-issue'),
                    icon: const Icon(Icons.upload, size: 18),
                    label: const Text('Metal Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryAction,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tabs + Search row
          Row(
            children: [
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppTheme.primaryAction,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppTheme.textSecondary,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  padding: const EdgeInsets.all(4),
                  tabs: const [
                    Tab(text: '  All  '),
                    Tab(text: '  Metal Out (Issue)  '),
                    Tab(text: '  Metal In (Receipt)  '),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Search
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search by party name or voucher no...',
                      isDense: true,
                      prefixIcon: const Icon(Icons.search, size: 18),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CONTENT
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildContent(
    List<TransactionWithParty> filtered,
    List<TransactionWithParty> all,
  ) {
    // Stats for summary cards
    final metalIssueAll = all.where((t) =>
        t.transaction.type == 'MetalIssue' ||
        t.transaction.type == 'Metal Issue');
    final metalReceiptAll = all.where((t) =>
        t.transaction.type == 'MetalReceipt' ||
        t.transaction.type == 'Metal Receipt');

    final totalIssueGold = metalIssueAll.fold<double>(
        0, (sum, t) => sum + t.transaction.totalGoldWeight);
    final totalReceiptGold = metalReceiptAll.fold<double>(
        0, (sum, t) => sum + t.transaction.totalGoldWeight);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // ── Summary Cards ──
          Row(
            children: [
              _buildSummaryCard(
                icon: Icons.swap_vert,
                iconColor: AppTheme.primaryAction,
                iconBg: AppTheme.primaryAction.withValues(alpha: 0.1),
                title: 'Total Transactions',
                value: '${metalIssueAll.length + metalReceiptAll.length}',
                subtitle:
                    '${metalIssueAll.length} out  /  ${metalReceiptAll.length} in',
              ),
              const SizedBox(width: 16),
              _buildSummaryCard(
                icon: Icons.upload,
                iconColor: Colors.orange.shade700,
                iconBg: Colors.orange.withValues(alpha: 0.1),
                title: 'Metal Out (Issue)',
                value: '${totalIssueGold.toStringAsFixed(3)} g',
                subtitle: '${metalIssueAll.length} transactions',
              ),
              const SizedBox(width: 16),
              _buildSummaryCard(
                icon: Icons.download,
                iconColor: Colors.green.shade700,
                iconBg: Colors.green.withValues(alpha: 0.1),
                title: 'Metal In (Receipt)',
                value: '${totalReceiptGold.toStringAsFixed(3)} g',
                subtitle: '${metalReceiptAll.length} transactions',
              ),
              const SizedBox(width: 16),
              _buildSummaryCard(
                icon: Icons.balance,
                iconColor: AppTheme.primaryGoldDark,
                iconBg: AppTheme.primaryGold.withValues(alpha: 0.1),
                title: 'Net Metal Balance',
                value:
                    '${(totalReceiptGold - totalIssueGold).toStringAsFixed(3)} g',
                subtitle: totalReceiptGold >= totalIssueGold
                    ? 'Net inward'
                    : 'Net outward',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Data Table ──
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swap_vert,
                              size: 48, color: AppTheme.textTertiary),
                          const SizedBox(height: 12),
                          Text(
                            'No metal transactions found',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a Metal In or Metal Out transaction to get started.',
                            style: TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildDataTable(filtered),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SUMMARY CARD
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DATA TABLE
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildDataTable(List<TransactionWithParty> items) {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryAction.withValues(alpha: 0.05),
            border: Border(
              bottom: BorderSide(color: AppTheme.borderLight),
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              _headerCell('Type', flex: 2),
              _headerCell('Party', flex: 3),
              _headerCell('Voucher No.', flex: 2),
              _headerCell('Date', flex: 2),
              _headerCell('Gold Wt', flex: 2, align: TextAlign.right),
              _headerCell('Silver Wt', flex: 2, align: TextAlign.right),
              _headerCell('Amount', flex: 2, align: TextAlign.right),
              _headerCell('Status', flex: 1),
              const SizedBox(width: 80), // actions space
            ],
          ),
        ),
        // Table body
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildTableRow(item, index);
            },
          ),
        ),
        // Footer count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            border: Border(
              top: BorderSide(color: AppTheme.borderLight),
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${items.length} transaction${items.length != 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String label, {int flex = 1, TextAlign? align}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: align,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTableRow(TransactionWithParty item, int index) {
    final txn = item.transaction;
    final party = item.party;
    final isIssueType = _isIssue(txn.type);

    return InkWell(
      onTap: () => context.push(_getEditRoute(item)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: index.isEven
              ? AppTheme.backgroundWhite
              : AppTheme.backgroundLight,
          border: Border(
            bottom: BorderSide(
              color: AppTheme.borderLight.withValues(alpha: 0.5),
            ),
          ),
        ),
        child: Row(
          children: [
            // Type badge
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isIssueType
                          ? Colors.orange.withValues(alpha: 0.1)
                          : Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isIssueType ? Icons.upload : Icons.download,
                          size: 14,
                          color: isIssueType
                              ? Colors.orange.shade700
                              : Colors.green.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isIssueType ? 'Out' : 'In',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isIssueType
                                ? Colors.orange.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Party name
            Expanded(
              flex: 3,
              child: Text(
                party.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Voucher No
            Expanded(
              flex: 2,
              child: Text(
                txn.transactionNumber ?? '-',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),

            // Date
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('dd MMM yyyy').format(txn.date),
                style: const TextStyle(fontSize: 13),
              ),
            ),

            // Gold Weight
            Expanded(
              flex: 2,
              child: Text(
                txn.totalGoldWeight > 0
                    ? '${txn.totalGoldWeight.toStringAsFixed(3)} g'
                    : '-',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryGoldDark,
                ),
              ),
            ),

            // Silver Weight
            Expanded(
              flex: 2,
              child: Text(
                txn.totalSilverWeight > 0
                    ? '${txn.totalSilverWeight.toStringAsFixed(3)} g'
                    : '-',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Amount
            Expanded(
              flex: 2,
              child: Text(
                txn.totalAmount > 0
                    ? NumberFormat('#,##0.00').format(txn.totalAmount)
                    : '-',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Status
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: txn.status == 'Completed'
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  txn.status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: txn.status == 'Completed'
                        ? Colors.green.shade700
                        : Colors.amber.shade700,
                  ),
                ),
              ),
            ),

            // Actions
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        size: 18, color: AppTheme.primaryAction),
                    onPressed: () => context.push(_getEditRoute(item)),
                    tooltip: 'Edit',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        size: 18, color: Colors.red.shade400),
                    onPressed: () => _confirmDelete(item),
                    tooltip: 'Delete',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DELETE CONFIRMATION
  // ─────────────────────────────────────────────────────────────────────────

  void _confirmDelete(TransactionWithParty item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text(
          'Are you sure you want to delete this ${_isIssue(item.transaction.type) ? 'Metal Issue' : 'Metal Receipt'} '
          'transaction for ${item.party.name}?\n\n'
          'This will reverse the party balance and stock changes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(transactionsControllerProvider.notifier)
                    .deleteTransaction(item.transaction.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Transaction deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
