import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_medicine_row.dart';

class DistributionFormMedicineSection extends StatefulWidget {
  const DistributionFormMedicineSection({super.key});

  @override
  State<DistributionFormMedicineSection> createState() => _DistributionFormMedicineSectionState();
}

class _DistributionFormMedicineSectionState extends State<DistributionFormMedicineSection> {
  int _rowCount = 1;

  void _addRow() {
    setState(() {
      _rowCount++;
    });
  }

  void _removeRow() {
    if (_rowCount > 1) {
      setState(() {
        _rowCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < _rowCount; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DistributionMedicineRow(
              showLabels: i == 0,
              onRemove: _rowCount > 1 ? _removeRow : null,
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: _addRow,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.add_circled, size: 16, color: Colors.black87),
                  SizedBox(width: 8),
                  Text("Add More", style: TextStyle(color: Colors.black87, fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
