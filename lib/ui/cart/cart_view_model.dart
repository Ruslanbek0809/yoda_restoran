import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../models/hive_models/hive_models.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

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

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  List<Meal>? get moreMeals => _cartService.moreMeals;

  bool get isDelivery => _toggleButtonService.isDelivery;

  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  /// FETCHS more meals and GETS all carts
  Future getMoreMeals() async {
    await runBusyFuture(_cartService.getMoreMeals());
    log.i('moreMeals length: ${moreMeals!.length} ');
  }

  /// CLEARS CART
  Future<void> clearCart() async {
    log.i('clearCart()');

    await _hiveDbService.clearCart();
    log.i('cartMeals length: ${cartMeals.length}');
    await _navService.pushNamedAndRemoveUntil(Routes.homeView);
  }

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

//------------------------ Clear CART DIALOG PART ----------------------------//

  /// SHOWS Clear CART Dialog
  Future showClearCartDialog(CartViewModel cartViewModel) async {
    log.i('showClearCartDialog()');
    await _dialogService.showCustomDialog(
      variant: DialogType.clearCart,
      title: LocaleKeys.wannaClearCart,
      mainButtonTitle: LocaleKeys.no,
      secondaryButtonTitle: LocaleKeys.letsClearCart,
      showIconInMainButton: false,
      barrierDismissible: true,
      data: cartViewModel,
    );
  }

//------------------------ CART MEAL REMOVE DIALOG ----------------------------//

  /// SHOWS CART MEAL REMOVE Dialog
  Future showRemoveCartMealDialog(
      CartViewModel cartViewModel, HiveMeal cartMeal) async {
    log.i('showRemoveCartMealDialog()');
    await _dialogService.showCustomDialog(
      variant: DialogType.removeCartMeal,
      title: LocaleKeys.wannaRemoveMeal,
      mainButtonTitle: LocaleKeys.no,
      secondaryButtonTitle: LocaleKeys.remove,
      showIconInMainButton: false,
      barrierDismissible: true,
      data: CartMealDialogData(
        cartViewModel: cartViewModel,
        cartMeal: cartMeal,
      ),
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

    List<HiveVolCus>? tempVolList = [];

    cartMeal.volumes!.forEach((vol) {
      if (vol.id != -1)
        tempVolList.add(
            vol); // This part is used to put ,(comma) after each concatenated and doesn't put for the latest one
    });

    tempVolList.forEach((vol) {
      var pos = tempVolList.indexOf(
          vol); // This part is used to put ,(comma) after each concatenated and doesn't put for the latest one

      if (pos == tempVolList.length - 1 && cartMeal.customs!.isEmpty)
        concatenatedString.write('${vol.name}');
      else
        concatenatedString.write('${vol.name}, ');
    });

    cartMeal.customs!.forEach((cus) {
      var pos = cartMeal.customs!.indexOf(
          cus); // This part is used to put ,(comma) after each concatenated and doesn't put for the latest one

      if (pos == cartMeal.customs!.length - 1)
        concatenatedString.write('${cus.name}');
      else
        concatenatedString.write('${cus.name}, ');
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

    if (cartMeals.isEmpty)
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

    notifyListeners();
  }

//------------------------ CHECKOUT BOTTOM SHEET ----------------------------//

  /// CALLS navs based on user's login state.
  Future<void> onCartCheckoutButtonPressed() async {
    if (hasLoggedInUser) {
      log.v(
          'USER FOUND with his/her phone: ${_userService.currentUser!.mobile}');
      await showCustomCheckoutBottomSheet();
    } else {
      log.v('USER NOTTTTT FOUND');
      await _navService.navigateTo(
        Routes.loginView,
        arguments: LoginViewArguments(isCartView: true),
      ); // Workaround. isCartView is used to navigate to new View by condition in OtpVM
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
  void navBack() => _navService.back(result: true);

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_hiveDbService, _toggleButtonService];
}
