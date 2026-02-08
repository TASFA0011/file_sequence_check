import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/ui/pages/launch_error_page.dart';
import 'package:file_sequence_check/ui/pages/login_page.dart';
import 'package:file_sequence_check/ui/pages/main_page.dart';
import 'package:file_sequence_check/ui/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic>? generate(RouteSettings settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case Routes.SPLASH_SCREEN:
        return MaterialPageRoute(builder: (_) => const SplashScreenPage());
      case Routes.LOGIN:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.LAUNCH_ERROR:
        return MaterialPageRoute(builder: (_) => const LaunchErrorPage());
      case Routes.MAIN:
        return MaterialPageRoute(
            builder: (_) => MainPage((args as String?) ?? Routes.HOME));
    }
    return null;
  }
}
