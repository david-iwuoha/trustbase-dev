import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui';

import '../../../core/app_export.dart';

class OrganizationCardWidget extends StatelessWidget {
  final Map<String, dynamic> organization;
  final Function(bool) onConsentToggle;
  final VoidCallback onViewDetails;
  final VoidCallback onRevokeAll;
  final VoidCallback onContact;

  const OrganizationCardWidget({
    Key? key,
    required this.organization,
    required this.onConsentToggle,
    required this.onViewDetails,
    required this.onRevokeAll,
    required this.onContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isConsentGranted =
        organization['consentGranted'] as bool? ?? false;
    final String trustScore = organization['trustScore'] as String? ?? '0';
    final String organizationName =
        organization['name'] as String? ?? 'Unknown Organization';
    final String logoUrl = organization['logo'] as String? ?? '';
    final String semanticLabel =
        organization['semanticLabel'] as String? ?? 'Organization logo';

    return Slidable(
      key: ValueKey(organization['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onViewDetails(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            icon: Icons.visibility,
            label: 'Details',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onRevokeAll(),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            icon: Icons.block,
            label: 'Revoke',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onContact(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
            icon: Icons.contact_support,
            label: 'Contact',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Organization Logo
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                    ),
                    child: logoUrl.isNotEmpty
                        ? CustomImageWidget(
                            imageUrl: logoUrl,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                            semanticLabel: semanticLabel,
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: 'business',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 6.w,
                            ),
                          ),
                  ),
                  SizedBox(width: 3.w),

                  // Organization Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                organizationName,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getTrustScoreColor(trustScore)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getTrustScoreColor(trustScore)
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                trustScore,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: _getTrustScoreColor(trustScore),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isConsentGranted
                                    ? 'Data sharing active'
                                    : 'Data sharing paused',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: isConsentGranted
                                      ? AppTheme.lightTheme.colorScheme.tertiary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                  fontSize: 11.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Switch(
                              value: isConsentGranted,
                              onChanged: onConsentToggle,
                              activeThumbColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                              inactiveThumbColor: AppTheme
                                  .lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                              inactiveTrackColor: AppTheme
                                  .lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ],
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

  Color _getTrustScoreColor(String score) {
    final double scoreValue = double.tryParse(score) ?? 0.0;
    if (scoreValue >= 8.0) {
      return AppTheme.lightTheme.colorScheme.tertiary; // Green for high trust
    } else if (scoreValue >= 6.0) {
      return AppTheme
          .lightTheme.colorScheme.secondary; // Amber for medium trust
    } else {
      return AppTheme.lightTheme.colorScheme.error; // Red for low trust
    }
  }
}