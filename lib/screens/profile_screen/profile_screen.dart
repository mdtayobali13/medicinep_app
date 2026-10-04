import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/screens/app_navigation/widgets/premium_sidebar.dart';
import 'package:medicine_system/widgets/top_right_header_actions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTabIndex = 1; // 0: Profile Information, 1: Change Password

  // Change password fields state
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Profile info fields state
  final TextEditingController _nameController = TextEditingController(text: 'Admin User');
  final TextEditingController _emailController = TextEditingController(text: 'admin@example.com');
  final TextEditingController _phoneController = TextEditingController(text: '+8801700000000');

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
          currentIndex: -1,
          onTap: (index) {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 320,
                      child: _buildProfileSummaryCard(isDark),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildTabsContentCard(isDark),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildProfileSummaryCard(isDark),
                    const SizedBox(height: 24),
                    _buildTabsContentCard(isDark),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProfileSummaryCard(bool isDark) {
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF262B30) : Colors.grey.shade100,
              border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, width: 1.5),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.photo_on_rectangle,
                size: 42,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Admin User',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF133B2B) : const Color(0xFFE8F8F0),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? const Color(0xFF1F6B4C) : const Color(0xFFA3E2C4)),
            ),
            child: const Text(
              'Super Admin',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2ECA7F),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'admin@example.com',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsContentCard(bool isDark) {
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Tab Bar Navigation Header
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              children: [
                _buildTabItem(title: 'Profile Information', index: 0, isDark: isDark),
                const SizedBox(width: 24),
                _buildTabItem(title: 'Change Password', index: 1, isDark: isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Active Tab Content Body
          _selectedTabIndex == 0
              ? _buildProfileInformationForm(isDark)
              : _buildChangePasswordForm(isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index, required bool isDark}) {
    final isSelected = _selectedTabIndex == index;
    final unselectedTextColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF1890FF) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? const Color(0xFF1890FF) : unselectedTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInformationForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormFieldLabel('Full Name', isDark),
        const SizedBox(height: 6),
        _buildTextField(_nameController, false, null, isDark),
        const SizedBox(height: 16),
        _buildFormFieldLabel('Email Address', isDark),
        const SizedBox(height: 6),
        _buildTextField(_emailController, false, null, isDark),
        const SizedBox(height: 16),
        _buildFormFieldLabel('Phone Number', isDark),
        const SizedBox(height: 6),
        _buildTextField(_phoneController, false, null, isDark),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1890FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Update Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangePasswordForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormFieldLabel('Old Password', isDark),
        const SizedBox(height: 6),
        _buildTextField(
          _oldPasswordController,
          _obscureOld,
          IconButton(
            icon: Icon(
              _obscureOld ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              size: 16,
              color: isDark ? Colors.white60 : Colors.grey.shade500,
            ),
            onPressed: () => setState(() => _obscureOld = !_obscureOld),
          ),
          isDark,
        ),
        const SizedBox(height: 16),
        _buildFormFieldLabel('New Password', isDark),
        const SizedBox(height: 6),
        _buildTextField(
          _newPasswordController,
          _obscureNew,
          IconButton(
            icon: Icon(
              _obscureNew ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              size: 16,
              color: isDark ? Colors.white60 : Colors.grey.shade500,
            ),
            onPressed: () => setState(() => _obscureNew = !_obscureNew),
          ),
          isDark,
        ),
        const SizedBox(height: 16),
        _buildFormFieldLabel('Confirm New Password', isDark),
        const SizedBox(height: 6),
        _buildTextField(
          _confirmPasswordController,
          _obscureConfirm,
          IconButton(
            icon: Icon(
              _obscureConfirm ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              size: 16,
              color: isDark ? Colors.white60 : Colors.grey.shade500,
            ),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          isDark,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1890FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Update Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white70 : Colors.grey.shade800,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    bool obscureText,
    Widget? suffixIcon,
    bool isDark,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: isDark ? const Color(0xFF262B30) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF1890FF)),
        ),
      ),
    );
  }
}

