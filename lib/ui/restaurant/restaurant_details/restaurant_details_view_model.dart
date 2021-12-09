import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';

class RestaurantDetailsViewModel extends BaseViewModel {
  final log = getLogger('RestaurantDetailsViewModel');

  final _navService = locator<NavigationService>();

  int _activeTab = 0;
  bool _isTabPressed = false;
  bool _isShrink = false;

  int get activeTab => _activeTab;
  bool get isTabPressed => _isTabPressed;
  bool get isShrink => _isShrink;

  /// Function to change ACTIVE TAB
  void updateActiveTab(int tabIndex) {
    log.i('TabIndex: $tabIndex');
    _activeTab = tabIndex;
    notifyListeners();
  }

  /// Function to change ACTIVE TAB
  void updateLastScrollStatus(bool isReallyShrink) {
    log.i('isReallyShrink: $isReallyShrink');
    _isShrink = isReallyShrink;
    notifyListeners();
  }

  // Function to create ripple like effect when Tab pressed
  void updateOnTapRipple() {
    if (_isTabPressed) {
      Timer(Duration(milliseconds: 1200), () {
        _isTabPressed = false;
        notifyListeners();
      });
    } else {
      _isTabPressed = true;
      notifyListeners();
    }
    log.i('_isTabPressed: $_isTabPressed');
  }

  // TODO: restaurantInfoBottomSheet
  // void _onRestaurantInfoPressed() {
  //   restaurantInfoBottomSheet(context);
  // }

  void navToResSearchView() => _navService.navigateTo(
      Routes.restaurantSearchView); // TODO: Change page transition here
}
