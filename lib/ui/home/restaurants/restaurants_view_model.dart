import 'dart:async';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/hive_models/hive_models.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class RestauranstViewModel extends FutureViewModel {
  final log = getLogger('RestauranstViewModel');

  final _homeService = locator<HomeService>();
  final _mainCatService = locator<MainCatService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>();
  final _navService = locator<NavigationService>();

  //* FILTER-RELATED VARS
  bool get fetchingFilter => _homeService
      .fetchingFilter; //* To show LOADING when FILTER or SINGLE CAT is applied in View
  bool get fetchingFilterError => _homeService
      .fetchingFilterError; //* To show ERROR while fetching selected FILTER or SINGLE CAT in View

  bool get isFilterApplied => _mainCatService
      .isFilterApplied; //* DISABLES filter unrelated part in View

  List<Restaurant> get selectedMainCatRestaurants => _homeService
      .selectedMainCatRestaurants; //* SHOWS found restaurants of selectedMainCats

  //*----------------- BOTTOM CART ---------------------//

  //* BOTTOM CART VARS
  HiveRestaurant? get cartRes => _hiveDbService.cartRes;
  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; //* Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity

  //*GETS total cart meals sum with each price/discountPrice, vols price, customs price, and each cartMeal's quantity
  num get getTotalCartSum {
    num totalCartSum = 0;

    _hiveDbService.cartMeals.forEach((_cartMeal) {
      num _totalCartMealSum = 0;
      _totalCartMealSum += _cartMeal.discount != null || _cartMeal.discount! > 0
          ? _cartMeal.discountedPrice!
          : _cartMeal.price!;

      _cartMeal.volumes!.forEach((vol) {
        if (vol.id != -1) _totalCartMealSum += vol.price!;
      });
      _cartMeal.customs!.forEach((cus) {
        _totalCartMealSum += cus.price!;
      });

      _totalCartMealSum *= _cartMeal.quantity!;

      totalCartSum += _totalCartMealSum;
    });

    return totalCartSum;
  }

  void navToResDetailsViewFromBottomCart() async =>
      await _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(
          restaurant: Restaurant(
            id: cartRes!.id,
            name: cartRes!.name,
            image: cartRes!.image,
            rated: cartRes!.rated,
            rating: cartRes!.rating,
            description: cartRes!.description,
            deliveryPrice: cartRes!.deliveryPrice,
            address: cartRes!.address,
            phoneNumber: cartRes!.phoneNumber,
            prepareTime: cartRes!.prepareTime,
            notification: cartRes!.notification,
            workingHours: cartRes!.workingHours,
            city: cartRes!.city,
            distance: cartRes!.distance,
            selfPickUp: cartRes!.selfPickUp,
            delivery: cartRes!.delivery,
          ),
        ),
      );

//*----------------------- INITIAL ----------------------------//

  List<Restaurant> get allPaginatedRestaurants =>
      _homeService.allPaginatedRestaurants;

  @override
  Future<void> futureToRun() async => runBusyFuture(
        _homeService.getAllPaginatedRestaurants(),
        throwException: true,
      );

//*----------------------- FILTER ----------------------------//

  //* DISABLES active filter error
  void disableActiveFilterErrorFromView() =>
      _homeService.disableActiveFilterError();

  //* CLEARS FILTER/MAINCAT and RESETS RestaurantsView to its default
  Future<void> clearSelectedMainCatRess() async {
    _homeService.clearSelectedMainCatRess();
    _mainCatService.clearSelectedMainCats();
    _mainCatService.filterDisabled();
  }

//*----------------------- CUSTOM SNACKBAR ----------------------------//

  FlashController? _flashController;

  //* CREATED custom flash bar instead of one global flash bar because multiple stack flash bar issue
  Future<void> showCustomFlashBar({
    required BuildContext context,
    String msg = LocaleKeys.errorOccured,
    bool isCartEmpty = true,
    Duration duration = const Duration(seconds: 2),
  }) async {
    await showCustomFlashBarWithFlashController(
      context: context,
      flashController: _flashController,
      msg: msg,
      duration: duration,
      isCartEmpty: isCartEmpty,
    );
  }

//*----------------------- NAVIGATIONS ----------------------------//

  void navToResDetailsView(Restaurant restaurant) => _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_homeService, _bottomCartService, _hiveDbService];
}
