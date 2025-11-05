import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageIndicatorWidget extends StatelessWidget {
  final String currentLanguage;
  final VoidCallback onLanguageTap;

  const LanguageIndicatorWidget({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onLanguageTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'language',
              color: AppTheme.lightTheme.primaryColor,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              currentLanguage,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.primaryColor,
              size: 3.w,
            ),
          ],
        ),
      ),
    );
  }
}
