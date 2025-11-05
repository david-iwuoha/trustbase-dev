import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionChipsWidget extends StatelessWidget {
  final Function(String) onChipTap;

  const QuickActionChipsWidget({
    Key? key,
    required this.onChipTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> quickActions = [
      {'text': 'Explain my rights', 'icon': 'info'},
      {'text': 'Review recent access', 'icon': 'history'},
      {'text': 'Help with consent', 'icon': 'help'},
    ];

    return Container(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: quickActions.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final action = quickActions[index];
          return GestureDetector(
            onTap: () => onChipTap(action['text']!),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: action['icon']!,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    action['text']!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
