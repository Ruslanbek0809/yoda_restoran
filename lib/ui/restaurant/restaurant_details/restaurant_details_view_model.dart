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
  final _restaurantService = locator<RestaurantService>();

  // Restaurant? _restaurant;
  int _activeTab = 0;
  bool _isTabPressed = false;
  bool _isShrink = false;

  int get activeTab => _activeTab;
  bool get isTabPressed => _isTabPressed;
  bool get isShrink => _isShrink;

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity
  List<ResCategory>? get resCategories => _restaurantService.resCategories;

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

  // Function to fetch Restaurant categories with their meals
  Future getResCatsWithMeals(int restaurantId) async {
    await runBusyFuture(_restaurantService.getResCatsWithMeals(restaurantId));
    log.i('resCategories length: ${resCategories!.length}');
  }

  void navToResSearchView() => _navService.navigateTo(
      Routes.restaurantSearchView); // TODO: Change page transition here

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_bottomCartService];
}
