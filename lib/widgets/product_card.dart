// ============================================================
// StockSmart – Premium Product Card Widget
// ============================================================

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/helpers.dart';
import '../models/product_model.dart';
import 'stock_indicator.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final status = AppHelpers.getStockStatus(product.quantity, product.minThreshold);
    final statusColor = AppHelpers.getStockStatusColor(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category icon with colored accent
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.secondary.withValues(alpha: 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                AppHelpers.getCategoryIcon(product.category),
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.category,
                    style: const TextStyle(fontSize: 12, color: AppColors.lightText),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    StockIndicator(status: status, size: StockIndicatorSize.small),
                    const SizedBox(width: 8),
                    Text(
                      '${product.quantity} ${product.unit}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor),
                    ),
                  ]),
                ],
              ),
            ),

            // Action buttons
            Column(children: [
              if (onEdit != null)
                _ActionBtn(icon: Icons.edit_rounded, color: AppColors.primary, onTap: onEdit!),
              if (onDelete != null) ...[
                const SizedBox(height: 6),
                _ActionBtn(icon: Icons.delete_outline_rounded, color: AppColors.danger, onTap: onDelete!),
              ],
            ]),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
      ),
    );
  }
}
