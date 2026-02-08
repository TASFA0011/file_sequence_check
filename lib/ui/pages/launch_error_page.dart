import 'package:flutter/material.dart';
import 'package:error_screen/error_screen.dart';
import '../../constants/navigation_service.dart';
import '../../constants/routes.dart';

class LaunchErrorPage extends StatelessWidget {

  const LaunchErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorScreenBase(
        image: Image.asset(ErrorScreenImages.ERROR, width: 192.0, package: "error_screen"),
        title: const Text("Une erreur s'est produite lors du lancement"),
        description: const Text("Veuillez vérifier votre connexion au serveur et réessayer"),
        button: ElevatedButton(
          onPressed: () => NavigationService.globalNavigatorKey.currentState?.pushNamed(Routes.SPLASH_SCREEN),
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 30.0, vertical: 13.0)),
            elevation: WidgetStateProperty.all<double>(0.0),
            minimumSize: WidgetStateProperty.all(const Size(120.0, 48.0))
          ),
          child: const Text('Réessayer')
        ),
      ),
    );
  }
}
