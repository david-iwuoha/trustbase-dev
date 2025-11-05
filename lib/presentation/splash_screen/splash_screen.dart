import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo scale animation with bounce effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _backgroundAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _logoAnimationController.forward();
    });
  }

  Future<void> _startInitialization() async {
    try {
      // Simulate checking authentication tokens
      setState(() {
        _initializationStatus = 'Checking authentication...';
      });
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate loading language preferences
      setState(() {
        _initializationStatus = 'Loading preferences...';
      });
      await Future.delayed(const Duration(milliseconds: 600));

      // Simulate fetching consent status cache
      setState(() {
        _initializationStatus = 'Fetching consent data...';
      });
      await Future.delayed(const Duration(milliseconds: 700));

      // Simulate preparing demo mode data
      setState(() {
        _initializationStatus = 'Preparing demo data...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Ready!';
      });

      // Wait for animations to complete before navigation
      await Future.delayed(const Duration(milliseconds: 800));

      // Navigate based on authentication status
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors
      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Initialization failed. Tap to retry.';
      });
    }
  }

  void _navigateToNextScreen() {
    // Simulate authentication check
    bool isAuthenticated = _checkAuthenticationStatus();

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/dashboard-screen');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check - in real app, check stored tokens
    // For demo purposes, randomly return false to show login flow
    return false;
  }

  void _retryInitialization() {
    if (!_isInitializing && _initializationStatus.contains('failed')) {
      setState(() {
        _isInitializing = true;
        _initializationStatus = 'Retrying...';
      });
      _startInitialization();
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to match brand colors
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.primaryColor.withValues(
                    alpha: 0.9 * _backgroundAnimation.value,
                  ),
                  AppTheme.lightTheme.colorScheme.secondary.withValues(
                    alpha: 0.7 * _backgroundAnimation.value,
                  ),
                  AppTheme.lightTheme.primaryColor.withValues(
                    alpha: 0.8 * _backgroundAnimation.value,
                  ),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Glassmorphism background effect
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _backgroundAnimation,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(
                                  alpha: 0.1 * _backgroundAnimation.value,
                                ),
                                Colors.white.withValues(
                                  alpha: 0.05 * _backgroundAnimation.value,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated logo section
                        AnimatedBuilder(
                          animation: _logoAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: FadeTransition(
                                opacity: _logoFadeAnimation,
                                child: _buildLogo(),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 8.h),

                        // Loading indicator and status
                        _buildLoadingSection(),
                      ],
                    ),
                  ),

                  // App version at bottom
                  Positioned(
                    bottom: 4.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'TrustBase v1.0.0',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.9),
            Colors.white.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.5.w),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'TrustBase',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
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

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading indicator
        _isInitializing
            ? SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              )
            : _initializationStatus.contains('failed')
                ? GestureDetector(
                    onTap: _retryInitialization,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'refresh',
                            color: Colors.white,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Retry',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 6.w,
                  ),

        SizedBox(height: 2.h),

        // Status text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _initializationStatus,
            key: ValueKey(_initializationStatus),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}