import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:intl/intl.dart';

class MedicineDateField extends StatefulWidget {
  final String label;
  final String hint;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  final DateTime? firstDate;

  const MedicineDateField({
    super.key,
    required this.label,
    required this.hint,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.firstDate,
  });

  @override
  State<MedicineDateField> createState() => _MedicineDateFieldState();
}

class _MedicineDateFieldState extends State<MedicineDateField> {
  late final TextEditingController _internalController;

  TextEditingController get _effectiveController => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.initialValue);
    }
  }

  Future<void> _pickDate() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final effectiveFirst = widget.firstDate ?? DateTime(1900);
    DateTime initDate = now;
    if (initDate.isBefore(effectiveFirst)) {
      initDate = effectiveFirst;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: effectiveFirst,
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF2ECC71),
                    onPrimary: Colors.white,
                    onSurface: Colors.white,
                    surface: Color(0xFF1E2226),
                  )
                : const ColorScheme.light(
                    primary: Color(0xFF2ECC71),
                    onPrimary: Colors.white,
                    onSurface: Color(0xFF1E293B),
                    surface: Colors.white,
                  ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: isDark ? const Color(0xFF1E2226) : Colors.white,
              surfaceTintColor: Colors.transparent,
              headerBackgroundColor: const Color(0xFF2ECC71),
              headerForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              dayStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              weekdayStyle: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.lightBlueAccent : Colors.blue.shade900),
              yearStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2ECC71),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        _effectiveController.text = formatted;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(formatted);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MedicineTextField(
      controller: _effectiveController,
      label: widget.label,
      hint: widget.hint.isNotEmpty ? widget.hint : "Select ${widget.label}",
      readOnly: true,
      onTap: _pickDate,
      suffixIcon: Icon(CupertinoIcons.calendar, color: isDark ? Colors.white38 : Colors.grey.shade400, size: 18),
    );
  }
}
