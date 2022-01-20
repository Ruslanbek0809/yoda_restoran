import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/services/services.dart';

/// This VM just to update quantity in realtime
class ResBottomCartTotalViewModel extends ReactiveViewModel {
  final log = getLogger('ResBottomCartTotalViewModel');

  final _hiveDbService = locator<HiveDbService>();
  final _bottomCartService = locator<BottomCartService>();

  List<HiveMeal> get cartMeals => _hiveDbService.cartMeals;
  bool get isUpdateQuantity => _bottomCartService.isUpdateQuantity;

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

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_hiveDbService, _bottomCartService];
}
