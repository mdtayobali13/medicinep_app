import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class NotificationsTopBar extends StatefulWidget {
  const NotificationsTopBar({super.key});

  @override
  State<NotificationsTopBar> createState() => _NotificationsTopBarState();
}

class _NotificationsTopBarState extends State<NotificationsTopBar> {
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
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildItemsPerPage(),
        _buildSearchBox(),
      ],
    );
  }

  Widget _buildItemsPerPage() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _itemsPerPageNotifier.value = newValue;
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

  Widget _buildSearchBox() {
    return Container(
      width: 250,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          icon: Icon(CupertinoIcons.search, color: Colors.grey.shade400, size: 18),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 12),
        ),
      ),
    );
  }
}
