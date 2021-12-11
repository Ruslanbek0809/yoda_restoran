import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

/// ReactiveViewModel is used to "react"
class RestaurantDetailsViewModel extends ReactiveViewModel {
  final log = getLogger('RestaurantDetailsViewModel');

  final _bottomSheetService = locator<BottomSheetService>();
  final _navService = locator<NavigationService>();
  final _bottomCartService = locator<BottomCartService>();

  BottomCartStatus get bottomCartStatus => _bottomCartService.bottomCartStatus;

  // Restaurant? _restaurant;
  int _activeTab = 0;
  bool _isTabPressed = false;
  bool _isShrink = false;

  // Restaurant? get restaurant => _restaurant;
  int get activeTab => _activeTab;
  bool get isTabPressed => _isTabPressed;
  bool get isShrink => _isShrink;

  /// Function to UPDATE _restaurant
  // void updateRestaurant(Restaurant newRestaurant) {
  //   _restaurant = newRestaurant;
  //   log.i(_restaurant!.name);
  //   notifyListeners();
  // }

  /// Function to change ACTIVE TAB
  void updateActiveTab(int tabIndex) {
    _activeTab = tabIndex;
    notifyListeners();
  }

  /// Function to change ACTIVE TAB
  void updateLastScrollStatus(bool isReallyShrink) {
    _isShrink = isReallyShrink;
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

  /// Function to call RestaurantDetailsInfoBottomSheet
  Future showCustomBottomSheet(Restaurant restaurant) async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.restaurantInfo,
      enableDrag: true,
      isScrollControlled: true,
      data: restaurant,
    );
  }

  void navToResSearchView() => _navService.navigateTo(
      Routes.restaurantSearchView); // TODO: Change page transition here

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_bottomCartService];
}
