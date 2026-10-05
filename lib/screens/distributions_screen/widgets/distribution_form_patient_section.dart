import 'package:flutter/material.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_form_fields.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_image_box.dart';

class DistributionFormPatientSection extends StatelessWidget {
  final PatientModel? selectedPatient;
  final ValueChanged<PatientModel?> onPatientChanged;
  final String? selectedReceiver;
  final ValueChanged<String?> onReceiverChanged;
  final TextEditingController prescriptionController;
  final TextEditingController notesController;

  const DistributionFormPatientSection({
    super.key,
    required this.selectedPatient,
    required this.onPatientChanged,
    required this.selectedReceiver,
    required this.onReceiverChanged,
    required this.prescriptionController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DistributionFormFields(
                selectedPatient: selectedPatient,
                onPatientChanged: onPatientChanged,
                selectedReceiver: selectedReceiver,
                onReceiverChanged: onReceiverChanged,
                prescriptionController: prescriptionController,
                notesController: notesController,
              ),
              const SizedBox(height: 24),
              DistributionImageBox(patient: selectedPatient),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: DistributionFormFields(
                selectedPatient: selectedPatient,
                onPatientChanged: onPatientChanged,
                selectedReceiver: selectedReceiver,
                onReceiverChanged: onReceiverChanged,
                prescriptionController: prescriptionController,
                notesController: notesController,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: DistributionImageBox(patient: selectedPatient),
            ),
          ],
        );
      },
    );
  }
}
