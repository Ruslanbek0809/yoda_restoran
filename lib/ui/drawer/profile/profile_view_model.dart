import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class ProfileViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  HiveUser? get currentUser => _userService.currentUser;
  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  /// LOGOUTS a user from app
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.accessToken);
    await _userService.logoutUser();
    await _hiveDbService.clearCart();
    await navToHomeByRemovingAll();
  }

  void navBack() => _navService.back();
}
