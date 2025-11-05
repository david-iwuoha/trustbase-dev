import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimelineEntryCardWidget extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onTap;
  final VoidCallback onExplainAccess;
  final VoidCallback onReportIssue;
  final VoidCallback onRevokeAccess;

  const TimelineEntryCardWidget({
    Key? key,
    required this.entry,
    required this.onTap,
    required this.onExplainAccess,
    required this.onReportIssue,
    required this.onRevokeAccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime timestamp = entry['timestamp'] as DateTime;
    final List<String> dataTypes = List<String>.from(entry['dataTypes'] ?? []);
    final bool isExpanded = entry['isExpanded'] as bool? ?? false;
    final String trustImpact = entry['trustImpact'] as String? ?? 'Unknown';
    final String organization = entry['organization'] as String? ?? 'Unknown Organization';
    final String organizationLogo = entry['organizationLogo'] as String? ?? '';
    final String semanticLabel = entry['semanticLabel'] as String? ?? 'Organization logo';
    final String accessPurpose = entry['accessPurpose'] as String? ?? 'No purpose specified';

    return Slidable(
      key: ValueKey(entry['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onExplainAccess(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
            icon: Icons.psychology,
            label: 'Explain',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onReportIssue(),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            icon: Icons.report,
            label: 'Report',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onRevokeAccess(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            icon: Icons.block,
            label: 'Revoke',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          // Organization Logo
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                            ),
                            child: organizationLogo.isNotEmpty
                                ? CustomImageWidget(
                                    imageUrl: organizationLogo,
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

                          // Organization Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        organization,
                                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: _getTrustImpactColor(trustImpact).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _getTrustImpactColor(trustImpact).withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        trustImpact,
                                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                          color: _getTrustImpactColor(trustImpact),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 9.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  _formatTimestamp(timestamp),
                                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Expand/Collapse Icon
                          CustomIconWidget(
                            iconName: isExpanded ? 'keyboard_arrow_up' : 'keyboard_arrow_down',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // Data Types
                      Wrap(
                        spacing: 1.5.w,
                        runSpacing: 1.h,
                        children: dataTypes.map((dataType) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.8.h),
                            decoration: BoxDecoration(
                              color: _getDataTypeColor(dataType).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getDataTypeColor(dataType).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: _getDataTypeIcon(dataType),
                                  color: _getDataTypeColor(dataType),
                                  size: 3.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  dataType,
                                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                    color: _getDataTypeColor(dataType),
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 2.h),

                      // Access Purpose
                      Text(
                        accessPurpose,
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 11.sp,
                          height: 1.4,
                        ),
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded ? null : TextOverflow.ellipsis,
                      ),

                      // Expanded Details
                      if (isExpanded) ...[
                        SizedBox(height: 3.h),
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detailed Information',
                                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),

                              // Legal Basis
                              _buildDetailRow(
                                'Legal Basis',
                                entry['legalBasis'] as String? ?? 'Not specified',
                                Icons.gavel,
                              ),
                              SizedBox(height: 1.5.h),

                              // Retention Period
                              _buildDetailRow(
                                'Retention Period',
                                entry['retentionPeriod'] as String? ?? 'Not specified',
                                Icons.schedule,
                              ),
                              SizedBox(height: 1.5.h),

                              // Specific Fields
                              _buildDetailRow(
                                'Data Fields Accessed',
                                (entry['specificFields'] as List?)?.join(', ') ?? 'Not specified',
                                Icons.view_list,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 4.w,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11.sp,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Color _getTrustImpactColor(String trustImpact) {
    switch (trustImpact.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.tertiary; // Green
      case 'medium':
        return AppTheme.lightTheme.colorScheme.secondary; // Amber
      case 'low':
        return AppTheme.lightTheme.colorScheme.error; // Red
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  Color _getDataTypeColor(String dataType) {
    switch (dataType.toLowerCase()) {
      case 'personal info':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'location data':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'contacts':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'transaction history':
        return AppTheme.lightTheme.colorScheme.error;
      case 'usage patterns':
        return const Color(0xFF9C27B0); // Purple
      case 'purchase history':
        return const Color(0xFFFF9800); // Orange
      case 'delivery address':
        return const Color(0xFF607D8B); // Blue Grey
      case 'vehicle registration':
        return const Color(0xFF795548); // Brown
      case 'fuel purchase history':
        return const Color(0xFF4CAF50); // Light Green
      case 'financial history':
        return const Color(0xFF2196F3); // Blue
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  String _getDataTypeIcon(String dataType) {
    switch (dataType.toLowerCase()) {
      case 'personal info':
        return 'person';
      case 'location data':
        return 'location_on';
      case 'contacts':
        return 'contacts';
      case 'transaction history':
        return 'account_balance_wallet';
      case 'usage patterns':
        return 'analytics';
      case 'purchase history':
        return 'shopping_cart';
      case 'delivery address':
        return 'local_shipping';
      case 'vehicle registration':
        return 'directions_car';
      case 'fuel purchase history':
        return 'local_gas_station';
      case 'financial history':
        return 'attach_money';
      default:
        return 'data_usage';
    }
  }
}