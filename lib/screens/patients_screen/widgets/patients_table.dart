import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patients_top_bar.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_list_card.dart';

class PatientsTable extends StatelessWidget {
  const PatientsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PatientsTopBar(),
        const SizedBox(height: 20),

        // List Cards
        const PatientListCard(
          sl: "1",
          name: "Apurbo Ray",
          designation: "Constable",
          bpNumber: "111111",
          policeUnit: "District Police",
          status: "Regular",
          phone: "01705963592",
        ),
        const PatientListCard(
          sl: "2",
          name: "Maris Galloway",
          designation: "Inspector",
          bpNumber: "222222",
          policeUnit: "Metropolitan",
          status: "Contractual",
          phone: "01700000000",
        ),
      ],
    );
  }
}
