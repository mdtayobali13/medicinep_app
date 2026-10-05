import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/medicine_model.dart';
import 'package:medicine_system/providers/medicines_provider.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_medicine_row.dart';

class DistributionMedicineItemState {
  MedicineModel? medicine;
  int quantity;

  DistributionMedicineItemState({this.medicine, this.quantity = 0});
}

class DistributionFormMedicineSection extends ConsumerWidget {
  final List<DistributionMedicineItemState> items;
  final VoidCallback onAddItem;
  final ValueChanged<int> onRemoveItem;
  final void Function(int index, MedicineModel? medicine) onMedicineChanged;
  final void Function(int index, int quantity) onQuantityChanged;

  const DistributionFormMedicineSection({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onMedicineChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicinesState = ref.watch(medicinesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DistributionMedicineRow(
              showLabels: i == 0,
              medicineList: medicinesState.list,
              selectedMedicine: items[i].medicine,
              quantity: items[i].quantity,
              onMedicineChanged: (med) => onMedicineChanged(i, med),
              onQuantityChanged: (qty) => onQuantityChanged(i, qty),
              onRemove: items.length > 1 ? () => onRemoveItem(i) : null,
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: onAddItem,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.add_circled, size: 16, color: textColor),
                  const SizedBox(width: 8),
                  Text("Add More", style: TextStyle(color: textColor, fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
