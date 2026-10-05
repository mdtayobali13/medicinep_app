import 'package:flutter/material.dart';
import 'package:medicine_system/screens/home_screen/widgets/stat_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: const [
        StatCard(
          title: "System Users",
          count: "2",
          icon: Icons.manage_accounts_rounded,
          iconColor: Color(0xFF10B981),
        ),
        StatCard(
          title: "Patients",
          count: "1",
          icon: Icons.personal_injury_rounded,
          iconColor: Color(0xFF3B82F6),
        ),
        StatCard(
          title: "Total Medicine",
          count: "5",
          icon: Icons.medication_rounded,
          iconColor: Color(0xFF0D9488),
        ),
        StatCard(
          title: "Medicine Stock",
          count: "2091",
          icon: Icons.inventory_2_rounded,
          iconColor: Color(0xFFF59E0B),
        ),
        StatCard(
          title: "Medicine Distributed",
          count: "80",
          icon: Icons.local_shipping_rounded,
          iconColor: Color(0xFF8B5CF6),
        ),
        StatCard(
          title: "Medicine Remaining",
          count: "2011",
          icon: Icons.pie_chart_rounded,
          iconColor: Color(0xFF06B6D4),
        ),
        StatCard(
          title: "Medicine Expiration",
          count: "0",
          icon: Icons.event_busy_rounded,
          iconColor: Color(0xFFF97316),
        ),
        StatCard(
          title: "Medicine Damaged",
          count: "0",
          icon: Icons.warning_amber_rounded,
          iconColor: Color(0xFFEF4444),
        ),
      ],
    );
  }
}
