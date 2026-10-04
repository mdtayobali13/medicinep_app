import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distributions_top_bar.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_list_card.dart';
import 'package:medicine_system/screens/designations_screen/widgets/delete_confirmation_dialog.dart';

class DistributionsTable extends StatelessWidget {
  final bool
  isMobile; // Kept for backwards compatibility but not used directly for layout now
  const DistributionsTable({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final headerBg = isDark ? const Color(0xFF262B30) : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : Colors.black87;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DistributionsTopBar(),
            const SizedBox(height: 16),
            if (isSmallScreen) ...[
              _buildMobileCards(),
            ] else ...[
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.black.withAlpha(5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(headerBg),
                      dataRowMaxHeight: 60,
                      dataRowMinHeight: 60,
                      columns: [
                        DataColumn(
                          label: Text(
                            'Sl',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Patient',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'BP Number',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Receiver',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Prescription Number',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Distribution By',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Action',
                            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ),
                      ],
                      rows: [
                        _buildRow(
                          context,
                          '1',
                          'Apurbo Ray (Self)',
                          '111111',
                          'Apurbo Ray',
                          '111111',
                          '02-12-2025',
                          'Admin User',
                          isDark,
                        ),
                        _buildRow(
                          context,
                          '2',
                          'Apurbo Ray (Parents)',
                          '111111',
                          'Demo',
                          '',
                          '02-12-2025',
                          'Admin User',
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMobileCards() {
    return Column(
      children: const [
        DistributionListCard(
          sl: '1',
          patient: 'Apurbo Ray (Self)',
          bpNumber: '111111',
          receiver: 'Apurbo Ray',
          prescriptionNumber: '111111',
          date: '02-12-2025',
          distributionBy: 'Admin User',
        ),
        DistributionListCard(
          sl: '2',
          patient: 'Apurbo Ray (Parents)',
          bpNumber: '111111',
          receiver: 'Demo',
          prescriptionNumber: '',
          date: '02-12-2025',
          distributionBy: 'Admin User',
        ),
      ],
    );
  }

  DataRow _buildRow(BuildContext context, String sl, String patient, String bp, String receiver, String preNum, String date, String by, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade600;

    return DataRow(
      cells: [
        DataCell(Text(sl, style: TextStyle(color: subTextColor))),
        DataCell(
          Text(
            patient,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(Text(bp, style: TextStyle(color: subTextColor))),
        DataCell(Text(receiver, style: TextStyle(color: subTextColor))),
        DataCell(Text(preNum, style: TextStyle(color: subTextColor))),
        DataCell(Text(date, style: TextStyle(color: subTextColor))),
        DataCell(Text(by, style: TextStyle(color: subTextColor))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionBtn(
                CupertinoIcons.printer,
                isDark ? Colors.white70 : Colors.grey.shade700,
                isDark,
                () {},
              ),
              const SizedBox(width: 8),
              _buildActionBtn(CupertinoIcons.trash, Colors.red.shade600, isDark, () {
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
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, Color color, bool isDark, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? Colors.white24 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
        color: isDark ? const Color(0xFF262B30) : Colors.transparent,
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: color),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        onPressed: onTap,
      ),
    );
  }
}
