import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_system/models/patient_model.dart';

class DistributionImageBox extends StatefulWidget {
  final PatientModel? patient;

  const DistributionImageBox({super.key, this.patient});

  @override
  State<DistributionImageBox> createState() => _DistributionImageBoxState();
}

class _DistributionImageBoxState extends State<DistributionImageBox> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    final patient = widget.patient;

    return Container(
      height: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: _pickImage,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.blue.shade300 : Colors.blue.shade200, width: 2),
                    color: isDark ? const Color(0xFF262B30) : Colors.blue.shade50,
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              patient != null ? CupertinoIcons.person_fill : CupertinoIcons.photo,
                              size: 40,
                              color: isDark ? Colors.blue.shade300 : Colors.blue.shade400,
                            ),
                            if (patient == null) ...[
                              const SizedBox(height: 4),
                              Text(
                                "No Image",
                                style: TextStyle(color: subColor, fontSize: 10),
                              ),
                            ],
                          ],
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                if (patient != null) ...[
                  Text(
                    patient.name,
                    style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  if (patient.bpNo != null && patient.bpNo!.isNotEmpty)
                    Text(
                      "BP No: ${patient.bpNo}",
                      style: TextStyle(color: subColor, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  if (patient.mobile != null && patient.mobile!.isNotEmpty)
                    Text(
                      "Mobile: ${patient.mobile}",
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                  if (patient.designation?.name != null)
                    Text(
                      "Designation: ${patient.designation!.name}",
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                  if (patient.policeUnit?.name != null)
                    Text(
                      "Unit: ${patient.policeUnit!.name}",
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                ] else ...[
                  Text(
                    "Please select a patient",
                    style: TextStyle(color: subColor, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
