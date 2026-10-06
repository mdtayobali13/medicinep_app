import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/notifications_provider.dart';
import 'package:medicine_system/models/notification_model.dart';
import 'package:medicine_system/screens/notifications_screen/widgets/notifications_top_bar.dart';
import 'package:medicine_system/utils/app_theme.dart';

class NotificationsTable extends ConsumerWidget {
  const NotificationsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NotificationsTopBar(),
            const SizedBox(height: 16),
            if (state.isLoading && state.notifications.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (state.notifications.isEmpty)
              Center(
                child: Text(
                  state.error ?? "No notifications found",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              )
            else if (isSmallScreen) ...[
              _buildMobileCards(state.notifications, isDark),
            ] else ...[
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey.shade200,
                      ),
                      dataRowMaxHeight: 52,
                      dataRowMinHeight: 52,
                      columns: const [
                        DataColumn(label: Text('Sl', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                      ],
                      rows: state.notifications.asMap().entries.map((entry) {
                        final index = entry.key;
                        final notif = entry.value;
                        final sl = (index + 1).toString();
                        return _buildRow(sl, notif.message, notif.date);
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

  Widget _buildMobileCards(List<NotificationModel> notifications, bool isDark) {
    return Column(
      children: notifications.asMap().entries.map((entry) {
        final index = entry.key;
        final notif = entry.value;
        final sl = (index + 1).toString();
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 50 : 5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "#$sl",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notif.date,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                notif.message,
                style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  DataRow _buildRow(String sl, String message, String date) {
    return DataRow(
      cells: [
        DataCell(Text(sl, style: TextStyle(color: Colors.grey.shade600, fontSize: 13))),
        DataCell(Text(message, style: TextStyle(color: Colors.grey.shade700, fontSize: 13))),
        DataCell(Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 13))),
      ],
    );
  }
}
