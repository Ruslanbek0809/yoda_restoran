import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
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
  final _bottomSheetService = locator<BottomSheetService>();
  final _userService = locator<UserService>();
  final _toggleButtonService = locator<ToggleButtonService>();

  List<HiveMeal> get cartMeals => _hiveDbService.cartMeals;

  List<Meal>? get moreMeals => _cartService.moreMeals;

  Promocode? get promocode => _cartService.promocode;

  bool get isDelivery => _toggleButtonService.isDelivery;

  // FETCHS more meals and GETS all carts
  Future getMoreMeals() async {
    await runBusyFuture(_cartService.getMoreMeals());
    log.i('moreMeals length: ${moreMeals!.length} ');
  }

  /// CLEARS CART
  Future<void> clearCart() async {
    log.i('clearCart()');

    await _hiveDbService.clearCart();
    log.i('cartMeals length: ${cartMeals.length}');
    navBack();
    notifyListeners();
  }

  /// GETS total cart meals sum with each price/discountPrice, vols price, customs price, and each cartMeal's quantity
  num get getTotalCartSum {
    num totalCartSum = 0;

    _hiveDbService.cartMeals.forEach((_cartMeal) {
      totalCartSum += _cartMeal.discount != null || _cartMeal.discount! > 0
          ? _cartMeal.discountedPrice!
          : _cartMeal.price!;

      _cartMeal.volumes!.forEach((vol) {
        if (vol.id != -1) totalCartSum += vol.price!;
      });
      _cartMeal.customs!.forEach((cus) {
        totalCartSum += cus.price!;
      });

      totalCartSum *= _cartMeal.quantity!;
    });

    return totalCartSum;
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

  /// GETS total meal draft sum
  num getTotalMealSum(HiveMeal cartMeal) {
    num totalMealSum = 0;
    totalMealSum += cartMeal.discount != null || cartMeal.discount! > 0
        ? cartMeal.discountedPrice!
        : cartMeal.price!;

    cartMeal.volumes!.forEach((vol) {
      if (vol.id != -1) totalMealSum += vol.price!;
    });
    cartMeal.customs!.forEach((cus) {
      totalMealSum += cus.price!;
    });

    totalMealSum *= cartMeal.quantity!;
    return totalMealSum;
  }

  /// CONCATENATES all cartMeal vols and customs into one string
  String getConcatenateVolsCustoms(HiveMeal cartMeal) {
    StringBuffer concatenatedString = StringBuffer();

    cartMeal.volumes!.forEach((vol) {
      if (vol.id != -1) concatenatedString.write('${vol.name} ');
    });

    cartMeal.customs!.forEach((cus) {
      concatenatedString.write('${cus.name} ');
    });

    return concatenatedString.toString();
  }

  /// UPDATES cartMeal. If cartMeals is empty then navBack bc CartView is empty
  Future<void> updateCartMealInCart(
      HiveMeal cartMeal, int? mealQuantity) async {
    log.i(
        'updateCartMealInCart() cartMeal.id: ${cartMeal.id}, mealQuantity: $mealQuantity');

    await _hiveDbService.updateCartMealInCart(
        hiveMeal: cartMeal, quantity: mealQuantity);

    if (cartMeals.isEmpty) navBack();

    notifyListeners();
  }

//------------------------ CART MEAL ----------------------------//

  /// SEARCHES and GETS promocode if found
  Future<void> searchPromocode(String? searchText) async {
    log.i('searchPromocode() searchText: $searchText');
    if (searchText != null && searchText.isEmpty || searchText!.length < 2)
      return;

    try {
      await runBusyFuture(_cartService.searchPromocode(searchText));
    } catch (err) {
      throw err;
    }
  }

//------------------------ CHECKOUT BOTTOM SHEET ----------------------------//

  /// CALLS navs based on user's login state.
  Future<void> onCartCheckoutButtonPressed() async {
    if (_userService.hasLoggedInUser) {
      log.v(
          'USER FOUND: ${_userService.currentUser!.mobile}, ${_userService.currentUser!.accessToken}');
      await showCustomCheckoutBottomSheet();
    } else {
      log.v('USER NOTTTTT FOUND');
      await _navService.navigateTo(Routes.loginView);
    }
  }

  /// CALLS CheckoutBottomSheetView
  Future showCustomCheckoutBottomSheet() async {
    log.i('showCustomCheckoutBottomSheet()');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.checkout,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
    );
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_hiveDbService, _toggleButtonService];
}
