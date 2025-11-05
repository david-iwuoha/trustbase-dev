import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatefulWidget {
  final Function(String fullName, String email, String password) onRegister;
  final bool isLoading;

  const RegistrationFormWidget({
    Key? key,
    required this.onRegister,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isFullNameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _acceptTerms = false;

  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_validateFullName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateFullName() {
    setState(() {
      _isFullNameValid = _fullNameController.text.trim().length >= 2 &&
          _fullNameController.text.trim().contains(' ');
    });
  }

  void _validateEmail() {
    setState(() {
      _isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(_emailController.text.trim());
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _isPasswordValid = password.length >= 8 &&
          password.contains(RegExp(r'[A-Z]')) &&
          password.contains(RegExp(r'[a-z]')) &&
          password.contains(RegExp(r'[0-9]'));

      // Password strength indicator
      if (password.isEmpty) {
        _passwordStrength = '';
        _passwordStrengthColor = Colors.transparent;
      } else if (password.length < 6) {
        _passwordStrength = 'Weak - Too short';
        _passwordStrengthColor = Colors.red;
      } else if (password.length < 8 ||
          !password.contains(RegExp(r'[A-Z]')) ||
          !password.contains(RegExp(r'[0-9]'))) {
        _passwordStrength = 'Fair - Add uppercase and numbers';
        _passwordStrengthColor = Colors.orange;
      } else if (_isPasswordValid) {
        _passwordStrength = 'Strong - Good to go!';
        _passwordStrengthColor = Colors.green;
      }
    });
    _validateConfirmPassword();
  }

  void _validateConfirmPassword() {
    setState(() {
      _isConfirmPasswordValid = _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;
    });
  }

  bool get _isFormValid =>
      _isFullNameValid &&
      _isEmailValid &&
      _isPasswordValid &&
      _isConfirmPasswordValid &&
      _acceptTerms;

  void _handleRegister() {
    if (_isFormValid && !widget.isLoading) {
      widget.onRegister(
        _fullNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      constraints: BoxConstraints(maxWidth: 400),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.all(6.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name Field
                  Text(
                    'Full Name',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'person',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _fullNameController.text.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName:
                                    _isFullNameValid ? 'check_circle' : 'error',
                                color: _isFullNameValid
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Email Field
                  Text(
                    'Email Address',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter your email address',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'email',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _emailController.text.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName:
                                    _isEmailValid ? 'check_circle' : 'error',
                                color:
                                    _isEmailValid ? Colors.green : Colors.red,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Password Field
                  Text(
                    'Password',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Create a strong password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'lock',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_passwordController.text.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: CustomIconWidget(
                                iconName:
                                    _isPasswordValid ? 'check_circle' : 'error',
                                color: _isPasswordValid
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                            ),
                          GestureDetector(
                            onTap: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible),
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: _isPasswordVisible
                                    ? 'visibility_off'
                                    : 'visibility',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_passwordStrength.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      _passwordStrength,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _passwordStrengthColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  SizedBox(height: 3.h),

                  // Confirm Password Field
                  Text(
                    'Confirm Password',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleRegister(),
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'lock_outline',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_confirmPasswordController.text.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: CustomIconWidget(
                                iconName: _isConfirmPasswordValid
                                    ? 'check_circle'
                                    : 'error',
                                color: _isConfirmPasswordValid
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                            ),
                          GestureDetector(
                            onTap: () => setState(() =>
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible),
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: _isConfirmPasswordVisible
                                    ? 'visibility_off'
                                    : 'visibility',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Terms and Conditions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) =>
                            setState(() => _acceptTerms = value ?? false),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _acceptTerms = !_acceptTerms),
                          child: Padding(
                            padding: EdgeInsets.only(top: 2.w),
                            child: RichText(
                              text: TextSpan(
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                                children: [
                                  TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _isFormValid && !widget.isLoading
                          ? _handleRegister
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                        foregroundColor: _isFormValid
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                      ),
                      child: widget.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              'Create Account',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _isFormValid
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                              ),
                            ),
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
}
