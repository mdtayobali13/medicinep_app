import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DistributionMedicineRow extends StatefulWidget {
  final bool showLabels;
  final VoidCallback? onRemove;

  const DistributionMedicineRow({
    super.key,
    required this.showLabels,
    this.onRemove,
  });

  @override
  State<DistributionMedicineRow> createState() => _DistributionMedicineRowState();
}

class _DistributionMedicineRowState extends State<DistributionMedicineRow> {
  String? _selectedMedicine;

  final Map<String, String> _medicines = {
    'Paracetamol 500mg': '150',
    'Amoxicillin 250mg': '45',
    'Vitamin C 1000mg': '200',
    'Ibuprofen 400mg': '80',
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          // Mobile Layout
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildColumn("Medicine", _buildDropdown("Select medicine"), true),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _buildColumn("Current Stocks", _buildDisabledTextField(), true),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildColumn("Mention Quantity", _buildNumberField("0"), true),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(CupertinoIcons.trash, color: Colors.red),
                      onPressed: widget.onRemove,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        // Desktop Layout
        return Row(
          crossAxisAlignment: widget.showLabels ? CrossAxisAlignment.end : CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: _buildColumn("Medicine", _buildDropdown("Select medicine"), widget.showLabels),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildColumn("Current Stocks", _buildDisabledTextField(), widget.showLabels),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: _buildColumn("Mention Quantity", _buildNumberField("0"), widget.showLabels),
            ),
            const SizedBox(width: 16),
            Padding(
              padding: EdgeInsets.only(bottom: widget.showLabels ? 8 : 0),
              child: IconButton(
                icon: const Icon(CupertinoIcons.minus_circled, color: Colors.black87),
                onPressed: widget.onRemove,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColumn(String label, Widget child, bool showLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 6),
        ],
        child,
      ],
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          value: _selectedMedicine,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
          items: _medicines.keys.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13, color: Colors.black87)))).toList(),
          onChanged: (val) {
            setState(() {
              _selectedMedicine = val;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDisabledTextField() {
    return Container(
      height: 42,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        _selectedMedicine != null ? _medicines[_selectedMedicine]! : "",
        style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildNumberField(String hint) {
    return SizedBox(
      height: 42,
      child: TextField(
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.black87, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
