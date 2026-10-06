import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MedicineDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool isLoading;

  const MedicineDropdownField({
    super.key,
    required this.label,
    required this.hint,
    this.value,
    this.items = const [],
    this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : Colors.grey.shade800;
    final hintColor = isDark ? Colors.white38 : Colors.grey.shade400;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final fieldBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final dropdownBg = isDark ? const Color(0xFF262B30) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    final List<DropdownMenuItem<T>> uniqueItems = [];
    final Set<T> seenValues = {};
    for (final item in items) {
      if (item.value != null && !seenValues.contains(item.value)) {
        seenValues.add(item.value as T);
        uniqueItems.add(item);
      }
    }

    final bool hasValidValue = value != null && seenValues.contains(value);
    final T? selectedValue = hasValidValue ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: 46,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: dropdownBg,
              textTheme: Theme.of(context).textTheme.copyWith(
                    titleMedium: TextStyle(color: textColor, fontSize: 13.5),
                    bodyMedium: TextStyle(color: textColor, fontSize: 13.5),
                    bodyLarge: TextStyle(color: textColor, fontSize: 13.5),
                  ),
            ),
            child: DropdownButtonFormField2<T>(
              isExpanded: true,
              value: selectedValue,
              style: TextStyle(color: textColor, fontSize: 13.5),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
                fillColor: fieldBg,
                filled: true,
              ),
              hint: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      hint.isNotEmpty ? hint : "Select $label",
                      style: TextStyle(color: hintColor, fontSize: 13.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  CupertinoIcons.chevron_down,
                  color: hintColor,
                  size: 16,
                ),
              ),
              items: uniqueItems,
              onChanged: onChanged,
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: dropdownBg,
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
