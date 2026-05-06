// ============================================================
// StockSmart – Premium Custom TextField Widget
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key, required this.label, this.hint, this.controller,
    this.keyboardType = TextInputType.text, this.obscureText = false,
    this.validator, this.onChanged, this.prefixIcon, this.suffix,
    this.maxLines = 1, this.inputFormatters, this.readOnly = false,
    this.onTap, this.enabled = true, this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkText, letterSpacing: 0.1)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller, keyboardType: keyboardType, obscureText: obscureText,
        validator: validator, onChanged: onChanged, maxLines: maxLines,
        inputFormatters: inputFormatters, readOnly: readOnly, onTap: onTap,
        enabled: enabled, focusNode: focusNode,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkText),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.lightText, size: 20) : null,
          suffixIcon: suffix,
          filled: true,
          fillColor: AppColors.surfaceElevated,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderColor)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderColor)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.danger)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.danger, width: 1.5)),
        ),
      ),
    ]);
  }
}
