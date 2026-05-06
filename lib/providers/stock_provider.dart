// ============================================================
// StockSmart – Stock Provider
// State management for stock transactions and history
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../models/stock_log_model.dart';
import '../services/hive_service.dart';
import '../core/utils/helpers.dart';

/// Provider for managing stock update operations and history
class StockProvider extends ChangeNotifier {
  List<StockLogModel> _logs = [];
  String _historySearchQuery = '';
  String _historyActionFilter = 'All'; // All, Stock In, Stock Out

  // ========== Getters ==========

  /// All stock logs
  List<StockLogModel> get logs => _logs;

  /// Filtered stock logs
  List<StockLogModel> get filteredLogs {
    var result = List<StockLogModel>.from(_logs);

    // Apply search
    if (_historySearchQuery.isNotEmpty) {
      result = result
          .where((log) => log.productName
              .toLowerCase()
              .contains(_historySearchQuery.toLowerCase()))
          .toList();
    }

    // Apply action filter
    if (_historyActionFilter == 'Stock In') {
      result = result.where((log) => log.isStockIn).toList();
    } else if (_historyActionFilter == 'Stock Out') {
      result = result.where((log) => log.isStockOut).toList();
    }

    return result;
  }

  /// Recent logs (top 10)
  List<StockLogModel> get recentLogs {
    final sorted = List<StockLogModel>.from(_logs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(10).toList();
  }

  /// Total stock in transactions
  int get totalStockInCount =>
      _logs.where((l) => l.action == StockAction.stockIn).length;

  /// Total stock out transactions
  int get totalStockOutCount =>
      _logs.where((l) => l.action == StockAction.stockOut).length;

  /// Total stock in quantity
  int get totalStockInQuantity => _logs
      .where((l) => l.action == StockAction.stockIn)
      .fold(0, (sum, l) => sum + l.quantity);

  /// Total stock out quantity
  int get totalStockOutQuantity => _logs
      .where((l) => l.action == StockAction.stockOut)
      .fold(0, (sum, l) => sum + l.quantity);

  String get historySearchQuery => _historySearchQuery;
  String get historyActionFilter => _historyActionFilter;

  /// Get stock movement data for chart (last 7 days)
  Map<String, Map<String, int>> get weeklyStockMovement {
    final now = DateTime.now();
    final result = <String, Map<String, int>>{};
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = days[date.weekday - 1];
      final dayLogs = _logs.where((log) =>
          log.timestamp.year == date.year &&
          log.timestamp.month == date.month &&
          log.timestamp.day == date.day);

      int stockIn = 0;
      int stockOut = 0;
      for (final log in dayLogs) {
        if (log.isStockIn) {
          stockIn += log.quantity;
        } else {
          stockOut += log.quantity;
        }
      }

      result[dayName] = {'in': stockIn, 'out': stockOut};
    }

    return result;
  }

  // ========== Actions ==========

  /// Load all stock logs from Hive
  void loadLogs() {
    _logs = HiveService.getAllStockLogs();
    notifyListeners();
  }

  /// Perform a stock update (Stock In or Stock Out)
  Future<bool> performStockUpdate({
    required ProductModel product,
    required StockAction action,
    required int quantity,
    String? notes,
  }) async {
    final previousQuantity = product.quantity;
    int newQuantity;

    if (action == StockAction.stockIn) {
      newQuantity = previousQuantity + quantity;
    } else {
      newQuantity = previousQuantity - quantity;
      if (newQuantity < 0) {
        return false; // Prevent negative stock
      }
    }

    // Create stock log entry
    final log = StockLogModel(
      id: AppHelpers.generateId(),
      productId: product.id,
      productName: product.name,
      action: action,
      quantity: quantity,
      previousQuantity: previousQuantity,
      newQuantity: newQuantity,
      notes: notes,
    );

    // Update product quantity
    final updatedProduct = product.copyWith(
      quantity: newQuantity,
      lastUpdated: DateTime.now(),
    );

    await HiveService.updateProduct(updatedProduct);
    await HiveService.addStockLog(log);

    loadLogs();
    return true;
  }

  /// Set history search query
  void setHistorySearch(String query) {
    _historySearchQuery = query;
    notifyListeners();
  }

  /// Set history action filter
  void setHistoryActionFilter(String filter) {
    _historyActionFilter = filter;
    notifyListeners();
  }

  /// Clear history filters
  void clearHistoryFilters() {
    _historySearchQuery = '';
    _historyActionFilter = 'All';
    notifyListeners();
  }
}
