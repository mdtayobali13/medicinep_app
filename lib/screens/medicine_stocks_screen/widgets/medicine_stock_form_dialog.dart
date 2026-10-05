import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/stock_model.dart';
import 'package:medicine_system/providers/medicines_provider.dart';
import 'package:medicine_system/providers/stocks_provider.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_date_field.dart';

class MedicineStockFormDialog extends ConsumerStatefulWidget {
  final bool isEdit;
  final StockModel? item;

  const MedicineStockFormDialog({
    super.key,
    this.isEdit = false,
    this.item,
  });

  @override
  ConsumerState<MedicineStockFormDialog> createState() => _MedicineStockFormDialogState();
}

class _MedicineStockFormDialogState extends ConsumerState<MedicineStockFormDialog> {
  late final TextEditingController _lotMemoController;
  late final TextEditingController _receivedDateController;
  late final TextEditingController _qtyController;
  late final TextEditingController _expireDateController;

  int? _selectedMedicineId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _lotMemoController = TextEditingController(text: widget.item?.batchNumber ?? '');
    _receivedDateController = TextEditingController(text: widget.item?.purchaseDate ?? '');
    _qtyController = TextEditingController(text: widget.item?.quantity.toString() ?? '0');
    _expireDateController = TextEditingController(text: widget.item?.expireDate ?? '');
    _selectedMedicineId = widget.item?.medicineId ?? widget.item?.medicine?.id;
  }

  @override
  void dispose() {
    _lotMemoController.dispose();
    _receivedDateController.dispose();
    _qtyController.dispose();
    _expireDateController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_selectedMedicineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a medicine')),
      );
      return;
    }

    final qty = int.tryParse(_qtyController.text.trim()) ?? 0;

    setState(() => _isSaving = true);

    final Map<String, dynamic> data = {
      'medicine_id': _selectedMedicineId,
      'quantity': qty,
      'batch_number': _lotMemoController.text.trim(),
      'purchase_date': _receivedDateController.text.trim(),
      'expire_date': _expireDateController.text.trim(),
    };

    bool success = false;
    if (widget.isEdit && widget.item != null) {
      success = await ref.read(stocksProvider.notifier).updateStock(widget.item!.id, data);
    } else {
      success = await ref.read(stocksProvider.notifier).createStock(data);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save stock. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final headerBg = isDark ? const Color(0xFF262B30) : const Color(0xFFE2E8F0);
    final headerTextColor = isDark ? Colors.lightBlueAccent : Colors.blue.shade900;
    final textColor = isDark ? Colors.white : Colors.black;

    final medicinesState = ref.watch(medicinesProvider);

    final medicineItems = medicinesState.list.map((m) {
      return DropdownMenuItem<int>(
        value: m.id,
        child: Text(m.brandName, style: TextStyle(fontSize: 14, color: textColor)),
      );
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEdit ? "Edit Medicine Stocks" : "Add Medicine Stocks",
                    style: TextStyle(
                      color: headerTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(CupertinoIcons.clear, size: 20, color: isDark ? Colors.white70 : Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Form Fields
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1
                  Row(
                    children: [
                      Expanded(
                        child: MedicineTextField(
                          label: "Lot Memo Number",
                          hint: "Enter lot memo number",
                          controller: _lotMemoController,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: MedicineDateField(
                          label: "Received Date",
                          hint: "Select date",
                          controller: _receivedDateController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 2
                  Row(
                    children: [
                      Expanded(
                        child: MedicineDropdownField<int>(
                          label: "Medicine",
                          hint: "Select medicine",
                          value: _selectedMedicineId,
                          items: medicineItems,
                          isLoading: medicinesState.isLoading,
                          onChanged: (val) => setState(() => _selectedMedicineId = val),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: MedicineTextField(
                          label: "Quantity",
                          hint: "Enter quantity",
                          controller: _qtyController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 3
                  Row(
                    children: [
                      Expanded(
                        child: MedicineDateField(
                          label: "Expiry Date",
                          hint: "Select date",
                          controller: _expireDateController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  Divider(height: 1, color: isDark ? Colors.white12 : const Color(0xFFEEEEEE)),
                  const SizedBox(height: 24),

                  // Footer Buttons
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _handleSave,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(CupertinoIcons.floppy_disk, size: 18),
                      label: Text(_isSaving ? "Saving..." : "Save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
