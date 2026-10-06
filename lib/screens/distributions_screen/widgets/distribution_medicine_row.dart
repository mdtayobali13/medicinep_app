import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:medicine_system/models/medicine_model.dart';
import 'package:medicine_system/providers/stocks_provider.dart';

class DistributionMedicineRow extends ConsumerWidget {
  final bool showLabels;
  final List<MedicineModel> medicineList;
  final MedicineModel? selectedMedicine;
  final int quantity;
  final ValueChanged<MedicineModel?> onMedicineChanged;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback? onRemove;

  const DistributionMedicineRow({
    super.key,
    required this.showLabels,
    required this.medicineList,
    required this.selectedMedicine,
    required this.quantity,
    required this.onMedicineChanged,
    required this.onQuantityChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white38 : Colors.grey.shade400;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final fieldBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final disabledBg = isDark ? const Color(0xFF262B30) : Colors.grey.shade100;
    final dropdownBg = isDark ? const Color(0xFF262B30) : Colors.white;

    int currentStock = selectedMedicine?.currentStock ?? 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          // Mobile Layout
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
              color: isDark ? const Color(0xFF262B30) : Colors.grey.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildColumn(
                  "Medicine",
                  _buildDropdown(textColor, hintColor, fieldBg, borderColor, dropdownBg),
                  true,
                  textColor,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _buildColumn(
                        "Current Stocks",
                        _buildDisabledTextField(currentStock.toString(), textColor, disabledBg, borderColor),
                        true,
                        textColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildColumn(
                        "Mention Quantity",
                        _buildNumberField(quantity, textColor, hintColor, fieldBg, borderColor),
                        true,
                        textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(CupertinoIcons.trash, color: Colors.red),
                      onPressed: onRemove,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        // Desktop Layout
        return Row(
          crossAxisAlignment: showLabels ? CrossAxisAlignment.end : CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: _buildColumn(
                "Medicine",
                _buildDropdown(textColor, hintColor, fieldBg, borderColor, dropdownBg),
                showLabels,
                textColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildColumn(
                "Current Stocks",
                _buildDisabledTextField(currentStock.toString(), textColor, disabledBg, borderColor),
                showLabels,
                textColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: _buildColumn(
                "Mention Quantity",
                _buildNumberField(quantity, textColor, hintColor, fieldBg, borderColor),
                showLabels,
                textColor,
              ),
            ),
            const SizedBox(width: 16),
            Padding(
              padding: EdgeInsets.only(bottom: showLabels ? 8 : 0),
              child: IconButton(
                icon: const Icon(CupertinoIcons.minus_circled, color: Colors.redAccent),
                onPressed: onRemove,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColumn(String label, Widget child, bool showLabel, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(label, style: TextStyle(fontSize: 13, color: labelColor)),
          const SizedBox(height: 6),
        ],
        child,
      ],
    );
  }

  Widget _buildDropdown(Color textColor, Color hintColor, Color fieldBg, Color borderColor, Color dropdownBg) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: fieldBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<MedicineModel>(
          isExpanded: true,
          value: selectedMedicine,
          hint: Text("Select medicine", style: TextStyle(color: hintColor, fontSize: 13)),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down, color: hintColor),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: dropdownBg,
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
          items: medicineList.map((e) {
            final nameStr = e.brandName.isNotEmpty ? e.brandName : (e.genericName ?? "Medicine #${e.id}");
            return DropdownMenuItem<MedicineModel>(
              value: e,
              child: Text(
                nameStr,
                style: TextStyle(fontSize: 13, color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onMedicineChanged,
        ),
      ),
    );
  }

  Widget _buildDisabledTextField(String text, Color textColor, Color disabledBg, Color borderColor) {
    return Container(
      height: 42,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: disabledBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        selectedMedicine != null ? text : "",
        style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNumberField(int currentQuantity, Color textColor, Color hintColor, Color fieldBg, Color borderColor) {
    return SizedBox(
      height: 42,
      child: TextFormField(
        initialValue: currentQuantity > 0 ? currentQuantity.toString() : '',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(color: textColor, fontSize: 13),
        onChanged: (val) {
          final parsed = int.tryParse(val) ?? 0;
          onQuantityChanged(parsed);
        },
        decoration: InputDecoration(
          hintText: "0",
          hintStyle: TextStyle(color: hintColor, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
