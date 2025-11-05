import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/glassmorphism_card_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String _selectedLanguage = 'en';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for demo
  final Map<String, String> _mockCredentials = {
    'admin@trustbase.ng': 'admin123',
    'user@trustbase.ng': 'user123',
    'demo@trustbase.ng': 'demo123',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_mockCredentials.containsKey(email.toLowerCase()) &&
        _mockCredentials[email.toLowerCase()] == password) {
      // Success haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
      }
    } else {
      // Error handling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _getLocalizedText('invalid_credentials'),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    // Simulate Google Sign-in process
    await Future.delayed(const Duration(seconds: 3));

    // Success haptic feedback
    HapticFeedback.lightImpact();

    // Navigate to dashboard
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard-screen');
    }

    if (mounted) {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  void _handleLanguageChange(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Show language change confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _getLocalizedText('language_changed'),
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getLocalizedText(String key) {
    final Map<String, Map<String, String>> localizedStrings = {
      'en': {
        'welcome_back': 'Welcome Back',
        'login_subtitle':
            'Sign in to manage your data consent and privacy settings',
        'invalid_credentials': 'Invalid email or password. Please try again.',
        'language_changed': 'Language updated successfully',
        'new_user': 'New user?',
        'register': 'Register',
      },
      'ig': {
        'welcome_back': 'Nnọọ Azụ',
        'login_subtitle': 'Banye iji jikwaa nkwenye data gị na ntọala nzuzo',
        'invalid_credentials':
            'Email ma ọ bụ paswọọdụ ezighi ezi. Biko nwaa ọzọ.',
        'language_changed': 'Asụsụ emelitela nke ọma',
        'new_user': 'Onye ọrụ ọhụrụ?',
        'register': 'Debanye aha',
      },
      'yo': {
        'welcome_back': 'Kaabo Pada',
        'login_subtitle': 'Wọle lati ṣakoso ifọwọsi data rẹ ati awọn eto aṣiri',
        'invalid_credentials':
            'Email tabi ọrọ igbaniwọle ti ko tọ. Jọwọ gbiyanju lẹẹkansi.',
        'language_changed': 'Ede ti yipada ni aṣeyọri',
        'new_user': 'Olumulo tuntun?',
        'register': 'Forukọsilẹ',
      },
      'ha': {
        'welcome_back': 'Maraba da Dawowa',
        'login_subtitle': 'Shiga don sarrafa yarda da saitunan sirri',
        'invalid_credentials':
            'Email ko kalmar sirri ba daidai ba. Ka sake gwadawa.',
        'language_changed': 'An sabunta harshe cikin nasara',
        'new_user': 'Sabon mai amfani?',
        'register': 'Yi rajista',
      },
    };

    return localizedStrings[_selectedLanguage]?[key] ??
        localizedStrings['en']?[key] ??
        key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.scaffoldBackgroundColor,
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Language Selector
              Positioned(
                top: 2.h,
                right: 4.w,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: LanguageSelectorWidget(
                    selectedLanguage: _selectedLanguage,
                    onLanguageChanged: _handleLanguageChange,
                  ),
                ),
              ),

              // Main Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 8.h),

                        // App Logo
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'TB',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Welcome Text
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                _getLocalizedText('welcome_back'),
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                _getLocalizedText('login_subtitle'),
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Login Form Card
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: GlassmorphismCardWidget(
                              child: Column(
                                children: [
                                  LoginFormWidget(
                                    onLogin: _handleLogin,
                                    isLoading: _isLoading,
                                  ),
                                  SizedBox(height: 3.h),
                                  SocialLoginWidget(
                                    onGoogleSignIn: _handleGoogleSignIn,
                                    isLoading: _isGoogleLoading,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Register Link
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getLocalizedText('new_user'),
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              TextButton(
                                onPressed: (_isLoading || _isGoogleLoading)
                                    ? null
                                    : () {
                                        Navigator.pushNamed(
                                            context, '/register-screen');
                                      },
                                child: Text(
                                  _getLocalizedText('register'),
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
