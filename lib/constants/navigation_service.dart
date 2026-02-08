import 'package:flutter/material.dart';

class NavigationService {

  static final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
  static final GlobalKey<NavigatorState> nestedNavigatorKey = GlobalKey();

  static navigate(String route, { Object? arguments, bool globalNavigator = false }) {
    var navigator = globalNavigator ? NavigationService.globalNavigatorKey : NavigationService.nestedNavigatorKey;
    navigator.currentState?.pushNamed(route, arguments: arguments);
  }

  static BuildContext get context => globalNavigatorKey.currentContext!;

}
