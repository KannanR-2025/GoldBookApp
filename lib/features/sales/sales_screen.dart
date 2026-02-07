import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/features/transactions/data/transactions_repository.dart';
import 'package:goldbook_desktop/features/transactions/providers/transactions_provider.dart';
import 'package:intl/intl.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getTransactionLineStats(int transactionId) async {
    final repo = ref.read(transactionsRepositoryProvider);
    final lines = await repo.getTransactionLines(transactionId);
    
    // Filter out metal receipt/payment and rate cut lines
    final regularLines = lines.where((l) {
      final desc = l.description ?? '';
      return !desc.startsWith('M-Rec:') && 
             !desc.startsWith('M-Pay:') && 
             !desc.startsWith('R-Cut:');
    }).toList();
    
    int totalItems = regularLines.where((l) => l.itemId != null).length;
    double totalQty = regularLines.fold(0.0, (sum, l) => sum + l.qty);
    double totalNetWt = regularLines.fold(0.0, (sum, l) => sum + l.netWeight);
    double totalFineWt = regularLines.fold(0.0, (sum, l) {
      final net = l.netWeight;
      final purity = l.purity ?? 0;
      final wastage = l.wastage;
      // Fine wt = net wt * (purity + wastage) / 100
      return sum + (net * ((purity + wastage) / 100));
    });
    
    return {
      'totalItems': totalItems,
      'totalQty': totalQty,
      'totalNetWt': totalNetWt,
      'totalFineWt': totalFineWt,
    };
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(transactionsListProvider);
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Settings
            },
            tooltip: 'Settings',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/sales/new');
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Sales'),
            ),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (allTransactions) {
          final sales = allTransactions
              .where((t) => t.transaction.type == 'Sale')
              .toList()
              .reversed
              .toList(); // Show newest first

          final filteredSales = _searchQuery.isEmpty
              ? sales
              : sales.where((sale) {
                  final partyName = sale.party.name.toLowerCase();
                  final invoiceNo = sale.transaction.transactionNumber?.toLowerCase() ?? '';
                  final query = _searchQuery.toLowerCase();
                  return partyName.contains(query) || invoiceNo.contains(query);
                }).toList();

          if (filteredSales.isEmpty) {
            return Column(
              children: [
                _buildSearchAndActions(),
                const Expanded(
                  child: Center(
                    child: Text('No sales transactions found. Create a new sale to get started.'),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              _buildSearchAndActions(),
              Expanded(
                child: _buildTable(filteredSales),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSearchAndActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Text(
            'Search',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Type to search...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // TODO: Copy functionality
            },
            tooltip: 'Copy',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Download functionality
            },
            tooltip: 'Download',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // TODO: Print functionality
            },
            tooltip: 'Print',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: More options
            },
            tooltip: 'More options',
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<TransactionWithParty> sales) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: _ProfessionalDataTable(
            columns: const [
              _TableColumn('#', width: 60),
              _TableColumn('Date', width: 120),
              _TableColumn('Invoice #', width: 130),
              _TableColumn('Party', width: 180),
              _TableColumn('Total Items', width: 110),
              _TableColumn('Total Qty', width: 110),
              _TableColumn('Total Net Wt.', width: 130),
              _TableColumn('Total Fine Wt.', width: 130),
              _TableColumn('Total Amounts', width: 140),
              _TableColumn('', width: 60),
            ],
            rows: sales.asMap().entries.map((entry) {
              final index = entry.key;
              final sale = entry.value;
              final rowNumber = sales.length - index;
              return _TableRow(
                cells: [
                  _TableCell(rowNumber.toString(), alignment: TextAlign.center),
                  _TableCell(DateFormat('dd-MMM-yyyy').format(sale.transaction.date)),
                  _TableCell(sale.transaction.transactionNumber ?? '-'),
                  _TableCell(
                    sale.party.name,
                    isLink: true,
                    onTap: () {
                      // TODO: Navigate to party details
                    },
                  ),
                  _TableCell(
                    FutureBuilder<Map<String, dynamic>>(
                      future: _getTransactionLineStats(sale.transaction.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        final stats = snapshot.data ?? {'totalItems': 0};
                        return Text(stats['totalItems'].toString());
                      },
                    ),
                    alignment: TextAlign.center,
                  ),
                  _TableCell(
                    FutureBuilder<Map<String, dynamic>>(
                      future: _getTransactionLineStats(sale.transaction.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        final stats = snapshot.data ?? {'totalQty': 0};
                        return Text(stats['totalQty'].toStringAsFixed(0));
                      },
                    ),
                    alignment: TextAlign.right,
                  ),
                  _TableCell(
                    FutureBuilder<Map<String, dynamic>>(
                      future: _getTransactionLineStats(sale.transaction.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        final stats = snapshot.data ?? {'totalNetWt': 0};
                        return Text(stats['totalNetWt'].toStringAsFixed(3));
                      },
                    ),
                    alignment: TextAlign.right,
                  ),
                  _TableCell(
                    FutureBuilder<Map<String, dynamic>>(
                      future: _getTransactionLineStats(sale.transaction.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        final stats = snapshot.data ?? {'totalFineWt': 0};
                        return Text(stats['totalFineWt'].toStringAsFixed(3));
                      },
                    ),
                    alignment: TextAlign.right,
                  ),
                  _TableCell(
                    NumberFormat.currency(symbol: '₹').format(sale.transaction.totalAmount),
                    alignment: TextAlign.right,
                    isBold: true,
                  ),
                  _TableCell(
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onSelected: (value) async {
                        if (value == 'view') {
                          context.push('/sales/edit/${sale.transaction.id}');
                        } else if (value == 'edit') {
                          context.push('/sales/edit/${sale.transaction.id}');
                        } else if (value == 'delete') {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Sale'),
                              content: Text(
                                'Are you sure you want to delete this sale to ${sale.party.name}?\n\nThis will reverse the stock and balance changes.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          ) ?? false;
                          
                          if (confirmed && context.mounted) {
                            try {
                              await ref
                                  .read(transactionsControllerProvider.notifier)
                                  .deleteTransaction(sale.transaction.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sale to ${sale.party.name} deleted'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting sale: $e'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                            }
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 18),
                              SizedBox(width: 8),
                              Text('View'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 18),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    alignment: TextAlign.center,
                  ),
                ],
                onTap: () {
                  context.push('/sales/edit/${sale.transaction.id}');
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Professional Table Components
class _TableColumn {
  final String label;
  final double width;

  const _TableColumn(this.label, {this.width = 120});
}

class _TableCell {
  final dynamic content;
  final TextAlign alignment;
  final bool isLink;
  final bool isBold;
  final VoidCallback? onTap;

  _TableCell(
    this.content, {
    this.alignment = TextAlign.left,
    this.isLink = false,
    this.isBold = false,
    this.onTap,
  });
}

class _TableRow {
  final List<_TableCell> cells;
  final VoidCallback? onTap;

  _TableRow({required this.cells, this.onTap});
}

class _ProfessionalDataTable extends StatelessWidget {
  final List<_TableColumn> columns;
  final List<_TableRow> rows;

  const _ProfessionalDataTable({
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        top: BorderSide(color: Colors.grey.shade300, width: 1),
        bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        left: BorderSide(color: Colors.grey.shade300, width: 1),
        right: BorderSide(color: Colors.grey.shade300, width: 1),
        horizontalInside: BorderSide(color: Colors.grey.shade200, width: 0.5),
        verticalInside: BorderSide(color: Colors.grey.shade200, width: 0.5),
      ),
      columnWidths: {
        for (int i = 0; i < columns.length; i++)
          i: FixedColumnWidth(columns[i].width),
      },
      children: [
        // Header Row
        TableRow(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 2),
            ),
          ),
          children: columns.map((col) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                col.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF495057),
                  letterSpacing: 0.2,
                ),
              ),
            );
          }).toList(),
        ),
        // Data Rows
        ...rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          final isEven = index % 2 == 0;
          
          return TableRow(
            decoration: BoxDecoration(
              color: isEven ? Colors.white : const Color(0xFFFAFBFC),
            ),
            children: row.cells.asMap().entries.map((cellEntry) {
              final cellIndex = cellEntry.key;
              final cell = cellEntry.value;
              
              Widget content;
              if (cell.content is Widget) {
                content = cell.content;
              } else {
                content = Text(
                  cell.content.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: cell.isBold ? FontWeight.w600 : FontWeight.normal,
                    color: cell.isLink ? const Color(0xFF0066CC) : const Color(0xFF212529),
                    decoration: cell.isLink ? TextDecoration.underline : null,
                  ),
                  textAlign: cell.alignment,
                );
              }
              
              return MouseRegion(
                cursor: (cell.isLink || row.onTap != null) ? SystemMouseCursors.click : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap: cell.onTap ?? row.onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: cellIndex < row.cells.length - 1 
                              ? Colors.grey.shade200 
                              : Colors.transparent,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: _getAlignment(cell.alignment),
                      child: content,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Alignment _getAlignment(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }
}
