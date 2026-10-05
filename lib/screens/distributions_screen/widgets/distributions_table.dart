import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/distribution_model.dart';
import 'package:medicine_system/providers/distributions_provider.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distributions_top_bar.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distribution_list_card.dart';
import 'package:medicine_system/screens/designations_screen/widgets/delete_confirmation_dialog.dart';

class DistributionsTable extends ConsumerWidget {
  final bool isMobile;
  const DistributionsTable({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(distributionsProvider);
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
            if (state.isLoading && state.list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.list.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    state.error ?? "No distribution records found",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ),
              )
            else if (isSmallScreen) ...[
              _buildMobileCards(context, ref, state.list),
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
                          label: Text('Sl', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        ),
                        DataColumn(
                          label: Text('Patient', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        ),
                        DataColumn(
                          label: Text('BP Number', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        ),
                        DataColumn(
                          label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        ),
                        DataColumn(
                          label: Text('Items Count', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        ),
                        DataColumn(
                          label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                        ),
                      ],
                      rows: state.list.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final item = entry.value;
                        return _buildRow(context, ref, index.toString(), item, isDark);
                      }).toList(),
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

  Widget _buildMobileCards(BuildContext context, WidgetRef ref, List<DistributionModel> list) {
    return Column(
      children: list.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final item = entry.value;
        return DistributionListCard(
          sl: index.toString(),
          patient: item.patientName ?? item.patient?.name ?? 'N/A',
          bpNumber: item.bpNo ?? item.patient?.bpNo ?? 'N/A',
          receiver: item.patientName ?? 'N/A',
          prescriptionNumber: '',
          date: item.distributionDate != null ? item.distributionDate!.split('T').first : '',
          distributionBy: 'System',
        );
      }).toList(),
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, String sl, DistributionModel item, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final dateStr = item.distributionDate != null ? item.distributionDate!.split('T').first : '';

    return DataRow(
      cells: [
        DataCell(Text(sl, style: TextStyle(color: subTextColor))),
        DataCell(
          Text(
            item.patientName ?? item.patient?.name ?? 'N/A',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(Text(item.bpNo ?? item.patient?.bpNo ?? 'N/A', style: TextStyle(color: subTextColor))),
        DataCell(Text(dateStr, style: TextStyle(color: subTextColor))),
        DataCell(Text('${item.items.length} items', style: TextStyle(color: subTextColor))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionBtn(CupertinoIcons.trash, Colors.red.shade600, isDark, () {
                showDialog(
                  context: context,
                  builder: (context) => DeleteConfirmationDialog(
                    onConfirm: () {
                      ref.read(distributionsProvider.notifier).deleteDistribution(item.id);
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
