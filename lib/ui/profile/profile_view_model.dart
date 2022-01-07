import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';

class ProfileViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  void navBack() => _navService.back();
}
