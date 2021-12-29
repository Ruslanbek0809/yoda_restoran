import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class CartViewModel extends ReactiveViewModel {
  final log = getLogger('CartViewModel');

  final _hiveDbService = locator<HiveDbService>();
  final _dialogService = locator<DialogService>();
  final _navService = locator<NavigationService>();
  final _cartService = locator<CartService>();

  List<HiveMeal> get cartMeals => _hiveDbService.cartMeals;

  List<Meal>? get moreMeals => _cartService.moreMeals;

  Promocode? get promocode => _cartService.promocode;

  // void getCartMeals() {
  //   cartMeals = _hiveDbService.cartMeals;
  //   log.i('cartMeals length: ${cartMeals.length}');
  //   notifyListeners();
  // }

  // FETCHS more meals and GETS all carts
  Future getMoreMeals() async {
    // getCartMeals();
    await runBusyFuture(_cartService.getMoreMeals());
    log.i('moreMeals length: ${moreMeals!.length} ');
    // notifyListeners();
  }

  /// CLEAR CART
  Future<void> clearCart() async {
    log.i('clearCart()');

    await _hiveDbService.clearCart();
    log.i('cartMeals length: ${cartMeals.length}');
    notifyListeners();
    navBack();
  }

//------------------------ Clear CART DIALOG PART ----------------------------//

  /// SHOWS Clear CART Dialog
  Future showClearCartDialog(CartViewModel cartViewModel) async {
    log.i('showClearCartDialog()');
    await _dialogService.showCustomDialog(
      variant: DialogType.clearCart,
      title: 'Siz sebedi boşatmakçymy?',
      mainButtonTitle: 'Ýok',
      secondaryButtonTitle: 'Hawa',
      showIconInMainButton: false,
      barrierDismissible: true,
      data: cartViewModel,
    );
  }

//------------------------ CART MEAL ----------------------------//

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

//------------------------ CART MEAL ----------------------------//

  /// SEARCHES and GETS promocode if found
  Future<void> searchPromocode(String? searchText) async {
    if (searchText != null && searchText.isEmpty || searchText!.length < 2)
      return;

    try {
      await runBusyFuture(_cartService.searchPromocode(searchText));
    } catch (err) {
      throw err;
    }
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
