import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/dashboard_provider.dart';
import 'package:medicine_system/screens/home_screen/widgets/stat_card.dart';

class DashboardStatsGrid extends ConsumerWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final data = state.data;

    final systemUsers = data != null ? data.systemUsers.toString() : "0";
    final patientsCount = data != null ? data.totalPatients.toString() : "0";
    final medicinesCount = data != null ? data.totalMedicines.toString() : "0";
    final medicineStock = data != null ? data.medicineStock.toString() : "0";
    final distributionsCount = data != null ? data.totalDistributions.toString() : "0";
    final medicineRemaining = data != null ? data.medicineRemaining.toString() : "0";
    final medicineExpiration = data != null ? data.medicineExpiration.toString() : "0";
    final medicineDamaged = data != null ? data.medicineDamaged.toString() : "0";

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        StatCard(
          title: "System Users",
          count: state.isLoading ? "..." : systemUsers,
          icon: Icons.manage_accounts_rounded,
          iconColor: const Color(0xFF10B981),
        ),
        StatCard(
          title: "Patients",
          count: state.isLoading ? "..." : patientsCount,
          icon: Icons.personal_injury_rounded,
          iconColor: const Color(0xFF3B82F6),
        ),
        StatCard(
          title: "Total Medicine",
          count: state.isLoading ? "..." : medicinesCount,
          icon: Icons.medication_rounded,
          iconColor: const Color(0xFF0D9488),
        ),
        StatCard(
          title: "Medicine Stock",
          count: state.isLoading ? "..." : medicineStock,
          icon: Icons.inventory_2_rounded,
          iconColor: const Color(0xFFF59E0B),
        ),
        StatCard(
          title: "Medicine Distributed",
          count: state.isLoading ? "..." : distributionsCount,
          icon: Icons.local_shipping_rounded,
          iconColor: const Color(0xFF8B5CF6),
        ),
        StatCard(
          title: "Medicine Remaining",
          count: state.isLoading ? "..." : medicineRemaining,
          icon: Icons.pie_chart_rounded,
          iconColor: const Color(0xFF06B6D4),
        ),
        StatCard(
          title: "Medicine Expiration",
          count: state.isLoading ? "..." : medicineExpiration,
          icon: Icons.event_busy_rounded,
          iconColor: const Color(0xFFF97316),
        ),
        StatCard(
          title: "Medicine Damaged",
          count: state.isLoading ? "..." : medicineDamaged,
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFEF4444),
        ),
      ],
    );
  }
}
