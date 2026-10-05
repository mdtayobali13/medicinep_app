import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/medicine_model.dart';
import 'package:medicine_system/providers/medicine_categories_provider.dart';
import 'package:medicine_system/providers/medicine_units_provider.dart';
import 'package:medicine_system/providers/medicines_provider.dart';
import 'form_fields/medicine_image_upload.dart';
import 'form_fields/medicine_text_field.dart';
import 'form_fields/medicine_dropdown_field.dart';

class MedicineFormDialog extends ConsumerStatefulWidget {
  final bool isEdit;
  final MedicineModel? item;

  const MedicineFormDialog({
    super.key,
    this.isEdit = false,
    this.item,
  });

  @override
  ConsumerState<MedicineFormDialog> createState() => _MedicineFormDialogState();
}

class _MedicineFormDialogState extends ConsumerState<MedicineFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _genericNameController;
  late final TextEditingController _alertQtyController;
  late final TextEditingController _expirationDaysController;
  late final TextEditingController _originController;

  int? _selectedCategoryId;
  int? _selectedUnitId;
  String _selectedStatus = 'Active';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.brandName ?? '');
    _genericNameController = TextEditingController(text: widget.item?.genericName ?? '');
    _alertQtyController = TextEditingController(text: widget.item?.alertQuantity?.toString() ?? '10');
    _expirationDaysController = TextEditingController(text: '30');
    _originController = TextEditingController(text: 'Local');

    _selectedCategoryId = widget.item?.categoryId ?? widget.item?.category?.id;
    _selectedUnitId = widget.item?.unitId ?? widget.item?.unit?.id;
    final rawStatus = widget.item?.status?.toString();
    if (rawStatus != null && (rawStatus == '1' || rawStatus == 'active' || rawStatus == 'Active')) {
      _selectedStatus = 'Active';
    } else if (rawStatus != null) {
      _selectedStatus = 'Inactive';
    } else {
      _selectedStatus = 'Active';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genericNameController.dispose();
    _alertQtyController.dispose();
    _expirationDaysController.dispose();
    _originController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter medicine name')),
      );
      return;
    }

    final categoriesList = ref.read(medicineCategoriesProvider).list;
    final unitsList = ref.read(medicineUnitsProvider).list;

    final catId = _selectedCategoryId ?? (categoriesList.isNotEmpty ? categoriesList.first.id : 1);
    final unitId = _selectedUnitId ?? (unitsList.isNotEmpty ? unitsList.first.id : 1);

    final expDays = int.tryParse(_expirationDaysController.text.trim()) ?? 30;

    setState(() => _isSaving = true);

    final Map<String, dynamic> data = {
      'name': name,
      'brand_name': name,
      if (_genericNameController.text.trim().isNotEmpty)
        'generic_name': _genericNameController.text.trim(),
      'category_id': catId,
      'medicine_category_id': catId,
      'unit_id': unitId,
      'medicine_unit_id': unitId,
      'alert_quantity': int.tryParse(_alertQtyController.text.trim()) ?? 10,
      'expiration_reminder_day': expDays,
      'expiration_reminder_days': expDays,
      'origin': _originController.text.trim().isNotEmpty ? _originController.text.trim() : 'Local',
      'status': _selectedStatus.toLowerCase(),
    };

    bool success = false;
    if (widget.isEdit && widget.item != null) {
      success = await ref.read(medicinesProvider.notifier).updateMedicine(widget.item!.id, data);
    } else {
      success = await ref.read(medicinesProvider.notifier).createMedicine(data);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save medicine. Please check error message above.')),
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

    final categoriesState = ref.watch(medicineCategoriesProvider);
    final unitsState = ref.watch(medicineUnitsProvider);

    final categoryItems = categoriesState.list.map((cat) {
      return DropdownMenuItem<int>(
        value: cat.id,
        child: Text(cat.name, style: TextStyle(fontSize: 14, color: textColor)),
      );
    }).toList();

    final unitItems = unitsState.list.map((u) {
      return DropdownMenuItem<int>(
        value: u.id,
        child: Text(u.name, style: TextStyle(fontSize: 14, color: textColor)),
      );
    }).toList();

    final statusItems = ['Active', 'Inactive'].map((s) {
      return DropdownMenuItem<String>(
        value: s,
        child: Text(s, style: TextStyle(fontSize: 14, color: textColor)),
      );
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 800,
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
                    widget.isEdit ? "Edit Medicine" : "Add Medicine",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MedicineImageUpload(),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            MedicineTextField(
                              label: "Name",
                              hint: "Enter medicine name",
                              controller: _nameController,
                            ),
                            const SizedBox(height: 16),
                            MedicineDropdownField<int>(
                              label: "Category",
                              hint: "Select a category",
                              value: _selectedCategoryId,
                              items: categoryItems,
                              isLoading: categoriesState.isLoading,
                              onChanged: (val) => setState(() => _selectedCategoryId = val),
                            ),
                          ],
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
                          label: "Medicine Unit",
                          hint: "Select a medicine unit",
                          value: _selectedUnitId,
                          items: unitItems,
                          isLoading: unitsState.isLoading,
                          onChanged: (val) => setState(() => _selectedUnitId = val),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: MedicineTextField(
                          label: "Alert Quantity",
                          hint: "Enter alert quantity",
                          controller: _alertQtyController,
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
                        child: MedicineTextField(
                          label: "Expiration Reminder Days",
                          hint: "Enter days",
                          controller: _expirationDaysController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: MedicineTextField(
                          label: "Origin",
                          hint: "Enter origin",
                          controller: _originController,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: MedicineDropdownField<String>(
                          label: "Status",
                          hint: "Select status",
                          value: _selectedStatus,
                          items: statusItems,
                          onChanged: (val) => setState(() => _selectedStatus = val ?? 'Active'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

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
}
