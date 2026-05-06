// ============================================================
// StockSmart – Premium Custom Button Widget
// ============================================================

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final Color? color;
  final bool isOutlined;

  const CustomButton({
    super.key, required this.label, this.onPressed, this.isLoading = false,
    this.icon, this.width, this.color, this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primary;

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity, height: 54,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: btnColor, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: _buildChild(btnColor),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity, height: 54,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [btnColor, btnColor == AppColors.primary ? AppColors.secondary : btnColor.withValues(alpha: 0.8)],
            begin: Alignment.centerLeft, end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: btnColor.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: _buildChild(Colors.white),
        ),
      ),
    );
  }

  Widget _buildChild(Color textColor) {
    if (isLoading) {
      return SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(textColor)));
    }
    if (icon != null) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 20, color: textColor),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor, letterSpacing: 0.2)),
      ]);
    }
    return Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor, letterSpacing: 0.2));
  }
}
