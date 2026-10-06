import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/medicine_model.dart';
import 'package:medicine_system/models/medicine_unit_model.dart';
import 'package:medicine_system/models/stock_model.dart';
import 'package:medicine_system/providers/medicine_units_provider.dart';
import 'package:medicine_system/providers/medicines_provider.dart';
import 'package:medicine_system/providers/stocks_provider.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_date_field.dart';

class _StockRowItem {
  int? medicineId;
  final TextEditingController qtyController;
  final TextEditingController expireDateController;
  final TextEditingController currentStockController;

  _StockRowItem({
    this.medicineId,
    String qty = '0',
    String expireDate = '',
    String currentStock = '0',
  })  : qtyController = TextEditingController(text: qty),
        expireDateController = TextEditingController(text: expireDate),
        currentStockController = TextEditingController(text: currentStock);

  void dispose() {
    qtyController.dispose();
    expireDateController.dispose();
    currentStockController.dispose();
  }
}

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
  late final TextEditingController _removeQtyController;
  late final TextEditingController _editCurrentStockController;
  late final TextEditingController _givenQtyController;

  final List<_StockRowItem> _items = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _lotMemoController = TextEditingController(text: widget.item?.batchNumber ?? '');
    _receivedDateController = TextEditingController(text: _formatDateForUi(widget.item?.purchaseDate));
    _removeQtyController = TextEditingController(text: '0');
    final initialUnits = ref.read(medicineUnitsProvider).list;
    final initialStockStr = _formatStockDisplay(widget.item?.medicine, initialUnits);
    _editCurrentStockController = TextEditingController(text: initialStockStr);
    _givenQtyController = TextEditingController(text: widget.item?.quantity.toString() ?? '0');

    if (widget.isEdit && widget.item != null) {
      _items.add(
        _StockRowItem(
          medicineId: (widget.item?.medicineId != null && widget.item!.medicineId > 0)
              ? widget.item!.medicineId
              : widget.item?.medicine?.id,
          qty: widget.item?.quantity.toString() ?? '0',
          expireDate: _formatDateForUi(widget.item?.expireDate),
        ),
      );
    } else {
      _items.add(_StockRowItem());
    }
  }

  @override
  void dispose() {
    _lotMemoController.dispose();
    _receivedDateController.dispose();
    _removeQtyController.dispose();
    _editCurrentStockController.dispose();
    _givenQtyController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _addStockRow() {
    setState(() {
      _items.add(_StockRowItem());
    });
  }

  void _removeStockRow(int index) {
    if (_items.length <= 1) return;
    setState(() {
      final removed = _items.removeAt(index);
      removed.dispose();
    });
  }

  String _formatDateForApi(String rawDate) {
    final trimmed = rawDate.trim();
    if (trimmed.isEmpty) return trimmed;
    try {
      if (trimmed.contains('-')) {
        final parts = trimmed.split('-');
        if (parts.length == 3 && parts[0].length == 2 && parts[2].length == 4) {
          // dd-MM-yyyy -> yyyy-MM-dd
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      } else if (trimmed.contains('/')) {
        final parts = trimmed.split('/');
        if (parts.length == 3 && parts[0].length == 2 && parts[2].length == 4) {
          // dd/MM/yyyy -> yyyy-MM-dd
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      }
    } catch (_) {}
    return trimmed;
  }

  String _formatDateForUi(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return '';
    var trimmed = rawDate.trim();
    try {
      if (trimmed.contains('T')) {
        trimmed = trimmed.split('T').first;
      } else if (trimmed.contains(' ')) {
        trimmed = trimmed.split(' ').first;
      }
      if (trimmed.contains('-')) {
        final parts = trimmed.split('-');
        if (parts.length == 3 && parts[0].length == 4) {
          // yyyy-MM-dd -> dd-MM-yyyy
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        } else if (parts.length == 3 && parts[0].length == 2 && parts[2].length == 4) {
          return trimmed;
        }
      } else if (trimmed.contains('/')) {
        final parts = trimmed.split('/');
        if (parts.length == 3 && parts[0].length == 4) {
          // yyyy/MM/dd -> dd-MM-yyyy
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        } else if (parts.length == 3 && parts[0].length == 2 && parts[2].length == 4) {
          return '${parts[0]}-${parts[1]}-${parts[2]}';
        }
      }
    } catch (_) {}
    return trimmed;
  }

  Future<void> _handleSave() async {
    final lotMemo = _lotMemoController.text.trim();
    final pDateRaw = _receivedDateController.text.trim();
    final pDateFormatted = _formatDateForApi(pDateRaw);

    if (!widget.isEdit && lotMemo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Lot Memo Number')),
      );
      return;
    }

    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);

    for (int i = 0; i < _items.length; i++) {
      if (_items[i].medicineId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a medicine for item #${i + 1}')),
        );
        return;
      }

      final qty = int.tryParse(_items[i].qtyController.text.trim()) ?? 0;
      if (qty <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid quantity for item #${i + 1}')),
        );
        return;
      }

      final expRaw = _items[i].expireDateController.text.trim();
      if (expRaw.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an Expiry Date for item #${i + 1}')),
        );
        return;
      }

      final formattedExp = _formatDateForApi(expRaw);
      final parsed = DateTime.tryParse(formattedExp);
      if (parsed != null && !parsed.isAfter(todayMidnight)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expiry date for item #${i + 1} must be a date after today.')),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    bool success = false;

    if (widget.isEdit && widget.item != null) {
      final item = _items.first;
      final newQty = int.tryParse(item.qtyController.text.trim()) ?? 0;
      final removeQty = int.tryParse(_removeQtyController.text.trim()) ?? 0;
      final expDateFormatted = _formatDateForApi(item.expireDateController.text.trim());

      final selectedMed = _findMedicine(ref.read(medicinesProvider).list, item.medicineId) ?? widget.item?.medicine;
      final currentStock = selectedMed?.currentStock ?? widget.item?.quantity ?? 0;

      if (removeQty > currentStock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Remove quantity ($removeQty) cannot exceed current stock quantity ($currentStock).'),
            backgroundColor: Colors.red.shade700,
          ),
        );
        setState(() => _isSaving = false);
        return;
      }

      final Map<String, dynamic> data = {
        'medicine_id': item.medicineId,
        'quantity': newQty,
        'given_quantity': widget.item?.quantity ?? 0,
        if (removeQty > 0) 'remove_quantity': removeQty,
        if (removeQty > 0) 'reduce_quantity': removeQty,
        if (expDateFormatted.isNotEmpty) 'expire_date': expDateFormatted,
        if (expDateFormatted.isNotEmpty) 'expiry_date': expDateFormatted,
        if (lotMemo.isNotEmpty) 'lot_memo_no': lotMemo,
        if (lotMemo.isNotEmpty) 'batch_number': lotMemo,
        if (pDateFormatted.isNotEmpty) 'received_date': pDateFormatted,
        if (pDateFormatted.isNotEmpty) 'purchase_date': pDateFormatted,
      };

      success = await ref.read(stocksProvider.notifier).updateStock(widget.item!.id, data);
    } else {
      final stockItemsPayload = _items.map((item) {
        final qty = int.tryParse(item.qtyController.text.trim()) ?? 0;
        final expDateFormatted = _formatDateForApi(item.expireDateController.text.trim());
        return {
          'medicine_id': item.medicineId,
          'quantity': qty,
          'qty': qty,
          if (expDateFormatted.isNotEmpty) 'expire_date': expDateFormatted,
          if (expDateFormatted.isNotEmpty) 'expiry_date': expDateFormatted,
        };
      }).toList();

      final Map<String, dynamic> data = {
        'lot_memo_no': lotMemo,
        'lot_memo_number': lotMemo,
        'batch_number': lotMemo,
        'received_date': pDateFormatted,
        'purchase_date': pDateFormatted,
        'stocks': stockItemsPayload,
        'items': stockItemsPayload,
        'medicines': stockItemsPayload,
        if (_items.isNotEmpty) 'medicine_id': _items.first.medicineId,
        if (_items.isNotEmpty) 'quantity': int.tryParse(_items.first.qtyController.text.trim()) ?? 0,
        if (_items.isNotEmpty && _formatDateForApi(_items.first.expireDateController.text.trim()).isNotEmpty)
          'expire_date': _formatDateForApi(_items.first.expireDateController.text.trim()),
      };

      success = await ref.read(stocksProvider.notifier).createStock(data);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save stock. Please check error message above.')),
        );
      }
    }
  }

  MedicineModel? _findMedicine(List<MedicineModel> medicines, int? id) {
    if (id == null) return null;
    try {
      return medicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  String _formatStockDisplay(MedicineModel? med, [List<MedicineUnitModel>? unitsList]) {
    if (med == null) return '0';
    if (med.currentStockRaw != null && med.currentStockRaw!.trim().isNotEmpty) {
      final raw = med.currentStockRaw!.trim();
      if (raw != '0' && raw != 'null') {
        if (RegExp(r'[a-zA-Z]').hasMatch(raw)) {
          return raw;
        }
      }
    }
    final rawStock = med.currentStock ?? 0;
    String unitName = med.unit?.name ?? med.unit?.symbol ?? '';
    final list = unitsList ?? [];
    if (unitName.isEmpty && med.unitId != null && list.isNotEmpty) {
      try {
        final foundUnit = list.firstWhere((u) => u.id == med.unitId);
        unitName = foundUnit.name.isNotEmpty ? foundUnit.name : (foundUnit.symbol ?? '');
      } catch (_) {}
    }
    return unitName.isNotEmpty ? '$rawStock $unitName' : '$rawStock';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final headerBg = isDark ? const Color(0xFF262B30) : const Color(0xFFE2E8F0);
    final headerTextColor = isDark ? Colors.lightBlueAccent : Colors.blue.shade900;
    final textColor = isDark ? Colors.white : Colors.black;

    final medicinesState = ref.watch(medicinesProvider);
    final unitsState = ref.watch(medicineUnitsProvider);

    final medicineItems = medicinesState.list.map((m) {
      return DropdownMenuItem<int>(
        value: m.id,
        child: Text(m.brandName, style: TextStyle(fontSize: 14, color: textColor)),
      );
    }).toList();

    final tomorrow = DateTime.now().add(const Duration(days: 1));

    // EDIT MODE LAYOUT
    if (widget.isEdit) {
      final item = _items.first;
      MedicineModel? selectedMed = _findMedicine(medicinesState.list, item.medicineId);
      selectedMed ??= widget.item?.medicine;
      final totalCurrentStockDisplay = _formatStockDisplay(selectedMed, unitsState.list);

      if (_editCurrentStockController.text == '0' ||
          _editCurrentStockController.text.isEmpty ||
          (!_editCurrentStockController.text.contains(RegExp(r'[a-zA-Z]')) && totalCurrentStockDisplay.contains(RegExp(r'[a-zA-Z]')))) {
        _editCurrentStockController.text = totalCurrentStockDisplay;
      }

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: dialogBg,
        surfaceTintColor: dialogBg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: 500,
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
                      "Edit Medicine Stocks",
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

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Medicine & Total Current stocks
                    Row(
                      children: [
                        Expanded(
                          child: MedicineDropdownField<int>(
                            label: "Medicine",
                            hint: "Select medicine",
                            value: item.medicineId,
                            items: medicineItems,
                            isLoading: medicinesState.isLoading,
                            onChanged: (val) {
                              setState(() {
                                item.medicineId = val;
                                final med = _findMedicine(medicinesState.list, val);
                                _editCurrentStockController.text = _formatStockDisplay(med, unitsState.list);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: MedicineTextField(
                            label: "Total Current stocks",
                            hint: "0",
                            enabled: false,
                            readOnly: true,
                            controller: _editCurrentStockController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Row 2: Given Quantity & Quantity (New stock)
                    Row(
                      children: [
                        Expanded(
                          child: MedicineTextField(
                            label: "Given Quantity",
                            hint: "0",
                            controller: _givenQtyController,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: MedicineTextField(
                            label: "Quantity (New stock)",
                            hint: "0",
                            controller: item.qtyController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Row 3: Remove Quantity & Expiry Date
                    Row(
                      children: [
                        Expanded(
                          child: MedicineTextField(
                            label: "Remove Quantity",
                            hint: "0",
                            controller: _removeQtyController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: MedicineDateField(
                            label: "Expiry Date",
                            hint: "Select date",
                            controller: item.expireDateController,
                            firstDate: tomorrow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Save Button
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

    // ADD MODE LAYOUT
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 650,
        constraints: const BoxConstraints(maxHeight: 750),
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
                    "Add Medicine Stocks",
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

            // Form Body (Scrollable)
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Shared Fields: Lot Memo Number & Received Date
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
                    const SizedBox(height: 24),
                    Divider(height: 1, color: isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                    const SizedBox(height: 20),

                    // Stock Item Rows
                    ..._items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final selectedMed = _findMedicine(medicinesState.list, item.medicineId);
                      final currentStockVal = _formatStockDisplay(selectedMed, unitsState.list);

                      if (item.currentStockController.text == '0' ||
                          item.currentStockController.text.isEmpty ||
                          (!item.currentStockController.text.contains(RegExp(r'[a-zA-Z]')) && currentStockVal.contains(RegExp(r'[a-zA-Z]')))) {
                        item.currentStockController.text = currentStockVal;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Medicine & Current Stock
                            Row(
                              children: [
                                Expanded(
                                  child: MedicineDropdownField<int>(
                                    label: "Medicine",
                                    hint: "Select medicine",
                                    value: item.medicineId,
                                    items: medicineItems,
                                    isLoading: medicinesState.isLoading,
                                    onChanged: (val) {
                                      setState(() {
                                        item.medicineId = val;
                                        final med = _findMedicine(medicinesState.list, val);
                                        item.currentStockController.text = _formatStockDisplay(med, unitsState.list);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: MedicineTextField(
                                    label: "Current stocks",
                                    hint: "0",
                                    enabled: false,
                                    readOnly: true,
                                    controller: item.currentStockController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: MedicineTextField(
                                    label: "Quantity (New stock)",
                                    hint: "0",
                                    controller: item.qtyController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: MedicineDateField(
                                    label: "Expiry Date",
                                    hint: "Select date",
                                    controller: item.expireDateController,
                                    firstDate: tomorrow,
                                  ),
                                ),
                              ],
                            ),

                            // Remove Button (if multiple items)
                            if (_items.length > 1) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: () => _removeStockRow(index),
                                  icon: const Icon(CupertinoIcons.minus_circle, size: 16, color: Colors.blue),
                                  label: const Text(
                                    "Remove",
                                    style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),

                    // "+ Add Stock" Button
                    OutlinedButton.icon(
                      onPressed: _addStockRow,
                      icon: const Icon(CupertinoIcons.plus_circle, size: 16, color: Colors.black87),
                      label: const Text(
                        "Add Stock",
                        style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1), style: BorderStyle.solid),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
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
            ),
          ],
        ),
      ),
    );
  }
}
