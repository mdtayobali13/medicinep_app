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
  final TextEditingController spouseNameController;
  final TextEditingController parentNameController;
  final List<TextEditingController> childrenControllers;
  final VoidCallback onAddChild;
  final ValueChanged<int> onRemoveChild;

  const DistributionFormPatientSection({
    super.key,
    required this.selectedPatient,
    required this.onPatientChanged,
    required this.selectedReceiver,
    required this.onReceiverChanged,
    required this.prescriptionController,
    required this.notesController,
    required this.spouseNameController,
    required this.parentNameController,
    required this.childrenControllers,
    required this.onAddChild,
    required this.onRemoveChild,
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
                spouseNameController: spouseNameController,
                parentNameController: parentNameController,
                childrenControllers: childrenControllers,
                onAddChild: onAddChild,
                onRemoveChild: onRemoveChild,
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
                spouseNameController: spouseNameController,
                parentNameController: parentNameController,
                childrenControllers: childrenControllers,
                onAddChild: onAddChild,
                onRemoveChild: onRemoveChild,
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
