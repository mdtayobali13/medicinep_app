import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/notifications_provider.dart';
import 'package:medicine_system/utils/app_theme.dart';

class NotificationsTopBar extends ConsumerStatefulWidget {
  const NotificationsTopBar({super.key});

  @override
  ConsumerState<NotificationsTopBar> createState() => _NotificationsTopBarState();
}

class _NotificationsTopBarState extends ConsumerState<NotificationsTopBar> {
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
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildItemsPerPage(isDark),
        _buildSearchBox(isDark),
      ],
    );
  }

  Widget _buildItemsPerPage(bool isDark) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
        color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
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
                  child: Icon(CupertinoIcons.chevron_down, size: 14, color: Colors.grey.shade600),
                ),
              ),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.zero,
                height: 38,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _itemsPerPageNotifier.value = newValue;
                  ref.read(notificationsProvider.notifier).updateItemsPerPage(int.parse(newValue));
                }
              },
              items: <String>['10', '20', '50', '100']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBox(bool isDark) {
    return Container(
      width: 250,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13),
        onChanged: (value) {
          ref.read(notificationsProvider.notifier).updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          icon: Icon(CupertinoIcons.search, color: Colors.grey.shade400, size: 16),
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
