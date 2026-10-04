import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MedicineImageUpload extends StatefulWidget {
  const MedicineImageUpload({super.key});

  @override
  State<MedicineImageUpload> createState() => _MedicineImageUploadState();
}

class _MedicineImageUploadState extends State<MedicineImageUpload> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            "Image",
            style: TextStyle(color: Colors.grey.shade800, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb 
                        ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                        : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.cloud_upload, color: Colors.grey.shade400, size: 24),
                      const SizedBox(height: 8),
                      Text("Upload", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
