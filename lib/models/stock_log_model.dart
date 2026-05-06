// ============================================================
// StockSmart – Stock Log Model
// Data model for tracking stock movement history
// ============================================================

import 'package:hive/hive.dart';

part 'stock_log_model.g.dart';

/// Type of stock transaction
@HiveType(typeId: 2)
enum StockAction {
  @HiveField(0)
  stockIn,

  @HiveField(1)
  stockOut,
}

/// Stock log model representing a single stock transaction
@HiveType(typeId: 1)
class StockLogModel extends HiveObject {
  /// Unique identifier for this log entry
  @HiveField(0)
  final String id;

  /// Reference to the product ID
  @HiveField(1)
  final String productId;

  /// Name of the product (stored for history readability)
  @HiveField(2)
  final String productName;

  /// Type of stock action (Stock In / Stock Out)
  @HiveField(3)
  final StockAction action;

  /// Quantity changed in this transaction
  @HiveField(4)
  final int quantity;

  /// Stock quantity before this transaction
  @HiveField(5)
  final int previousQuantity;

  /// Stock quantity after this transaction
  @HiveField(6)
  final int newQuantity;

  /// Timestamp of this transaction
  @HiveField(7)
  final DateTime timestamp;

  /// Optional notes for this transaction
  @HiveField(8)
  String? notes;

  StockLogModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.action,
    required this.quantity,
    required this.previousQuantity,
    required this.newQuantity,
    DateTime? timestamp,
    this.notes,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Whether this is a Stock In action
  bool get isStockIn => action == StockAction.stockIn;

  /// Whether this is a Stock Out action
  bool get isStockOut => action == StockAction.stockOut;

  /// Display label for the action type
  String get actionLabel => isStockIn ? 'Stock In' : 'Stock Out';

  @override
  String toString() =>
      'StockLog(id: $id, product: $productName, action: $actionLabel, qty: $quantity)';
}
