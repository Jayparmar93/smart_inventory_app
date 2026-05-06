// ============================================================
// StockSmart – Smart Inventory & Stock Replenishment App
// Main entry point with Hive initialization and Provider setup
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/product_provider.dart';
import 'providers/stock_provider.dart';
import 'providers/dashboard_provider.dart';
import 'routes/app_routes.dart';
import 'services/hive_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for mobile)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for premium look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.cardColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Initialize Hive local database
  await HiveService.init();

  // Seed dummy data for demonstration
  await HiveService.seedDummyData();

  // Run the application
  runApp(const StockSmartApp());
}

/// Root application widget with Provider setup
class StockSmartApp extends StatelessWidget {
  const StockSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'StockSmart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
