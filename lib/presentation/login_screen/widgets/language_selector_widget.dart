import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelectorWidget({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇳🇬'},
    {'code': 'ig', 'name': 'Igbo', 'flag': '🇳🇬'},
    {'code': 'yo', 'name': 'Yoruba', 'flag': '🇳🇬'},
    {'code': 'ha', 'name': 'Hausa', 'flag': '🇳🇬'},
  ];

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Language',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ..._languages
                      .map((language) => ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            leading: Text(
                              language['flag']!,
                              style: TextStyle(fontSize: 6.w),
                            ),
                            title: Text(
                              language['name']!,
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                fontWeight:
                                    widget.selectedLanguage == language['code']
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                              ),
                            ),
                            trailing: widget.selectedLanguage ==
                                    language['code']
                                ? CustomIconWidget(
                                    iconName: 'check_circle',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 5.w,
                                  )
                                : null,
                            onTap: () {
                              widget.onLanguageChanged(language['code']!);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentLanguageName() {
    return _languages.firstWhere(
      (lang) => lang['code'] == widget.selectedLanguage,
      orElse: () => _languages.first,
    )['name']!;
  }

  String _getCurrentLanguageFlag() {
    return _languages.firstWhere(
      (lang) => lang['code'] == widget.selectedLanguage,
      orElse: () => _languages.first,
    )['flag']!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageSelector,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getCurrentLanguageFlag(),
              style: TextStyle(fontSize: 4.w),
            ),
            SizedBox(width: 2.w),
            Text(
              _getCurrentLanguageName(),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
