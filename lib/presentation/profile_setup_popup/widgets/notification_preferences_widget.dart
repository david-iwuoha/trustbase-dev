import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatelessWidget {
  final Map<String, bool> preferences;
  final Function(String, bool) onPreferenceChanged;

  const NotificationPreferencesWidget({
    Key? key,
    required this.preferences,
    required this.onPreferenceChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> _notificationTypes = const [
    {
      'key': 'consent_changes',
      'title': 'Consent Changes',
      'description':
          'Get notified when organizations request new permissions or modify existing ones',
      'icon': 'security',
    },
    {
      'key': 'data_access',
      'title': 'Data Access Alerts',
      'description':
          'Receive alerts when your data is accessed by organizations',
      'icon': 'visibility',
    },
    {
      'key': 'yarngpt_updates',
      'title': 'YarnGPT Updates',
      'description': 'Stay informed about new AI features and privacy insights',
      'icon': 'smart_toy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Text(
                'Notification Preferences',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ..._notificationTypes.map((notificationType) {
            final key = notificationType['key'] as String;
            final isEnabled = preferences[key] ?? false;

            return Container(
              margin: EdgeInsets.only(bottom: 3.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? AppTheme.lightTheme.colorScheme.primaryContainer
                              .withValues(alpha: 0.2)
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: notificationType['icon'] as String,
                        size: 5.w,
                        color: isEnabled
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificationType['title'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          notificationType['description'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isEnabled,
                      onChanged: (value) => onPreferenceChanged(key, value),
                      activeThumbColor: AppTheme.lightTheme.colorScheme.primary,
                      activeTrackColor: AppTheme
                          .lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                      inactiveThumbColor:
                          AppTheme.lightTheme.colorScheme.outline,
                      inactiveTrackColor: AppTheme
                          .lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'You can change these preferences anytime in Settings',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
