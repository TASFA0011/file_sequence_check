import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/models/check_model.dart';
import 'package:file_sequence_check/ui/pages/facturation/facturation_interco_page.dart';
import 'package:file_sequence_check/ui/pages/facturation/facturation_page.dart';
import 'package:file_sequence_check/ui/pages/facturation/facturations_interco_page.dart';
import 'package:file_sequence_check/ui/pages/home_page.dart';
import 'package:file_sequence_check/ui/pages/setting_page.dart';
import 'package:file_sequence_check/ui/pages/upload_facturation_adress.dart';
import 'package:flutter/material.dart';

class NestedRouteGenerator {
  static Route<dynamic>? generate(RouteSettings settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case Routes.HOME:
        return MaterialPageRoute(
            builder: (_) => HomePage(
                  initialData: args as CheckModel?,
                ),
            settings: settings);

      case Routes.REGISTER_FACTURATION: 
        return MaterialPageRoute(builder: (_) => const FacturationIntercoPage(), settings:settings);
      case Routes.FACTURATION: 
        return MaterialPageRoute(builder: (_) =>  FacturationPage(id: args as String), settings:settings);
      case Routes.FACTURATIONS: 
        return MaterialPageRoute(builder: (_) =>  const FacturationsIntercoPage(), settings:settings);


      case Routes.FACTURATION_ADRESS:
        return MaterialPageRoute(builder: (_) => UploadFacturationAdress(isFirst: args as bool,), settings: settings);
      case Routes.SETTINGS:
        return MaterialPageRoute(
            builder: (_) => const SettingPage(), settings: settings);
    }
    return null;
  }
}
