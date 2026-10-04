import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/screens/app_navigation/widgets/premium_sidebar.dart';
import 'package:medicine_system/screens/stock_reports_screen/widgets/stock_reports_header.dart';
import 'package:medicine_system/screens/stock_reports_screen/widgets/stock_reports_table.dart';
import 'package:medicine_system/widgets/top_right_header_actions.dart';

class StockReportsScreen extends StatefulWidget {
  const StockReportsScreen({super.key});

  @override
  State<StockReportsScreen> createState() => _StockReportsScreenState();
}

class _StockReportsScreenState extends State<StockReportsScreen> {
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
          currentIndex: 4,
          onTap: (index) {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              StockReportsHeader(),
              SizedBox(height: 24),
              StockReportsTable(),
            ],
          ),
        ),
      ),
    );
  }
}
