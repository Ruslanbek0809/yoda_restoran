import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/services/services.dart';

class DrawerViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  bool get hasLoggedInUser => _userService.hasLoggedInUser;
}
