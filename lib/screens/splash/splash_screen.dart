// ============================================================
// StockSmart – Premium Splash Screen
// ============================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _scaleCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut));
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    _scaleCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () => _fadeCtrl.forward());
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(top: -80, right: -60, child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.04)),
            )),
            Positioned(bottom: -100, left: -80, child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.03)),
            )),
            Positioned(top: 150, left: -40, child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.02)),
            )),

            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Logo
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 110, height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 40, offset: const Offset(0, 16))],
                    ),
                    child: const Icon(Icons.inventory_rounded, size: 52, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 36),

                // App name
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(children: [
                    const Text(AppConstants.appName, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.8)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Text(
                        AppConstants.appSubtitle.toUpperCase(),
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9), letterSpacing: 2.5),
                      ),
                    ),
                  ]),
                ),

                const Spacer(flex: 2),

                // Loading
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(children: [
                    SizedBox(
                      width: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Loading inventory...', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w400)),
                  ]),
                ),

                const Spacer(),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Text('v${AppConstants.appVersion}', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
