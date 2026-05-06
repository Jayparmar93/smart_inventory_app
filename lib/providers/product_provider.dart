// ============================================================
// StockSmart – Product Provider
// State management for product CRUD operations
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/hive_service.dart';
import '../core/utils/helpers.dart';

/// Provider for managing product state and operations
class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  // ========== Getters ==========

  /// All products from local storage
  List<ProductModel> get products => _products;

  /// Current search query
  String get searchQuery => _searchQuery;

  /// Currently selected category filter
  String get selectedCategory => _selectedCategory;

  /// Currently selected status filter
  String get selectedStatus => _selectedStatus;

  /// Filtered products based on search and filters
  List<ProductModel> get filteredProducts {
    var result = List<ProductModel>.from(_products);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (p.barcode?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'All') {
      result = result.where((p) {
        final status = AppHelpers.getStockStatus(p.quantity, p.minThreshold);
        switch (_selectedStatus) {
          case 'In Stock':
            return status == StockStatus.inStock;
          case 'Low Stock':
            return status == StockStatus.lowStock;
          case 'Out of Stock':
            return status == StockStatus.outOfStock;
          default:
            return true;
        }
      }).toList();
    }

    return result;
  }

  /// Total product count
  int get totalProducts => _products.where((p) => p.isActive).length;

  /// Low stock product count
  int get lowStockCount =>
      _products.where((p) => p.isActive && p.isLowStock).length;

  /// Out of stock product count
  int get outOfStockCount =>
      _products.where((p) => p.isActive && p.isOutOfStock).length;

  /// In stock product count
  int get inStockCount =>
      _products.where((p) => p.isActive && p.isInStock).length;

  /// Recently updated products (top 5)
  List<ProductModel> get recentProducts {
    final sorted = List<ProductModel>.from(_products)
      ..sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    return sorted.take(5).toList();
  }

  /// Get unique categories from products
  List<String> get availableCategories {
    final categories = _products.map((p) => p.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  /// Get product category distribution as a map
  Map<String, int> get categoryDistribution {
    final map = <String, int>{};
    for (final product in _products.where((p) => p.isActive)) {
      map[product.category] = (map[product.category] ?? 0) + 1;
    }
    return map;
  }

  // ========== Actions ==========

  /// Load all products from Hive storage
  void loadProducts() {
    _products = HiveService.getAllProducts();
    notifyListeners();
  }

  /// Add a new product
  Future<void> addProduct(ProductModel product) async {
    await HiveService.addProduct(product);
    loadProducts();
  }

  /// Update an existing product
  Future<void> updateProduct(ProductModel product) async {
    await HiveService.updateProduct(product);
    loadProducts();
  }

  /// Delete a product by ID
  Future<void> deleteProduct(String id) async {
    await HiveService.deleteProduct(id);
    loadProducts();
  }

  /// Update product quantity directly
  Future<void> updateQuantity(String productId, int newQuantity) async {
    final product = _products.firstWhere((p) => p.id == productId);
    final updated = product.copyWith(
      quantity: newQuantity,
      lastUpdated: DateTime.now(),
    );
    await HiveService.updateProduct(updated);
    loadProducts();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Set category filter
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Set status filter
  void setStatusFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedStatus = 'All';
    notifyListeners();
  }

  /// Get a product by its ID
  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
