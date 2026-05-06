// ============================================================
// StockSmart – Premium Dashboard Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../providers/product_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/stock_indicator.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true, snap: true,
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 72,
              title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.inventory_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('StockSmart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkText, letterSpacing: -0.5)),
                    Text('Inventory Dashboard', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.lightText)),
                  ]),
                ]),
              ]),
              actions: [
                Consumer<DashboardProvider>(
                  builder: (context, dash, _) => Stack(children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: IconButton(
                        onPressed: () => _showAlertsSheet(context, provider),
                        icon: const Icon(Icons.notifications_outlined, color: AppColors.darkText, size: 22),
                      ),
                    ),
                    if (dash.alertCount > 0)
                      Positioned(right: 6, top: 4, child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.danger, shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text('${dash.alertCount}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                      )),
                  ]),
                ),
                const SizedBox(width: 16),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(delegate: SliverChildListDelegate([
                const SizedBox(height: 8),

                // Stat cards row
                Row(children: [
                  Expanded(child: DashboardCard(title: 'Total Products', value: '${provider.totalProducts}', icon: Icons.inventory_2_rounded, color: AppColors.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: DashboardCard(title: 'Low Stock', value: '${provider.lowStockCount}', icon: Icons.warning_amber_rounded, color: AppColors.warning, subtitle: provider.lowStockCount > 0 ? 'Needs attention' : null)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: DashboardCard(title: 'Out of Stock', value: '${provider.outOfStockCount}', icon: Icons.error_outline_rounded, color: AppColors.danger, subtitle: provider.outOfStockCount > 0 ? 'Critical' : null)),
                  const SizedBox(width: 12),
                  Expanded(child: DashboardCard(title: 'In Stock', value: '${provider.inStockCount}', icon: Icons.check_circle_outline_rounded, color: AppColors.success)),
                ]),
                const SizedBox(height: 24),

                // Inventory chart
                _buildChart(provider),
                const SizedBox(height: 24),

                // Stock overview
                _buildStockOverview(provider),
                const SizedBox(height: 24),

                // Recent products
                _buildRecentSection(context, provider),
                const SizedBox(height: 100),
              ])),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChart(ProductProvider provider) {
    final dist = provider.categoryDistribution;
    if (dist.isEmpty) return const SizedBox.shrink();
    final colors = [AppColors.chartIndigo, AppColors.chartSky, AppColors.chartEmerald, AppColors.chartAmber, AppColors.chartRose, AppColors.chartTeal, AppColors.chartViolet, AppColors.chartOrange];
    final entries = dist.entries.toList();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardColor, borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.chartIndigo.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.pie_chart_rounded, color: AppColors.chartIndigo, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('Inventory Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.darkText)),
        ]),
        const SizedBox(height: 22),
        Row(children: [
          SizedBox(width: 130, height: 130, child: PieChart(PieChartData(
            sections: List.generate(entries.length, (i) => PieChartSectionData(
              value: entries[i].value.toDouble(), color: colors[i % colors.length], radius: 22, showTitle: false,
            )),
            centerSpaceRadius: 38, sectionsSpace: 3,
          ))),
          const SizedBox(width: 22),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List.generate(
            entries.length > 5 ? 5 : entries.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: colors[i % colors.length], borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Expanded(child: Text(entries[i].key, style: const TextStyle(fontSize: 12, color: AppColors.mediumText), overflow: TextOverflow.ellipsis)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: colors[i % colors.length].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('${entries[i].value}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors[i % colors.length])),
                ),
              ]),
            ),
          ))),
        ]),
      ]),
    );
  }

  Widget _buildStockOverview(ProductProvider provider) {
    final total = provider.totalProducts;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardColor, borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.bar_chart_rounded, color: AppColors.success, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('Stock Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.darkText)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
            child: Text('$total items', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
        ]),
        const SizedBox(height: 20),
        _overviewRow('In Stock', provider.inStockCount, total, AppColors.success, Icons.check_circle_rounded),
        const SizedBox(height: 14),
        _overviewRow('Low Stock', provider.lowStockCount, total, AppColors.warning, Icons.warning_rounded),
        const SizedBox(height: 14),
        _overviewRow('Out of Stock', provider.outOfStockCount, total, AppColors.danger, Icons.cancel_rounded),
      ]),
    );
  }

  Widget _overviewRow(String label, int count, int total, Color color, IconData icon) {
    final ratio = total > 0 ? count / total : 0.0;
    return Row(children: [
      Icon(icon, color: color, size: 16), const SizedBox(width: 10),
      Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.mediumText, fontWeight: FontWeight.w500))),
      Expanded(flex: 3, child: Container(
        height: 7,
        decoration: BoxDecoration(color: AppColors.borderColor, borderRadius: BorderRadius.circular(4)),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft, widthFactor: ratio.clamp(0.0, 1.0),
          child: Container(decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.6)]),
            borderRadius: BorderRadius.circular(4),
          )),
        ),
      )),
      const SizedBox(width: 12),
      SizedBox(width: 28, child: Text('$count', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color), textAlign: TextAlign.right)),
    ]);
  }

  Widget _buildRecentSection(BuildContext context, ProductProvider provider) {
    final recent = provider.recentProducts;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.update_rounded, color: AppColors.accent, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('Recently Updated', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.darkText)),
        ]),
        TextButton(
          onPressed: () => context.read<DashboardProvider>().setNavIndex(1),
          child: const Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ]),
      const SizedBox(height: 12),
      if (recent.isEmpty)
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: AppColors.cardColor, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5))),
          child: const Center(child: Text('No products yet', style: TextStyle(color: AppColors.lightText))),
        )
      else
        ...recent.map((product) {
          final status = AppHelpers.getStockStatus(product.quantity, product.minThreshold);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardColor, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(AppHelpers.getCategoryIcon(product.category), color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkText)),
                const SizedBox(height: 2),
                Text(AppHelpers.formatRelativeTime(product.lastUpdated), style: const TextStyle(fontSize: 11, color: AppColors.lightText)),
              ])),
              StockIndicator(status: status, size: StockIndicatorSize.small),
            ]),
          );
        }),
    ]);
  }

  void _showAlertsSheet(BuildContext context, ProductProvider provider) {
    final alerts = provider.products.where((p) => p.isActive && (p.isLowStock || p.isOutOfStock)).toList();
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
        decoration: const BoxDecoration(color: AppColors.cardColor, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.notifications_active_rounded, color: AppColors.warning, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Stock Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.darkText)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(8)),
              child: Text('${alerts.length}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.danger, fontSize: 13)),
            ),
          ])),
          const SizedBox(height: 16), const Divider(height: 1),
          Flexible(
            child: alerts.isEmpty
              ? Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle_rounded, size: 40, color: AppColors.success),
                  ),
                  const SizedBox(height: 16),
                  const Text('All stock levels healthy!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkText)),
                ]))
              : ListView.builder(
                  shrinkWrap: true, padding: const EdgeInsets.all(16), itemCount: alerts.length,
                  itemBuilder: (context, i) {
                    final p = alerts[i]; final isOut = p.isOutOfStock;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isOut ? AppColors.dangerLight : AppColors.warningLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(children: [
                        Icon(isOut ? Icons.error_rounded : Icons.warning_rounded, color: isOut ? AppColors.danger : AppColors.warning, size: 20),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkText, fontSize: 14)),
                          Text(isOut ? 'Out of stock — restock now' : 'Low: ${p.quantity}/${p.minThreshold} ${p.unit}',
                            style: TextStyle(fontSize: 12, color: isOut ? AppColors.danger : AppColors.warning, fontWeight: FontWeight.w500)),
                        ])),
                      ]),
                    );
                  },
                ),
          ),
        ]),
      ),
    );
  }
}
