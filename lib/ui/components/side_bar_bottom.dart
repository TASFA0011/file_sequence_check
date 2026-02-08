import 'package:file_sequence_check/constants/navigation_service.dart';
import 'package:file_sequence_check/constants/routes.dart';
import 'package:file_sequence_check/models/user_model.dart';
import 'package:file_sequence_check/service/auth_service.dart';
import 'package:file_sequence_check/service/setup_locator.dart';
import 'package:flutter/material.dart';
import 'package:my_utils/my_utils.dart';

class SideBarBottomWidget extends StatelessWidget {
  const SideBarBottomWidget({super.key});

  void _disconnet() async {
    await AuthService.removeAuthData();
    NavigationService.globalNavigatorKey.currentState!.pushNamedAndRemoveUntil(
        Routes.LOGIN, (route) => route.settings.name == Routes.SPLASH_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = locator.get();

    return Padding(
      padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, bottom: 20.0, top: 5.0),
      child: Material(
        color: Colors.grey[200],
        // clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        child: InkWell(
          onTap: () => {},
          hoverColor: Colors.grey[400],
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                CircleAvatarLetters(user.fullName,
                    radius: 15.0, transparent: true),

                const SizedBox(
                  width: 8.0,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringUtils.getShorterName(user.fullName),
                        style: const TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w600),
                      ),
                      _getUserType(user)
                    ],
                  ),
                ),

                const SizedBox(
                  width: 5.0,
                ),

                // FIXME add popup with many params
                GestureDetector(
                  onTap: _disconnet,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Tooltip(
                      message: 'Se deconnecter', // FIXME typo
                      child: Icon(Icons.logout_rounded),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getUserType(UserModel user) {
    bool isAdmin = 2 == 1;
    Color color = isAdmin ? Colors.red : Colors.green;

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 5.0,
          height: 5.0,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(5.0))),
        ),
        const SizedBox(width: 5.0),
        Text(
          isAdmin ? 'admin' : 'utilisateur', // FIXME typo
          style: TextStyle(
              fontSize: 12.0, color: color, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
