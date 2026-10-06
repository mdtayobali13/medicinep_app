import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/services/repository/patients_repository.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_details_layout.dart';

class PatientViewDialog extends StatefulWidget {
  final PatientModel item;

  const PatientViewDialog({super.key, required this.item});

  @override
  State<PatientViewDialog> createState() => _PatientViewDialogState();
}

class _PatientViewDialogState extends State<PatientViewDialog> {
  late Future<PatientModel> _patientFuture;

  @override
  void initState() {
    super.initState();
    _patientFuture = _loadPatientDetails();
  }

  Future<PatientModel> _loadPatientDetails() async {
    final detailed = await PatientsRepository.instance.getPatientDetails(
      widget.item.id,
    );
    return detailed ?? widget.item;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "View Patient",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      CupertinoIcons.clear,
                      size: 20,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FutureBuilder<PatientModel>(
                future: _patientFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final patient = snapshot.data ?? widget.item;
                  final avatarName = Uri.encodeComponent(
                    patient.name.isNotEmpty ? patient.name : 'Patient',
                  );

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Profile Image
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? const Color(0xFF262B30)
                                  : Colors.blue.shade50,
                              image: DecorationImage(
                                image: NetworkImage(
                                  "https://ui-avatars.com/api/?name=$avatarName&background=0D8ABC&color=fff&size=200",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Information Layout
                        PatientDetailsLayout(
                          isDesktop: isDesktop,
                          item: patient,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
