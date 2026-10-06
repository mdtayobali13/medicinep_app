import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/medicine_unit_model.dart';
import 'package:medicine_system/providers/medicine_units_provider.dart';
import 'package:medicine_system/utils/app_snack_bar.dart';
import 'package:medicine_system/screens/medicine_units_screen/widgets/medicine_unit_form_dialog.dart';
import 'package:medicine_system/screens/medicine_units_screen/widgets/delete_confirmation_dialog.dart';

class MedicineUnitsTable extends ConsumerWidget {
  const MedicineUnitsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineUnitsProvider);

    if (state.isLoading && state.list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            state.error ?? "No medicine units found",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...state.list.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          return _buildListCard(context, ref, index.toString(), item);
        }),
        if (state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildListCard(BuildContext context, WidgetRef ref, String sl, MedicineUnitModel item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final iconColor = isDark ? Colors.white54 : Colors.grey.shade500;
    final circleBg = isDark ? const Color(0xFF262B30) : const Color(0xFFF0FDF4);
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade100;
    final createdAtStr = item.createdAt != null ? item.createdAt!.split('T').first : '';

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
        children: [
          // SL Circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: circleBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                sl,
                style: const TextStyle(
                  color: Color(0xFF2ECC71),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.tag, size: 12, color: iconColor),
                        const SizedBox(width: 3),
                        Text(
                          "Symbol: ${item.symbol ?? item.name}",
                          style: TextStyle(fontSize: 11.5, color: subTextColor),
                        ),
                      ],
                    ),
                    if (createdAtStr.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.calendar, size: 12, color: iconColor),
                          const SizedBox(width: 3),
                          Text(
                            createdAtStr,
                            style: TextStyle(fontSize: 11.5, color: subTextColor),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                CupertinoIcons.pencil,
                Colors.blue.shade700,
                isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.shade50,
                () {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => MedicineUnitFormDialog(
                      isEdit: true,
                      initialName: item.name,
                      onSave: (newName) async {
                        final ok = await ref.read(medicineUnitsProvider.notifier).updateUnit(item.id, newName);
                        if (ok) {
                          AppSnackBar.instance.success("Medicine Unit updated successfully!");
                        } else {
                          AppSnackBar.instance.error("Failed to update medicine unit.");
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              _buildActionButton(
                CupertinoIcons.trash,
                Colors.red.shade700,
                isDark ? Colors.red.withValues(alpha: 0.2) : Colors.red.shade50,
                () {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => DeleteConfirmationDialog(
                      onConfirm: () async {
                        final ok = await ref.read(medicineUnitsProvider.notifier).deleteUnit(item.id);
                        if (ok) {
                          AppSnackBar.instance.success("Medicine Unit deleted successfully!");
                        } else {
                          AppSnackBar.instance.error("Failed to delete medicine unit.");
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color iconColor, Color bgColor, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 15, color: iconColor),
        ),
      ),
    );
  }
}
