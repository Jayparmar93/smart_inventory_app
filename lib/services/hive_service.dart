// ============================================================
// StockSmart – Hive Database Service
// Handles all local database operations using Hive
// ============================================================

import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/product_model.dart';
import '../models/stock_log_model.dart';

/// Service class for managing Hive local database operations
class HiveService {
  static late Box<ProductModel> _productBox;
  static late Box<StockLogModel> _stockLogBox;

  /// Initialize Hive and register adapters
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register type adapters
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(StockLogModelAdapter());
    Hive.registerAdapter(StockActionAdapter());

    // Open boxes
    _productBox = await Hive.openBox<ProductModel>(
      AppConstants.productBoxName,
    );
    _stockLogBox = await Hive.openBox<StockLogModel>(
      AppConstants.stockLogBoxName,
    );
  }

  // ========== Product Operations ==========

  /// Get the product box reference
  static Box<ProductModel> get productBox => _productBox;

  /// Get all products
  static List<ProductModel> getAllProducts() {
    return _productBox.values.toList();
  }

  /// Get a single product by ID
  static ProductModel? getProduct(String id) {
    try {
      return _productBox.values.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Add a new product
  static Future<void> addProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
  }

  /// Update an existing product
  static Future<void> updateProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
  }

  /// Delete a product by ID
  static Future<void> deleteProduct(String id) async {
    await _productBox.delete(id);
  }

  /// Check if a product exists
  static bool productExists(String id) {
    return _productBox.containsKey(id);
  }

  // ========== Stock Log Operations ==========

  /// Get the stock log box reference
  static Box<StockLogModel> get stockLogBox => _stockLogBox;

  /// Get all stock logs
  static List<StockLogModel> getAllStockLogs() {
    final logs = _stockLogBox.values.toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  /// Get stock logs for a specific product
  static List<StockLogModel> getProductLogs(String productId) {
    final logs = _stockLogBox.values
        .where((log) => log.productId == productId)
        .toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  /// Add a new stock log entry
  static Future<void> addStockLog(StockLogModel log) async {
    await _stockLogBox.put(log.id, log);
  }

  /// Get recent stock logs (limited count)
  static List<StockLogModel> getRecentLogs({int limit = 20}) {
    final logs = getAllStockLogs();
    return logs.take(limit).toList();
  }

  // ========== Utility Operations ==========

  /// Clear all data (useful for testing/reset)
  static Future<void> clearAll() async {
    await _productBox.clear();
    await _stockLogBox.clear();
  }

  /// Get product count
  static int get productCount => _productBox.length;

  /// Get stock log count
  static int get stockLogCount => _stockLogBox.length;

  /// Seed initial dummy data for demonstration
  static Future<void> seedDummyData() async {
    if (_productBox.isNotEmpty) return; // Don't seed if data exists

    final now = DateTime.now();

    final dummyProducts = [
      ProductModel(
        id: '1',
        name: 'Wireless Mouse',
        category: 'Electronics',
        quantity: 45,
        minThreshold: 10,
        barcode: 'WM-001',
        description: 'Ergonomic wireless mouse with USB receiver',
        unit: 'pcs',
        lastUpdated: now.subtract(const Duration(hours: 2)),
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      ProductModel(
        id: '2',
        name: 'USB-C Hub',
        category: 'Electronics',
        quantity: 8,
        minThreshold: 15,
        barcode: 'UH-002',
        description: '7-in-1 USB-C docking station',
        unit: 'pcs',
        lastUpdated: now.subtract(const Duration(hours: 5)),
        createdAt: now.subtract(const Duration(days: 25)),
      ),
      ProductModel(
        id: '3',
        name: 'A4 Paper Ream',
        category: 'Office Supplies',
        quantity: 120,
        minThreshold: 20,
        barcode: 'AP-003',
        description: '500 sheets, 80gsm white paper',
        unit: 'pcs',
        lastUpdated: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 60)),
      ),
      ProductModel(
        id: '4',
        name: 'Lab Microscope',
        category: 'Lab Equipment',
        quantity: 3,
        minThreshold: 5,
        barcode: 'LM-004',
        description: 'Binocular compound microscope 40X-2000X',
        unit: 'pcs',
        lastUpdated: now.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      ProductModel(
        id: '5',
        name: 'Hand Sanitizer',
        category: 'Cleaning Supplies',
        quantity: 0,
        minThreshold: 25,
        barcode: 'HS-005',
        description: '500ml alcohol-based hand sanitizer',
        unit: 'pcs',
        lastUpdated: now.subtract(const Duration(hours: 8)),
        createdAt: now.subtract(const Duration(days: 15)),
      ),
      ProductModel(
        id: '6',
        name: 'Surgical Gloves',
        category: 'Medical Supplies',
        quantity: 200,
        minThreshold: 50,
        barcode: 'SG-006',
        description: 'Latex-free disposable gloves, box of 100',
        unit: 'boxes',
        lastUpdated: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 45)),
      ),
      ProductModel(
        id: '7',
        name: 'Printer Toner',
        category: 'Office Supplies',
        quantity: 5,
        minThreshold: 8,
        barcode: 'PT-007',
        description: 'Black toner cartridge for HP LaserJet',
        unit: 'pcs',
        lastUpdated: now.subtract(const Duration(hours: 12)),
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      ProductModel(
        id: '8',
        name: 'Steel Bolts M8',
        category: 'Tools & Hardware',
        quantity: 500,
        minThreshold: 100,
        barcode: 'SB-008',
        description: 'Stainless steel hex bolts M8x30mm',
        unit: 'pcs',
        lastUpdated: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 120)),
      ),
      ProductModel(
        id: '9',
        name: 'Bubble Wrap Roll',
        category: 'Packaging',
        quantity: 12,
        minThreshold: 10,
        barcode: 'BW-009',
        description: '300mm x 50m bubble wrap roll',
        unit: 'rolls',
        lastUpdated: now.subtract(const Duration(hours: 18)),
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      ProductModel(
        id: '10',
        name: 'Ergonomic Chair',
        category: 'Furniture',
        quantity: 0,
        minThreshold: 3,
        barcode: 'EC-010',
        description: 'Adjustable mesh office chair with lumbar support',
        unit: 'pcs',
        lastUpdated: now.subtract(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(days: 180)),
      ),
    ];

    for (final product in dummyProducts) {
      await addProduct(product);
    }

    // Seed some stock log history
    final dummyLogs = [
      StockLogModel(
        id: 'log_1',
        productId: '1',
        productName: 'Wireless Mouse',
        action: StockAction.stockIn,
        quantity: 20,
        previousQuantity: 25,
        newQuantity: 45,
        timestamp: now.subtract(const Duration(hours: 2)),
        notes: 'New shipment received',
      ),
      StockLogModel(
        id: 'log_2',
        productId: '2',
        productName: 'USB-C Hub',
        action: StockAction.stockOut,
        quantity: 7,
        previousQuantity: 15,
        newQuantity: 8,
        timestamp: now.subtract(const Duration(hours: 5)),
        notes: 'Distributed to IT department',
      ),
      StockLogModel(
        id: 'log_3',
        productId: '5',
        productName: 'Hand Sanitizer',
        action: StockAction.stockOut,
        quantity: 10,
        previousQuantity: 10,
        newQuantity: 0,
        timestamp: now.subtract(const Duration(hours: 8)),
        notes: 'All units distributed',
      ),
      StockLogModel(
        id: 'log_4',
        productId: '3',
        productName: 'A4 Paper Ream',
        action: StockAction.stockIn,
        quantity: 50,
        previousQuantity: 70,
        newQuantity: 120,
        timestamp: now.subtract(const Duration(days: 1)),
        notes: 'Monthly restocking',
      ),
      StockLogModel(
        id: 'log_5',
        productId: '7',
        productName: 'Printer Toner',
        action: StockAction.stockOut,
        quantity: 3,
        previousQuantity: 8,
        newQuantity: 5,
        timestamp: now.subtract(const Duration(hours: 12)),
        notes: 'Replaced toner in 3 printers',
      ),
      StockLogModel(
        id: 'log_6',
        productId: '6',
        productName: 'Surgical Gloves',
        action: StockAction.stockIn,
        quantity: 100,
        previousQuantity: 100,
        newQuantity: 200,
        timestamp: now.subtract(const Duration(days: 2)),
        notes: 'Quarterly supply order',
      ),
      StockLogModel(
        id: 'log_7',
        productId: '4',
        productName: 'Lab Microscope',
        action: StockAction.stockOut,
        quantity: 2,
        previousQuantity: 5,
        newQuantity: 3,
        timestamp: now.subtract(const Duration(days: 3)),
        notes: 'Sent for maintenance',
      ),
      StockLogModel(
        id: 'log_8',
        productId: '9',
        productName: 'Bubble Wrap Roll',
        action: StockAction.stockIn,
        quantity: 8,
        previousQuantity: 4,
        newQuantity: 12,
        timestamp: now.subtract(const Duration(hours: 18)),
      ),
    ];

    for (final log in dummyLogs) {
      await addStockLog(log);
    }
  }
}
