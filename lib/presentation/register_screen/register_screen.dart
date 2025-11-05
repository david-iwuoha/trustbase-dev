
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/google_signup_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/registration_form_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String _selectedLanguage = 'en';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock user data for demonstration
  final List<Map<String, dynamic>> existingUsers = [
    {
      "email": "john.doe@example.com",
      "fullName": "John Doe",
      "password": "Password123",
    },
    {
      "email": "sarah.johnson@gmail.com",
      "fullName": "Sarah Johnson",
      "password": "SecurePass456",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
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
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Map<String, String> _getLocalizedStrings() {
    switch (_selectedLanguage) {
      case 'ig':
        return {
          'title': 'Mepụta Akaụntụ',
          'subtitle': 'Debanye aha gị ka ịmalite',
          'alreadyHaveAccount': 'Ị nwere akaụntụ?',
          'signIn': 'Banye',
          'successMessage': 'Akaụntụ emepụtara nke ọma!',
          'errorDuplicateEmail': 'Email a adịlarị. Biko jiri email ọzọ.',
          'errorWeakPassword':
              'Okwuntughe adịghị ike. Gbakwunye mkpụrụedemede ukwu na ọnụọgụgụ.',
          'errorNetworkIssue': 'Nsogbu netwọk. Biko nwalee ọzọ.',
        };
      case 'yo':
        return {
          'title': 'Ṣẹda Akọọlẹ',
          'subtitle': 'Tẹ alaye rẹ lati bẹrẹ',
          'alreadyHaveAccount': 'Ṣe o ni akọọlẹ tẹlẹ?',
          'signIn': 'Wọle',
          'successMessage': 'Akọọlẹ ti ṣẹda ni aṣeyọri!',
          'errorDuplicateEmail': 'Email yii ti wa tẹlẹ. Jọwọ lo email miiran.',
          'errorWeakPassword':
              'Ọrọigbaniwọle ko lagbara. Fi lẹta nla ati nọmba kun.',
          'errorNetworkIssue': 'Iṣoro nẹtiwọọki. Jọwọ gbiyanju lẹẹkansi.',
        };
      case 'ha':
        return {
          'title': 'Ƙirƙiri Asusun',
          'subtitle': 'Shigar da bayananku don farawa',
          'alreadyHaveAccount': 'Kuna da asusun?',
          'signIn': 'Shiga',
          'successMessage': 'An ƙirƙiri asusun cikin nasara!',
          'errorDuplicateEmail':
              'Wannan imel ɗin ya riga ya kasance. Da fatan za a yi amfani da wani imel.',
          'errorWeakPassword':
              'Kalmar sirri ba ta da ƙarfi. Ƙara manyan haruffa da lambobi.',
          'errorNetworkIssue':
              'Matsalar hanyar sadarwa. Da fatan za a sake gwadawa.',
        };
      default:
        return {
          'title': 'Create Account',
          'subtitle': 'Enter your details to get started',
          'alreadyHaveAccount': 'Already have an account?',
          'signIn': 'Sign In',
          'successMessage': 'Account created successfully!',
          'errorDuplicateEmail':
              'This email already exists. Please use a different email.',
          'errorWeakPassword':
              'Password is too weak. Add uppercase letters and numbers.',
          'errorNetworkIssue': 'Network issue. Please try again.',
        };
    }
  }

  Future<void> _handleRegister(
      String fullName, String email, String password) async {
    setState(() => _isLoading = true);

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 2));

      // Check for duplicate email
      bool emailExists = existingUsers.any((user) =>
          (user['email'] as String).toLowerCase() == email.toLowerCase());

      if (emailExists) {
        _showErrorMessage(_getLocalizedStrings()['errorDuplicateEmail']!);
        return;
      }

      // Simulate successful registration
      final localizedStrings = _getLocalizedStrings();

      Fluttertoast.showToast(
        msg: localizedStrings['successMessage']!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to profile setup popup
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile-setup-popup');
      }
    } catch (e) {
      _showErrorMessage(_getLocalizedStrings()['errorNetworkIssue']!);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignup() async {
    setState(() => _isGoogleLoading = true);

    try {
      // Simulate Google Sign-up process
      await Future.delayed(Duration(seconds: 2));

      final localizedStrings = _getLocalizedStrings();

      Fluttertoast.showToast(
        msg: localizedStrings['successMessage']!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to dashboard
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
      }
    } catch (e) {
      _showErrorMessage(_getLocalizedStrings()['errorNetworkIssue']!);
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  @override
  Widget build(BuildContext context) {
    final localizedStrings = _getLocalizedStrings();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
              AppTheme.lightTheme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 2.h),

                      // Back button and Language selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _navigateToLogin,
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface
                                    .withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: CustomIconWidget(
                                iconName: 'arrow_back',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 24,
                              ),
                            ),
                          ),
                          LanguageSelectorWidget(
                            selectedLanguage: _selectedLanguage,
                            onLanguageChanged: (language) {
                              setState(() => _selectedLanguage = language);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Logo
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.lightTheme.colorScheme.primary,
                              AppTheme.lightTheme.colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'TB',
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Title and subtitle
                      Text(
                        localizedStrings['title']!,
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        localizedStrings['subtitle']!,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),

                      // Registration Form
                      RegistrationFormWidget(
                        onRegister: _handleRegister,
                        isLoading: _isLoading,
                      ),
                      SizedBox(height: 3.h),

                      // Google Sign-up
                      GoogleSignupWidget(
                        onGoogleSignup: _handleGoogleSignup,
                        isLoading: _isGoogleLoading,
                      ),
                      SizedBox(height: 4.h),

                      // Sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizedStrings['alreadyHaveAccount']!,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          GestureDetector(
                            onTap: _navigateToLogin,
                            child: Text(
                              localizedStrings['signIn']!,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
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
}
