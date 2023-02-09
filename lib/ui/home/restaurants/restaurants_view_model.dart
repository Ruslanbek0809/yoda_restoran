import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/hive_models/hive_models.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class RestauranstViewModel extends FutureViewModel {
  final log = getLogger('RestauranstViewModel');

  final _homeService = locator<HomeService>();
  final _navService = locator<NavigationService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>();

  List<Restaurant>? get allPaginatedRestaurants =>
      _homeService.allPaginatedRestaurants;

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity

  List<ResCategory> _resCategories = [];
  List<ResCategory> get resCategories => _resCategories;

  @override
  Future<void> futureToRun() async => runBusyFuture(
        _homeService.getAllPaginatedRestaurants(),
        // busyObject: allPaginatedRestaurantsFuture,
        throwException: true,
      );
  // @override
  // Future<void> futureToRun() async => await Future.delayed(Duration.zero);

//*----------------------- NAVIGATIONS ----------------------------//

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_homeService, _bottomCartService, _hiveDbService];
}
