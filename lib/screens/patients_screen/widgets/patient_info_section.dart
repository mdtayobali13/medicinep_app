import 'package:flutter/material.dart';

class PatientInfoSection extends StatelessWidget {
  final String title;
  final Map<String, String> data;

  const PatientInfoSection({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Divider(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          thickness: 1,
        ),
        const SizedBox(height: 12),
        ...data.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    "${entry.key}:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
