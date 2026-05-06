// ============================================================
// StockSmart – Application Constants
// Centralized configuration values
// ============================================================

/// Application-wide constant values
class AppConstants {
  // App info
  static const String appName = 'StockSmart';
  static const String appSubtitle = 'Enterprise Replenishment';
  static const String appVersion = '1.0.0';

  // Hive box names
  static const String productBoxName = 'products';
  static const String stockLogBoxName = 'stock_logs';
  static const String settingsBoxName = 'settings';

  // Animation durations
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // UI Constants
  static const double cardBorderRadius = 20.0;
  static const double buttonBorderRadius = 16.0;
  static const double inputBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;

  // Stock status thresholds
  static const int defaultMinThreshold = 10;

  // Product categories
  static const List<String> categories = [
    'Electronics',
    'Food & Beverages',
    'Office Supplies',
    'Lab Equipment',
    'Cleaning Supplies',
    'Medical Supplies',
    'Raw Materials',
    'Packaging',
    'Tools & Hardware',
    'Furniture',
    'Other',
  ];

  // Category icons mapping
  static const Map<String, int> categoryIcons = {
    'Electronics': 0xe1d5,       // Icons.devices
    'Food & Beverages': 0xe25a,   // Icons.fastfood
    'Office Supplies': 0xe0eb,    // Icons.business_center
    'Lab Equipment': 0xe5d1,      // Icons.science
    'Cleaning Supplies': 0xe1db,  // Icons.cleaning_services
    'Medical Supplies': 0xe548,   // Icons.medical_services
    'Raw Materials': 0xe263,      // Icons.inventory
    'Packaging': 0xe264,          // Icons.inventory_2
    'Tools & Hardware': 0xe0ce,   // Icons.build
    'Furniture': 0xe147,          // Icons.chair
    'Other': 0xe14d,              // Icons.category
  };
}
