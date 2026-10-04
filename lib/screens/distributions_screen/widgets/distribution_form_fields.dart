import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DistributionFormFields extends StatefulWidget {
  const DistributionFormFields({super.key});

  @override
  State<DistributionFormFields> createState() => _DistributionFormFieldsState();
}

class _DistributionFormFieldsState extends State<DistributionFormFields> {
  String? _selectedBp;
  String? _selectedReceiver;

  final List<String> _bpList = ['111111 - Apurbo Ray', '222222 - Demo Patient', '333333 - John Doe'];
  final List<String> _receiverList = ['Self', 'Parents', 'Spouse', 'Children'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDropdown("BP/CIV Number or Name", "Select", _selectedBp, _bpList, (val) {
          setState(() {
            _selectedBp = val;
          });
        }),
        const SizedBox(height: 16),
        _buildDropdown("Receiver Type", "Select", _selectedReceiver, _receiverList, (val) {
          setState(() {
            _selectedReceiver = val;
          });
        }),
        const SizedBox(height: 16),
        _buildTextField("Prescription Code", "Enter prescription code", maxLines: 1),
        const SizedBox(height: 16),
        _buildTextField("Notes", "Enter any notes", maxLines: 3),
      ],
    );
  }

  Widget _buildDropdown(String label, String hint, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 6),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              value: value,
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
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13, color: Colors.black87)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      ],
    );
  }
}
