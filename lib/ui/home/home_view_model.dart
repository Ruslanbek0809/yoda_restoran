import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/home_service.dart';

// A map key of type string
const String homeSlidersFuture = 'homeSlidersFuture';
const String homeMainCatFuture = 'homeMainCatFuture';
const String homeRandomResFuture = 'homeRandomResFuture';
const String homePromotedResFuture = 'homePromotedResFuture';

class HomeViewModel extends MultipleFutureViewModel {
  final log = getLogger('HomeViewModel');

  final _homeService = locator<HomeService>();

  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  List<SliderModel>? get sliders => dataMap![homeSlidersFuture];
  List<MainCategory>? get mainCategories => dataMap![homeMainCatFuture];
  List<Restaurant>? get randomRestaurants => dataMap![homeRandomResFuture];
  List<Promoted>? get promotedRes => dataMap![homePromotedResFuture];

  bool get fetchinghomeSliders => busy(homeSlidersFuture);
  bool get fetchinghomeMainCat => busy(homeMainCatFuture);
  bool get fetchingRandomRes => busy(homeRandomResFuture);
  bool get fetchingPromotedRes => busy(homePromotedResFuture);

  int _promotedCounter = 0;
  bool get isOkToPromote =>
      _promotedCounter <
      promotedRes!.length; // Check if promoted below than its length

  int get promotedCounter =>
      _promotedCounter; // Increment each time when promoted part is displayed

  // int get promotedCounter =>
  //     _promotedCounter++; // Increment each time when promoted part is displayed

  void homeMenuPressed() {
    log.i('openDrawer(): $_promotedCounter');
    homeScaffoldKey.currentState!.openDrawer();
  }

  @override
  Map<String, Future Function()> get futuresMap => {
        homeSlidersFuture: _homeService.getSliders,
        homeMainCatFuture: _homeService.getMainCategories,
        homeRandomResFuture: _homeService.getRandomRestorants,
        homePromotedResFuture: _homeService.getPromotedRestaurants,
      };
}
