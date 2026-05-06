// ============================================================
// StockSmart – Main Shell
// Container screen with bottom navigation bar
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/product_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/stock_provider.dart';
import '../../widgets/custom_bottom_navbar.dart';
import '../dashboard/dashboard_screen.dart';
import '../products/products_screen.dart';
import '../stock_update/stock_update_screen.dart';
import '../stock_history/stock_history_screen.dart';

/// Main application shell with bottom navigation
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      final stockProvider = context.read<StockProvider>();
      final dashProvider = context.read<DashboardProvider>();

      productProvider.loadProducts();
      stockProvider.loadLogs();
      dashProvider.updateAlerts(productProvider.products);
    });
  }

  /// Screens for each bottom nav tab
  final List<Widget> _screens = const [
    DashboardScreen(),
    ProductsScreen(),
    StockUpdateScreen(),
    StockHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashProvider, _) {
        // Refresh alerts when products change
        final products = context.watch<ProductProvider>().products;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          dashProvider.updateAlerts(products);
        });

        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: dashProvider.currentNavIndex,
            children: _screens,
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: dashProvider.currentNavIndex,
            onTap: (index) => dashProvider.setNavIndex(index),
          ),
          floatingActionButton: dashProvider.currentNavIndex == 0
              ? Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () => Navigator.pushNamed(context, '/add-product').then((_) {
                      context.read<ProductProvider>().loadProducts();
                    }),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
                  ),
                )
              : null,
        );
      },
    );
  }
}
