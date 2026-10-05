import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/patient_model.dart';
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

  PatientModel? _selectedPatient;
  String? _selectedReceiver = 'Self';
  final _prescriptionController = TextEditingController();
  final _notesController = TextEditingController();

  final List<DistributionMedicineItemState> _items = [
    DistributionMedicineItemState(),
  ];

  @override
  void dispose() {
    _prescriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient.')),
      );
      return;
    }

    final validItems = _items.where((e) => e.medicine != null && e.quantity > 0).toList();
    if (validItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one medicine with a quantity greater than 0.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final List<Map<String, dynamic>> itemsPayload = validItems
        .map((e) => {
              'medicine_id': e.medicine!.id,
              'quantity': e.quantity,
            })
        .toList();

    final Map<String, dynamic> data = {
      'patient_id': _selectedPatient!.id,
      'distribution_date': DateTime.now().toIso8601String().split('T').first,
      'receiver_type': _selectedReceiver ?? 'Self',
      'prescription_code': _prescriptionController.text.trim(),
      'notes': _notesController.text.trim(),
      'items': itemsPayload,
      'medicines': itemsPayload,
    };

    final success = await ref.read(distributionsProvider.notifier).createDistribution(data);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save distribution record. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DistributionFormPatientSection(
          selectedPatient: _selectedPatient,
          onPatientChanged: (patient) => setState(() => _selectedPatient = patient),
          selectedReceiver: _selectedReceiver,
          onReceiverChanged: (type) => setState(() => _selectedReceiver = type),
          prescriptionController: _prescriptionController,
          notesController: _notesController,
        ),
        const SizedBox(height: 24),
        DistributionFormMedicineSection(
          items: _items,
          onAddItem: () => setState(() => _items.add(DistributionMedicineItemState())),
          onRemoveItem: (index) {
            if (_items.length > 1) {
              setState(() => _items.removeAt(index));
            }
          },
          onMedicineChanged: (index, medicine) {
            setState(() => _items[index].medicine = medicine);
          },
          onQuantityChanged: (index, quantity) {
            setState(() => _items[index].quantity = quantity);
          },
        ),
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
