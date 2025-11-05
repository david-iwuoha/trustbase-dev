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
  final List<Map<String, String>> languages = [
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                'Select Language',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Language options
            ...languages.map((language) => ListTile(
                  leading: Text(
                    language['flag']!,
                    style: TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    language['name']!,
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  trailing: widget.selectedLanguage == language['code']
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    widget.onLanguageChanged(language['code']!);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String get _selectedLanguageName {
    return languages.firstWhere(
      (lang) => lang['code'] == widget.selectedLanguage,
      orElse: () => languages.first,
    )['name']!;
  }

  String get _selectedLanguageFlag {
    return languages.firstWhere(
      (lang) => lang['code'] == widget.selectedLanguage,
      orElse: () => languages.first,
    )['flag']!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageSelector,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedLanguageFlag,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 2.w),
            Text(
              _selectedLanguageName,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
