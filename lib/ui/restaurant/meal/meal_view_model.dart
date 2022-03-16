import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

/// ReactiveViewModel is used to "react"
class MealViewModel extends ReactiveViewModel {
  final log = getLogger('MealViewModel');
  final int? mealId;
  MealViewModel({this.mealId});

  final _bottomCartService = locator<BottomCartService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _dialogService = locator<DialogService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  // bool _isButtonToggled = false;
  // bool get isButtonToggled => _isButtonToggled;

  // int quantity = 0;

  //----------- HIVE DB PART ------------//

  /// This mealQuantity is used in UI part instead of quantity var so that UI to be updated without any Workarounds
  int get mealQuantity => _hiveDbService.getMealQuantity(mealId)!;

  /// GETS quantity of cartMeal for this meal if this meal exists in CART and TOGGLES _isButtonToggled
  // void getMealQuantity(int? mealId) {
  //   quantity = _hiveDbService.getMealQuantity(mealId)!;
  //   if (quantity >= 1) _isButtonToggled = true;
  //   notifyListeners();
  // }

  /// ADDS or UPDATES a restaurant in CART with condition
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

    // quantity = _hiveDbService.getMealQuantity(meal.id)!;
    // if (quantity >= 1) _isButtonToggled = true;

    // log.i(
    //     'addMealToCartWithCondition() quantity: $quantity, _isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

  /// UPDATES a meal in CART. Also UPDATES _quantity and _isButtonToggled
  Future<void> updateMealInCart({int? mealId, int? mealQuantity}) async {
    log.i('updateMealInCart() mealId: $mealId, mealQuantity: $mealQuantity');

    await _hiveDbService.updateMealInCart(
        mealId: mealId, quantity: mealQuantity);
    // quantity = _hiveDbService.getMealQuantity(mealId)!;
    // if (quantity >= 1)
    //   _isButtonToggled = true;
    // else
    //   _isButtonToggled = false;

    // log.i(
    //     'updateMealInCart() quantity: $quantity, _isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

  /// SUBTRACTS quantity of a meal or REMOVES a meal from CART
  Future<void> subtractOrRemoveMealInCart(int? mealId) async {
    log.i('subtractOrRemoveMealInCart() mealId: $mealId');

    await _hiveDbService.subtractOrRemoveMealInCart(mealId);
    // quantity = _hiveDbService.getMealQuantity(mealId)!;
    // if (quantity >= 1)
    //   _isButtonToggled = true;
    // else
    //   _isButtonToggled = false;

    /// UPDATES ResBottomCart's quantity
    _bottomCartService.updateResBottomCartQuantity();

    // log.i(
    //     'subtractOrRemoveMealInCart() quantity: $quantity, _isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

//------------------------ MEAL CART DIALOG PART ----------------------------//

  /// SHOWS Clear or Navigate Cart Dialog
  Future showClearOrNavigateCartDialog() async {
    log.i('');
    await _dialogService.showCustomDialog(
      variant: DialogType.mealCartClear,
      title: LocaleKeys.clearCartPls,
      description: LocaleKeys.cart_is_full_with_other_restaurant,
      mainButtonTitle: LocaleKeys.clearCart,
      secondaryButtonTitle: LocaleKeys.goToCart,
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

  /// CALLS MealBottomSheet
  // Future showCustomMealBottomSheet(
  //     Meal meal, Restaurant restaurant, MealViewModel mealViewModel) async {
  //   log.i('');
  //   await _bottomSheetService.showCustomSheet(
  //     variant: BottomSheetType.meal,
  //     enableDrag: true,
  //     barrierDismissible: true,
  //     isScrollControlled: true,
  //     data: MealBottomSheetData(
  //       meal: meal,
  //       restaurant: restaurant,
  //       mealViewModel: mealViewModel,
  //     ),
  //   );

  //   /// These below 2 lines are implemented for rare issue cases: when user dismisses mealBottomSheet without action it preserves meal's quantity. It solves this issue.
  //   quantityDraft = 1;
  //   quantityDraftTempNoAttribute = 0;
  // }

  int quantityDraft = 1;
  int quantityDraftTempNoAttribute =
      0; // Here quantityDraftTempNoAttribute is used in a meal with NO attributes
  num totalSumDraft = 0;

  bool _isAllVolSelected = false;
  bool get isAllVolSelected => _isAllVolSelected;

  List<Volume> _selectedVols = [];
  List<Volume> get selectedVols => _selectedVols;

  List<Customizable> _selectedCustoms = [];
  List<Customizable> get selectedCustoms => _selectedCustoms;

  /// CREATES INITIAL list for selectedVolumes and selectedMultiCustomizables
  void setOnModelReadyVolsCustoms(Meal meal) {
    log.i('setOnModelReadyVolsCustoms()');

    _isAllVolSelected = false; // RESETS vols to default
    _selectedCustoms.clear(); // CLEARS all selectedCustoms
    _selectedVols = List.generate(
      meal.gVolumes!.length,
      (_) => Volume(id: -1, groupId: -1, price: -1, volumeName: 'Default'),
    );

    /// ASSINGS initial value to totalSumDraft and quantityDraft
    if (meal.gVolumes!.isEmpty && meal.gCustomizables!.isEmpty) {
      if (mealQuantity != 0) {
        quantityDraft = mealQuantity;
        quantityDraftTempNoAttribute = mealQuantity;
      } else
        quantityDraft = 1;

      totalSumDraft = meal.discount != null && meal.discount! > 0
          ? meal.discountedPrice!
          : meal.price!;
      totalSumDraft *= quantityDraft;
    } else {
      quantityDraft = 1;
      totalSumDraft = meal.discount != null && meal.discount! > 0
          ? meal.discountedPrice!
          : meal.price!;
    }

    /// ASSINGS initial value to _isAllVolSelected based on
    if (meal.gVolumes!.isEmpty) _isAllVolSelected = true;
  }

  /// ADDS to quantityInDraft
  void addQuantityDraft(Meal meal) {
    quantityDraft += 1;

    /// ADDS a meal from totalDraftSum
    totalSumDraft += meal.discount != null && meal.discount! > 0
        ? meal.discountedPrice!
        : meal.price!;

    _selectedVols.forEach((vol) {
      if (vol.id != -1)
        totalSumDraft += meal.discount != null || meal.discount! > 0
            ? (vol.price! / 100) * (100 - meal.discount!)
            : vol.price!;
    });
    _selectedCustoms.forEach((cus) {
      totalSumDraft += meal.discount != null || meal.discount! > 0
          ? (cus.price! / 100) * (100 - meal.discount!)
          : cus.price!;
    });
    log.i('addQuantityDraft() quantityDraft: $quantityDraft');
    notifyListeners();
  }

  /// SUBTRACTS quantityInDraft
  void subtractQuantityDraft(Meal meal) {
    if (quantityDraft <= 1) return;
    quantityDraft -= 1;

    /// SUBTRACTS a meal from totalDraftSum
    totalSumDraft -= meal.discount != null && meal.discount! > 0
        ? meal.discountedPrice!
        : meal.price!;

    _selectedVols.forEach((vol) {
      if (vol.id != -1)
        totalSumDraft -= meal.discount != null || meal.discount! > 0
            ? (vol.price! / 100) * (100 - meal.discount!)
            : vol.price!;
    });
    _selectedCustoms.forEach((cus) {
      totalSumDraft -= meal.discount != null || meal.discount! > 0
          ? (cus.price! / 100) * (100 - meal.discount!)
          : cus.price!;
    });
    log.i('subtractQuantityDraft() quantityDraft: $quantityDraft');
    notifyListeners();
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
  void updateSelectedVols(Meal meal, int mainVolPos, Volume? volume) {
    if (_selectedVols[mainVolPos].id != -1)

      /// Step 1. SUBTRACTS selected vol's price from totalDraftSum
      totalSumDraft -= meal.discount != null || meal.discount! > 0
          ? (_selectedVols[mainVolPos].price! / 100) * (100 - meal.discount!)
          : _selectedVols[mainVolPos].price! *
              quantityDraft; // If already selected vol from group then remove it first

    /// Step 2. ASSIGNS selected volume to _selectedVols[mainVolPos]
    _selectedVols[mainVolPos] = volume!;

    /// Step 3. ADDS selected vol's price to totalDraftSum
    totalSumDraft += meal.discount! > 0
        ? (_selectedVols[mainVolPos].price! / 100) * (100 - meal.discount!)
        : _selectedVols[mainVolPos].price! * quantityDraft;

    /// Lines of codes below CHECKS whether all vols selected or NOT to change button conditions
    var _volWithMinus = _selectedVols.firstWhere(
      (vol) => vol.id == -1,
      orElse: () => Volume(id: -2),
    );

    if (_volWithMinus.id == -2) _isAllVolSelected = true;
    notifyListeners();
  }

  /// ADDS or REMOVES selected customizable in _selectedCustomizables![mainVolumePos]
  void updateSelectedCustoms(Meal meal, Customizable? selectedCus) {
    if (_selectedCustoms.contains(selectedCus)) {
      _selectedCustoms.remove(selectedCus);

      /// SUBTRACTS selectedCus's price from totalDraftSum
      totalSumDraft -= meal.discount != null || meal.discount! > 0
          ? (selectedCus!.price! / 100) * (100 - meal.discount!)
          : selectedCus!.price! * quantityDraft;
    } else {
      _selectedCustoms.add(selectedCus!);

      /// ADDS selectedCus's price to totalDraftSum
      totalSumDraft += meal.discount != null || meal.discount! > 0
          ? (selectedCus.price! / 100) * (100 - meal.discount!)
          : selectedCus.price! * quantityDraft;
    }
    notifyListeners();
  }

  /// ADDS or UPDATES a restaurant in CART
  /// ADDS a meal to CART from BOTTOM SHEET and UPDATES _quantity and _isButtonToggled
  Future<void> addUpdateMealInCartFromBottomSheet(
      Meal? meal, Restaurant? restaurant) async {
    log.i(
        'addUpdateMealInCartFromBottomSheet() mealId: ${meal!.id}, resId: ${restaurant!.id}');

    if (_hiveDbService.cartMeals.isEmpty)
      await _hiveDbService
          .setResDefault(); // SETS CART restaurant to default value

    if (_hiveDbService.cartRes!.id == meal.restaurantId) {
      await _hiveDbService.addUpdateMealInCartFromBottomSheet(
        meal,
        _selectedVols,
        _selectedCustoms,
        quantityDraft: quantityDraft -
            quantityDraftTempNoAttribute, // Here quantityDraftTempNoAttribute is subtracted from quantityDraft to UPDATE a meal's quantity properly when meal doesn't have attributes
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

    // quantity = _hiveDbService.getMealQuantity(meal.id)!;
    // if (quantity >= 1) _isButtonToggled = true;

    /// UPDATES ResBottomCart's quantity
    _bottomCartService.updateResBottomCartQuantity();

    quantityDraft = 1;
    quantityDraftTempNoAttribute = 0;
    _selectedCustoms.clear();
    _selectedVols = List.generate(
      _selectedVols.length,
      (_) => Volume(id: -1, groupId: -1, price: -1, volumeName: 'Default'),
    );
    // _selectedVols.clear();
    // log.i(
    //     'addUpdateMealInCartFromBottomSheet() quantity: $quantity, _isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

//------------------------ NAVIGATIONS ----------------------------//

  Future navToCartView() async => await _navService
      .navigateTo(Routes.cartView); // TODO: Change page transition here

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_bottomCartService, _hiveDbService];
}
