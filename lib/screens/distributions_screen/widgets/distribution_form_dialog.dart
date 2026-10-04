import 'package:flutter/material.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_form_header.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_form_body.dart';

class DistributionFormDialog extends StatelessWidget {
  const DistributionFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E2226) : Colors.white;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      child: Container(
        width: 800,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DistributionFormHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: const DistributionFormBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
