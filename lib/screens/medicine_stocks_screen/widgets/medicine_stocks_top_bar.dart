import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MedicineStocksTopBar extends StatefulWidget {
  const MedicineStocksTopBar({super.key});

  @override
  State<MedicineStocksTopBar> createState() => _MedicineStocksTopBarState();
}

class _MedicineStocksTopBarState extends State<MedicineStocksTopBar> {
  late final ValueNotifier<String?> _itemsPerPageNotifier;
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["Active", "Expired", "Damaged"];

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs: Active, Expired, Damaged
        Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            final tabBg = isSelected
                ? (isDark ? const Color(0xFF1E2226) : Colors.white)
                : (isDark ? const Color(0xFF262B30) : Colors.grey.shade100);
            final tabBorder = isSelected
                ? (isDark ? Colors.white24 : Colors.grey.shade300)
                : Colors.transparent;
            final tabTextColor = isSelected
                ? textColor
                : (isDark ? Colors.white54 : Colors.grey.shade600);

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: tabBg,
                      border: Border.all(color: tabBorder),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black26
                                    : Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      _tabs[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: tabTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        // Action Controls Row
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildItemsPerPage(isDark, cardBg, borderColor, textColor),
                _buildIconButton(
                  CupertinoIcons.printer,
                  isDark,
                  cardBg,
                  borderColor,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Printing medicine stocks..."),
                      ),
                    );
                  },
                ),
                _buildExportButton(isDark, cardBg, borderColor, textColor),
              ],
            ),
            _buildSearchBox(isDark, cardBg, borderColor, textColor),
          ],
        ),
      ],
    );
  }

  Widget _buildItemsPerPage(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textColor,
  ) {
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
                  child: Icon(
                    CupertinoIcons.chevron_down,
                    size: 14,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
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
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _itemsPerPageNotifier.value = newValue;
                }
              },
              items: <String>['10', '20', '50', '100']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: textColor)),
                    );
                  })
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    bool isDark,
    Color cardBg,
    Color borderColor,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
        color: cardBg,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white70 : Colors.grey.shade700,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildExportButton(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textColor,
  ) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
        color: cardBg,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Downloading Excel file...")),
            );
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                "Export to Excel",
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textColor,
  ) {
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
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey.shade400,
            fontSize: 13,
          ),
          icon: Icon(
            CupertinoIcons.search,
            color: isDark ? Colors.white38 : Colors.grey.shade400,
            size: 16,
          ),
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
