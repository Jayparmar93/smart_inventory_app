// ============================================================
// StockSmart – Premium Stock History Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../models/stock_log_model.dart';
import '../../providers/stock_provider.dart';
import '../../widgets/empty_state.dart';

class StockHistoryScreen extends StatelessWidget {
  const StockHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true, snap: true,
              backgroundColor: AppColors.background, surfaceTintColor: Colors.transparent, toolbarHeight: 70,
              title: const Text('Stock History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.darkText, letterSpacing: -0.5)),
            ),
            SliverToBoxAdapter(child: _chart(provider)),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Summary row
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _summaryChip(Icons.arrow_downward_rounded, 'In: ${provider.totalStockInQuantity}', AppColors.success, AppColors.successLight),
                const SizedBox(width: 10),
                _summaryChip(Icons.arrow_upward_rounded, 'Out: ${provider.totalStockOutQuantity}', AppColors.danger, AppColors.dangerLight),
                const SizedBox(width: 10),
                _summaryChip(Icons.receipt_long_rounded, '${provider.logs.length} logs', AppColors.primary, AppColors.primary.withValues(alpha: 0.08)),
              ]),
            )),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Filter
            SliverToBoxAdapter(child: SizedBox(height: 42, child: ListView(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
              children: ['All', 'Stock In', 'Stock Out'].map((f) {
                final sel = provider.historyActionFilter == f;
                return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
                  onTap: () => provider.setHistoryActionFilter(f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      gradient: sel ? AppColors.primaryGradient : null,
                      color: sel ? null : AppColors.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: sel ? null : Border.all(color: AppColors.borderColor),
                      boxShadow: sel ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
                    ),
                    child: Text(f, style: TextStyle(color: sel ? Colors.white : AppColors.mediumText, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, fontSize: 13)),
                  ),
                ));
              }).toList(),
            ))),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            // Search
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: BoxDecoration(color: AppColors.cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5))),
                child: TextField(onChanged: provider.setHistorySearch,
                  decoration: const InputDecoration(hintText: 'Search history...', prefixIcon: Icon(Icons.search_rounded, color: AppColors.lightText, size: 20), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14), hintStyle: TextStyle(color: AppColors.lightText, fontSize: 14))),
              ),
            )),
            // Logs
            provider.filteredLogs.isEmpty
                ? const SliverFillRemaining(child: EmptyState(icon: Icons.history_rounded, title: 'No History Yet', subtitle: 'Stock transactions will appear here\nonce you start updating inventory.'))
                : SliverPadding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 100), sliver: SliverList(delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _logCard(provider.filteredLogs[i]), childCount: provider.filteredLogs.length))),
          ],
        );
      },
    );
  }

  Widget _summaryChip(IconData icon, String text, Color color, Color bg) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ]),
    ));
  }

  Widget _chart(StockProvider provider) {
    final data = provider.weeklyStockMovement;
    final days = data.keys.toList();
    if (days.isEmpty) return const SizedBox.shrink();

    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor, borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.chartIndigo.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.bar_chart_rounded, color: AppColors.chartIndigo, size: 18)),
          const SizedBox(width: 10),
          const Text('Weekly Movement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.darkText)),
          const Spacer(),
          _dot(AppColors.success, 'In'), const SizedBox(width: 12), _dot(AppColors.danger, 'Out'),
        ]),
        const SizedBox(height: 20),
        SizedBox(height: 150, child: BarChart(BarChartData(
          alignment: BarChartAlignment.spaceAround, maxY: _maxY(data),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 26,
              getTitlesWidget: (v, _) => Padding(padding: const EdgeInsets.only(top: 6),
                child: Text(days[v.toInt() < days.length ? v.toInt() : 0], style: const TextStyle(fontSize: 10, color: AppColors.lightText, fontWeight: FontWeight.w500))))),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false), borderData: FlBorderData(show: false),
          barGroups: List.generate(days.length, (i) {
            final d = data[days[i]]!;
            return BarChartGroupData(x: i, barRods: [
              BarChartRodData(toY: d['in']!.toDouble(), color: AppColors.success, width: 8, borderRadius: BorderRadius.circular(4)),
              BarChartRodData(toY: d['out']!.toDouble(), color: AppColors.danger, width: 8, borderRadius: BorderRadius.circular(4)),
            ]);
          }),
        ))),
      ]),
    ));
  }

  double _maxY(Map<String, Map<String, int>> d) {
    double m = 10; for (final v in d.values) { if (v['in']! > m) m = v['in']!.toDouble(); if (v['out']! > m) m = v['out']!.toDouble(); } return m * 1.3;
  }

  Widget _dot(Color c, String l) => Row(children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 4), Text(l, style: const TextStyle(fontSize: 11, color: AppColors.lightText)),
  ]);

  Widget _logCard(StockLogModel log) {
    final isIn = log.isStockIn;
    final color = isIn ? AppColors.success : AppColors.danger;
    final bgColor = isIn ? AppColors.successLight : AppColors.dangerLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardColor, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(width: 42, height: 42,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(isIn ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: color, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(log.productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkText)),
          const SizedBox(height: 2),
          Text('${log.actionLabel} • ${AppHelpers.formatRelativeTime(log.timestamp)}', style: const TextStyle(fontSize: 11, color: AppColors.lightText)),
          if (log.notes != null && log.notes!.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(log.notes!, style: const TextStyle(fontSize: 11, color: AppColors.lightText, fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
            child: Text('${isIn ? '+' : '-'}${log.quantity}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
          ),
          const SizedBox(height: 4),
          Text('${log.previousQuantity} → ${log.newQuantity}', style: const TextStyle(fontSize: 10, color: AppColors.lightText)),
        ]),
      ]),
    );
  }
}
