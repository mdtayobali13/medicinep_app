import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/providers/designations_provider.dart';
import 'package:medicine_system/screens/app_navigation/widgets/premium_sidebar.dart';
import 'package:medicine_system/screens/designations_screen/widgets/designations_header.dart';
import 'package:medicine_system/screens/designations_screen/widgets/designations_top_bar.dart';
import 'package:medicine_system/screens/designations_screen/widgets/designations_table.dart';
import 'package:medicine_system/widgets/top_right_header_actions.dart';

class DesignationsScreen extends ConsumerWidget {
  const DesignationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              ref.read(designationsProvider.notifier).loadMore();
            }
            return false;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                DesignationsHeader(),
                SizedBox(height: 20),
                DesignationsTopBar(),
                SizedBox(height: 16),
                DesignationsTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
