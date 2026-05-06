// ============================================================
// StockSmart – Premium Add/Edit Product Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;
  const AddEditProductScreen({super.key, this.product});
  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _qtyCtrl, _threshCtrl, _barcodeCtrl, _descCtrl;
  String _category = AppConstants.categories.first;
  String _unit = 'pcs';
  bool _isActive = true;
  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _qtyCtrl = TextEditingController(text: p?.quantity.toString() ?? '');
    _threshCtrl = TextEditingController(text: p?.minThreshold.toString() ?? '10');
    _barcodeCtrl = TextEditingController(text: p?.barcode ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    if (p != null) { _category = p.category; _unit = p.unit; _isActive = p.isActive; }
  }

  @override
  void dispose() { for (var c in [_nameCtrl, _qtyCtrl, _threshCtrl, _barcodeCtrl, _descCtrl]) { c.dispose(); } super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(_isEditing ? 'Edit Product' : 'Add Product', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkText))),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), padding: const EdgeInsets.all(20),
        child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Icon placeholder
          Center(child: Container(width: 96, height: 96,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.05)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 2)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(AppHelpers.getCategoryIcon(_category), size: 36, color: AppColors.primary), const SizedBox(height: 4), Text(_category, style: const TextStyle(fontSize: 9, color: AppColors.lightText), overflow: TextOverflow.ellipsis)]),
          )),
          const SizedBox(height: 28),
          CustomTextField(label: 'Product Name', hint: 'Enter product name', controller: _nameCtrl, prefixIcon: Icons.inventory_2_outlined, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 20),
          const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkText)),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderColor)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _category, isExpanded: true, borderRadius: BorderRadius.circular(14), icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.lightText),
              items: AppConstants.categories.map((c) => DropdownMenuItem(value: c, child: Row(children: [Icon(AppHelpers.getCategoryIcon(c), size: 16, color: AppColors.primary), const SizedBox(width: 10), Text(c, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]))).toList(),
              onChanged: (v) => setState(() => _category = v!)))),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: CustomTextField(label: 'Quantity', hint: '0', controller: _qtyCtrl, keyboardType: TextInputType.number, prefixIcon: Icons.numbers_rounded, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
            const SizedBox(width: 14),
            Expanded(child: CustomTextField(label: 'Min Threshold', hint: '10', controller: _threshCtrl, keyboardType: TextInputType.number, prefixIcon: Icons.warning_amber_rounded, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => v == null || v.isEmpty ? 'Required' : null)),
          ]),
          const SizedBox(height: 20),
          CustomTextField(label: 'Barcode / SKU', hint: 'Optional', controller: _barcodeCtrl, prefixIcon: Icons.qr_code_rounded),
          const SizedBox(height: 20),
          const Text('Unit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkText)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: ['pcs', 'kg', 'liters', 'boxes', 'rolls', 'sets'].map((u) {
            final sel = _unit == u;
            return GestureDetector(onTap: () => setState(() => _unit = u), child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(gradient: sel ? AppColors.primaryGradient : null, color: sel ? null : AppColors.cardColor, borderRadius: BorderRadius.circular(10), border: sel ? null : Border.all(color: AppColors.borderColor)),
              child: Text(u, style: TextStyle(color: sel ? Colors.white : AppColors.mediumText, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, fontSize: 13))));
          }).toList()),
          const SizedBox(height: 20),
          CustomTextField(label: 'Description', hint: 'Optional', controller: _descCtrl, maxLines: 3, prefixIcon: Icons.description_outlined),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderColor)),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.toggle_on_outlined, color: AppColors.primary, size: 20)),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Active Product', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkText)), Text('Include in inventory', style: TextStyle(fontSize: 11, color: AppColors.lightText))])),
              Switch(value: _isActive, onChanged: (v) => setState(() => _isActive = v), activeColor: AppColors.primary),
            ])),
          const SizedBox(height: 32),
          CustomButton(label: _isEditing ? 'Update Product' : 'Save Product', icon: Icons.check_circle_rounded, onPressed: _save),
          const SizedBox(height: 40),
        ])),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final prov = context.read<ProductProvider>();
    final product = ProductModel(id: _isEditing ? widget.product!.id : AppHelpers.generateId(), name: _nameCtrl.text.trim(), category: _category, quantity: int.tryParse(_qtyCtrl.text) ?? 0, minThreshold: int.tryParse(_threshCtrl.text) ?? 10, barcode: _barcodeCtrl.text.isEmpty ? null : _barcodeCtrl.text.trim(), isActive: _isActive, description: _descCtrl.text.isEmpty ? null : _descCtrl.text.trim(), unit: _unit, createdAt: _isEditing ? widget.product!.createdAt : DateTime.now());
    _isEditing ? prov.updateProduct(product) : prov.addProduct(product);
    AppHelpers.showSnackBar(context, _isEditing ? 'Product updated!' : 'Product added!', isSuccess: true);
    Navigator.pop(context);
  }
}
