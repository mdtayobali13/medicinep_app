import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MedicineDropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final String? initialValue;

  const MedicineDropdownField({
    super.key,
    required this.label,
    required this.hint,
    this.initialValue,
  });

  @override
  State<MedicineDropdownField> createState() => _MedicineDropdownFieldState();
}

class _MedicineDropdownFieldState extends State<MedicineDropdownField> {
  late final ValueNotifier<String?> _valueNotifier;

  @override
  void initState() {
    super.initState();
    _valueNotifier = ValueNotifier<String?>(widget.initialValue);
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : Colors.grey.shade800;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white38 : Colors.grey.shade400;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final fieldBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final dropdownBg = isDark ? const Color(0xFF262B30) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: 42,
          child: ValueListenableBuilder<String?>(
            valueListenable: _valueNotifier,
            builder: (context, currentValue, _) {
              return DropdownButtonFormField2<String>(
                isExpanded: true,
                value: currentValue,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
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
                  fillColor: fieldBg,
                  filled: true,
                ),
                hint: Text(
                  widget.hint.isNotEmpty ? widget.hint : "Select ${widget.label}",
                  style: TextStyle(color: hintColor, fontSize: 13),
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
                items: ['Option 1', 'Option 2', 'Option 3', if (widget.initialValue != null && !['Option 1', 'Option 2', 'Option 3'].contains(widget.initialValue)) widget.initialValue!].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  _valueNotifier.value = value;
                },
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: dropdownBg,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
