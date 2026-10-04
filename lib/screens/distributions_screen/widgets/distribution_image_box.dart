import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class DistributionImageBox extends StatefulWidget {
  const DistributionImageBox({super.key});

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
    return Container(
      height: 320,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
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
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                    color: Colors.grey.shade50,
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
                            Icon(CupertinoIcons.photo, size: 40, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              "No Image",
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                            ),
                          ],
                        )
                      : null,
                ),
            const SizedBox(height: 24),
            Text(
              "Please select a patient",
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}
