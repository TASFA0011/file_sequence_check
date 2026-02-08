import 'package:file_sequence_check/constants/navigation_service.dart';
import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/service/nested_route_generator.dart';
import 'package:file_sequence_check/ui/components/side_bar_bottom.dart';
import 'package:flutter/material.dart';
import 'package:my_utils/my_utils.dart';
import 'package:side_bar/side_bar.dart';

class MainPage extends StatefulWidget {
  final String defaultRoute;
  const MainPage(
    this.defaultRoute, {
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _bloc = SideBarBloc();
  static final GlobalKey<NavigatorState> _navigatorKey =
      NavigationService.nestedNavigatorKey;

  late MyNavigatorObserver _observer;

  List<String> _routes = [];
  List<SideBarGroup> _sideBarData = [];

  @override
  void initState() {
    super.initState();
    handle();
    _observer = MyNavigatorObserver(
        onDidPush: (route, _) => _onRouteChanged(route.settings.name),
        onDidPop: (_, route) => _onRouteChanged(route?.settings.name),
        onDidRemove: (_, route) => _onRouteChanged(route?.settings.name));
  }

  void handle() {
    setState(() {
      _routes = [Routes.HOME, Routes.FACTURATIONS, Routes.SETTINGS];
      _sideBarData = [
        const SideBarGroup(items: [
          SideBarItem(icon: Icon(Icons.file_copy_outlined), label: "File sequence"),
          SideBarItem(icon: Icon(Icons.inventory_outlined), label: "Facturation"),
          SideBarItem(
              icon: Icon(Icons.settings_outlined),
              label:
                  "Paramètres"), // configuration de la base donnees, jours ferie et conges
        ]),
      ];
    });
  }

  void _onRouteChanged(String? route) {
    if (route == null) {
      _bloc.change(null, null);
      return;
    }

    int index = -1;
    for (int i = 0, len = _routes.length; i < len; ++i) {
      // seulement pour le groupe 1
      if (_routes[i] == route) {
        index = i;
        break;
      }
    }

    if (index != -1) {
      _bloc.change(index, 0);
    } else {
      _bloc.change(null, null);
      // FIXME implementer pour about et autre groupe
      // switch (route) {
      //   case Routes.CONTACT_US:
      //     _bloc.change(0, 1);
      //     break;
      //   default:
      //     _bloc.change(null, null);
      // }
    }
  }

  void _onTapSideBar(int groupIndex, int itemIndex) {
    String? route;

    if (groupIndex == 0) {
      route = _routes[itemIndex];
    }

    if (route != null) _navigatorKey.currentState?.pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final isLighMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: Row(
        children: [
          // PART: side bar
          StreamBuilder<SideBarChangedData>(
              initialData: _bloc.getData,
              stream: _bloc.listen,
              builder: (context, snapshot) {
                final data = snapshot.data!;
                return SideBar(
                  // controller:_sideBarController,
                  onTap: _onTapSideBar,
                  groups: _sideBarData,
                  selectedItemsIndex: data.index,
                  selectedGroupIndex: data.groupIndex,
                  iconTheme: IconThemeData(
                      // color: Colors.black54
                      color: isLighMode ? null : Colors.white),
                  selectedIconTheme: const IconThemeData(color: Colors.blue),
                  top: SizedBox(
                      height: 100.0,
                      // FIXME rendre l'image plus grande et le decaler l'aligner a gauche
                      child: Image.asset("assets/logo.png", width: 100.0)),
                  // Image.network(config.logoUrl, width: 296.0)),

                  bottom: const SideBarBottomWidget(),
                );
              }),

          Expanded(
            child: NestedNavigatorHelper(
              navigationKey: _navigatorKey,
              observers: [_observer],
              initialRoute: widget.defaultRoute, // renommer initialRoute
              onGenerateRoute: NestedRouteGenerator.generate,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
