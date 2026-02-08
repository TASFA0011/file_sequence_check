import 'package:file_sequence_check/constants/navigation_service.dart';
import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/service/api.dart';
import 'package:file_sequence_check/service/auth_service.dart';
import 'package:file_sequence_check/service/setup_locator.dart';
import 'package:flutter/material.dart';
// import 'package:my_utils/my_utils.dart';

Future<void> handleStartUp() async {
  // FIXME use [pushReplacementNamed] instead of [pushNamed]

  // Verify authentication

  var authData = await AuthService.getAuthData();

  if (authData == null) {
    NavigationService.globalNavigatorKey.currentState?.pushNamed(Routes.LOGIN);
    return;
  }

  locator.update(authData);

  final user = await Api.getUser(authData.userId);
  locator.update(user);

  NavigationService.globalNavigatorKey.currentState?.pushNamed(Routes.MAIN);
}

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    // AuthService.removeAuthData();
    // StorageService.removeServerHost();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setup();
    });
  }

  void setup() async {
    try {
      await handleStartUp();
    } catch (err) {
      // FIXME use [pushReplacementNamed] instead of [pushNamed]
      // if (err is HttpError && err.data?.code == 'expired_token') {
      NavigationService.globalNavigatorKey.currentState
          ?.pushNamed(Routes.LOGIN);
      return;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo.png", width: 296.0),
      ),
    );
  }
}
