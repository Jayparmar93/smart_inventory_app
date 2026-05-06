// ============================================================
// StockSmart – Alert Service
// Manages low-stock and out-of-stock alert logic
// ============================================================

import '../models/product_model.dart';
import '../core/utils/helpers.dart';

/// Alert data model for stock warnings
class StockAlert {
  final ProductModel product;
  final StockStatus status;
  final String message;
  final DateTime timestamp;

  StockAlert({
    required this.product,
    required this.status,
    required this.message,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Service class for managing inventory alerts
class AlertService {
  /// Generate alerts for all products that need attention
  static List<StockAlert> generateAlerts(List<ProductModel> products) {
    final alerts = <StockAlert>[];

    for (final product in products) {
      if (!product.isActive) continue;

      if (product.isOutOfStock) {
        alerts.add(StockAlert(
          product: product,
          status: StockStatus.outOfStock,
          message: '${product.name} is out of stock! Immediate restocking required.',
        ));
      } else if (product.isLowStock) {
        alerts.add(StockAlert(
          product: product,
          status: StockStatus.lowStock,
          message:
              '${product.name} is running low (${product.quantity}/${product.minThreshold} ${product.unit}). Consider restocking.',
        ));
      }
    }

    // Sort by severity (out of stock first, then low stock)
    alerts.sort((a, b) {
      if (a.status == StockStatus.outOfStock &&
          b.status != StockStatus.outOfStock) {
        return -1;
      }
      if (a.status != StockStatus.outOfStock &&
          b.status == StockStatus.outOfStock) {
        return 1;
      }
      return a.product.quantity.compareTo(b.product.quantity);
    });

    return alerts;
  }

  /// Count products with low stock
  static int countLowStock(List<ProductModel> products) {
    return products.where((p) => p.isActive && p.isLowStock).length;
  }

  /// Count products that are out of stock
  static int countOutOfStock(List<ProductModel> products) {
    return products.where((p) => p.isActive && p.isOutOfStock).length;
  }

  /// Check if any product needs restocking
  static bool hasAlerts(List<ProductModel> products) {
    return products.any((p) => p.isActive && (p.isLowStock || p.isOutOfStock));
  }
}
