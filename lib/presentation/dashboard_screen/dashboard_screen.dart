import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../timeline_screen/timeline_screen.dart';
import './widgets/empty_state_widget.dart';
import './widgets/organization_card_widget.dart';
import './widgets/profile_setup_popup_widget.dart';
import './widgets/summary_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showProfileSetup = true;
  bool _isRefreshing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for dashboard
  final List<Map<String, dynamic>> _organizations = [
    {
      "id": 1,
      "name": "First Bank Nigeria",
      "logo": "https://images.unsplash.com/photo-1603698068022-96266b22898b",
      "semanticLabel":
          "Modern glass office building with blue tinted windows reflecting the sky",
      "trustScore": "8.5",
      "consentGranted": true,
      "dataTypes": ["Personal Info", "Transaction History", "Contact Details"],
      "lastAccess": "2 hours ago"
    },
    {
      "id": 2,
      "name": "MTN Nigeria",
      "logo": "https://images.unsplash.com/photo-1644088379091-d574269d422f",
      "semanticLabel":
          "Close-up of interconnected network nodes with glowing connections on dark background",
      "trustScore": "7.2",
      "consentGranted": false,
      "dataTypes": ["Call Records", "Location Data", "Usage Patterns"],
      "lastAccess": "1 day ago"
    },
    {
      "id": 3,
      "name": "Jumia Nigeria",
      "logo": "https://images.unsplash.com/photo-1618914241432-5043b1b4acf5",
      "semanticLabel":
          "Shopping cart filled with colorful packages and gift boxes on wooden surface",
      "trustScore": "6.8",
      "consentGranted": true,
      "dataTypes": ["Purchase History", "Delivery Address", "Payment Info"],
      "lastAccess": "5 hours ago"
    },
    {
      "id": 4,
      "name": "Nigerian National Petroleum Corporation",
      "logo": "https://images.unsplash.com/photo-1678984239471-4c535fd15dce",
      "semanticLabel":
          "Industrial oil refinery with tall metal towers and pipes against blue sky",
      "trustScore": "9.1",
      "consentGranted": true,
      "dataTypes": ["Vehicle Registration", "Fuel Purchase History"],
      "lastAccess": "3 days ago"
    },
  ];

  final Map<String, dynamic> _summaryData = {
    "totalConsents": "12",
    "activeConsents": "8",
    "recentAccesses": "24",
    "trustScore": "7.8"
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
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
    await _loadDashboardData();
    Fluttertoast.showToast(
      msg: "Dashboard data refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleConsent(int organizationId, bool newValue) {
    setState(() {
      final orgIndex =
          _organizations.indexWhere((org) => org['id'] == organizationId);
      if (orgIndex != -1) {
        _organizations[orgIndex]['consentGranted'] = newValue;
      }
    });

    final orgName =
        _organizations.firstWhere((org) => org['id'] == organizationId)['name'];
    Fluttertoast.showToast(
      msg: newValue
          ? "Consent granted to $orgName"
          : "Consent revoked from $orgName",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showOrganizationDetails(Map<String, dynamic> organization) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOrganizationDetailsModal(organization),
    );
  }

  Widget _buildOrganizationDetailsModal(Map<String, dynamic> organization) {
    return Container(
      height: 70.h,
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

                // Organization header
                Row(
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                      ),
                      child: CustomImageWidget(
                        imageUrl: organization['logo'] as String? ?? '',
                        width: 16.w,
                        height: 16.w,
                        fit: BoxFit.cover,
                        semanticLabel:
                            organization['semanticLabel'] as String? ??
                                'Organization logo',
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            organization['name'] as String? ??
                                'Unknown Organization',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Trust Score: ${organization['trustScore']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Data types section
                Text(
                  'Data Types Shared',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: ((organization['dataTypes'] as List?) ?? [])
                      .map<Widget>((dataType) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        dataType as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontSize: 11.sp,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 4.h),

                // Last access
                Text(
                  'Last Access: ${organization['lastAccess']}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                    fontSize: 12.sp,
                  ),
                ),
                const Spacer(),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _revokeAllConsents(organization);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          side: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.error,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Revoke All',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.error,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _contactOrganization(organization);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Contact',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _revokeAllConsents(Map<String, dynamic> organization) {
    setState(() {
      final orgIndex =
          _organizations.indexWhere((org) => org['id'] == organization['id']);
      if (orgIndex != -1) {
        _organizations[orgIndex]['consentGranted'] = false;
      }
    });

    Fluttertoast.showToast(
      msg: "All consents revoked from ${organization['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _contactOrganization(Map<String, dynamic> organization) {
    Fluttertoast.showToast(
      msg: "Opening contact options for ${organization['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _addOrganization() {
    Fluttertoast.showToast(
      msg: "Add organization feature coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Text(
                'Overview',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(
              height: 18.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                children: [
                  SummaryCardWidget(
                    title: 'Total Consents',
                    value: _summaryData['totalConsents'] as String,
                    subtitle: 'Organizations connected',
                  ),
                  SummaryCardWidget(
                    title: 'Active Consents',
                    value: _summaryData['activeConsents'] as String,
                    subtitle: 'Currently sharing data',
                  ),
                  SummaryCardWidget(
                    title: 'Recent Accesses',
                    value: _summaryData['recentAccesses'] as String,
                    subtitle: 'In the last 7 days',
                  ),
                  SummaryCardWidget(
                    title: 'Trust Score',
                    value: _summaryData['trustScore'] as String,
                    subtitle: 'Average across all orgs',
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            // Organizations Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Organizations',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addOrganization,
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    label: Text(
                      'Add',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Organizations List or Empty State
            _organizations.isEmpty
                ? EmptyStateWidget(onAddOrganization: _addOrganization)
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _organizations.length,
                    itemBuilder: (context, index) {
                      final organization = _organizations[index];
                      return OrganizationCardWidget(
                        organization: organization,
                        onConsentToggle: (value) =>
                            _toggleConsent(organization['id'] as int, value),
                        onViewDetails: () =>
                            _showOrganizationDetails(organization),
                        onRevokeAll: () => _revokeAllConsents(organization),
                        onContact: () => _contactOrganization(organization),
                      );
                    },
                  ),
            SizedBox(height: 10.h), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: tabName == 'Timeline'
                ? 'timeline'
                : tabName == 'YarnGPT'
                    ? 'chat'
                    : 'settings',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20.w,
          ),
          SizedBox(height: 2.h),
          Text(
            '$tabName Coming Soon',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This feature is under development',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: Drawer(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    backgroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'John Doe',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    'john.doe@email.com',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.8),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Profile',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile-setup-popup');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'language',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Language',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Language settings coming soon",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'help',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Help & Support',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Help & Support coming soon",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'logout',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'Logout',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontSize: 12.sp,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: CustomIconWidget(
            iconName: 'menu',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'TrustBase',
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
          indicatorWeight: 3,
          labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
          ),
          unselectedLabelStyle:
              AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 11.sp,
          ),
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Timeline'),
            Tab(text: 'YarnGPT'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildDashboardTab(),
              TimelineScreen(),
              _buildPlaceholderTab('YarnGPT'),
              _buildPlaceholderTab('Settings'),
            ],
          ),
          if (_showProfileSetup)
            ProfileSetupPopupWidget(
              onCompleteNow: () {
                setState(() {
                  _showProfileSetup = false;
                });
                Navigator.pushNamed(context, '/profile-setup-popup');
              },
              onLater: () {
                setState(() {
                  _showProfileSetup = false;
                });
                Fluttertoast.showToast(
                  msg: "You can complete your profile later from the menu",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _addOrganization,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              elevation: 8,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text(
                'Add Organization',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            )
          : null,
    );
  }
}
