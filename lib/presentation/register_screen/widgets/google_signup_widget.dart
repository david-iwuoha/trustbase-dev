import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoogleSignupWidget extends StatelessWidget {
  final VoidCallback onGoogleSignup;
  final bool isLoading;

  const GoogleSignupWidget({
    Key? key,
    required this.onGoogleSignup,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      constraints: BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          // Divider with "OR"
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'OR',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Google Sign-up Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton(
              onPressed: isLoading ? null : onGoogleSignup,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                  width: 1.5,
                ),
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImageWidget(
                          imageUrl:
                              'https://developers.google.com/identity/images/g-logo.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          semanticLabel:
                              'Google logo - colorful G icon for Google authentication',
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Continue with Google',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
