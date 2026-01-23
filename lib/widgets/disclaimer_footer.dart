import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/theme.dart';

/// Sticky disclaimer footer
class DisclaimerFooter extends StatelessWidget {
  const DisclaimerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.black,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.health_and_safety,
            size: 16,
            color: AppTheme.black,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              AppConstants.footerDisclaimer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
