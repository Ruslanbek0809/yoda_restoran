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

class HomeViewModel extends MultipleFutureViewModel {
  final log = getLogger('HomeViewModel');

  final _homeService = locator<HomeService>();
  final _mainCatService = locator<MainCatService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>(); // For BOTTOM CART part ONLY
  final _navService = locator<NavigationService>();

  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  List<SliderModel>? get sliders => _homeService.sliders;
  List<MainCategory>? get mainCats => _homeService.mainCats;
  List<Restaurant>? get randomRess => _homeService.randomRess;
  List<Promoted>? get proms => _homeService.proms;

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity

  // List<int> get selectedMainCats => _mainCatService.selectedMainCats;
  List<Restaurant> get selectedMainCatRestaurants =>
      _homeService.selectedMainCatRestaurants!;

  // List<SliderModel>? get sliders => dataMap![homeSlidersFuture];
  // List<MainCategory>? get mainCategories => dataMap![homeMainCatFuture];
  // List<Restaurant>? get randomRestaurants => dataMap![homeRandomResFuture];
  // List<Promoted>? get promotedRes => dataMap![homePromotedResFuture];

  bool get fetchinghomeSliders => busy(homeSlidersFuture);
  bool get fetchinghomeMainCat => busy(homeMainCatsFuture);
  bool get fetchingRandomRes => busy(homeRandomRessFuture);
  bool get fetchingPromotedRes => busy(homePromsFuture);
  bool get fetchingSelectedMainCatsRes => _homeService.fetchingSelectedMainCats;

  /// GETTER for combined list of randomRestaurants and promotedRestaurants
  List<HomeResPromo>? get resWithProms {
    List<HomeResPromo> _resWithProms = [];
    int promoPosCount = 0;
    if (_homeService.randomRess!.isNotEmpty)
      _homeService.randomRess!.forEach(
        (_randomRes) {
          int pos = _homeService.randomRess!.indexOf(_randomRes);

          /// Here in 5th restaurant we will add new Promoted from promotedList
          if ((pos + 1) % 5 == 0) {
            if (promoPosCount <= _homeService.proms!.length - 1)
              _resWithProms.add(
                HomeResPromo(
                  _randomRes,
                  Promoted(
                    id: _homeService.proms![promoPosCount].id,
                    name: _homeService.proms![promoPosCount].name,
                    order: _homeService.proms![promoPosCount].order,
                    restaurants: _homeService.proms![promoPosCount].restaurants,
                  ),
                ),
              );
            promoPosCount++;
          } else {
            _resWithProms.add(HomeResPromo(_randomRes, null));
          }
        },
      );
    return _resWithProms;
  }

  /// CLEARS and UPDATES HomeView to its default
  Future<void> clearSelectedMainCatRess() async {
    _homeService.clearSelectedMainCatRess();
    _mainCatService.clearSelectedMainCats();
    await initialise();
  }

  //------------------ DRAWER ---------------------//

  void homeMenuPressed() {
    log.i('openDrawer()');
    homeScaffoldKey.currentState!.openDrawer();
  }

  @override
  Map<String, Future Function()> get futuresMap => {
        homeSlidersFuture: _homeService.getSliders,
        homeMainCatsFuture: _homeService.getMainCategs,
        homeRandomRessFuture: _homeService.getRandomRess,
        homePromsFuture: _homeService.getProms,
      };

  //------------------ BOTTOM CART ---------------------//

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  void navToResDetailsView() => _navService.navigateTo(
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
          ),
        ),
      );

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_bottomCartService, _homeService];

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
