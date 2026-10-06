import 'package:flutter/material.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_info_section.dart';

class PatientDetailsLayout extends StatelessWidget {
  final bool isDesktop;
  final PatientModel item;

  const PatientDetailsLayout({
    super.key,
    required this.isDesktop,
    required this.item,
  });

  Map<String, String> get _personalInfo => {
        "Name": item.name.isNotEmpty ? item.name : 'N/A',
        "Father": item.father ?? 'N/A',
        "Mother": item.mother ?? 'N/A',
        "Date of Birth": item.dob ?? 'N/A',
        "Gender": item.gender ?? 'N/A',
        "NID Number": item.nid ?? 'N/A',
        "Blood Group": item.bloodGroup ?? 'N/A',
        "Marital Status": item.maritalStatus ?? 'N/A',
      };

  Map<String, String> get _employmentDetails => {
        "Designation": item.designation?.name ?? 'N/A',
        "Police unit": item.policeUnit?.name ?? 'N/A',
        "Employment Status": item.employmentStatus ?? item.patientType ?? 'N/A',
        "BP Number": item.bpNo ?? 'N/A',
        "Work Place": item.workPlace ?? 'N/A',
        "Joining Date": item.joiningDate ?? 'N/A',
      };

  String _cleanValue(String? val) {
    if (val == null) return 'N/A';
    final trimmed = val.trim();
    if (trimmed.isEmpty || trimmed == 'null' || trimmed == 'N/A') return 'N/A';
    return trimmed;
  }

  Map<String, String> get _physicalAttrs {
    final rawH = item.height ?? item.rawJson?['height']?.toString();
    final rawW = item.weight ?? item.rawJson?['weight']?.toString();
    final rawE = item.eyesight ?? item.rawJson?['eyesight']?.toString();

    final hVal = (rawH != null && rawH.trim().isNotEmpty && rawH.trim() != 'null' && rawH.trim() != 'N/A') ? rawH.trim() : '';
    final wVal = (rawW != null && rawW.trim().isNotEmpty && rawW.trim() != 'null' && rawW.trim() != 'N/A') ? rawW.trim() : '';
    final eVal = (rawE != null && rawE.trim().isNotEmpty && rawE.trim() != 'null' && rawE.trim() != 'N/A') ? rawE.trim() : '';

    return {
      "Height": hVal.isNotEmpty ? (hVal.endsWith('ft') ? hVal : "$hVal ft") : 'ft',
      "Weight": wVal.isNotEmpty ? (wVal.endsWith('kg') ? wVal : "$wVal kg") : 'kg',
      "Eyesight": eVal,
    };
  }

  Map<String, String> get _contactInfo {
    final mob = _cleanValue(item.mobile ?? item.rawJson?['mobile']?.toString() ?? item.rawJson?['phone_number']?.toString() ?? item.rawJson?['phone']?.toString());
    return {
      "Phone Number": mob,
    };
  }

  String _cleanName(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 'N/A';
    final str = raw.trim();
    if (str.startsWith('{') && str.endsWith('}')) {
      final match = RegExp(r'name:\s*([^,}]+)').firstMatch(str);
      if (match != null) {
        final res = match.group(1)?.trim();
        if (res != null && res.isNotEmpty) return res;
      }
    }
    return str;
  }

  Map<String, String> get _presentAddress => {
        "Division": _cleanName(item.presentDivision),
        "District": _cleanName(item.presentDistrict),
        "Upazila": _cleanName(item.presentUpazila),
        "Union": _cleanName(item.presentUnion),
        "Village": _cleanName(item.presentVillage ?? item.address),
      };

  Map<String, String> get _permanentAddress => {
        "Division": _cleanName(item.permanentDivision),
        "District": _cleanName(item.permanentDistrict),
        "Upazila": _cleanName(item.permanentUpazila),
        "Union": _cleanName(item.permanentUnion),
        "Village": _cleanName(item.permanentVillage),
      };

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                PatientInfoSection(title: "Personal Information", data: _personalInfo),
                const SizedBox(height: 32),
                PatientInfoSection(title: "Physical Attributes", data: _physicalAttrs),
                const SizedBox(height: 32),
                PatientInfoSection(title: "Present Address", data: _presentAddress),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: Column(
              children: [
                PatientInfoSection(title: "Employment Details", data: _employmentDetails),
                const SizedBox(height: 32),
                PatientInfoSection(title: "Contact Information", data: _contactInfo),
                const SizedBox(height: 32),
                PatientInfoSection(title: "Permanent Address", data: _permanentAddress),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        PatientInfoSection(title: "Personal Information", data: _personalInfo),
        const SizedBox(height: 32),
        PatientInfoSection(title: "Employment Details", data: _employmentDetails),
        const SizedBox(height: 32),
        PatientInfoSection(title: "Physical Attributes", data: _physicalAttrs),
        const SizedBox(height: 32),
        PatientInfoSection(title: "Contact Information", data: _contactInfo),
        const SizedBox(height: 32),
        PatientInfoSection(title: "Present Address", data: _presentAddress),
        const SizedBox(height: 32),
        PatientInfoSection(title: "Permanent Address", data: _permanentAddress),
      ],
    );
  }
}
