import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/designations_provider.dart';
import 'package:medicine_system/utils/app_snack_bar.dart';
import 'package:medicine_system/screens/designations_screen/widgets/designation_form_dialog.dart';

class DesignationsHeader extends ConsumerWidget {
  const DesignationsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC71),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Designations",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogCtx) => DesignationFormDialog(
                  onSave: (name, index) async {
                    final ok = await ref.read(designationsProvider.notifier).createDesignation(name, index: index);
                    if (ok) {
                      AppSnackBar.instance.success("Designation created successfully!");
                    } else {
                      AppSnackBar.instance.error("Failed to create designation.");
                    }
                  },
                ),
              );
            },
            icon: const Icon(CupertinoIcons.add_circled, size: 16),
            label: const Text("Create", style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
