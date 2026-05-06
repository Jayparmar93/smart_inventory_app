// ============================================================
// StockSmart – Premium Stock Update Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../models/product_model.dart';
import '../../models/stock_log_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/stock_provider.dart';
import '../../widgets/custom_button.dart';

class StockUpdateScreen extends StatefulWidget {
  const StockUpdateScreen({super.key});
  @override
  State<StockUpdateScreen> createState() => _StockUpdateScreenState();
}

class _StockUpdateScreenState extends State<StockUpdateScreen> {
  ProductModel? _selectedProduct;
  StockAction _action = StockAction.stockIn;
  int _quantity = 1;
  final _notesCtrl = TextEditingController();

  @override
  void dispose() { _notesCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background,
        title: const Text('Stock Update', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkText))),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Select Product'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardColor, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: DropdownButtonHideUnderline(child: DropdownButton<ProductModel>(
              value: _selectedProduct, isExpanded: true,
              hint: const Text('Choose a product...', style: TextStyle(color: AppColors.lightText, fontSize: 14)),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.lightText),
              borderRadius: BorderRadius.circular(14),
              items: products.map((p) => DropdownMenuItem(value: p,
                child: Row(children: [
                  Icon(AppHelpers.getCategoryIcon(p.category), size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
                  Text('${p.quantity} ${p.unit}', style: const TextStyle(fontSize: 11, color: AppColors.lightText)),
                ]),
              )).toList(),
              onChanged: (v) => setState(() => _selectedProduct = v),
            )),
          ),
          const SizedBox(height: 24),

          _label('Transaction Type'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderColor)),
            child: Row(children: [
              _toggle('Stock In', StockAction.stockIn, Icons.add_circle_outline_rounded, AppColors.success),
              const SizedBox(width: 4),
              _toggle('Stock Out', StockAction.stockOut, Icons.remove_circle_outline_rounded, AppColors.danger),
            ]),
          ),
          const SizedBox(height: 24),

          _label('Quantity'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardColor, borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _qtyBtn(Icons.remove_rounded, () { if (_quantity > 1) setState(() => _quantity--); }),
              Container(
                width: 90, margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(12)),
                child: Text('$_quantity', textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.darkText, letterSpacing: -1)),
              ),
              _qtyBtn(Icons.add_rounded, () => setState(() => _quantity++)),
            ]),
          ),
          const SizedBox(height: 24),

          if (_selectedProduct != null) ...[
            _label('Preview'),
            const SizedBox(height: 8),
            _preview(),
            const SizedBox(height: 24),
          ],

          _label('Notes (optional)'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: AppColors.cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderColor)),
            child: TextField(controller: _notesCtrl, maxLines: 3,
              decoration: const InputDecoration(hintText: 'Add transaction notes...', border: InputBorder.none, contentPadding: EdgeInsets.all(16), hintStyle: TextStyle(color: AppColors.lightText, fontSize: 14))),
          ),
          const SizedBox(height: 32),

          CustomButton(
            label: _action == StockAction.stockIn ? 'Confirm Stock In' : 'Confirm Stock Out',
            icon: _action == StockAction.stockIn ? Icons.add_circle_rounded : Icons.remove_circle_rounded,
            color: _action == StockAction.stockIn ? AppColors.success : AppColors.danger,
            onPressed: _selectedProduct == null ? null : () => _confirm(context),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkText, letterSpacing: 0.1));

  Widget _toggle(String label, StockAction action, IconData icon, Color color) {
    final sel = _action == action;
    return Expanded(child: GestureDetector(
      onTap: () => setState(() => _action = action),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: sel ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: sel ? Border.all(color: color.withValues(alpha: 0.3)) : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: sel ? color : AppColors.lightText, size: 18),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: sel ? color : AppColors.lightText, fontSize: 13)),
        ]),
      ),
    ));
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(width: 50, height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.05)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppColors.primary, size: 26)),
  );

  Widget _preview() {
    final p = _selectedProduct!;
    final newQty = _action == StockAction.stockIn ? p.quantity + _quantity : p.quantity - _quantity;
    final isNeg = newQty < 0;
    final previewStatus = AppHelpers.getStockStatus(isNeg ? 0 : newQty, p.minThreshold);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardColor, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 42, height: 42,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.05)]), borderRadius: BorderRadius.circular(12)),
            child: Icon(AppHelpers.getCategoryIcon(p.category), color: AppColors.primary, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkText)),
            Text(p.category, style: const TextStyle(fontSize: 12, color: AppColors.lightText)),
          ])),
        ]),
        const SizedBox(height: 16),
        Container(height: 1, color: AppColors.borderColor),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _prevItem('Current', '${p.quantity}', AppColors.mediumText),
          const Icon(Icons.arrow_forward_rounded, color: AppColors.lightText, size: 18),
          _prevItem('After', isNeg ? 'Invalid' : '$newQty', isNeg ? AppColors.danger : AppHelpers.getStockStatusColor(previewStatus)),
        ]),
        if (isNeg) ...[
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [Icon(Icons.error_outline, color: AppColors.danger, size: 16), SizedBox(width: 8),
              Text('Insufficient stock', style: TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.w500))])),
        ],
      ]),
    );
  }

  Widget _prevItem(String label, String value, Color color) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.lightText)),
    const SizedBox(height: 4),
    Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.5)),
  ]);

  void _confirm(BuildContext context) async {
    final stock = context.read<StockProvider>();
    final prod = context.read<ProductProvider>();
    final ok = await stock.performStockUpdate(product: _selectedProduct!, action: _action, quantity: _quantity, notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text);
    if (ok) {
      prod.loadProducts();
      AppHelpers.showSnackBar(context, 'Stock updated successfully!', isSuccess: true);
      setState(() { _selectedProduct = null; _quantity = 1; _notesCtrl.clear(); });
    } else {
      AppHelpers.showSnackBar(context, 'Insufficient stock for this operation', isError: true);
    }
  }
}
