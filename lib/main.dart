import 'package:file_sequence_check/constants/navigation_service.dart';
import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/constants/themes.dart';
import 'package:file_sequence_check/service/route_generator.dart';
import 'package:file_sequence_check/service/setup_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_utils/my_utils.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final ThemeSwitcherBloc _bloc = locator.get();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeMode>(
        initialData: _bloc.mode,
        stream: _bloc.listen,
        builder: (context, snapshot) {
          return MaterialApp(
            title: "File Sequence Check",
            themeMode: snapshot.data,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('fr', 'FR')],
            navigatorKey: NavigationService.globalNavigatorKey,
            initialRoute: Routes.SPLASH_SCREEN,
            onGenerateRoute: RouteGenerator.generate,
          );
        });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
