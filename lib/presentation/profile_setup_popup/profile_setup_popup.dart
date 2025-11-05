import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_selector_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/profile_avatar_widget.dart';

class ProfileSetupPopup extends StatefulWidget {
  const ProfileSetupPopup({Key? key}) : super(key: key);

  @override
  State<ProfileSetupPopup> createState() => _ProfileSetupPopupState();
}

class _ProfileSetupPopupState extends State<ProfileSetupPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();

  XFile? _selectedImage;
  String _selectedLanguage = 'en';
  bool _isLoading = false;

  final Map<String, bool> _notificationPreferences = {
    'consent_changes': true,
    'data_access': true,
    'yarngpt_updates': false,
  };

  // Mock user data for demonstration
  final Map<String, dynamic> _mockUserData = {
    'id': 'user_001',
    'email': 'adaeze.okafor@email.com',
    'displayName': '',
    'phone': '',
    'language': 'en',
    'profileImage': null,
    'notificationPreferences': {
      'consent_changes': true,
      'data_access': true,
      'yarngpt_updates': false,
    },
    'isProfileComplete': false,
    'createdAt': DateTime.now().subtract(Duration(hours: 2)),
    'lastUpdated': DateTime.now(),
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _displayNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _loadUserData() {
    // Simulate loading existing user data
    _displayNameController.text = _mockUserData['displayName'] ?? '';
    _phoneController.text = _mockUserData['phone'] ?? '';
    _selectedLanguage = _mockUserData['language'] ?? 'en';

    final prefs =
        _mockUserData['notificationPreferences'] as Map<String, dynamic>?;
    if (prefs != null) {
      _notificationPreferences.addAll(prefs.cast<String, bool>());
    }
  }

  String? _validateDisplayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required';
    }
    if (value.trim().length < 2) {
      return 'Display name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Nigerian phone number validation
    final phoneRegex = RegExp(r'^(\+234|0)[789][01]\d{8}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Please enter a valid Nigerian phone number';
    }
    return null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate API call delay
      await Future.delayed(Duration(milliseconds: 1500));

      // Update mock user data
      _mockUserData['displayName'] = _displayNameController.text.trim();
      _mockUserData['phone'] = _phoneController.text.trim();
      _mockUserData['language'] = _selectedLanguage;
      _mockUserData['profileImage'] = _selectedImage?.path;
      _mockUserData['notificationPreferences'] =
          Map.from(_notificationPreferences);
      _mockUserData['isProfileComplete'] = true;
      _mockUserData['lastUpdated'] = DateTime.now();

      // Show success animation
      await _animationController.reverse();

      // Provide success haptic feedback
      HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
      }
    } catch (e) {
      // Handle error
      HapticFeedback.heavyImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _skipForNow() {
    HapticFeedback.selectionClick();

    // Set reminder for profile completion
    _mockUserData['profileReminderCount'] =
        (_mockUserData['profileReminderCount'] ?? 0) + 1;
    _mockUserData['lastSkipped'] = DateTime.now();

    Navigator.pushReplacementNamed(context, '/dashboard-screen');
  }

  Widget _buildGlassmorphismCard() {
    return Container(
      width: 90.w,
      constraints: BoxConstraints(maxHeight: 85.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(6.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                SizedBox(height: 4.h),
                _buildProfileSection(),
                SizedBox(height: 4.h),
                _buildFormFields(),
                SizedBox(height: 4.h),
                _buildLanguageSection(),
                SizedBox(height: 4.h),
                _buildNotificationSection(),
                SizedBox(height: 6.h),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Complete Your Profile',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Help us personalize your TrustBase experience',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        ProfileAvatarWidget(
          selectedImage: _selectedImage,
          onImageSelected: (image) {
            setState(() {
              _selectedImage = image;
            });
          },
        ),
        SizedBox(height: 2.h),
        Text(
          'Tap to add profile photo',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _displayNameController,
          validator: _validateDisplayName,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Display Name',
            hintText: 'Enter your display name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        TextFormField(
          controller: _phoneController,
          validator: _validatePhone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: '+234 or 0 followed by number',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'phone',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return LanguageSelectorWidget(
      selectedLanguage: _selectedLanguage,
      onLanguageChanged: (language) {
        setState(() {
          _selectedLanguage = language;
        });
      },
    );
  }

  Widget _buildNotificationSection() {
    return NotificationPreferencesWidget(
      preferences: _notificationPreferences,
      onPreferenceChanged: (key, value) {
        setState(() {
          _notificationPreferences[key] = value;
        });
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              elevation: 2,
              shadowColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    'Save Profile',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: TextButton(
            onPressed: _isLoading ? null : _skipForNow,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Skip for Now',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Center(
                child: _buildGlassmorphismCard(),
              ),
            ),
          );
        },
      ),
    );
  }
}