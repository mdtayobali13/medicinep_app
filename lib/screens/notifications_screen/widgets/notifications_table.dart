import 'package:flutter/material.dart';
import 'package:medicine_system/screens/notifications_screen/widgets/notifications_top_bar.dart';

class NotificationsTable extends StatelessWidget {
  const NotificationsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NotificationsTopBar(),
            const SizedBox(height: 16),
            if (isSmallScreen) ...[
              _buildMobileCards(),
            ] else ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      rows: [
                        _buildRow('1', "Medicine 'Maris Galloway' is almost sold out with a remaining quantity of 5.", '07-03-2024 08:51 AM'),
                        _buildRow('2', "Medicine 'Maris Galloway' is almost sold out with a remaining quantity of 5.", '07-03-2024 08:51 AM'),
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
    final List<Map<String, String>> notifications = [
      {
        'sl': '1',
        'message': "Medicine 'Maris Galloway' is almost sold out with a remaining quantity of 5.",
        'date': '07-03-2024 08:51 AM',
      },
      {
        'sl': '2',
        'message': "Medicine 'Maris Galloway' is almost sold out with a remaining quantity of 5.",
        'date': '07-03-2024 08:51 AM',
      },
    ];

    return Column(
      children: notifications.map((n) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
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
                        "#${n['sl']}",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      n['date']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                n['message']!,
                style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
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
