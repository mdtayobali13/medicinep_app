import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/providers/distributions_provider.dart';
import 'package:medicine_system/utils/app_snack_bar.dart';
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
  final _spouseNameController = TextEditingController();
  final _parentNameController = TextEditingController();
  final List<TextEditingController> _childrenControllers = [TextEditingController()];

  final List<DistributionMedicineItemState> _items = [
    DistributionMedicineItemState(),
  ];

  @override
  void dispose() {
    _prescriptionController.dispose();
    _notesController.dispose();
    _spouseNameController.dispose();
    _parentNameController.dispose();
    for (var c in _childrenControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addChildController() {
    setState(() {
      _childrenControllers.add(TextEditingController());
    });
  }

  void _removeChildController(int index) {
    if (_childrenControllers.length > 1) {
      setState(() {
        _childrenControllers[index].dispose();
        _childrenControllers.removeAt(index);
      });
    }
  }

  void _onPatientChanged(PatientModel? patient) {
    setState(() {
      _selectedPatient = patient;
      if (patient != null) {
        if (patient.spouses != null && patient.spouses!.isNotEmpty) {
          _spouseNameController.text = patient.spouses!.first.name;
        }
        if (patient.father != null && patient.father!.isNotEmpty) {
          _parentNameController.text = patient.father!;
        } else if (patient.mother != null && patient.mother!.isNotEmpty) {
          _parentNameController.text = patient.mother!;
        }
        if (patient.childrens != null && patient.childrens!.isNotEmpty) {
          _childrenControllers.clear();
          for (var child in patient.childrens!) {
            _childrenControllers.add(TextEditingController(text: child.name));
          }
        }
      }
    });
  }

  Future<void> _handleSave() async {
    if (_selectedPatient == null) {
      AppSnackBar.instance.error('Please select a patient.');
      return;
    }

    final validItems = _items.where((e) => e.medicine != null && e.quantity > 0).toList();
    if (validItems.isEmpty) {
      AppSnackBar.instance.error('Please select at least one medicine with a quantity greater than 0.');
      return;
    }

    for (final item in validItems) {
      int availableStock = item.medicine!.currentStock ?? 0;

      if (item.quantity > availableStock) {
        AppSnackBar.instance.error(
          'Quantity (${item.quantity}) for "${item.medicine!.brandName}" exceeds available stock ($availableStock).',
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    final List<Map<String, dynamic>> itemsPayload = validItems
        .map((e) => {
              'medicine_id': e.medicine!.id,
              'quantity': e.quantity,
            })
        .toList();

    String receiverDetails = '';
    final recType = _selectedReceiver ?? 'Self';
    if (recType == 'Spouse' && _spouseNameController.text.trim().isNotEmpty) {
      receiverDetails = _spouseNameController.text.trim();
    } else if (recType == 'Parents' && _parentNameController.text.trim().isNotEmpty) {
      receiverDetails = _parentNameController.text.trim();
    } else if (recType == 'Children') {
      final names = _childrenControllers.map((c) => c.text.trim()).where((n) => n.isNotEmpty).toList();
      if (names.isNotEmpty) {
        receiverDetails = names.join(', ');
      }
    }

    final Map<String, dynamic> data = {
      'patient_id': _selectedPatient!.id,
      'patient_name': _selectedPatient!.name,
      'patient': _selectedPatient!.name,
      'name': _selectedPatient!.name,
      if (_selectedPatient!.bpNo != null) 'bp_no': _selectedPatient!.bpNo,
      if (_selectedPatient!.bpNo != null) 'bp_number': _selectedPatient!.bpNo,
      'distribution_date': DateTime.now().toIso8601String().split('T').first,
      'date': DateTime.now().toIso8601String().split('T').first,
      'receiver_type': recType,
      if (receiverDetails.isNotEmpty) 'receiver_name': receiverDetails,
      if (recType == 'Spouse') 'spouse_name': _spouseNameController.text.trim(),
      if (recType == 'Parents') 'parent_name': _parentNameController.text.trim(),
      if (recType == 'Children')
        'children_names': _childrenControllers.map((c) => c.text.trim()).where((n) => n.isNotEmpty).toList(),
      'prescription_code': _prescriptionController.text.trim(),
      'notes': [
        _notesController.text.trim(),
        if (receiverDetails.isNotEmpty) 'Receiver: $receiverDetails'
      ].where((s) => s.isNotEmpty).join(' | '),
      'items': itemsPayload,
      'medicines': itemsPayload,
    };

    final success = await ref.read(distributionsProvider.notifier).createDistribution(data);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        AppSnackBar.instance.success('Distribution record created successfully!');
        Navigator.pop(context);
      } else {
        AppSnackBar.instance.error('Failed to save distribution record. Please try again.');
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
          onPatientChanged: _onPatientChanged,
          selectedReceiver: _selectedReceiver,
          onReceiverChanged: (type) => setState(() => _selectedReceiver = type),
          prescriptionController: _prescriptionController,
          notesController: _notesController,
          spouseNameController: _spouseNameController,
          parentNameController: _parentNameController,
          childrenControllers: _childrenControllers,
          onAddChild: _addChildController,
          onRemoveChild: _removeChildController,
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
