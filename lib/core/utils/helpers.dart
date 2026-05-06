// ============================================================
// StockSmart – Utility Helpers
// Common helper functions used throughout the app
// ============================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

/// Stock status enumeration
enum StockStatus { inStock, lowStock, outOfStock }

/// Helper utility class
class AppHelpers {
  /// Format a DateTime to a readable date string
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format a DateTime to a readable date-time string
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy – hh:mm a').format(date);
  }

  /// Format a DateTime to a short time string
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format a DateTime relative to now (e.g., "2 hours ago")
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Determine stock status based on quantity and threshold
  static StockStatus getStockStatus(int quantity, int threshold) {
    if (quantity <= 0) {
      return StockStatus.outOfStock;
    } else if (quantity <= threshold) {
      return StockStatus.lowStock;
    }
    return StockStatus.inStock;
  }

  /// Get the color associated with a stock status
  static Color getStockStatusColor(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return AppColors.success;
      case StockStatus.lowStock:
        return AppColors.warning;
      case StockStatus.outOfStock:
        return AppColors.danger;
    }
  }

  /// Get display label for a stock status
  static String getStockStatusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  /// Get icon for a stock status
  static IconData getStockStatusIcon(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return Icons.check_circle_rounded;
      case StockStatus.lowStock:
        return Icons.warning_amber_rounded;
      case StockStatus.outOfStock:
        return Icons.error_rounded;
    }
  }

  /// Get icon for a category name
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Electronics':
        return Icons.devices_rounded;
      case 'Food & Beverages':
        return Icons.fastfood_rounded;
      case 'Office Supplies':
        return Icons.business_center_rounded;
      case 'Lab Equipment':
        return Icons.science_rounded;
      case 'Cleaning Supplies':
        return Icons.cleaning_services_rounded;
      case 'Medical Supplies':
        return Icons.medical_services_rounded;
      case 'Raw Materials':
        return Icons.inventory_rounded;
      case 'Packaging':
        return Icons.inventory_2_rounded;
      case 'Tools & Hardware':
        return Icons.build_rounded;
      case 'Furniture':
        return Icons.chair_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  /// Show a styled snackbar message
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    final color = isError
        ? AppColors.danger
        : isSuccess
            ? AppColors.success
            : AppColors.darkText;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : isSuccess
                      ? Icons.check_circle_outline_rounded
                      : Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Generate a unique ID based on timestamp
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
