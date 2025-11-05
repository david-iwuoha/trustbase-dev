import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyTimelineWidget extends StatelessWidget {
  final VoidCallback onConnectOrganizations;

  const EmptyTimelineWidget({
    Key? key,
    required this.onConnectOrganizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Illustration
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: CustomImageWidget(
                      imageUrl:
                          'https://images.unsplash.com/photo-1551288049-bebda4e38f71',
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.cover,
                      semanticLabel:
                          'Diverse group of people working together on laptops in modern office space with data visualization charts on screens',
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Title
                  Text(
                    'Your Privacy Timeline Awaits',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),

                  // Description
                  Text(
                    'Connect with organizations to see how your data is being accessed and used. Build trust through transparency.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      height: 1.5,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),

                  // Features List
                  Column(
                    children: [
                      _buildFeatureItem(
                        icon: 'timeline',
                        title: 'Real-time Access Tracking',
                        description:
                            'See exactly when and how your data is accessed',
                      ),
                      SizedBox(height: 2.h),
                      _buildFeatureItem(
                        icon: 'psychology',
                        title: 'AI-Powered Insights',
                        description:
                            'Get personalized privacy recommendations from YarnGPT',
                      ),
                      SizedBox(height: 2.h),
                      _buildFeatureItem(
                        icon: 'security',
                        title: 'Trust & Control',
                        description:
                            'Manage permissions and understand data usage patterns',
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onConnectOrganizations,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 2.5.h),
                        elevation: 4,
                        shadowColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: CustomIconWidget(
                        iconName: 'add_link',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 5.w,
                      ),
                      label: Text(
                        'Connect Organizations',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Secondary Action
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to learn more or help
                    },
                    icon: CustomIconWidget(
                      iconName: 'help_outline',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    label: Text(
                      'Learn More About Privacy Timeline',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 5.w,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                  fontSize: 10.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
