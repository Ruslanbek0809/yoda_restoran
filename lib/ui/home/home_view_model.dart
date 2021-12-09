import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/home_service.dart';

// A map key of type string
const String homeSlidersFuture = 'homeSlidersFuture';
const String homeMainCatFuture = 'homeMainCatFuture';

class HomeViewModel extends MultipleFutureViewModel {
  final log = getLogger('HomeViewModel');

  final _homeService = locator<HomeService>();

  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  List<SliderModel>? get sliders => dataMap![homeSlidersFuture];
  List<MainCategory>? get mainCategories => dataMap![homeMainCatFuture];

  bool get fetchinghomeSliders => busy(homeSlidersFuture);
  bool get fetchinghomeMainCat => busy(homeMainCatFuture);

  void homeMenuPressed() {
    log.i('openDrawer()');
    homeScaffoldKey.currentState!.openDrawer();
  }

  @override
  Map<String, Future Function()> get futuresMap => {
        homeSlidersFuture: _homeService.getSliders,
        homeMainCatFuture: _homeService.getMainCategories,
      };
}
