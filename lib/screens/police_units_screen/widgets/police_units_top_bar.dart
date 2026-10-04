import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class PoliceUnitsTopBar extends StatelessWidget {
  const PoliceUnitsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cardBg,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<int>(
              hint: Text("10", style: TextStyle(color: textColor)),
              items: [10, 20, 50, 100].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(color: textColor),
                  ),
                );
              }).toList(),
              onChanged: (_) {},
              iconStyleData: IconStyleData(
                icon: Icon(CupertinoIcons.chevron_down, size: 16, color: isDark ? Colors.white70 : Colors.grey.shade600),
              ),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.zero,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isDark ? const Color(0xFF262B30) : Colors.white,
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: cardBg,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400),
              prefixIcon: Icon(CupertinoIcons.search, size: 20, color: isDark ? Colors.white38 : Colors.grey.shade400),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}

