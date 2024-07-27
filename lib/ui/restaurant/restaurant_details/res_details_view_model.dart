import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/hive_models/hive_models.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class ResDetailsViewModel extends FutureViewModel {
  final log = getLogger('ResDetailsViewModel');
  final Restaurant restaurant;
  ResDetailsViewModel(this.restaurant);

  final _api = locator<ApiService>();
  final _navService = locator<NavigationService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>();
  final _userService = locator<UserService>();
  final _geolocatorService = locator<GeolocatorService>();

  Position? get locationPosition => _geolocatorService.locationPosition;

  int _activeTab = 0;
  bool _isTabPressed = false;
  bool _isShrink = false;
  bool _isTitleShrink = false;

  int get activeTab => _activeTab;
  bool get isTabPressed => _isTabPressed;
  bool get isShrink => _isShrink;
  bool get isTitleShrink => _isTitleShrink;

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity
  bool get isUpdateQuantity =>
      _bottomCartService.isUpdateQuantity; // custom loading of res bottom cart

  //*_isCustomError and updateCustomError func are used to show error flash bar once. Workaround
  bool _isCustomError = false;
  bool get isCustomError => _isCustomError;
  List<ResCategory> _resCategories = [];
  List<ResCategory> get resCategories => _resCategories;

//*----------------------- HEADER/ANIMATION/TAB PART ----------------------------//

  //*Function to change ACTIVE TAB
  void updateActiveTab(int tabIndex) {
    _activeTab = tabIndex;
    notifyListeners();
  }

  //*Function to change ACTIVE TAB
  void updateLastScrollStatus(bool isReallyShrink, bool isTitleShrink) {
    _isShrink = isReallyShrink;
    _isTitleShrink = isTitleShrink;
    notifyListeners();
  }

  // Function to create ripple like effect when Tab pressed
  void updateOnTapRipple() {
    if (_isTabPressed) {
      Timer(Duration(milliseconds: 1200), () {
        _isTabPressed = false;
        log.i('_isTabPressed: $_isTabPressed');
        notifyListeners();
      });
    } else {
      _isTabPressed = true;
      log.i('_isTabPressed: $_isTabPressed');
      notifyListeners();
    }
  }

  double get expandedHeight => 500.0;
  double get collapsedHeight => kToolbarHeight;

  //* PREVENTS animate when press on tab bar
  bool _pauseRectGetterIndex = false;
  bool get pauseRectGetterIndex => _pauseRectGetterIndex;

  bool _isCollapsed = true;
  bool get isCollapsed => _isCollapsed;

  //*Function to change isCollapsed var
  void updatePauseRectGetterIndex(bool value) {
    if (this._pauseRectGetterIndex == value) return;
    _pauseRectGetterIndex = value;
    // notifyListeners();
  }

  //*Function to change isCollapsed var
  void updateIsCollapsed(bool value) {
    log.i('_isTabPressed: $_isTabPressed');
    if (this._isCollapsed == value) return;
    _isCollapsed = value;
    // notifyListeners();
  }

//*----------------------- MAIN FETCH PART ----------------------------//

  @override
  Future<void> futureToRun() async => await getResCatsWithMeals();

  // // FETCHS Restaurant categories with their meals
  Future getResCatsWithMeals(
      //   {
      //   // Function()? onFailForView,
      // }
      ) async {
    log.i('');
    await _api.getResCatsWithMeals(
      restaurantId: restaurant.id!,
      onSuccess: (result) async {
        _resCategories = result;
      },
      onFail: () {
        _isCustomError = true;
        // _snackBarService.showCustomSnackBar(
        //   variant: SnackBarType.restaurantDetailsError,
        //   message: 'This is a snack bar',
        //   // title: 'The title',
        //   duration: Duration(seconds: 2),
        // );
      },
    );

    log.i('_resCategories.length: ${_resCategories.length}');
  }

  //*Workaround to show error flash bar once
  void updateCustomError() {
    log.i('updateCustomError()');

    _isCustomError = false;
  }

//*----------------------- RESTAURANT BOTTOM SHEET ----------------------------//

  //*SHOWS RestaurantDetailsInfoBottomSheet
  // Future showCustomBottomSheet(Restaurant restaurant) async {
  //   log.i('');
  //   await _bottomSheetService.showCustomSheet(
  //     variant: BottomSheetType.restaurantInfo,
  //     enableDrag: true,
  //     isScrollControlled: true,
  //     data: restaurant,
  //   );
  // }

//*----------------------- FAVOURITE PART ----------------------------//

  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  //* ADDS id of current res to favoritesBox
  Future<void> addRestaurantToFav(int resId) async {
    if (hasLoggedInUser) {
      log.v('addRestaurantToFav() USER FOUND with resId: $resId');

      await _userService.addRestaurantToFav(resId);
    } else {
      log.v('addRestaurantToFav() USER NOTTTTT FOUND');
      await _navService.navigateTo(
        Routes.loginView,
        arguments: LoginViewArguments(isCartView: true),
      ); //* Workaround. isCartView is used to navigate to new View by condition in OtpVM
    }
  }

  //* REMOVES id of current res from favoritesBox
  Future<void> removeRestaurantFromFav(int resId) async {
    if (hasLoggedInUser) {
      log.v('removeRestaurantFromFav() USER FOUND with resId: $resId');

      await _userService.removeRestaurantFromFav(resId);
    } else {
      log.v('removeRestaurantFromFav() USER NOTTTTT FOUND');
      await _navService.navigateTo(
        Routes.loginView,
        arguments: LoginViewArguments(isCartView: true),
      ); //* Workaround. isCartView is used to navigate to new View by condition in OtpVM
    }
  }

  FlashController? _flashController;

  Future<void> showCustomFlashBar({
    required BuildContext context,
    String msg = LocaleKeys.errorOccured,
    Duration duration = const Duration(seconds: 2),
  }) async {
    await showCustomFlashBarWithFlashController(
      context: context,
      flashController: _flashController,
      msg: msg,
      duration: duration,
    );
  }

//*----------------------- NAVIGATIONS ----------------------------//

  Future<void> navToCartView() async {
    // dynamic _navResult;
    // _navResult =
    await _navService.navigateTo(Routes.cartView);
    // ?? true;
    // if (_navResult) await initialise(); // Workaround
  }

  void navToResSearchView() async {
    // dynamic _navResult;
    // _navResult =
    await _navService.navigateTo(Routes.restaurantSearchView,
        arguments: RestaurantSearchViewArguments(restaurant: restaurant));
    // ?? true;
    // if (_navResult) await initialise(); // Workaround
  }

  //*NAVIGATES to LoginView if not logged in yet
  // Future<void> navToLoginView() async => await _navService.navigateTo(
  //       Routes.loginView,
  //       arguments: LoginViewArguments(
  //         isCartView: true,
  //       ), // Workaround.
  //     );

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_bottomCartService, _hiveDbService];
}
