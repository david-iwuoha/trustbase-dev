import 'package:flutter/material.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/yarn_gpt_chat_screen/yarn_gpt_chat_screen.dart';
import '../presentation/register_screen/register_screen.dart';
import '../presentation/profile_setup_popup/profile_setup_popup.dart';
import '../presentation/timeline_screen/timeline_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String dashboard = '/dashboard-screen';
  static const String splash = '/splash-screen';
  static const String login = '/login-screen';
  static const String yarnGptChat = '/yarn-gpt-chat-screen';
  static const String register = '/register-screen';
  static const String profileSetupPopup = '/profile-setup-popup';
  static const String timelineScreen = '/timeline-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    dashboard: (context) => const DashboardScreen(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    yarnGptChat: (context) => const YarnGptChatScreen(),
    register: (context) => const RegisterScreen(),
    profileSetupPopup: (context) => const ProfileSetupPopup(),
    timelineScreen: (context) => const TimelineScreen(),
    // TODO: Add your other routes here
  };
}
