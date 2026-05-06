// ============================================================
// StockSmart – Dashboard Provider
// State management for the main dashboard screen
// ============================================================

import 'package:flutter/foundation.dart';
import '../services/alert_service.dart';
import '../models/product_model.dart';

/// Provider for managing dashboard state and navigation
class DashboardProvider extends ChangeNotifier {
  int _currentNavIndex = 0;
  List<StockAlert> _alerts = [];
  bool _showAlerts = false;

  /// Current bottom navigation index
  int get currentNavIndex => _currentNavIndex;

  /// Active stock alerts
  List<StockAlert> get alerts => _alerts;

  /// Whether to show alerts panel
  bool get showAlerts => _showAlerts;

  /// Number of unread alerts
  int get alertCount => _alerts.length;

  /// Set the current navigation tab
  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  /// Generate alerts from current product list
  void updateAlerts(List<ProductModel> products) {
    _alerts = AlertService.generateAlerts(products);
    notifyListeners();
  }

  /// Toggle alerts panel visibility
  void toggleAlerts() {
    _showAlerts = !_showAlerts;
    notifyListeners();
  }

  /// Hide alerts panel
  void hideAlerts() {
    _showAlerts = false;
    notifyListeners();
  }
}
