import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../services/services.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';

class DrawerViewModel extends BaseViewModel {
  final log = getLogger('DrawerViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _apiRootService = locator<ApiRootService>();

  PackageInfo? packageInfo;

  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  Future<void> getAppVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    notifyListeners();
  }

  Future<void> navToLoginView() async => await _navService.navigateTo(
        Routes.loginView,
        arguments: LoginViewArguments(
          isCartView: false,
        ), // Workaround. isCartView is used to navigate to new View by condition in OtpVM
      );

  Future<void> navToProfileView() async =>
      await _navService.navigateTo(Routes.profileView);

  Future<void> navToOrdersView() async =>
      await _navService.navigateTo(Routes.ordersView);

  Future<void> navToAddressesView() async =>
      await _navService.navigateTo(Routes.addressesView);

  Future<void> navToMyCreditCardsView() async =>
      await _navService.navigateTo(Routes.myCreditCardsView);

  Future<void> navToAboutUsView() async =>
      await _navService.navigateTo(Routes.aboutUsView);

  void collapseExpansionTile(
      GlobalKey<CustomExpansionTileState> expansionTile) {
    expansionTile.currentState?.collapse();
    notifyListeners();
  }

  /// SETS LOCALE of an app's baseUrl
  Future<void> setLocale(String locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.savedLocale, locale);
  }

  /// REINITIALIZES app api url
  Future<void> reinitializeDio() async =>
      await _apiRootService.initDio(); // MUST REINITIALIZE whole app dio config

//------------------------ NAVIGATIONS ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  Future<void> navToContactUsView() async =>
      await _navService.navigateTo(Routes.contactUsView);
}
