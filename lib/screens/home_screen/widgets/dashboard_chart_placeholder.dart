import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/models/dashboard_model.dart';
import 'package:medicine_system/providers/dashboard_provider.dart';

class DashboardChartPlaceholder extends ConsumerWidget {
  final String title;
  final bool isPieChart;

  const DashboardChartPlaceholder({
    super.key,
    required this.title,
    this.isPieChart = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(dashboardProvider);
    final data = state.data;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2226) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.instance.textBlack800,
            ),
          ),
          const SizedBox(height: 12),
          if (isPieChart) _buildPieChart(isDark, data) else _buildLineChart(isDark, data),
        ],
      ),
    );
  }

  Widget _buildLineChart(bool isDark, DashboardModel? data) {
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final monthlyList = data?.monthlyReport ?? [];

    int maxVal = 100;
    for (var m in monthlyList) {
      maxVal = max(maxVal, max(m.stockQuantity, max(m.distributionQuantity, m.remainingQuantity)));
    }
    if (data != null && data.medicineStock > maxVal) {
      maxVal = data.medicineStock;
    }
    if (maxVal <= 0) maxVal = 100;

    return Column(
      children: [
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            _buildLegendItem("Stock", Colors.blue, isDark),
            _buildLegendItem("Distributed", const Color(0xFF10B981), isDark),
            _buildLegendItem("Remaining", Colors.amber, isDark),
          ],
        ),
        const SizedBox(height: 16),

        // Line Chart Representation
        SizedBox(
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y-Axis labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(maxVal >= 1000 ? "${(maxVal / 1000).toStringAsFixed(1)}k" : "$maxVal", style: TextStyle(fontSize: 10, color: subTextColor)),
                  Text(maxVal >= 1000 ? "${((maxVal / 2) / 1000).toStringAsFixed(1)}k" : "${maxVal ~/ 2}", style: TextStyle(fontSize: 10, color: subTextColor)),
                  Text("0", style: TextStyle(fontSize: 10, color: subTextColor)),
                ],
              ),
              const SizedBox(width: 8),

              // Chart area
              Expanded(
                child: CustomPaint(
                  size: const Size(double.infinity, 140),
                  painter: _LineChartPainter(
                    isDark: isDark,
                    monthlyReport: monthlyList,
                    maxVal: maxVal,
                    stockVal: data?.medicineStock ?? 0,
                    distVal: data?.totalDistributions ?? 0,
                    remVal: data?.medicineRemaining ?? 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // X-Axis labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ["Jan", "Mar", "May", "Jul", "Sep", "Nov", "Dec"]
              .map((m) => Text(m, style: TextStyle(fontSize: 10, color: subTextColor)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPieChart(bool isDark, DashboardModel? data) {
    double dist = data?.distributionPercentage ?? 0.0;
    double rem = data?.remainingPercentage ?? 0.0;
    double exp = data?.expiredPercentage ?? 0.0;
    double dmg = data?.damagedPercentage ?? 0.0;

    if (dist == 0 && rem == 0 && exp == 0 && dmg == 0 && data != null && data.medicineStock > 0) {
      dist = (data.totalDistributions / data.medicineStock) * 100;
      rem = (data.medicineRemaining / data.medicineStock) * 100;
    }
    if (dist == 0 && rem == 0 && exp == 0 && dmg == 0) {
      rem = 100.0;
    }

    return SizedBox(
      height: 160,
      child: Row(
        children: [
          // Custom Pie Painter
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(130, 130),
                painter: _PieChartPainter(
                  distPct: dist,
                  remPct: rem,
                  expPct: exp,
                  dmgPct: dmg,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Pie Legend
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegendItem("Distributed (${dist.toStringAsFixed(1)}%)", Colors.blue, isDark),
              const SizedBox(height: 6),
              _buildLegendItem("Remaining (${rem.toStringAsFixed(1)}%)", const Color(0xFF10B981), isDark),
              const SizedBox(height: 6),
              _buildLegendItem("Expired (${exp.toStringAsFixed(1)}%)", Colors.amber, isDark),
              const SizedBox(height: 6),
              _buildLegendItem("Damaged (${dmg.toStringAsFixed(1)}%)", Colors.red, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final bool isDark;
  final List<MonthlyReportModel> monthlyReport;
  final int maxVal;
  final int stockVal;
  final int distVal;
  final int remVal;

  _LineChartPainter({
    required this.isDark,
    required this.monthlyReport,
    required this.maxVal,
    required this.stockVal,
    required this.distVal,
    required this.remVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = isDark ? Colors.white12 : Colors.grey.shade200
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final bluePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final greenPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final amberPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    if (monthlyReport.isNotEmpty) {
      final pathBlue = Path();
      final pathGreen = Path();
      final pathAmber = Path();

      final stepX = size.width / (max(1, monthlyReport.length - 1));

      for (int i = 0; i < monthlyReport.length; i++) {
        final x = i * stepX;
        final item = monthlyReport[i];

        final yStock = size.height - (item.stockQuantity / maxVal) * size.height;
        final yDist = size.height - (item.distributionQuantity / maxVal) * size.height;
        final yRem = size.height - (item.remainingQuantity / maxVal) * size.height;

        if (i == 0) {
          pathBlue.moveTo(x, yStock.clamp(0.0, size.height));
          pathGreen.moveTo(x, yDist.clamp(0.0, size.height));
          pathAmber.moveTo(x, yRem.clamp(0.0, size.height));
        } else {
          pathBlue.lineTo(x, yStock.clamp(0.0, size.height));
          pathGreen.lineTo(x, yDist.clamp(0.0, size.height));
          pathAmber.lineTo(x, yRem.clamp(0.0, size.height));
        }
      }

      canvas.drawPath(pathBlue, bluePaint);
      canvas.drawPath(pathGreen, greenPaint);
      canvas.drawPath(pathAmber, amberPaint);
    } else {
      // Smooth curve plotting stock, dist, remaining totals
      final stockY = size.height - ((stockVal / maxVal).clamp(0.0, 1.0) * size.height * 0.8 + size.height * 0.1);
      final distY = size.height - ((distVal / maxVal).clamp(0.0, 1.0) * size.height * 0.8 + size.height * 0.1);
      final remY = size.height - ((remVal / maxVal).clamp(0.0, 1.0) * size.height * 0.8 + size.height * 0.1);

      final pathBlue = Path()
        ..moveTo(0, stockY)
        ..cubicTo(size.width * 0.3, stockY * 0.9, size.width * 0.6, stockY * 1.05, size.width, stockY);

      final pathGreen = Path()
        ..moveTo(0, distY)
        ..cubicTo(size.width * 0.3, distY * 0.95, size.width * 0.6, distY * 1.02, size.width, distY);

      final pathAmber = Path()
        ..moveTo(0, remY)
        ..cubicTo(size.width * 0.3, remY * 0.92, size.width * 0.6, remY * 1.04, size.width, remY);

      canvas.drawPath(pathBlue, bluePaint);
      canvas.drawPath(pathGreen, greenPaint);
      canvas.drawPath(pathAmber, amberPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PieChartPainter extends CustomPainter {
  final double distPct;
  final double remPct;
  final double expPct;
  final double dmgPct;

  _PieChartPainter({
    required this.distPct,
    required this.remPct,
    required this.expPct,
    required this.dmgPct,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.fill;

    double total = distPct + remPct + expPct + dmgPct;
    if (total <= 0) total = 100.0;

    double startAngle = -pi / 2;

    // 1. Distributed (Blue)
    if (distPct > 0) {
      final sweep = (distPct / total) * 2 * pi;
      paint.color = Colors.blue;
      canvas.drawArc(rect, startAngle, sweep, true, paint);
      startAngle += sweep;
    }

    // 2. Remaining (Green)
    if (remPct > 0) {
      final sweep = (remPct / total) * 2 * pi;
      paint.color = const Color(0xFF10B981);
      canvas.drawArc(rect, startAngle, sweep, true, paint);
      startAngle += sweep;
    }

    // 3. Expired (Amber)
    if (expPct > 0) {
      final sweep = (expPct / total) * 2 * pi;
      paint.color = Colors.amber;
      canvas.drawArc(rect, startAngle, sweep, true, paint);
      startAngle += sweep;
    }

    // 4. Damaged (Red)
    if (dmgPct > 0) {
      final sweep = (dmgPct / total) * 2 * pi;
      paint.color = Colors.red;
      canvas.drawArc(rect, startAngle, sweep, true, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
