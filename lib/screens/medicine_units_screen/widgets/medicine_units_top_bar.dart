import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:medicine_system/providers/medicine_units_provider.dart';

class MedicineUnitsTopBar extends ConsumerWidget {
  const MedicineUnitsTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black;

    final state = ref.watch(medicineUnitsProvider);

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Container(
          width: 85,
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: cardBg,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<int>(
              isExpanded: true,
              value: state.perPage,
              hint: Text("10", style: TextStyle(color: textColor, fontSize: 13)),
              items: [10, 20, 50, 100].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(color: textColor, fontSize: 13),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  ref.read(medicineUnitsProvider.notifier).fetchUnits(page: 1, perPage: val);
                }
              },
              iconStyleData: IconStyleData(
                icon: Icon(CupertinoIcons.chevron_down, size: 14, color: isDark ? Colors.white70 : Colors.grey.shade600),
              ),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.zero,
                height: 38,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isDark ? const Color(0xFF262B30) : Colors.white,
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
        Container(
          width: 240,
          height: 38,
          decoration: BoxDecoration(
            color: cardBg,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            onChanged: (val) {
              ref.read(medicineUnitsProvider.notifier).fetchUnits(search: val);
            },
            style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13),
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400, fontSize: 13),
              prefixIcon: Icon(CupertinoIcons.search, size: 16, color: isDark ? Colors.white38 : Colors.grey.shade400),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
