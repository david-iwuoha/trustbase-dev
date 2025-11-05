import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBarWidget extends StatelessWidget {
  final String selectedDateRange;
  final String selectedOrganization;
  final List<String> selectedDataTypes;
  final List<String> dateRangeOptions;
  final List<String> organizationOptions;
  final List<String> dataTypeOptions;
  final Function(String) onDateRangeChanged;
  final Function(String) onOrganizationChanged;
  final Function(List<String>) onDataTypesChanged;

  const FilterBarWidget({
    Key? key,
    required this.selectedDateRange,
    required this.selectedOrganization,
    required this.selectedDataTypes,
    required this.dateRangeOptions,
    required this.organizationOptions,
    required this.dataTypeOptions,
    required this.onDateRangeChanged,
    required this.onOrganizationChanged,
    required this.onDataTypesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
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
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'filter_list',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Filter Timeline',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    const Spacer(),
                    if (selectedDataTypes.isNotEmpty ||
                        selectedOrganization != 'All Organizations')
                      TextButton(
                        onPressed: () {
                          onOrganizationChanged('All Organizations');
                          onDataTypesChanged([]);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                        ),
                        child: Text(
                          'Clear',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Date Range Selector
                _buildFilterChip(
                  context,
                  title: 'Date Range',
                  subtitle: selectedDateRange,
                  onTap: () => _showDateRangePicker(context),
                ),
                SizedBox(height: 1.h),

                // Organization Selector
                _buildFilterChip(
                  context,
                  title: 'Organization',
                  subtitle: selectedOrganization,
                  onTap: () => _showOrganizationPicker(context),
                ),
                SizedBox(height: 1.h),

                // Data Types Selector
                _buildFilterChip(
                  context,
                  title: 'Data Types',
                  subtitle: selectedDataTypes.isEmpty
                      ? 'All Types'
                      : selectedDataTypes.length == 1
                          ? selectedDataTypes.first
                          : '${selectedDataTypes.length} selected',
                  onTap: () => _showDataTypesPicker(context),
                  hasMultipleSelection: selectedDataTypes.length > 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool hasMultipleSelection = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subtitle,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasMultipleSelection) ...[
                        SizedBox(width: 1.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.5.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${selectedDataTypes.length}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color:
                                  AppTheme.lightTheme.colorScheme.onSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 9.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPickerModal(
        context,
        title: 'Select Date Range',
        options: dateRangeOptions,
        selectedOption: selectedDateRange,
        onSelect: (value) {
          onDateRangeChanged(value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showOrganizationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPickerModal(
        context,
        title: 'Select Organization',
        options: organizationOptions,
        selectedOption: selectedOrganization,
        onSelect: (value) {
          onOrganizationChanged(value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDataTypesPicker(BuildContext context) {
    List<String> tempSelectedTypes = List.from(selectedDataTypes);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 60.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
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

                    // Title
                    Row(
                      children: [
                        Text(
                          'Select Data Types',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempSelectedTypes.clear();
                            });
                          },
                          child: Text(
                            'Clear All',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Data type options
                    Expanded(
                      child: ListView.builder(
                        itemCount: dataTypeOptions.length,
                        itemBuilder: (context, index) {
                          final dataType = dataTypeOptions[index];
                          final isSelected =
                              tempSelectedTypes.contains(dataType);

                          return CheckboxListTile(
                            title: Text(
                              dataType,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            value: isSelected,
                            onChanged: (value) {
                              setModalState(() {
                                if (value == true) {
                                  tempSelectedTypes.add(dataType);
                                } else {
                                  tempSelectedTypes.remove(dataType);
                                }
                              });
                            },
                            activeColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            contentPadding: EdgeInsets.zero,
                          );
                        },
                      ),
                    ),

                    // Action buttons
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              side: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              onDataTypesChanged(tempSelectedTypes);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                            child: Text(
                              'Apply (${tempSelectedTypes.length})',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
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
        ),
      ),
    );
  }

  Widget _buildPickerModal(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String selectedOption,
    required Function(String) onSelect,
  }) {
    return Container(
      height: 50.h,
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
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),

                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option == selectedOption;

                      return ListTile(
                        title: Text(
                          option,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                        trailing: isSelected
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 5.w,
                              )
                            : null,
                        onTap: () => onSelect(option),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
