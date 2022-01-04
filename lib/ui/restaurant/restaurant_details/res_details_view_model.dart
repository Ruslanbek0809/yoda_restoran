import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

/// ReactiveViewModel is used to "react"
class ResDetailsViewModel extends FutureViewModel {
  final log = getLogger('ResDetailsViewModel');
  final Restaurant? restaurant;
  ResDetailsViewModel(this.restaurant);

  final _navService = locator<NavigationService>();
  final _resService = locator<ResService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _bottomCartService = locator<BottomCartService>();

  int _activeTab = 0;
  bool _isTabPressed = false;
  bool _isShrink = false;

  int get activeTab => _activeTab;
  bool get isTabPressed => _isTabPressed;
  bool get isShrink => _isShrink;

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity
  List<ResCategory>? get resCategories => _resService.resCategories;

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

  // // FETCHS Restaurant categories with their meals
  Future getResCatsWithMeals(int resId) async {
    log.i('');
    await _resService.getResCatsWithMeals(resId);
    // await runBusyFuture(_resService.getResCatsWithMeals(resId));
    log.i('resCategories length: ${resCategories!.length}');
  }

//------------------------ RESTAURANT BOTTOM SHEET ----------------------------//

  /// SHOWS RestaurantDetailsInfoBottomSheet
  Future showCustomBottomSheet(Restaurant restaurant) async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.restaurantInfo,
      enableDrag: true,
      isScrollControlled: true,
      data: restaurant,
    );
  }

//------------------------ NAVIGATIONS ----------------------------//

  Future<void> navToCartView() async {
    bool _navResult = false;
    _navResult = await _navService.navigateTo(Routes.cartView);
    if (_navResult) await initialise(); // Workaround
  } // TODO: Change page transition here

  void navToResSearchView() => _navService.navigateTo(
      Routes.restaurantSearchView); // TODO: Change page transition here

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_bottomCartService];

  @override
  Future<void> futureToRun() async =>
      await getResCatsWithMeals(restaurant!.id!);
}
