import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/features/dashboard/dashboard_provider.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Summary Cards
            summaryAsync.when(
              data: (data) => _buildSummaryCards(data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => SelectableText(
                'Error: $err\n$stack',
                style: const TextStyle(color: Colors.red),
              ),
            ),

            const SizedBox(height: 32),

            // Charts Section
            summaryAsync.when(
              data: (data) => Row(
                children: [
                  Expanded(flex: 2, child: _buildSalesChart(context, ref)),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildTopDebtorsList(context, ref)),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(DashboardSummary data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Simple responsive grid
        final width = constraints.maxWidth;
        final crossAxisCount = width > 1200 ? 5 : (width > 800 ? 3 : 2);

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _SummaryCard(
              title: 'Gold Rate (24k)',
              value: NumberFormat.currency(
                symbol: '₹',
                decimalDigits: 2,
              ).format(data.goldRate),
              icon: Icons.monetization_on,
              color: Colors.amber.shade700,
            ),
            _SummaryCard(
              title: 'Gold Stock',
              value: '${data.totalGoldStock.toStringAsFixed(3)} g',
              icon: Icons.layers,
              color: Colors.orange.shade800,
            ),
            _SummaryCard(
              title: 'Silver Stock',
              value: '${data.totalSilverStock.toStringAsFixed(3)} g',
              icon: Icons.layers_outlined,
              color: Colors.blueGrey,
            ),
            _SummaryCard(
              title: 'Cust. Gold Balance',
              value: '${data.customerGoldBalance.toStringAsFixed(3)} g',
              icon: Icons.account_balance_wallet,
              color: Colors.green.shade700,
            ),
            _SummaryCard(
              title: 'Cust. Cash Balance',
              value: NumberFormat.currency(
                symbol: '₹',
                decimalDigits: 0,
              ).format(data.customerCashBalance),
              icon: Icons.attach_money,
              color: Colors.teal,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSalesChart(BuildContext context, WidgetRef ref) {
    final chartDataAsync = ref.watch(salesChartDataProvider);
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Overview (Last 7 Days)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: chartDataAsync.when(
              data: (data) {
                // Calculate max Y for the chart
                double maxAmount = 100.0;
                if (data.isNotEmpty) {
                  final calculatedMax = data
                      .map((d) => d['amount'] as double)
                      .reduce((a, b) => a > b ? a : b);
                  if (calculatedMax > 0) {
                    maxAmount = calculatedMax;
                  }
                }

                return BarChart(
                  BarChartData(
                    barGroups: data.asMap().entries.map((entry) {
                      return _makeGroupData(
                        entry.key,
                        entry.value['amount'] as double,
                      );
                    }).toList(),
                    maxY: maxAmount * 1.2,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            );
                            if (value.toInt() < data.length) {
                              final dayData = data[value.toInt()];
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  dayData['day'] as String,
                                  style: style,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => Colors.blueGrey,
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: SelectableText(
                  'Error: $err\n$stack',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppTheme.primaryGold,
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildTopDebtorsList(BuildContext context, WidgetRef ref) {
    final topCustomersAsync = ref.watch(topCustomersProvider);
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Customers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: topCustomersAsync.when(
              data: (customers) {
                if (customers.isEmpty) {
                  return const Center(child: Text('No customers found'));
                }
                return ListView.separated(
                  itemCount: customers.length,
                  separatorBuilder: (c, i) => const Divider(),
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                        ),
                      ),
                      title: Text(
                        customer.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Gold Balance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: customer.goldBalance > 0
                              ? AppTheme.success.withValues(alpha: 0.1)
                              : (customer.goldBalance < 0
                                    ? AppTheme.error.withValues(alpha: 0.1)
                                    : AppTheme.backgroundGrey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${customer.goldBalance.toStringAsFixed(3)} g',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: customer.goldBalance > 0
                                    ? AppTheme.success
                                    : (customer.goldBalance < 0
                                          ? AppTheme.error
                                          : AppTheme.textPrimary),
                              ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppTheme.textTertiary,
                  size: 20,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
