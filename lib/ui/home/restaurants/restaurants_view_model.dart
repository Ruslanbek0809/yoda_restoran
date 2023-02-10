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

  bool get fetchingFilter => _homeService
      .fetchingFilter; //* To show LOADING when FILTER or SINGLE CAT is applied in View
  bool get fetchingFilterError => _homeService
      .fetchingFilterError; //* To show ERROR while fetching selected FILTER or SINGLE CAT in View

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;
  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; //* Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity

//*----------------------- INITIAL ----------------------------//

  List<Restaurant>? get allPaginatedRestaurants =>
      _homeService.allPaginatedRestaurants;

  @override
  Future<void> futureToRun() async => runBusyFuture(
        _homeService.getAllPaginatedRestaurants(),
        throwException: true,
      );

//*----------------------- FILTER ----------------------------//

  void disableActiveFilterErrorFromView() =>
      _homeService.disableActiveFilterError();

//*----------------------- NAVIGATIONS ----------------------------//

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_homeService, _bottomCartService, _hiveDbService];
}
