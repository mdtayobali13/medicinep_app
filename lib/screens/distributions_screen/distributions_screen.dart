import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/screens/app_navigation/widgets/premium_sidebar.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distributions_header.dart';
import 'package:medicine_system/screens/distributions_screen/widgets/distributions_table.dart';
import 'package:medicine_system/widgets/top_right_header_actions.dart';

class DistributionsScreen extends StatefulWidget {
  const DistributionsScreen({super.key});

  @override
  State<DistributionsScreen> createState() => _DistributionsScreenState();
}

class _DistributionsScreenState extends State<DistributionsScreen> {
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
          currentIndex: 2, // 2 is Distributions
          onTap: (index) {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              DistributionsHeader(),
              SizedBox(height: 24),
              DistributionsTable(isMobile: false),
            ],
          ),
        ),
      ),
    );
  }
}
