import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/designations_screen/widgets/delete_confirmation_dialog.dart';

class DistributionListCard extends StatelessWidget {
  final String sl;
  final String patient;
  final String bpNumber;
  final String receiver;
  final String prescriptionNumber;
  final String date;
  final String distributionBy;

  const DistributionListCard({
    super.key,
    required this.sl,
    required this.patient,
    required this.bpNumber,
    required this.receiver,
    required this.prescriptionNumber,
    required this.date,
    required this.distributionBy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  patient,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildActions(context, isDark, textColor),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(CupertinoIcons.number, "BP: $bpNumber", isDark, textColor),
          _buildInfoRow(CupertinoIcons.person, "Receiver: $receiver", isDark, textColor),
          if (prescriptionNumber.isNotEmpty)
            _buildInfoRow(CupertinoIcons.doc_text, "Prescription: $prescriptionNumber", isDark, textColor),
          _buildInfoRow(CupertinoIcons.calendar, "Date: $date", isDark, textColor),
          _buildInfoRow(CupertinoIcons.person_solid, "By: $distributionBy", isDark, textColor),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECA7F).withAlpha(isDark ? 40 : 25),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, size: 12, color: const Color(0xFF2ECA7F)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
        if (value == 'print') {
          // print
        } else if (value == 'delete') {
          showDialog(
            context: context,
            builder: (context) => DeleteConfirmationDialog(
              onConfirm: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data deleted successfully")),
                );
              },
            ),
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'print',
          child: Row(
            children: [
              Icon(CupertinoIcons.printer, size: 18, color: Colors.blue.shade600),
              const SizedBox(width: 12),
              Text('Print', style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
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
