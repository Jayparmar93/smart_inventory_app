// ============================================================
// StockSmart – Product Model
// Data model for inventory products with Hive support
// ============================================================

import 'package:hive/hive.dart';

part 'product_model.g.dart';

/// Product model representing an inventory item
@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  /// Unique identifier for the product
  @HiveField(0)
  final String id;

  /// Product display name
  @HiveField(1)
  String name;

  /// Product category (e.g., Electronics, Lab Equipment)
  @HiveField(2)
  String category;

  /// Current available quantity
  @HiveField(3)
  int quantity;

  /// Minimum stock threshold for low-stock alerts
  @HiveField(4)
  int minThreshold;

  /// Optional barcode/SKU identifier
  @HiveField(5)
  String? barcode;

  /// Whether the product is active in inventory
  @HiveField(6)
  bool isActive;

  /// Last updated timestamp
  @HiveField(7)
  DateTime lastUpdated;

  /// Created timestamp
  @HiveField(8)
  DateTime createdAt;

  /// Optional description
  @HiveField(9)
  String? description;

  /// Optional unit of measurement (e.g., pcs, kg, liters)
  @HiveField(10)
  String unit;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.minThreshold = 10,
    this.barcode,
    this.isActive = true,
    DateTime? lastUpdated,
    DateTime? createdAt,
    this.description,
    this.unit = 'pcs',
  })  : lastUpdated = lastUpdated ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  /// Create a copy with updated fields
  ProductModel copyWith({
    String? name,
    String? category,
    int? quantity,
    int? minThreshold,
    String? barcode,
    bool? isActive,
    DateTime? lastUpdated,
    String? description,
    String? unit,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      minThreshold: minThreshold ?? this.minThreshold,
      barcode: barcode ?? this.barcode,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? DateTime.now(),
      createdAt: createdAt,
      description: description ?? this.description,
      unit: unit ?? this.unit,
    );
  }

  /// Check if stock is low (quantity <= threshold)
  bool get isLowStock => quantity > 0 && quantity <= minThreshold;

  /// Check if product is out of stock
  bool get isOutOfStock => quantity <= 0;

  /// Check if stock level is healthy
  bool get isInStock => quantity > minThreshold;

  @override
  String toString() => 'ProductModel(id: $id, name: $name, qty: $quantity)';
}
