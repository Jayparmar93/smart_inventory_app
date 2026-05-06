// ============================================================
// StockSmart – App Routes Configuration
// Centralized navigation route definitions
// ============================================================

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/dashboard/main_shell.dart';
import '../screens/add_edit_product/add_edit_product_screen.dart';
import '../screens/search_filter/search_filter_screen.dart';
import '../screens/stock_update/stock_update_screen.dart';

/// Application route configuration
class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';
  static const String search = '/search';
  static const String stockUpdate = '/stock-update';

  /// Generate route based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings);

      case main:
        return _buildRoute(const MainShell(), settings);

      case addProduct:
        return _buildRoute(const AddEditProductScreen(), settings);

      case editProduct:
        final product = settings.arguments as ProductModel?;
        return _buildRoute(AddEditProductScreen(product: product), settings);

      case search:
        return _buildRoute(const SearchFilterScreen(), settings);

      case stockUpdate:
        return _buildRoute(const StockUpdateScreen(), settings);

      default:
        return _buildRoute(const SplashScreen(), settings);
    }
  }

  /// Build a route with a smooth page transition
  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        );
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
