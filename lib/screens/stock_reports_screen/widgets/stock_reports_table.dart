import 'package:flutter/material.dart';
import 'package:medicine_system/screens/stock_reports_screen/widgets/stock_reports_top_bar.dart';

class StockReportsTable extends StatelessWidget {
  const StockReportsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final headerBg = isDark ? const Color(0xFF262B30) : Colors.grey.shade200;
    final textColor = isDark ? Colors.white : Colors.black87;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StockReportsTopBar(),
            const SizedBox(height: 16),
            if (isSmallScreen) ...[
              _buildMobileCards(context, isDark, cardBg, textColor),
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
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(headerBg),
                        dataRowMaxHeight: 52,
                        dataRowMinHeight: 52,
                        columns: [
                          DataColumn(label: Text('Sl', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                          DataColumn(label: Text('Medicine', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                          DataColumn(label: Text('Previous Stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                          DataColumn(label: Text('Stock Between Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                          DataColumn(label: Text('Total Stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                          DataColumn(label: Text('Previous Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                          DataColumn(label: Text('Distribution Between Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                          DataColumn(label: Text('Total Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                          DataColumn(label: Text('Remaining', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                        ],
                        rows: [
                          _buildRow('1', 'Admin', '0', '0', '2001', '0', '0', '0', '2001', isDark: isDark, isHighlightTotal: true),
                          _buildRow('2', 'Raymond Hawkins', '0', '0', '50', '0', '0', '25', '25', isDark: isDark),
                          _buildRow('3', 'Maris Galloway', '0', '0', '40', '0', '0', '5', '35', isDark: isDark),
                          _buildRow('4', 'Paracetamol', '0', '0', '0', '0', '0', '0', '0', isDark: isDark),
                          _buildRow('5', 'Apurbo Ray', '0', '0', '0', '0', '0', '0', '0', isDark: isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMobileCards(BuildContext context, bool isDark, Color cardBg, Color textColor) {
    final List<Map<String, String>> data = [
      {'sl': '1', 'medicine': 'Admin', 'prevStock': '0', 'stockBetween': '0', 'totalStock': '2001', 'prevDist': '0', 'distBetween': '0', 'totalDist': '0', 'remaining': '2001'},
      {'sl': '2', 'medicine': 'Raymond Hawkins', 'prevStock': '0', 'stockBetween': '0', 'totalStock': '50', 'prevDist': '0', 'distBetween': '0', 'totalDist': '25', 'remaining': '25'},
      {'sl': '3', 'medicine': 'Maris Galloway', 'prevStock': '0', 'stockBetween': '0', 'totalStock': '40', 'prevDist': '0', 'distBetween': '0', 'totalDist': '5', 'remaining': '35'},
      {'sl': '4', 'medicine': 'Paracetamol', 'prevStock': '0', 'stockBetween': '0', 'totalStock': '0', 'prevDist': '0', 'distBetween': '0', 'totalDist': '0', 'remaining': '0'},
      {'sl': '5', 'medicine': 'Apurbo Ray', 'prevStock': '0', 'stockBetween': '0', 'totalStock': '0', 'prevDist': '0', 'distBetween': '0', 'totalDist': '0', 'remaining': '0'},
    ];

    return Column(
      children: data.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withAlpha(5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "#${item['sl']} ${item['medicine']}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Remaining: ${item['remaining']}",
                      style: TextStyle(color: isDark ? Colors.lightBlueAccent : Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Divider(height: 20, color: isDark ? Colors.white12 : Colors.grey.shade200),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCardItem("Prev Stock", item['prevStock']!, isDark, textColor),
                  _buildCardItem("Total Stock", item['totalStock']!, isDark, textColor),
                  _buildCardItem("Total Dist", item['totalDist']!, isDark, textColor),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCardItem(String label, String value, bool isDark, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  DataRow _buildRow(
    String sl,
    String medicine,
    String prevStock,
    String stockBetween,
    String totalStock,
    String prevDist,
    String distBetween,
    String totalDist,
    String remaining, {
    required bool isDark,
    bool isHighlightTotal = false,
  }) {
    final TextStyle defaultStyle = TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13);
    final TextStyle highlightStyle = TextStyle(color: isDark ? Colors.lightBlueAccent : Colors.blue.shade600, fontWeight: FontWeight.w500, fontSize: 13);

    return DataRow(
      cells: [
        DataCell(Text(sl, style: defaultStyle)),
        DataCell(Text(medicine, style: TextStyle(color: isDark ? Colors.white : Colors.grey.shade700, fontSize: 13))),
        DataCell(Text(prevStock, style: defaultStyle)),
        DataCell(Text(stockBetween, style: defaultStyle)),
        DataCell(Text(totalStock, style: isHighlightTotal ? highlightStyle : defaultStyle)),
        DataCell(Text(prevDist, style: defaultStyle)),
        DataCell(Text(distBetween, style: defaultStyle)),
        DataCell(Text(totalDist, style: defaultStyle)),
        DataCell(Text(remaining, style: isHighlightTotal ? highlightStyle : defaultStyle)),
      ],
    );
  }
}
