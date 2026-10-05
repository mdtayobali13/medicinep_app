import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/patients_provider.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patients_top_bar.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_list_card.dart';

class PatientsTable extends ConsumerWidget {
  const PatientsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(patientsProvider);

    return Column(
      children: [
        const PatientsTopBar(),
        const SizedBox(height: 16),
        if (state.isLoading && state.list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state.list.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                state.error ?? "No patients found",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ),
          )
        else
          ...state.list.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final item = entry.value;
            return PatientListCard(
              sl: index.toString(),
              name: item.name,
              designation: item.designation?.name ?? 'N/A',
              bpNumber: item.bpNo ?? 'N/A',
              policeUnit: item.policeUnit?.name ?? 'N/A',
              status: item.patientType ?? 'Regular',
              phone: item.mobile ?? 'N/A',
              onDelete: () {
                ref.read(patientsProvider.notifier).deletePatient(item.id);
              },
            );
          }),
      ],
    );
  }
}
