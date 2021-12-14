import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

// A map key of type string
const String homeSlidersFuture = 'homeSlidersFuture';
const String homeMainCatsFuture = 'homeMainCatsFuture';
const String homeRandomRessFuture = 'homeRandomRessFuture';
const String homePromsFuture = 'homePromsFuture';

class HomeViewModel extends MultipleFutureViewModel {
  final log = getLogger('HomeViewModel');

  final _homeService = locator<HomeService>();
  final _bottomCartService = locator<BottomCartService>();

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here we just receive bottomCartStatus from _bottomCartService for realtime reactivity

  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  List<SliderModel>? get sliders => _homeService.sliders;
  List<MainCategory>? get mainCats => _homeService.mainCats;
  List<Restaurant>? get randomRess => _homeService.randomRess;
  List<Promoted>? get proms => _homeService.proms;

  /// Combined list of randomRestaurants and promotedRestaurants
  List<HomeResPromo>? get resWithProms {
    List<HomeResPromo> _resWithProms = [];
    int promoPosCount = 0;

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

  // List<SliderModel>? get sliders => dataMap![homeSlidersFuture];
  // List<MainCategory>? get mainCategories => dataMap![homeMainCatFuture];
  // List<Restaurant>? get randomRestaurants => dataMap![homeRandomResFuture];
  // List<Promoted>? get promotedRes => dataMap![homePromotedResFuture];

  bool get fetchinghomeSliders => busy(homeSlidersFuture);
  bool get fetchinghomeMainCat => busy(homeMainCatsFuture);
  bool get fetchingRandomRes => busy(homeRandomRessFuture);
  bool get fetchingPromotedRes => busy(homePromsFuture);

  // int get promotedCounter =>
  //     _promotedCounter++; // Increment each time when promoted part is displayed

  void homeMenuPressed() {
    log.i('openDrawer()');
    homeScaffoldKey.currentState!.openDrawer();
  }

  // Function to call all apis when button is clicked
  // Future callFuturePullToRefresh() async {
  //   log.i('');
  //   await runBusyFuture(
  //     Future.wait(
  //       [
  //         _homeService.getSliders(),
  //         _homeService.getMainCategs(),
  //         _homeService.getRandomRess(),
  //         _homeService.getProms(),
  //       ],
  //     ),
  //   );
  // }

  @override
  Map<String, Future Function()> get futuresMap => {
        homeSlidersFuture: _homeService.getSliders,
        homeMainCatsFuture: _homeService.getMainCategs,
        homeRandomRessFuture: _homeService.getRandomRess,
        homePromsFuture: _homeService.getProms,
      };

  //------------------ Custom overridden REACTIVE PART ---------------------//
  late List<ReactiveServiceMixin> _reactiveServices;

  // List<ReactiveServiceMixin> get reactiveServices; /// Instead of this getter I will directly initialise reactiveness here

  HomeViewModel() {
    _reactToServices([_bottomCartService]);
    // _reactToServices(reactiveServices);
  }

  void _reactToServices(List<ReactiveServiceMixin> reactiveServices) {
    _reactiveServices = reactiveServices;
    for (var reactiveService in _reactiveServices) {
      reactiveService.addListener(_indicateChange);
    }
  }

  @override
  void dispose() {
    for (var reactiveService in _reactiveServices) {
      reactiveService.removeListener(_indicateChange);
    }
    super.dispose();
  }

  void _indicateChange() {
    notifyListeners();
  }
}
