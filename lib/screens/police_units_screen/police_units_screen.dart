import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/screens/app_navigation/widgets/premium_sidebar.dart';
import 'package:medicine_system/screens/police_units_screen/widgets/police_units_header.dart';
import 'package:medicine_system/screens/police_units_screen/widgets/police_units_top_bar.dart';
import 'package:medicine_system/screens/police_units_screen/widgets/police_units_table.dart';
import 'package:medicine_system/widgets/top_right_header_actions.dart';

class PoliceUnitsScreen extends StatelessWidget {
  const PoliceUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Medicine System',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.instance.black500,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.instance.black500),
        actions: const [
          TopRightHeaderActions(),
        ],
      ),
      drawer: Drawer(
        child: PremiumSidebar(
          currentIndex: -1,
          onTap: (index) {},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PoliceUnitsHeader(),
              SizedBox(height: 20),
              PoliceUnitsTopBar(),
              SizedBox(height: 16),
              PoliceUnitsTable(),
            ],
          ),
        ),
      ),
    );
  }
}
