// ============================================================
// StockSmart – Premium Search & Filter Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/empty_state.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});
  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _searchCtrl = TextEditingController();
  String _catFilter = 'All';
  String _statusFilter = 'All';
  final _focus = FocusNode();

  @override
  void initState() { super.initState(); Future.delayed(const Duration(milliseconds: 300), () { if (mounted) _focus.requestFocus(); }); }
  @override
  void dispose() { _searchCtrl.dispose(); _focus.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Search & Filter', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkText))),
      body: Consumer<ProductProvider>(builder: (context, prov, _) {
        var results = prov.products.toList();
        final q = _searchCtrl.text.toLowerCase();
        if (q.isNotEmpty) results = results.where((p) => p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q) || (p.barcode?.toLowerCase().contains(q) ?? false)).toList();
        if (_catFilter != 'All') results = results.where((p) => p.category == _catFilter).toList();
        if (_statusFilter != 'All') results = results.where((p) { final s = AppHelpers.getStockStatus(p.quantity, p.minThreshold); return (_statusFilter == 'In Stock' && s == StockStatus.inStock) || (_statusFilter == 'Low Stock' && s == StockStatus.lowStock) || (_statusFilter == 'Out of Stock' && s == StockStatus.outOfStock); }).toList();

        return Column(children: [
          // Search
          Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 12), child: Container(
            decoration: BoxDecoration(color: AppColors.cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))]),
            child: TextField(controller: _searchCtrl, focusNode: _focus, onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: 'Search by name, category, or barcode...', prefixIcon: const Icon(Icons.search_rounded, color: AppColors.lightText, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty ? IconButton(icon: const Icon(Icons.close_rounded, color: AppColors.lightText, size: 18), onPressed: () { _searchCtrl.clear(); setState(() {}); }) : null,
                border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), hintStyle: const TextStyle(color: AppColors.lightText, fontSize: 14))),
          )),
          // Categories
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkText)),
            const SizedBox(height: 8),
            SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal, children: ['All', ...AppConstants.categories].map((c) {
              final sel = _catFilter == c;
              return Padding(padding: const EdgeInsets.only(right: 6), child: GestureDetector(onTap: () => setState(() => _catFilter = c),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(gradient: sel ? AppColors.primaryGradient : null, color: sel ? null : AppColors.cardColor, borderRadius: BorderRadius.circular(8), border: sel ? null : Border.all(color: AppColors.borderColor)),
                  child: Text(c, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: sel ? Colors.white : AppColors.mediumText)))));
            }).toList())),
            const SizedBox(height: 12),
            const Text('Stock Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkText)),
            const SizedBox(height: 8),
            Row(children: ['All', 'In Stock', 'Low Stock', 'Out of Stock'].map((s) {
              final sel = _statusFilter == s;
              return Padding(padding: const EdgeInsets.only(right: 6), child: GestureDetector(onTap: () => setState(() => _statusFilter = s),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(gradient: sel ? AppColors.primaryGradient : null, color: sel ? null : AppColors.cardColor, borderRadius: BorderRadius.circular(8), border: sel ? null : Border.all(color: AppColors.borderColor)),
                  child: Text(s, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: sel ? Colors.white : AppColors.mediumText)))));
            }).toList()),
          ])),
          const SizedBox(height: 12),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
            Text('${results.length} result${results.length == 1 ? '' : 's'}', style: const TextStyle(fontSize: 12, color: AppColors.lightText, fontWeight: FontWeight.w500)),
            const Spacer(),
            if (_catFilter != 'All' || _statusFilter != 'All') GestureDetector(onTap: () => setState(() { _catFilter = 'All'; _statusFilter = 'All'; }),
              child: const Text('Clear Filters', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600))),
          ])),
          const SizedBox(height: 8),
          Expanded(child: results.isEmpty
            ? const EmptyState(icon: Icons.search_off_rounded, title: 'No Results', subtitle: 'Try different search terms\nor adjust your filters.')
            : ListView.builder(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), itemCount: results.length,
                itemBuilder: (ctx, i) => ProductCard(product: results[i], onTap: () => Navigator.pushNamed(context, '/edit-product', arguments: results[i])))),
        ]);
      }),
    );
  }
}
