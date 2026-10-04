import 'package:flutter/material.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_form_fields.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_image_box.dart';

class DistributionFormPatientSection extends StatelessWidget {
  const DistributionFormPatientSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              DistributionFormFields(),
              SizedBox(height: 24),
              DistributionImageBox(),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(flex: 3, child: DistributionFormFields()),
            SizedBox(width: 24),
            Expanded(flex: 2, child: DistributionImageBox()),
          ],
        );
      },
    );
  }
}
