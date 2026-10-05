import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_view_dialog.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_dialog.dart';

class PatientListCard extends StatelessWidget {
  final String sl;
  final String name;
  final String designation;
  final String bpNumber;
  final String policeUnit;
  final String status;
  final String phone;
  final VoidCallback? onDelete;

  const PatientListCard({
    super.key,
    required this.sl,
    required this.name,
    required this.designation,
    required this.bpNumber,
    required this.policeUnit,
    required this.status,
    required this.phone,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileImage(isDark),
          const SizedBox(width: 10),
          Expanded(child: _buildDetailsColumn(isDark, textColor)),
          const SizedBox(width: 6),
          _buildActions(context, isDark, textColor),
        ],
      ),
    );
  }

  Widget _buildProfileImage(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF262B30) : Colors.blue.shade50,
        shape: BoxShape.circle,
      ),
      child: Icon(
        CupertinoIcons.person_solid,
        color: isDark ? Colors.blue.shade200 : Colors.blue.shade300,
        size: 22,
      ),
    );
  }

  Widget _buildDetailsColumn(bool isDark, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            _buildStatusBadge(isDark),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _buildInfoBadge(CupertinoIcons.briefcase, designation, isDark),
            _buildInfoBadge(CupertinoIcons.building_2_fill, policeUnit, isDark),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _buildInfoBadge(CupertinoIcons.number_square, "BP: $bpNumber", isDark),
            _buildInfoBadge(CupertinoIcons.phone, phone, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    final bool isRegular = status == "Regular";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isRegular
            ? (isDark ? Colors.green.withValues(alpha: 0.2) : Colors.green.shade50)
            : (isDark ? Colors.orange.withValues(alpha: 0.2) : Colors.orange.shade50),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isRegular ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isRegular ? (isDark ? Colors.greenAccent : Colors.green.shade700) : (isDark ? Colors.orangeAccent : Colors.orange.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 14, color: isDark ? Colors.white54 : Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildActions(BuildContext context, bool isDark, Color textColor) {
    return PopupMenuButton<String>(
      icon: Icon(CupertinoIcons.ellipsis_vertical, color: isDark ? Colors.white70 : Colors.grey.shade600, size: 20),
      color: isDark ? const Color(0xFF262B30) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == 'view') {
          showDialog(
            context: context,
            builder: (context) => const PatientViewDialog(),
          );
        } else if (value == 'edit') {
          showDialog(
            context: context,
            builder: (context) => PatientFormDialog(
              isEdit: true,
              initialData: {
                'name': name,
                'designation': designation,
                'bp_number': bpNumber,
                'police_unit': policeUnit,
                'status': status,
                'phone': phone,
              },
            ),
          );
        } else if (value == 'delete') {
          if (onDelete != null) onDelete!();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(CupertinoIcons.eye, size: 18, color: Colors.green.shade600),
              const SizedBox(width: 12),
              Text('View', style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(CupertinoIcons.pencil, size: 18, color: Colors.blue.shade600),
              const SizedBox(width: 12),
              Text('Edit', style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(CupertinoIcons.trash, size: 18, color: Colors.red.shade600),
              const SizedBox(width: 12),
              Text('Delete', style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
