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

/// NOTE: Here, instead of using MultiFutureViewModel, different viewModel is used so that model.initialise doesn't trigger when I already trigger _refreshController.requestRefresh()
class HomeViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  final _homeService = locator<HomeService>();
  final _mainCatService = locator<MainCatService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>(); // For BOTTOM CART part ONLY
  final _navService = locator<NavigationService>();
  final _dynamicLinkService = locator<DynamicLinkService>();
  final _dialogService = locator<DialogService>();
  final _geolocatorService = locator<GeolocatorService>();

  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  List<SliderModel>? get sliders => _homeService.sliders;
  List<MainCategory>? get mainCats => _homeService.mainCats;
  List<Restaurant>? get randomRess => _homeService.randomRess;
  List<Promoted?> get proms => _homeService.proms;
  List<Exclusive>? get exclusives => _homeService.exclusives;

  // List<int> get selectedMainCats =>
  //     _mainCatService.selectedMainCats; // NEEDS only for UI cases

  // FilterSort get selectedSort =>
  //     _mainCatService.selectedSort; // NEEDS only for UI cases

  bool get isFilterApplied =>
      _mainCatService.isFilterApplied; // NEEDS only for UI cases

  List<Restaurant> get selectedMainCatRestaurants => _homeService
      .selectedMainCatRestaurants!; // FOUND restaurants of selectedMainCats

  bool get fetchingFilter => _homeService.fetchingFilter;
  bool get fetchingFilterError => _homeService.fetchingFilterError;

  /// HOME RESS PAG
  int _page = 1;
  int get page => _page;
  bool get isPullUpEnabled => _homeService.isPullUpEnabled;

  /// Custom boolean busy indicator
  bool get busyForKeys =>
      busy(homeSlidersFuture) ||
      busy(homeMainCatsFuture) ||
      busy(homeRandomRessFuture) ||
      busy(homePromsFuture) ||
      busy(homeExclusivesFuture);

  /// Custom boolean error indicator
  bool get hasErrorForKeys =>
      hasErrorForKey(homeSlidersFuture) ||
      hasErrorForKey(homeMainCatsFuture) ||
      hasErrorForKey(homeRandomRessFuture) ||
      hasErrorForKey(homePromsFuture) ||
      hasErrorForKey(homeExclusivesFuture);

  //------------------ HOME FETCH ---------------------//

  /// GETS all home data
  Future getHomeData() async {
    /// GETS user's location
    await _geolocatorService.getUserLocation();
    await runBusyFuture(_homeService.getSliders(),
        busyObject: homeSlidersFuture);
    await runBusyFuture(_homeService.getMainCategs(),
        busyObject: homeMainCatsFuture);
    await runBusyFuture(_homeService.getPaginatedRess(),
        busyObject: homeRandomRessFuture);
    await runBusyFuture(_homeService.getProms(), busyObject: homePromsFuture);
    await runBusyFuture(_homeService.getExclusives(),
        busyObject: homeExclusivesFuture);
  }

  /// HOME RESS PAG
  /// GETS more home restaurants
  Future<void> getMorePaginatedRestaurants() async {
    _page++;
    log.v('getMorePaginatedRestaurants() with _page: $_page');
    await runBusyFuture(_homeService.getPaginatedRess(page: _page));
  }

  //------------------ PAGINATION ---------------------//

  /// HOME RESS PAG
  void enablePullUp() {
    _page = 1;
    _homeService.enablePullUp();
  }

  //------------------ HOME GETTER ---------------------//

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
        /// Here it CHECKS whether this PROMOTED's position is equa to this RESTAURANT. Add + 1 to restaurant bc of indexOf its position
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
    }
    return _homeRess;
  }

  /// CLEARS and UPDATES HomeView to its default
  Future<void> clearSelectedMainCatRess() async {
    _homeService.clearSelectedMainCatRess();
    _mainCatService.clearSelectedMainCats();
    _mainCatService.filterDisabled();
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

  //------------------ DRAWER ---------------------//

  void homeMenuPressed() {
    log.i('openDrawer()');
    homeScaffoldKey.currentState!.openDrawer();
  }

  //------------------ DYNAMIC LINK ---------------------//

  /// HANDLES clicked terminated dynamic link
  Future<void> handleClickedDynamicLink() async =>
      await _dynamicLinkService.handleClickedDynamicLinks();

  //------------------ NAVIGATION ---------------------//

  void navToHomeSearchView() async =>
      await _navService.navigateTo(Routes.homeSearchView);

  void navToSingleExView(ExclusiveSingle singleEx) async =>
      await _navService.navigateTo(
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

  // TODO: HiveRating
  //------------------ HIVE RATING PART ---------------------//

  /// GETS very first hiveRating
  HiveRating? get hiveRating => _hiveDbService.hiveRatings.isNotEmpty
      ? _hiveDbService.hiveRatings.first
      : null;

  Future<void> checkAndShowFirstHiveRating() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.rateOrder,
      showIconInMainButton: false,
      barrierDismissible: true,
      data: NotificationModel(
        id: hiveRating!.id,
        option: hiveRating!.option,
        resId: hiveRating!.resId,
        title: hiveRating!.title,
        status: hiveRating!.status,
        selfPickUp: hiveRating!.selfPickUp,
      ),
    );
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_mainCatService, _bottomCartService, _homeService, _hiveDbService];
}
