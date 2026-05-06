// ============================================================
// StockSmart – Premium Stock Indicator Widget
// ============================================================

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/helpers.dart';

enum StockIndicatorSize { small, medium, large }

class StockIndicator extends StatelessWidget {
  final StockStatus status;
  final StockIndicatorSize size;
  final bool showLabel;

  const StockIndicator({
    super.key,
    required this.status,
    this.size = StockIndicatorSize.medium,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppHelpers.getStockStatusColor(status);
    final label = AppHelpers.getStockStatusLabel(status);
    final icon = AppHelpers.getStockStatusIcon(status);

    double fontSize, iconSize, paddingH, paddingV, dotSize;
    switch (size) {
      case StockIndicatorSize.small:
        fontSize = 10; iconSize = 11; paddingH = 7; paddingV = 3; dotSize = 6;
      case StockIndicatorSize.medium:
        fontSize = 12; iconSize = 13; paddingH = 10; paddingV = 5; dotSize = 8;
      case StockIndicatorSize.large:
        fontSize = 14; iconSize = 15; paddingH = 14; paddingV = 7; dotSize = 10;
    }

    if (!showLabel) {
      return Container(
        width: dotSize, height: dotSize,
        decoration: BoxDecoration(
          color: color, shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 1))],
        ),
      );
    }

    // Background color based on status
    Color bgColor;
    switch (status) {
      case StockStatus.inStock:
        bgColor = AppColors.successLight;
      case StockStatus.lowStock:
        bgColor = AppColors.warningLight;
      case StockStatus.outOfStock:
        bgColor = AppColors.dangerLight;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: iconSize, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: color, letterSpacing: -0.1)),
      ]),
    );
  }
}

class StockLevelBar extends StatelessWidget {
  final int currentQuantity;
  final int maxQuantity;
  final Color? color;

  const StockLevelBar({super.key, required this.currentQuantity, required this.maxQuantity, this.color});

  @override
  Widget build(BuildContext context) {
    final ratio = maxQuantity > 0 ? (currentQuantity / maxQuantity).clamp(0.0, 1.0) : 0.0;
    final barColor = color ?? (ratio > 0.5 ? AppColors.success : ratio > 0.2 ? AppColors.warning : AppColors.danger);

    return Container(
      height: 6,
      decoration: BoxDecoration(color: AppColors.borderColor, borderRadius: BorderRadius.circular(3)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: ratio,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [barColor, barColor.withValues(alpha: 0.7)]),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
