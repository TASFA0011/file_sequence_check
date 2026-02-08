import 'package:my_utils/my_utils.dart';

final UniqueInstance locator = UniqueInstance.getInstance();

void setupLocator() {

  locator.register(ThemeSwitcherBloc());

}
