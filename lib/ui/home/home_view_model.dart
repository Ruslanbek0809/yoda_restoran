import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/models/story.dart';
import 'package:yoda_res/ui/home/moments/moments_view.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/hive_models/hive_models.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../shared/shared.dart';
import '../../utils/utils.dart';

//* A map key of type string
const String homeSlidersFuture = 'homeSlidersFuture';
const String homeMainCatsFuture = 'homeMainCatsFuture';
const String homeSearchMainCatsFuture = 'homeSearchMainCatsFuture';
const String homeMomentsFuture = 'homeMomentsFuture';
const String homeRandomRessFuture = 'homeRandomRessFuture';
const String homePromsFuture = 'homePromsFuture';
const String homeExclusivesFuture = 'homeExclusivesFuture';

//*NOTE: Here, instead of using MultiFutureViewModel, different viewModel is used so that model.initialise doesn't trigger when I already trigger _refreshController.requestRefresh()
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
  List<MainCategory>? get searchMainCats => _homeService.searchMainCats;
  List<Restaurant>? get moments => _homeService.moments;
  List<Restaurant>? get randomRess => _homeService.randomRess;
  List<Promoted?> get proms => _homeService.proms;
  List<Exclusive>? get exclusives => _homeService.exclusives;

  // List<int> get selectedMainCats =>
  //     _mainCatService.selectedMainCats; // NEEDS only for UI cases

  // FilterSort get selectedSort =>
  //     _mainCatService.selectedSort; // NEEDS only for UI cases

  //* FILTER-RELATED VARS
  bool get fetchingFilter => _homeService
      .fetchingFilter; //* To show LOADING when FILTER or SINGLE CAT is applied in View
  bool get fetchingFilterError => _homeService
      .fetchingFilterError; //* To show ERROR while fetching selected FILTER or SINGLE CAT in View

  bool get isFilterApplied => _mainCatService
      .isFilterApplied; //* DISABLES filter unrelated part in View

  List<Restaurant> get selectedMainCatRestaurants => _homeService
      .selectedMainCatRestaurants; //* SHOWS found restaurants of selectedMainCats

  //* HOME RESS PAG
  int _page = 1;
  int get page => _page;
  bool get isPullUpEnabled => _homeService.isPullUpEnabled;

  //* Custom boolean busy indicator
  bool get busyForKeys =>
      busy(homeSlidersFuture) ||
      busy(homeMainCatsFuture) ||
      busy(homeSearchMainCatsFuture) ||
      busy(homeMomentsFuture) ||
      busy(homeRandomRessFuture) ||
      busy(homePromsFuture) ||
      busy(homeExclusivesFuture);

  //* Custom boolean error indicator
  bool get hasErrorForKeys =>
      hasErrorForKey(homeSlidersFuture) ||
      hasErrorForKey(homeMainCatsFuture) ||
      hasErrorForKey(homeSearchMainCatsFuture) ||
      hasErrorForKey(homeMomentsFuture) ||
      hasErrorForKey(homeRandomRessFuture) ||
      hasErrorForKey(homePromsFuture) ||
      hasErrorForKey(homeExclusivesFuture);

  //*----------------- HOME FETCH ---------------------//

  //* GETS all home data
  Future getHomeData() async {
    //* GETS user's location
    await _geolocatorService.getUserLocation();
    await runBusyFuture(_homeService.getSliders(),
        busyObject: homeSlidersFuture);
    await runBusyFuture(_homeService.getMainCategs(),
        busyObject: homeMainCatsFuture);
    await runBusyFuture(_homeService.getSearchMainCategs(),
        busyObject: homeSearchMainCatsFuture);
    await runBusyFuture(_homeService.getMoments(pageSize: 5),
        busyObject: homeMomentsFuture);
    await runBusyFuture(_homeService.getPaginatedRess(),
        busyObject: homeRandomRessFuture);
    await runBusyFuture(_homeService.getProms(), busyObject: homePromsFuture);
    await runBusyFuture(_homeService.getExclusives(),
        busyObject: homeExclusivesFuture);
  }

  //*----------------- PAGINATION ---------------------//

  //* HOME RESS PAG
  //* GETS more home restaurants
  Future<void> getMorePaginatedRestaurants() async {
    _page++;
    log.v('getMorePaginatedRestaurants() with _page: $_page');
    await runBusyFuture(_homeService.getPaginatedRess(page: _page));
  }

  //* HOME RESS PAG
  void enablePullUp() {
    _page = 1;
    _homeService.enablePullUp();
  }

  //*----------------- HOME GETTER ---------------------//

  //* GETTER for combined list of randomRestaurants and promotedRestaurants
  List<HomeResPromo>? get homeRess {
    List<HomeResPromo> _homeRess = [];
    int promPosCount = 0;

    //* Looping random restaurants
    for (final _randomRes in _homeService.randomRess) {
      int _randomResPos = _homeService.randomRess.indexOf(_randomRes);

      //* Here it CHECKS whether PROMOTED EXISTS in promPosCount's position or NOT.
      if (_homeService.proms.isNotEmpty &&
          _homeService.proms.length > promPosCount) {
        //* Here it CHECKS whether this PROMOTED's position is equa to this RESTAURANT. Add + 1 to restaurant bc of indexOf its position
        //* If it positions are EQUAL, then ADDS this PROMOTED to this RESTAURANT
        if (_homeService.proms[promPosCount].position == _randomResPos + 1) {
          _homeRess.add(
            HomeResPromo(
              _randomRes,
              Promoted(
                id: _homeService.proms[promPosCount].id,
                name: _homeService.proms[promPosCount].name,
                order: _homeService.proms[promPosCount].order,
                restaurants: _homeService.proms[promPosCount].restaurants,
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

//*----------------------- FILTER ----------------------------//

  //* DISABLES active filter error
  void disableActiveFilterErrorFromView() =>
      _homeService.disableActiveFilterError();

  //* CLEARS FILTER/MAINCAT and RESETS HomeView to its default
  Future<void> clearSelectedMainCatRess() async {
    _homeService.clearSelectedMainCatRess();
    _mainCatService.clearSelectedMainCats();
    _mainCatService.filterDisabled();
  }

  //*----------------- BOTTOM CART ---------------------//

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity
  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

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

  //*----------------- DRAWER ---------------------//

  void homeMenuPressed() {
    log.i('openDrawer()');
    homeScaffoldKey.currentState!.openDrawer();
  }

  //*----------------- MOMENTS ---------------------//

  Future<void> addRestaurantStoriesToStoriesBox(List<Story> stories) async {
    await _homeService.addRestaurantStoriesToStoriesBox(stories);
  }

  //*----------------- DYNAMIC LINK ---------------------//

  //*HANDLES clicked terminated dynamic link
  Future<void> handleClickedDynamicLink() async =>
      await _dynamicLinkService.handleClickedDynamicLinks();

  //*----------------- NAVIGATION ---------------------//

  void navToHomeSearchView() async =>
      await _navService.navigateTo(Routes.homeSearchView);

  void navToRestaurantsView() async =>
      await _navService.navigateTo(Routes.restaurantsView);

  void navToMomentsAllView() async =>
      await _navService.navigateTo(Routes.momentsAllView);

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
            notification: cartRes!.notification,
            workingHours: cartRes!.workingHours,
            city: cartRes!.city,
            distance: cartRes!.distance,
            selfPickUp: cartRes!.selfPickUp,
            delivery: cartRes!.delivery,
            paymentTypes: cartRes!.resPaymentTypes!
                .map((hiveResPaymentType) => PaymentType(
                      id: hiveResPaymentType.id,
                      nameTk: hiveResPaymentType.nameTk,
                      nameRu: hiveResPaymentType.nameRu,
                    ))
                .toList(),
          ),
        ),
      );

  Future<void> navToMomentStoryView(Restaurant restaurant) async =>
      await _navService.navigateTo(
        Routes.momentStoryView,
        arguments: MomentStoryViewArguments(restaurant: restaurant),
      );

  //*----------------- AWESOME DIALOG NAVIGATION ---------------------//

  Future<void> navToResDetailsViewViaAwesomeDialog(
          Restaurant restaurant) async =>
      await _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );

  Future<void> navToSliderWebview(String sliderUrl) async =>
      await _navService.navigateTo(
        Routes.sliderWebview,
        arguments: SliderWebviewArguments(sliderUrl: sliderUrl),
      );

  //*----------------- HIVE RATING PART ---------------------//

  //*GETS very first hiveRating
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

  FlashController? _flashController;

  /// CREATED custom flash bar instead of one global flash bar because multiple stack flash bar issue
  Future<void> showCustomFlashBar({
    required BuildContext context,
    String msg = LocaleKeys.errorOccured,
    bool isCartEmpty = true,
    Duration duration = const Duration(seconds: 2),
  }) async {
    if (_flashController?.isDisposed == false)
      await _flashController?.dismiss();
    _flashController = FlashController<dynamic>(
      context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          barrierDismissible: true,
          margin: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: isCartEmpty ? 0.05.sh : 0.12.sh,
          ),
          position: FlashPosition.bottom,
          behavior: FlashBehavior.floating,
          boxShadows: kElevationToShadow[0],
          borderRadius: AppTheme().radius16,
          backgroundColor: kcSecondaryDarkColor,
          child: FlashBar(
            icon: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 12.w),
              child: SvgPicture.asset(
                'assets/warning.svg',
                width: 20.w,
                height: 20.h,
              ),
            ),
            content: Text(msg, style: kts16ButtonText).tr(),
          ),
        );
      },
    );
    await _flashController?.show();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_mainCatService, _bottomCartService, _homeService, _hiveDbService];
}
