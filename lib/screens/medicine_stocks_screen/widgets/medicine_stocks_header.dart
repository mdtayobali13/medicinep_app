import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/medicine_stocks_screen/widgets/medicine_stock_form_dialog.dart';

class MedicineStocksHeader extends StatefulWidget {
  const MedicineStocksHeader({super.key});

  @override
  State<MedicineStocksHeader> createState() => _MedicineStocksHeaderState();
}

class _MedicineStocksHeaderState extends State<MedicineStocksHeader> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2ECA7F),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2ECA7F),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildDateRangePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _selectDate(context, true),
            child: Text(
              _startDate != null ? "${_startDate!.day}-${_startDate!.month}-${_startDate!.year}" : "Start date",
              style: TextStyle(color: _startDate != null ? Colors.black87 : Colors.grey.shade400, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Icon(CupertinoIcons.arrow_right, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _selectDate(context, false),
            child: Text(
              _endDate != null ? "${_endDate!.day}-${_endDate!.month}-${_endDate!.year}" : "End date",
              style: TextStyle(color: _endDate != null ? Colors.black87 : Colors.grey.shade400, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Icon(CupertinoIcons.calendar, size: 14, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECA7F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          const Text(
            "Medicine Stocks",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildDateRangePicker(),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const MedicineStockFormDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(CupertinoIcons.add, size: 18),
                label: const Text("Create"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
