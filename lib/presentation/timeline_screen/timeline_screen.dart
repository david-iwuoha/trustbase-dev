import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_timeline_widget.dart';
import './widgets/filter_bar_widget.dart';
import './widgets/timeline_entry_card_widget.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool _isRefreshing = false;
  String _selectedDateRange = 'Last 30 days';
  String _selectedOrganization = 'All Organizations';
  List<String> _selectedDataTypes = [];

  // Mock timeline data
  final List<Map<String, dynamic>> _timelineEntries = [
    {
      "id": 1,
      "organization": "First Bank Nigeria",
      "organizationLogo":
          "https://images.unsplash.com/photo-1603698068022-96266b22898b",
      "semanticLabel":
          "Modern glass office building with blue tinted windows reflecting the sky",
      "dataTypes": ["Personal Info", "Transaction History"],
      "accessPurpose":
          "Account verification and transaction processing for mobile banking services",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "legalBasis": "Contractual Necessity",
      "retentionPeriod": "5 years",
      "trustImpact": "High",
      "specificFields": [
        "Full Name",
        "Phone Number",
        "Account Balance",
        "Transaction History"
      ],
      "isExpanded": false,
    },
    {
      "id": 2,
      "organization": "MTN Nigeria",
      "organizationLogo":
          "https://images.unsplash.com/photo-1644088379091-d574269d422f",
      "semanticLabel":
          "Close-up of interconnected network nodes with glowing connections on dark background",
      "dataTypes": ["Location Data", "Usage Patterns"],
      "accessPurpose": "Network optimization and personalized service delivery",
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
      "legalBasis": "Legitimate Interest",
      "retentionPeriod": "2 years",
      "trustImpact": "Medium",
      "specificFields": [
        "GPS Location",
        "Data Usage",
        "Call Duration",
        "SMS Count"
      ],
      "isExpanded": false,
    },
    {
      "id": 3,
      "organization": "Jumia Nigeria",
      "organizationLogo":
          "https://images.unsplash.com/photo-1618914241432-5043b1b4acf5",
      "semanticLabel":
          "Shopping cart filled with colorful packages and gift boxes on wooden surface",
      "dataTypes": ["Purchase History", "Delivery Address"],
      "accessPurpose":
          "Order processing and delivery coordination for recent purchase",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "legalBasis": "Contractual Necessity",
      "retentionPeriod": "3 years",
      "trustImpact": "High",
      "specificFields": [
        "Home Address",
        "Purchase History",
        "Payment Method",
        "Product Preferences"
      ],
      "isExpanded": false,
    },
    {
      "id": 4,
      "organization": "Nigerian National Petroleum Corporation",
      "organizationLogo":
          "https://images.unsplash.com/photo-1678984239471-4c535fd15dce",
      "semanticLabel":
          "Industrial oil refinery with tall metal towers and pipes against blue sky",
      "dataTypes": ["Vehicle Registration", "Fuel Purchase History"],
      "accessPurpose":
          "Fuel subsidy verification and consumption pattern analysis",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "legalBasis": "Legal Obligation",
      "retentionPeriod": "7 years",
      "trustImpact": "High",
      "specificFields": [
        "Vehicle License Plate",
        "Fuel Purchase Amount",
        "Purchase Location",
        "Driver ID"
      ],
      "isExpanded": false,
    },
    {
      "id": 5,
      "organization": "Access Bank",
      "organizationLogo":
          "https://images.unsplash.com/photo-1571840615771-acc2e9f42641",
      "semanticLabel":
          "Modern banking hall with glass walls and customers at service counters",
      "dataTypes": ["Personal Info", "Financial History"],
      "accessPurpose": "Credit assessment for loan application review",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "legalBasis": "Consent",
      "retentionPeriod": "10 years",
      "trustImpact": "Medium",
      "specificFields": [
        "Credit Score",
        "Employment Status",
        "Monthly Income",
        "Existing Loans"
      ],
      "isExpanded": false,
    },
  ];

  // Available filter options
  final List<String> _dateRangeOptions = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'Custom range'
  ];

  final List<String> _organizationOptions = [
    'All Organizations',
    'First Bank Nigeria',
    'MTN Nigeria',
    'Jumia Nigeria',
    'Nigerian National Petroleum Corporation',
    'Access Bank'
  ];

  final List<String> _dataTypeOptions = [
    'Personal Info',
    'Location Data',
    'Contacts',
    'Transaction History',
    'Usage Patterns',
    'Purchase History',
    'Delivery Address',
    'Vehicle Registration',
    'Fuel Purchase History',
    'Financial History'
  ];

  @override
  void initState() {
    super.initState();
    _loadTimelineData();
  }

  Future<void> _loadTimelineData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> _refreshData() async {
    await _loadTimelineData();
    Fluttertoast.showToast(
      msg: "Timeline refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  List<Map<String, dynamic>> get _filteredEntries {
    List<Map<String, dynamic>> filtered = List.from(_timelineEntries);

    // Filter by organization
    if (_selectedOrganization != 'All Organizations') {
      filtered = filtered
          .where((entry) => entry['organization'] == _selectedOrganization)
          .toList();
    }

    // Filter by data types
    if (_selectedDataTypes.isNotEmpty) {
      filtered = filtered.where((entry) {
        List<String> entryDataTypes =
            List<String>.from(entry['dataTypes'] ?? []);
        return _selectedDataTypes.any((type) => entryDataTypes.contains(type));
      }).toList();
    }

    // Sort by timestamp (most recent first)
    filtered.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    return filtered;
  }

  void _toggleEntryExpansion(int entryId) {
    setState(() {
      final entryIndex =
          _timelineEntries.indexWhere((entry) => entry['id'] == entryId);
      if (entryIndex != -1) {
        _timelineEntries[entryIndex]['isExpanded'] =
            !_timelineEntries[entryIndex]['isExpanded'];
      }
    });
  }

  void _explainAccess(Map<String, dynamic> entry) {
    Navigator.pushNamed(
      context,
      AppRoutes.yarnGptChat,
      arguments: {
        'context': 'timeline_entry',
        'entry_data': entry,
        'initial_message':
            'Can you explain this data access: ${entry['organization']} accessed my ${entry['dataTypes'].join(', ')} for ${entry['accessPurpose']}'
      },
    );
  }

  void _reportIssue(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReportIssueModal(entry),
    );
  }

  void _revokeAccess(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Revoke Future Access',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        content: Text(
          'Are you sure you want to revoke future access for ${entry['organization']}? This may affect some services.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontSize: 12.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Future access revoked for ${entry['organization']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text(
              'Revoke',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportIssueModal(Map<String, dynamic> entry) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.9),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                Text(
                  'Report Issue',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 2.h),

                Text(
                  'What type of issue would you like to report?',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 3.h),

                // Issue type buttons
                ...[
                  'Unauthorized Access',
                  'Incorrect Data Usage',
                  'Privacy Violation',
                  'Data Retention Concern',
                  'Other Issue'
                ]
                    .map((issueType) => Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                msg: "Issue reported: $issueType",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              side: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'report',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 5.w,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    issueType,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                CustomIconWidget(
                                  iconName: 'arrow_forward',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                  size: 4.w,
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _askYarnGPT() {
    List<Map<String, dynamic>> selectedEntries =
        _filteredEntries.where((entry) => entry['isExpanded'] == true).toList();

    Navigator.pushNamed(
      context,
      AppRoutes.yarnGptChat,
      arguments: {
        'context': 'timeline_analysis',
        'selected_entries': selectedEntries,
        'initial_message': selectedEntries.isNotEmpty
            ? 'Can you analyze these selected timeline entries for privacy insights?'
            : 'I need help understanding my privacy timeline. Can you provide some general privacy analysis?'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _filteredEntries;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Privacy Timeline',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: _isRefreshing
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Filter Bar
          FilterBarWidget(
            selectedDateRange: _selectedDateRange,
            selectedOrganization: _selectedOrganization,
            selectedDataTypes: _selectedDataTypes,
            dateRangeOptions: _dateRangeOptions,
            organizationOptions: _organizationOptions,
            dataTypeOptions: _dataTypeOptions,
            onDateRangeChanged: (value) =>
                setState(() => _selectedDateRange = value),
            onOrganizationChanged: (value) =>
                setState(() => _selectedOrganization = value),
            onDataTypesChanged: (value) =>
                setState(() => _selectedDataTypes = value),
          ),

          // Timeline Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: filteredEntries.isEmpty
                  ? EmptyTimelineWidget(
                      onConnectOrganizations: () {
                        Fluttertoast.showToast(
                          msg: "Connect organizations feature coming soon",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      },
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 2.w,
                        right: 2.w,
                        top: 1.h,
                        bottom: 12.h, // Space for FAB
                      ),
                      itemCount: filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = filteredEntries[index];
                        return TimelineEntryCardWidget(
                          entry: entry,
                          onTap: () =>
                              _toggleEntryExpansion(entry['id'] as int),
                          onExplainAccess: () => _explainAccess(entry),
                          onReportIssue: () => _reportIssue(entry),
                          onRevokeAccess: () => _revokeAccess(entry),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _askYarnGPT,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
        elevation: 8,
        icon: CustomIconWidget(
          iconName: 'psychology',
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          size: 5.w,
        ),
        label: Text(
          'Ask YarnGPT',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
