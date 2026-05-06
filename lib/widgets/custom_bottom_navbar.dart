// ============================================================
// StockSmart – Premium Bottom Navigation Bar
// ============================================================

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const NavItem({required this.icon, required this.activeIcon, required this.label});
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  static const List<NavItem> _items = [
    NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: 'Dashboard'),
    NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2_rounded, label: 'Products'),
    NavItem(icon: Icons.swap_vert_rounded, activeIcon: Icons.swap_vert_rounded, label: 'Update'),
    NavItem(icon: Icons.history_outlined, activeIcon: Icons.history_rounded, label: 'History'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        border: Border(top: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5), width: 1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, -6)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = currentIndex == index;

              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: isActive ? 18 : 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.05)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(children: [
                    Icon(
                      isActive ? item.activeIcon : item.icon,
                      color: isActive ? AppColors.primary : AppColors.lightText,
                      size: 23,
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 8),
                      Text(
                        item.label,
                        style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                      ),
                    ],
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
