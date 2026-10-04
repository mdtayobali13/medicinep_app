import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/screens/app_navigation/widgets/premium_sidebar.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patients_header.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patients_table.dart';
import 'package:medicine_system/widgets/top_right_header_actions.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.instance.black500),
        title: Text(
          "Medicine System",
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.instance.black500,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          TopRightHeaderActions(),
        ],
      ),
      drawer: Drawer(
        child: PremiumSidebar(
          currentIndex: -1, // Use -1 since we are relying on route matching in sidebar
          onTap: (index) {
            // Handled internally by sidebar now for Patients
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PatientsHeader(),
              SizedBox(height: 24),
              PatientsTable(),
            ],
          ),
        ),
      ),
    );
  }
}
