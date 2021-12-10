import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class RestaurantDetailsViewModel extends BaseViewModel {
  final log = getLogger('RestaurantDetailsViewModel');

  final _navService = locator<NavigationService>();
  final _bottomCartService = locator<BottomCartService>();

  BottomCartStatus get bottomCartStatus => _bottomCartService.bottomCartStatus;

  int _activeTab = 0;
  bool _isTabPressed = false;
  bool _isShrink = false;

  int get activeTab => _activeTab;
  bool get isTabPressed => _isTabPressed;
  bool get isShrink => _isShrink;

  /// Function to change ACTIVE TAB
  void updateActiveTab(int tabIndex) {
    _activeTab = tabIndex;
    // log.i('_activeTab: $_activeTab');
    notifyListeners();
  }

  /// Function to change ACTIVE TAB
  void updateLastScrollStatus(bool isReallyShrink) {
    _isShrink = isReallyShrink;
    // log.i('_isShrink: $_isShrink');
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

  // TODO: restaurantInfoBottomSheet
  // void _onRestaurantInfoPressed() {
  //   restaurantInfoBottomSheet(context);
  // }

  void navToResSearchView() => _navService.navigateTo(
      Routes.restaurantSearchView); // TODO: Change page transition here
}
