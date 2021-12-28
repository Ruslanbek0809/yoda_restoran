import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/services/services.dart';

class CartMealViewModel extends ReactiveViewModel {
  final log = getLogger('CartMealViewModel');

  final _hiveDbService = locator<HiveDbService>();

  HiveMeal? cartMeal;
  int quantity = 0;

  /// GETS quantity of cartMeal for this mealId
  void getCartMealQuantity(HiveMeal hiveMeal) {
    quantity = _hiveDbService.getCartMealQuantity(hiveMeal);
    cartMeal = hiveMeal; // Assigning initial value
    notifyListeners();
  }

  /// GETS total meal draft sum
  num get totalMealSum {
    num totalMealSum = 0;
    totalMealSum += cartMeal!.discount != null || cartMeal!.discount! > 0
        ? cartMeal!.discountedPrice!
        : cartMeal!.price!;

    cartMeal!.volumes!.forEach((vol) {
      if (vol.id != -1) totalMealSum += vol.price!;
    });
    cartMeal!.customs!.forEach((cus) {
      totalMealSum += cus.price!;
    });

    totalMealSum *= quantity;
    return totalMealSum;
  }

  /// CONCATENATES all cartMeal vols and customs into one string
  String get concatenateVolsCustoms {
    StringBuffer concatenatedString = StringBuffer();

    cartMeal!.volumes!.forEach((vol) {
      if (vol.id != -1) concatenatedString.write('${vol.name} ');
    });

    cartMeal!.customs!.forEach((cus) {
      concatenatedString.write('${cus.name} ');
    });

    return concatenatedString.toString();
  }

  /// UPDATES cartMeal
  Future<void> updateCartMealInCart(int? mealQuantity) async {
    log.i(
        'updateCartMealInCart() cartMeal.id: ${cartMeal!.id}, mealQuantity: $mealQuantity');

    await _hiveDbService.updateCartMealInCart(
        hiveMeal: cartMeal, quantity: mealQuantity);
    quantity = _hiveDbService.getCartMealQuantity(cartMeal!);

    log.i('updateCartMealInCart() quantity: $quantity');
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
