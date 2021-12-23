import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class CartViewModel extends BaseViewModel {
  final log = getLogger('CartViewModel');

  final _hiveDbService = locator<HiveDbService>();
  final _dialogService = locator<DialogService>();
  final _navService = locator<NavigationService>();
  final _cartService = locator<CartService>();

  List<HiveMeal> get cartMeals => _hiveDbService.cartMeals;
  List<Meal>? get moreMeals => _cartService.moreMeals;

  // FETCHS more meals
  Future getMoreMeals() async {
    log.i('');
    await runBusyFuture(_cartService.getMoreMeals());
    log.i('moreMeals length: ${moreMeals!.length}');
  }

  /// CLEAR CART
  Future<void> clearCart() async {
    log.i('clearCart()');

    await _hiveDbService.clearCart();
    navBack();
    notifyListeners();
  }

//------------------------ Clear CART DIALOG PART ----------------------------//

  /// SHOWS Clear CART Dialog
  Future showClearCartDialog() async {
    log.i('');
    await _dialogService.showCustomDialog(
      variant: DialogType.clearCart,
      title: 'Siz sebedi boşatmakçymy?',
      mainButtonTitle: 'Ýok',
      secondaryButtonTitle: 'Hawa',
      showIconInMainButton: false,
      barrierDismissible: true,
    );
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();
}
