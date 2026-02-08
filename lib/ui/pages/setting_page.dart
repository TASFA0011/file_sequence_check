import 'dart:developer';
import 'dart:io';

import 'package:file_sequence_check/constants/navigation_service.dart';
import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/service/api.dart';
import 'package:file_sequence_check/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:my_utils/my_utils.dart';
import 'package:overlay_notifications/overlay_notifications.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final newController = TextEditingController();
  final oldController = TextEditingController();

  String newPassword = '';
  String oldPassword = "";
  bool _trySubmit = false;
  bool _isLoadding = false;

  void _onSubmit() {
    if (!_onValid()) {
      setState(() {
        _trySubmit = true;
      });
      return;
    }
    setState(() {
      _isLoadding = true;
    });
    Api.modifyPassword(oldPassword, newPassword).then((value) {
      setState(() {
        _isLoadding = false;
      });
      OverlayNotifications.instance.notify(
          context: context,
          notification: const OverlayNotificationWidget.success(
              title: Text('Modification du mot de passe'),
              description: Text('Le mot de passe a été modifié avec succes')));

      NavigationService.nestedNavigatorKey.currentState!
          .pushNamed(Routes.LOGIN);

      AuthService.removeAuthData();
    }, onError: (err) {
      log(err.toString(), name: 'Error');
      setState(() {
        _isLoadding = false;
      });

      OverlayNotificationWidget notification;
      if (err is SocketException) {
        notification = const OverlayNotificationWidget.networkError();
      } else if (err is HttpError && err.statusCode == 401) {
        notification = const OverlayNotificationWidget.error(
            title: Text("Erreur d'authentification"),
            description: Text("Le mot de passe actuel saisi est  incorrect"));
      } else {
        notification = const OverlayNotificationWidget.wrongThing();
      }

      OverlayNotifications.instance
          .notify(context: context, notification: notification);
    });
  }

  bool _onValid() {
    if (oldPassword.trim() == '' || newPassword.trim() == '') {
      setState(() {
        _trySubmit = true;
      });
      return false;
    }

    if (oldPassword.trim().length < 5) {
      OverlayNotifications.instance.notify(
          context: context,
          notification: const OverlayNotificationWidget.error(
            description: Text(
                'Les mots de passe doivent etre composer de minimum 5 caracteres'),
            title: Text('Erreur de mot de passe'),
          ));
      setState(() {
        _trySubmit = true;
      });

      return false;
    }

    return true;
  }

  void _onOldPasswordChange(String value) {
    setState(() {
      oldPassword = value;
    });
  }

  void _onNewPasswordChange(String value) {
    setState(() {
      newPassword = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parametres"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Changer le mot de passe",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: oldController,
                        onChanged: _onOldPasswordChange,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Mot de passe actuel",
                          errorText: _trySubmit && oldPassword.trim() == ''
                              ? "Saisissez le mot de passe actuel"
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: newController,
                        onChanged: _onNewPasswordChange,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Nouveau mot de passe",
                          errorText: _trySubmit && newPassword.trim() == ''
                              ? "Saisissez le nouveau mot de passe"
                              : null,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                          onPressed: _onSubmit,
                          style: ButtonStyle(
                            elevation: WidgetStateProperty.all(0),
                            minimumSize: WidgetStateProperty.all(
                                const Size(double.infinity, 54.0)),
                          ),
                          child: _isLoadding
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white))
                              : const Text("Enregistrer")
                        ),
                        const SizedBox(height: 10,),
                        const Divider(),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: (){NavigationService.navigate(Routes.FACTURATION_ADRESS, arguments: false);},
                          style: ButtonStyle(
                            elevation: WidgetStateProperty.all(0),
                            minimumSize: WidgetStateProperty.all(
                                const Size(double.infinity, 54.0)),
                          ),
                          child: const Text("Charger les adresses")
                        ),
                    ]))
          ],
        ),
      ),
    );
  }
}
