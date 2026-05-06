// ============================================================
// StockSmart – Premium Products Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/empty_state.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

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
              toolbarHeight: 70,
              title: const Text('Products', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.darkText, letterSpacing: -0.5)),
              actions: [
                Container(
                  decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderColor)),
                  child: IconButton(onPressed: () => Navigator.pushNamed(context, '/search'), icon: const Icon(Icons.search_rounded, color: AppColors.darkText, size: 22)),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12)),
                  child: IconButton(onPressed: () => Navigator.pushNamed(context, '/add-product'), icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22)),
                ),
                const SizedBox(width: 16),
              ],
            ),
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardColor, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: TextField(
                    onChanged: provider.setSearchQuery,
                    decoration: const InputDecoration(
                      hintText: 'Search products...', prefixIcon: Icon(Icons.search_rounded, color: AppColors.lightText, size: 20),
                      border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      hintStyle: TextStyle(color: AppColors.lightText, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            // Filter chips
            SliverToBoxAdapter(
              child: SizedBox(height: 42,
                child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: ['All', 'In Stock', 'Low Stock', 'Out of Stock'].map((status) {
                    final isSel = provider.selectedStatus == status;
                    return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
                      onTap: () => provider.setStatusFilter(status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                          gradient: isSel ? AppColors.primaryGradient : null,
                          color: isSel ? null : AppColors.cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: isSel ? null : Border.all(color: AppColors.borderColor),
                          boxShadow: isSel ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
                        ),
                        child: Text(status, style: TextStyle(
                          color: isSel ? Colors.white : AppColors.mediumText,
                          fontWeight: isSel ? FontWeight.w600 : FontWeight.w400, fontSize: 13,
                        )),
                      ),
                    ));
                  }).toList(),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Product list
            provider.filteredProducts.isEmpty
                ? SliverFillRemaining(child: EmptyState(
                    icon: Icons.inventory_2_outlined, title: 'No Products Found',
                    subtitle: 'Try adjusting your search or filters,\nor add a new product.',
                    actionLabel: 'Add Product', onAction: () => Navigator.pushNamed(context, '/add-product'),
                  ))
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList(delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = provider.filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () => Navigator.pushNamed(context, '/edit-product', arguments: product),
                          onEdit: () => Navigator.pushNamed(context, '/edit-product', arguments: product),
                          onDelete: () => _confirmDelete(context, provider, product.id, product.name),
                        );
                      },
                      childCount: provider.filteredProducts.length,
                    )),
                  ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ProductProvider provider, String id, String name) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20)),
        const SizedBox(width: 10),
        const Text('Delete Product', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      ]),
      content: Text('Are you sure you want to delete "$name"? This action cannot be undone.', style: const TextStyle(color: AppColors.mediumText)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.mediumText))),
        Container(
          decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () { provider.deleteProduct(id); Navigator.pop(ctx); AppHelpers.showSnackBar(context, 'Product deleted', isSuccess: true); },
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    ));
  }
}
