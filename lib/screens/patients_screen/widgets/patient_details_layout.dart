import 'package:flutter/material.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_info_section.dart';

class PatientDetailsLayout extends StatelessWidget {
  final bool isDesktop;

  const PatientDetailsLayout({super.key, required this.isDesktop});

  static const _personalInfo = {
    "Name": "Apurbo Ray",
    "Father": "Demo",
    "Mother": "Demo",
    "Date of Birth": "October 4, 2026",
    "Gender": "Male",
    "NID Number": "1111111111",
    "Blood Group": "B+",
    "Marital Status": "Single",
  };

  static const _employmentDetails = {
    "Designation": "Constable",
    "Police unit": "District Police",
    "Employment Status": "Regular",
    "BP Number": "111111",
    "Work Place": "demo",
    "Joining Date": "October 4, 2026",
  };

  static const _physicalAttrs = {
    "Height": "ft",
    "Weight": "kg",
    "Eyesight": "",
  };

  static const _contactInfo = {
    "Phone Number": "01705963592",
  };

  static const _presentAddress = {
    "Division": "Rajshahi",
    "District": "Natore",
    "Upazila": "Gurudaspur",
    "Union": "Moshindha",
    "Village": "demo",
  };

  static const _permanentAddress = {
    "Division": "Rajshahi",
    "District": "Natore",
    "Upazila": "Lalpur",
    "Union": "Oalia",
    "Village": "demo",
  };

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: const [
                PatientInfoSection(title: "Personal Information", data: _personalInfo),
                SizedBox(height: 32),
                PatientInfoSection(title: "Physical Attributes", data: _physicalAttrs),
                SizedBox(height: 32),
                PatientInfoSection(title: "Present Address", data: _presentAddress),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: Column(
              children: const [
                PatientInfoSection(title: "Employment Details", data: _employmentDetails),
                SizedBox(height: 32),
                PatientInfoSection(title: "Contact Information", data: _contactInfo),
                SizedBox(height: 32),
                PatientInfoSection(title: "Permanent Address", data: _permanentAddress),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: const [
        PatientInfoSection(title: "Personal Information", data: _personalInfo),
        SizedBox(height: 32),
        PatientInfoSection(title: "Employment Details", data: _employmentDetails),
        SizedBox(height: 32),
        PatientInfoSection(title: "Physical Attributes", data: _physicalAttrs),
        SizedBox(height: 32),
        PatientInfoSection(title: "Contact Information", data: _contactInfo),
        SizedBox(height: 32),
        PatientInfoSection(title: "Present Address", data: _presentAddress),
        SizedBox(height: 32),
        PatientInfoSection(title: "Permanent Address", data: _permanentAddress),
      ],
    );
  }
}
