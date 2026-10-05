import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/distributions_provider.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_form_patient_section.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_form_medicine_section.dart';

class DistributionFormBody extends ConsumerStatefulWidget {
  const DistributionFormBody({super.key});

  @override
  ConsumerState<DistributionFormBody> createState() => _DistributionFormBodyState();
}

class _DistributionFormBodyState extends ConsumerState<DistributionFormBody> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    final Map<String, dynamic> data = {
      'patient_id': 1,
      'distribution_date': DateTime.now().toIso8601String(),
    };

    final success = await ref.read(distributionsProvider.notifier).createDistribution(data);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save distribution record.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DistributionFormPatientSection(),
        const SizedBox(height: 24),
        const DistributionFormMedicineSection(),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save, size: 18),
            label: Text(_isSaving ? "Saving..." : "Save"),
          ),
        ),
      ],
    );
  }
}
