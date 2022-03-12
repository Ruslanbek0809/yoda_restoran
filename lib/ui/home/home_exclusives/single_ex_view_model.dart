import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class SingleExViewModel extends FutureViewModel {
  final log = getLogger('SingleExViewModel');
  final ExclusiveSingle? singleEx;
  SingleExViewModel(this.singleEx);

  final _api = locator<ApiService>();
  final _navService = locator<NavigationService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>();
  final _geolocatorService = locator<GeolocatorService>();

  Position? get locationPosition => _geolocatorService.locationPosition;

  List<EsRich> _seRiches = [];
  List<EsRich> get seRiches => _seRiches;

  // // FETCHS Restaurant categories with their meals
  Future getSingleExRiches() async {
    log.i('');
    await _api.getSingleExRiches(
      singleExId: singleEx!.id!,
      onSuccess: (result) => _seRiches = result,
    );

    log.i('_seRiches length: ${_seRiches.length}');
  }

  //------------------ SINGLE EX WEBVIEW ---------------------//

  String _url = '';
  String get url => _url;

  double _progress = 0;
  double get progress => _progress;

  void onLoadStart(Uri? onLoadUrl) {
    _url = onLoadUrl.toString();
    // notifyListeners();
  }

  void onProgressChanged(int progress) {
    _progress = progress / 100;
    // notifyListeners();
  }

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

//------------------------ NAVIGATIONS ----------------------------//

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
      [_bottomCartService, _hiveDbService];

  @override
  Future<void> futureToRun() async => await getSingleExRiches();
}
