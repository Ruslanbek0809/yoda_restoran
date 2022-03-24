import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../models/hive_models/hive_models.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

// A map key of type string
const String homeSlidersFuture = 'homeSlidersFuture';
const String homeMainCatsFuture = 'homeMainCatsFuture';
const String homeRandomRessFuture = 'homeRandomRessFuture';
const String homePromsFuture = 'homePromsFuture';
const String homeExclusivesFuture = 'homeExclusivesFuture';

class HomeViewModel extends MultipleFutureViewModel {
  final log = getLogger('HomeViewModel');

  final _homeService = locator<HomeService>();
  final _mainCatService = locator<MainCatService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>(); // For BOTTOM CART part ONLY
  final _navService = locator<NavigationService>();
  final _dynamicLinkService = locator<DynamicLinkService>();

  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  List<SliderModel>? get sliders => _homeService.sliders;
  List<MainCategory>? get mainCats => _homeService.mainCats;
  List<Restaurant>? get randomRess => _homeService.randomRess;
  List<Promoted?> get proms => _homeService.proms;
  List<Exclusive>? get exclusives => _homeService.exclusives;

  List<int> get selectedMainCats =>
      _mainCatService.selectedMainCats; // NEEDS only for UI cases

  List<Restaurant> get selectedMainCatRestaurants => _homeService
      .selectedMainCatRestaurants!; // FOUND restaurants of selectedMainCats

  // List<SliderModel>? get sliders => dataMap![homeSlidersFuture];
  // List<MainCategory>? get mainCategories => dataMap![homeMainCatFuture];
  // List<Restaurant>? get randomRestaurants => dataMap![homeRandomResFuture];
  // List<Promoted>? get promotedRes => dataMap![homePromotedResFuture];

  bool get fetchinghomeSliders => busy(homeSlidersFuture);
  bool get fetchinghomeMainCat => busy(homeMainCatsFuture);
  bool get fetchingRandomRes => busy(homeRandomRessFuture);
  bool get fetchingPromotedRes => busy(homePromsFuture);
  bool get fetchingExclusives => busy(homeExclusivesFuture);
  bool get fetchingSelectedMainCatsRes => _homeService.fetchingSelectedMainCats;
  bool get fetchingSelectError => _homeService.fetchingSelectError;

  bool _hasFutureError = false;
  bool get hasFutureError => _hasFutureError;

  /// GETTER for combined list of randomRestaurants and promotedRestaurants
  List<HomeResPromo>? get homeRess {
    List<HomeResPromo> _homeRess = [];
    int promPosCount = 0;

    /// Looping random restaurants
    for (final _randomRes in _homeService.randomRess!) {
      int _randomResPos = _homeService.randomRess!.indexOf(_randomRes);

      /// Here it CHECKS whether PROMOTED EXISTS in promPosCount's position or NOT.
      if (_homeService.proms.isNotEmpty &&
          _homeService.proms.length > promPosCount) {
        /// Here it CHECKS whether this PROMOTED's position is equal to this RESTAURANT. Add + 1 to restaurant bc of indexOf its position
        /// If it positions are EQUAL, then ADDS this PROMOTED to this RESTAURANT
        if (_homeService.proms[promPosCount]!.position == _randomResPos + 1) {
          _homeRess.add(
            HomeResPromo(
              _randomRes,
              Promoted(
                id: _homeService.proms[promPosCount]!.id,
                name: _homeService.proms[promPosCount]!.name,
                order: _homeService.proms[promPosCount]!.order,
                restaurants: _homeService.proms[promPosCount]!.restaurants,
              ),
            ),
          );
          promPosCount++;
        } else
          _homeRess.add(HomeResPromo(_randomRes, null));
      } else
        _homeRess.add(HomeResPromo(_randomRes, null));

      // /// Here in 5th restaurant we will add new PROMOTED with its restaurants from promotedList
      // if ((_randomResPos + 1) % 5 == 0) {
      //   /// Here it CHECKS whether PROMOTED EXISTS in promPosCount's position or NOT.
      //   /// If yes, then ADDS promPosCount's positioned PROMOTED. Else it ADDS 5th randomRes
      //   if (_homeService.proms.isNotEmpty &&
      //       _homeService.proms.length > promPosCount) {
      //     _homeRess.add(
      //       HomeResPromo(
      //         _randomRes,
      //         Promoted(
      //           id: _homeService.proms[promPosCount]!.id,
      //           name: _homeService.proms[promPosCount]!.name,
      //           order: _homeService.proms[promPosCount]!.order,
      //           restaurants: _homeService.proms[promPosCount]!.restaurants,
      //         ),
      //       ),
      //     );
      //     promPosCount++;
      //   } else
      //     _homeRess.add(HomeResPromo(_randomRes, null));
      // } else
      //   _homeRess.add(HomeResPromo(_randomRes, null));
    }
    // log.v('_resWithProms.length: ${_resWithProms.length}');
    return _homeRess;
  }

  /// CLEARS and UPDATES HomeView to its default
  Future<void> clearSelectedMainCatRess() async {
    _homeService.clearSelectedMainCatRess();
    _mainCatService.clearSelectedMainCats();
  }

  //------------------ DRAWER ---------------------//

  void homeMenuPressed() {
    log.i('openDrawer()');
    homeScaffoldKey.currentState!.openDrawer();
  }

  void refresh() {
    notifyListeners();
  }

  @override
  Map<String, Future Function()> get futuresMap => {
        homeSlidersFuture: _homeService.getSliders,
        homeMainCatsFuture: _homeService.getMainCategs,
        homeRandomRessFuture: _homeService.getRandomRess,
        homePromsFuture: _homeService.getProms,
        homeExclusivesFuture: _homeService.getExclusives,
      };

  /// Below lines are custom error part
  @override
  void onError({error, key}) {
    _hasFutureError = true;
  }

  /// Below lines are custom error part
  @override
  void onData(key) {
    _hasFutureError = false;
  }

  void updateHasFutureError() {
    _hasFutureError = false;
  }

  void updateFetchingSelectedError() => _homeService.disableSelectError();

  //------------------ BOTTOM CART ---------------------//

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity
  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  /// GETS total cart meals sum with each price/discountPrice, vols price, customs price, and each cartMeal's quantity
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

  //------------------ DYNAMIC LINK ---------------------//

  /// HANDLES clicked terminated dynamic link
  Future<void> handleClickedDynamicLink() async =>
      await _dynamicLinkService.handleClickedDynamicLinks();

  //------------------ NAVIGATION ---------------------//

  void navToHomeSearchView() async =>
      await _navService.navigateTo(Routes.homeSearchView);

  void navToSingleExView(ExclusiveSingle singleEx) => _navService.navigateTo(
        Routes.singleExView,
        arguments: SingleExViewArguments(singleEx: singleEx),
      );

  void navToResDetailsView() async => await _navService.navigateTo(
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
            workingHours: cartRes!.workingHours,
            city: cartRes!.city,
            distance: cartRes!.distance,
            selfPickUp: cartRes!.selfPickUp,
            delivery: cartRes!.delivery,
          ),
        ),
      );

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_bottomCartService, _homeService, _hiveDbService];

  //------------------ Custom overridden REACTIVE PART ---------------------//
  // late List<ReactiveServiceMixin> _reactiveServices;

  // HomeViewModel() {
  //   _reactToServices([_bottomCartService, _homeService]);
  // }

  // void _reactToServices(List<ReactiveServiceMixin> reactiveServices) {
  //   _reactiveServices = reactiveServices;
  //   for (var reactiveService in _reactiveServices) {
  //     reactiveService.addListener(_indicateChange);
  //   }
  // }

  // @override
  // void dispose() {
  //   for (var reactiveService in _reactiveServices) {
  //     reactiveService.removeListener(_indicateChange);
  //   }
  //   super.dispose();
  // }

  // void _indicateChange() {
  //   notifyListeners();
  // }
}
