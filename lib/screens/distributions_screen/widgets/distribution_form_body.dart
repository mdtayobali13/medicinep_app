import 'package:flutter/material.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_form_patient_section.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_form_medicine_section.dart';

class DistributionFormBody extends StatelessWidget {
  const DistributionFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DistributionFormPatientSection(),
        const SizedBox(height: 24),
        const DistributionFormMedicineSection(),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(Icons.save, size: 18),
            label: const Text("Save"),
          ),
        ),
      ],
    );
  }
}
