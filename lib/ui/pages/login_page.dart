import 'dart:collection' show HashMap;
import 'dart:io' show SocketException;
import 'package:file_sequence_check/constants/navigation_service.dart';
import 'package:file_sequence_check/service/api.dart';
import 'package:file_sequence_check/service/auth_service.dart';
import 'package:file_sequence_check/ui/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:my_utils/my_utils.dart';
import 'package:overlay_notifications/overlay_notifications.dart';
import '../../constants/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // static Api _api = locator.get();

  final FormValidatorBloc _bloc = FormValidatorBloc(
      data: FormValidatorData(
          fields: HashMap.from({
    "matricule": ValidatorField<String>("",
        requiredMessage: "Veuillez renseigner le matricule"),
    "password": ValidatorField<String>("",
        requiredMessage: "Veuillez renseigner le mot de passe",
        validator: (value, _) {
      if (value == "") {
        return null;
      }
      return value.length < 5 /* FIXME 8 */
          ? "Votre mot de passe doit contenir au moins 6 caracteres"
          : null;
    })
  })));

  @override
  void initState() {
    // FIXME: supprimer plus tard
    super.initState();
  }

  void _submit() {
    if (_bloc.data.isLoading || !_bloc.validate()) {
      return;
    }

    _bloc.setLoadingStatus(true);

    // locator.delete();
    // return;

    final data = _bloc.getFormValues();

    Api.authenticate(data["matricule"], data["password"]).then((value) async {
      _bloc.setLoadingStatus(false);
      await AuthService.registerAuthData(value);
      try {
        await handleStartUp();
      } catch (err) {
        // FIXME use [pushReplacementNamed] instead of [pushNamed]
        NavigationService.globalNavigatorKey.currentState
            ?.pushNamed(Routes.LAUNCH_ERROR);
      }
    }, onError: (err) {
      _bloc.setLoadingStatus(false);
      OverlayNotificationWidget notification;

      if (err is SocketException) {
        notification = const OverlayNotificationWidget.networkError();
      } else if (err is HttpError && err.data?.code == 'wrong_credentials') {
        notification = const OverlayNotificationWidget.error(
            title: Text('Erreur d\'authentification'),
            description: Text('Nom d\'utilisateur ou mot de passe incorrect'));
      } else {
        notification = const OverlayNotificationWidget.wrongThing();
      }

      OverlayNotifications.instance
          .notify(context: context, notification: notification);
    });
  }

  void _onUsernameChanged(String value) {
    _bloc.changeValue("matricule", value);
  }

  void _onPasswordChanged(String value) {
    _bloc.changeValue("password", value);
  }

  void onReload() {
    AuthService.removeAuthData();
    setState(() {});
    NavigationService.globalNavigatorKey.currentState!
        .pushNamed(Routes.SPLASH_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Container(
        decoration: const BoxDecoration(
          // color: MyTheme.blackColor,
          image: DecorationImage(
            opacity: 1.1,
            image: AssetImage(
                "assets/logo.png"), // Remplacez le chemin par l'emplacement de votre image
            fit: BoxFit.cover, // Ajuste l'image pour couvrir tout le conteneur
          ),
        ),
        child: _cardWidget(width),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _cardWidget(double width) {
    return FormValidatorBuilder(
        bloc: _bloc,
        builder: (context, snapshot) {
          final data = snapshot.fields;

          return Scaffold(
            floatingActionButton: SizedBox(
              child: IconButton(
                icon: const Icon(Icons.sync),
                onPressed: onReload,
              ),
            ),
            body: Center(
              child: SizedBox(
                width: width * 0.35,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // PART: card
                    Card(
                      color: const Color.fromARGB(80, 255, 255, 255),
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50.0),

                            const Text(
                              "Connetez vous",
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87),
                            ),

                            const SizedBox(height: 25.0),

                            TextField(
                              onChanged: _onUsernameChanged,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Matricule",
                                  errorText: data["matricule"]!.errorMessage),
                            ),

                            const SizedBox(height: 15.0),

                            TextField(
                              onChanged: _onPasswordChanged,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Mot de passe",
                                  errorText: data["password"]!.errorMessage),
                            ),

                            // MyOutlineTextField(
                            //   onChanged: _onUsernameChanged,
                            //   labelText: "Numéro de téléphone",
                            //   errorText:  data["username"]!.errorMessage,
                            // ),

                            // const SizedBox(height: 15.0),
                            // MyOutlineTextField(
                            //   onChanged: _onPasswordChanged,
                            //   obscureText: true,
                            //   labelText: "Mot de passe",
                            //   errorText: data["password"]!.errorMessage
                            // ),

                            const SizedBox(height: 15.0),

                            ElevatedButton(
                                onPressed: snapshot.isValid ? _submit : null,
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(double.infinity, 54.0)),
                                  // backgroundColor: MaterialStateColor.resolveWith((states) {
                                  //   return states.contains(MaterialState.disabled) ? Colors.black12 : MyTheme.primaryColor;
                                  // })
                                ),
                                child: snapshot.isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white))
                                    : const Text("Se connecter")),

                            const SizedBox(height: 30.0),
                          ],
                        ),
                      ),
                    ),
                    //                AuthService.removeAuthData();
                    // StorageService.removeServerHost();
                    // pART: image sur le card
                    Positioned(
                      top: -50.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: const BoxDecoration(
                            // color: MyTheme.primaryColor,
                            shape: BoxShape.circle),
                        child: Center(
                            child: Image.asset(
                          "assets/logo.png",
                          width: 500.0,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
