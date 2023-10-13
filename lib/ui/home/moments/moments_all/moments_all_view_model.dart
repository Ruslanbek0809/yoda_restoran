import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/story.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../models/hive_models/hive_restaurant.dart';
import '../../../../models/models.dart';
import '../../../../services/services.dart';
import '../../../../utils/utils.dart';

class MomentsAllViewModel extends FutureViewModel {
  final log = getLogger('MomentsAllViewModel');

  final _homeService = locator<HomeService>();
  final _bottomCartService = locator<BottomCartService>();
  final _hiveDbService = locator<HiveDbService>();
  final _navService = locator<NavigationService>();

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

  //*----------------- MOMENTS ---------------------//

  Future<void> addRestaurantStoriesToStoriesBox(List<Story> stories) async {
    await _homeService.addRestaurantStoriesToStoriesBox(stories);
  }

  //*----------------- NAVIGATIONS ---------------------//

  Future<void> navToMomentStoryView(Restaurant restaurant) async =>
      await _navService.navigateTo(
        Routes.momentStoryView,
        arguments: MomentStoryViewArguments(restaurant: restaurant),
      );

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

  List<Restaurant> get allMoments => _homeService.moments;

  @override
  Future<void> futureToRun() async => runBusyFuture(
        _homeService.getMoments(),
        throwException: true,
      );

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_homeService, _bottomCartService, _hiveDbService];
}
