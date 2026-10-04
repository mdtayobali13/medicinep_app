import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DistributionFormHeader extends StatelessWidget {
  const DistributionFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Distribution",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(CupertinoIcons.clear, size: 20, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
