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

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
