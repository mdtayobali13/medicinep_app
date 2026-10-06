import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/stock_reports_provider.dart';
import 'package:medicine_system/screens/stock_reports_screen/widgets/stock_reports_top_bar.dart';

class StockReportsTable extends ConsumerWidget {
  const StockReportsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockReportsProvider);
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
                    state.error ?? "No stock records found",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ),
              )
            else if (isSmallScreen) ...[
              _buildMobileCards(context, isDark, cardBg, textColor, state.list),
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
                        rows: state.list.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final item = entry.value;
                          return _buildRow(
                            index.toString(),
                            item.medicineName,
                            item.previousStock.toString(),
                            item.stockBetween.toString(),
                            item.totalStock.toString(),
                            item.previousDistribution.toString(),
                            item.distributionBetween.toString(),
                            item.totalDistribution.toString(),
                            item.remainingCalculated.toString(),
                            isDark: isDark,
                            isHighlightTotal: item.remainingCalculated <= 0,
                          );
                        }).toList(),
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

  Widget _buildMobileCards(BuildContext context, bool isDark, Color cardBg, Color textColor, List<dynamic> list) {
    return Column(
      children: list.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final item = entry.value;
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
                      "#$index ${item.medicineName}",
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
                      "Remaining: ${item.remainingCalculated}",
                      style: TextStyle(color: isDark ? Colors.lightBlueAccent : Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Divider(height: 20, color: isDark ? Colors.white12 : Colors.grey.shade200),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCardItem("Prev Stock", item.previousStock.toString(), isDark, textColor),
                  _buildCardItem("Total Stock", item.totalStock.toString(), isDark, textColor),
                  _buildCardItem("Total Dist", item.totalDistribution.toString(), isDark, textColor),
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
