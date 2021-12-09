import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantDetailsViewModel extends BaseViewModel {
  final log = getLogger('RestaurantDetailsViewModel');

  final _navService = locator<NavigationService>();

  int _activeTab = 0;
  bool _isTabPressed = false;

  int get activeTab => _activeTab;
  bool get isTabPressed => _isTabPressed;

  /// Function to change ACTIVE TAB
  void updateActiveTab(int tabIndex) {
    _activeTab = tabIndex;
    notifyListeners();
  }

  void tabOnTapPressed(int index) {
    double itemWidth = (1.sw - 5.w * 2 - 20.w) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing) / crossAxisCount

    double itemHeight = itemWidth + 0.3.sw; // 0.4.sw is for item height

    _isTabPressed = true;
    notifyListeners();
    double offset = foodCategoryList.getRange(0, index).fold(
      0,
      (prev, category) {
        int rows =
            (foodList.length / 2).ceil(); // food length to crossAxisCount
        return prev += rows * (itemHeight + 24.w); // GridView vertical padding
      },
    );

    // _sliverScrollController.animateTo(
    //   offset +
    //       ((index - 1) * 50.w) +
    //       0.55.sh -
    //       45.w, // * 50.w is same with each Food category title height // + 0.55.sh is to compensate 0.55.sh expanded height // + 45.w is for tab title
    //   duration: Duration(milliseconds: 300),
    //   curve: Curves.linear,
    // );
    Timer(Duration(milliseconds: 1200), () {
      _isTabPressed = false;
    notifyListeners();
    });
  }

  void navToResSearchView() => _navService.navigateTo(
      Routes.restaurantSearchView); // TODO: Change page transition here
}
