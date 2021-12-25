import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

/// ReactiveViewModel is used to "react"
class MealViewModel extends ReactiveViewModel {
  final log = getLogger('MealViewModel');

  final _bottomCartService = locator<BottomCartService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _dialogService = locator<DialogService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here I retrieved bottomCartStatus for log ONLY

  bool _isButtonToggled = false;
  bool get isButtonToggled => _isButtonToggled;

  int quantity = 0;
  int quantityDraft = 1;

  /// Function to update isButtonToggled
  // void updateButtonToggle() {
  //   _isButtonToggled = !_isButtonToggled;
  //   log.i('_isButtonToggled: $_isButtonToggled');
  //   notifyListeners();
  // }

  /// ADDS to quantityInDraft
  void addQuantityDraft() {
    quantityDraft += 1;
    log.i('addQuantityDraft() quantityDraft: $quantityDraft');
    notifyListeners();
  }

  /// SUBTRACTS quantityInDraft
  void subtractQuantityDraft() {
    if (quantityDraft <= 1) return;
    quantityDraft -= 1;
    log.i('subtractQuantityDraft() quantityDraft: $quantityDraft');
    notifyListeners();
  }

  //----------- HIVE DB PART ------------//

  /// GETS quantity of cartMeal for this meal if this meal exist in CART and TOGGLES _isButtonToggled
  void getMealQuantity(int? mealId) {
    quantity = _hiveDbService.getMealQuantity(mealId)!;
    if (quantity >= 1) _isButtonToggled = true;
    notifyListeners();
  }

  /// ADDS or UPDATES a restaurant in CART in condition
  /// ADDS a meal to CART and UPDATES _quantity and _isButtonToggled
  Future<void> addMealToCart(
    Meal? meal,
    Restaurant? restaurant,
  ) async {
    log.i('addMealToCart() mealId: ${meal!.id}, resId: ${restaurant!.id}');

    if (_hiveDbService.cartMeals.isEmpty)
      await _hiveDbService
          .setResDefault(); // SETS CART restaurant to default value

    if (_hiveDbService.cartRes!.id == meal.restaurantId) {
      await _hiveDbService.addMealToCart(meal);
    } else if (_hiveDbService.cartRes!.id == -1) {
      await _hiveDbService.updateResInCart(restaurant);
      await _hiveDbService.addMealToCart(meal);
      _bottomCartService
          .showBottomCart(); // SHOWS BottomCart. If already active, nothing happens
    } else if (_hiveDbService.cartRes!.id != meal.restaurantId &&
        _hiveDbService.cartRes!.id != -1) {
      await showClearOrNavigateCartDialog(); // CALLS MealDialogView

      /// If user CLEARS cart then START below functions
      if (_hiveDbService.cartMeals.isEmpty) {
        _bottomCartService
            .showBottomCart(); // SHOWS BottomCart. If already active, nothing happens
        await _hiveDbService.updateResInCart(restaurant);
        await _hiveDbService.addMealToCart(meal);
      }
    }

    quantity = _hiveDbService.getMealQuantity(meal.id)!;
    if (quantity >= 1) _isButtonToggled = true;

    log.i(
        'addMealToCartWithCondition() quantity: $quantity, _isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

  /// UPDATES a meal in CART. Also UPDATES _quantity and _isButtonToggled
  Future<void> updateMealInCart({int? mealId, int? mealQuantity}) async {
    log.i('updateMealInCart() mealId: $mealId, mealQuantity: $mealQuantity');

    await _hiveDbService.updateMealInCart(
        mealId: mealId, quantity: mealQuantity);
    quantity = _hiveDbService.getMealQuantity(mealId)!;
    if (quantity >= 1)
      _isButtonToggled = true;
    else
      _isButtonToggled = false;

    log.i(
        'updateMealInCart() quantity: $quantity, _isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

//------------------------ MEAL CART DIALOG PART ----------------------------//

  /// SHOWS Clear or Navigate Cart Dialog
  Future showClearOrNavigateCartDialog() async {
    log.i('');
    await _dialogService.showCustomDialog(
      variant: DialogType.mealCartClear,
      title: 'Sebedi boşadyň',
      description:
          'Sebetde başga restorandan goşulan haryt bar. Täze sargyt etmek üçin ilki restorana sargydyňyzy ugradyň ýa-da sebedi boşadyň.',
      mainButtonTitle: 'Sebedi boşat',
      secondaryButtonTitle: 'Sebede geç',
      showIconInMainButton: false,
      barrierDismissible: true,
    );
  }

  /// CLEAR CART
  Future<void> clearCart() async {
    log.i('clearCart()');

    await _hiveDbService.clearCart();
    notifyListeners();
  }

//------------------------ MEAL BOTTOM SHEET PART ----------------------------//

  /// Function to call MealBottomSheet
  Future showCustomMealBottomSheet(Meal meal, Restaurant restaurant) async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.meal,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
      data: MealBottomSheetData(
        meal: meal,
        restaurant: restaurant,
      ),
    );
  }

  List<Volume> _selectedVols = [];
  List<Volume> get selectedVols => _selectedVols;

  List<Customizable> _selectedCustoms = [];
  List<Customizable> get selectedCustoms => _selectedCustoms;

  /// CREATES initial list for selectedVolumes and selectedMultiCustomizables
  void setOnModelReadyVolsCustoms(int gVolsLength) {
    _selectedVols = List.generate(
      gVolsLength,
      (_) => Volume(id: -1, groupId: -1, price: -1, volumeName: 'Default'),
    );
  }

  // /// CHECKS wether this vol in _selectedVols or NOT
  // Volume? isVolSelected(Volume? vol) => _selectedVols!.firstWhere(
  //       (_vol) => _vol.id == vol!.id,
  //       orElse: () =>
  //           Volume(id: -1, groupId: -1, price: -1, volumeName: 'Default'),
  //     );

  /// CHECKS wether this cus in _selectedCustoms or NOT
  bool isCustomSelected(Customizable? cus) => _selectedCustoms.contains(cus);

  /// UPDATES _selectedVolumes's mainVolumePos value to volume
  void updateSelectedVols(int mainVolPos, Volume? volume) {
    _selectedVols[mainVolPos] = volume!;
    notifyListeners();
  }

  /// ADDS or REMOVES selected customizable in _selectedCustomizables![mainVolumePos]
  void updateSelectedCustoms(Customizable? selectedCus) {
    if (_selectedCustoms.contains(selectedCus))
      _selectedCustoms.remove(selectedCus);
    else
      _selectedCustoms.add(selectedCus!);
    notifyListeners();
  }

  /// ADDS or UPDATES a restaurant in CART
  /// ADDS a meal to CART from BOTTOM SHEET and UPDATES _quantity and _isButtonToggled
  Future<void> addUpdateMealInCartFromBottomSheet(
      Meal? meal, Restaurant? restaurant) async {
    log.i(
        'addMealToCartFromBottomSheet() mealId: ${meal!.id}, resId: ${restaurant!.id}');

    if (_hiveDbService.cartMeals.isEmpty)
      await _hiveDbService
          .setResDefault(); // SETS CART restaurant to default value

    if (_hiveDbService.cartRes!.id == meal.restaurantId) {
      await _hiveDbService.addUpdateMealInCartFromBottomSheet(
        meal,
        _selectedVols,
        _selectedCustoms,
        quantityDraft: quantityDraft,
      );
    } else if (_hiveDbService.cartRes!.id == -1) {
      await _hiveDbService.updateResInCart(restaurant);
      await _hiveDbService.addUpdateMealInCartFromBottomSheet(
        meal,
        _selectedVols,
        _selectedCustoms,
        quantityDraft: quantityDraft,
      );
      _bottomCartService
          .showBottomCart(); // SHOWS BottomCart. If already active, nothing happens
    } else if (_hiveDbService.cartRes!.id != meal.restaurantId &&
        _hiveDbService.cartRes!.id != -1) {
      await showClearOrNavigateCartDialog(); // CALLS MealDialogView

      /// If user CLEARS cart then START below functions
      if (_hiveDbService.cartMeals.isEmpty) {
        _bottomCartService
            .showBottomCart(); // SHOWS BottomCart. If already active, nothing happens
        await _hiveDbService.updateResInCart(restaurant);
        await _hiveDbService.addUpdateMealInCartFromBottomSheet(
          meal,
          _selectedVols,
          _selectedCustoms, 
          quantityDraft: quantityDraft,
        );
      }
    }

    quantity = _hiveDbService.getMealQuantity(meal.id)!;
    if (quantity >= 1) _isButtonToggled = true;

    log.i(
        'addUpdateMealInCartFromBottomSheet() quantity: $quantity, _isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

//------------------------ NAVIGATIONS ----------------------------//

  Future navToCartView() async => await _navService
      .navigateTo(Routes.cartView); // TODO: Change page transition here

  void navBack() => _navService.back();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_bottomCartService];
}
