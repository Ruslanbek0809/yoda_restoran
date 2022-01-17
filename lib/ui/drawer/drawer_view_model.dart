import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';

class DrawerViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  Future<void> navToLoginView() async => await _navService.replaceWith(
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

  void collapseExpansionTile(
      GlobalKey<CustomExpansionTileState> expansionTile) {
    expansionTile.currentState?.collapse();
    notifyListeners();
  }
}
