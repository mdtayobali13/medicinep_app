import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class UsersTopBar extends StatefulWidget {
  const UsersTopBar({super.key});

  @override
  State<UsersTopBar> createState() => _UsersTopBarState();
}

class _UsersTopBarState extends State<UsersTopBar> {
  late final ValueNotifier<String?> _itemsPerPageNotifier;

  @override
  void initState() {
    super.initState();
    _itemsPerPageNotifier = ValueNotifier<String?>('10');
  }

  @override
  void dispose() {
    _itemsPerPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildItemsPerPage(isDark, cardBg, borderColor, textColor),
        _buildSearchBox(isDark, cardBg, borderColor, textColor),
      ],
    );
  }

  Widget _buildItemsPerPage(bool isDark, Color cardBg, Color borderColor, Color textColor) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
        color: cardBg,
      ),
      child: ValueListenableBuilder<String?>(
        valueListenable: _itemsPerPageNotifier,
        builder: (context, currentValue, _) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isDense: true,
              value: currentValue,
              iconStyleData: IconStyleData(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(CupertinoIcons.chevron_down, size: 14, color: isDark ? Colors.white70 : Colors.grey.shade600),
                ),
              ),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.zero,
                height: 38,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262B30) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _itemsPerPageNotifier.value = newValue;
                }
              },
              items: <String>['10', '20', '50', '100']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: textColor),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBox(bool isDark, Color cardBg, Color borderColor, Color textColor) {
    return Container(
      width: 250,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        style: TextStyle(color: textColor, fontSize: 13),
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400, fontSize: 13),
          icon: Icon(CupertinoIcons.search, color: isDark ? Colors.white38 : Colors.grey.shade400, size: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          isDense: true,
        ),
      ),
    );
  }
}
