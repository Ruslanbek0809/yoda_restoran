import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

// 1 For Reactive Views
class HiveDbService with ReactiveServiceMixin {
  final log = getLogger('HiveDbService');

  HiveDbService() {
    // 3
    listenToReactiveValues([_cartMeals]);
  }

  final _bottomCartService = locator<BottomCartService>();

  static late Box<HiveRestaurant> cartResBox; // Change model type in
  static late Box<HiveMeal> cartMealsBox;
  static late Box<HiveVolCus> volCartBox;

  HiveRestaurant? cartRes;

  // 2
  ReactiveValue<List<HiveMeal>> _cartMeals = ReactiveValue<List<HiveMeal>>([]);
  List<HiveMeal> get cartMeals => _cartMeals.value;

  /// INITIALIZE in StartUpViewModel
  Future initDB() async {
    log.i('');

    await Hive.openBox<HiveRestaurant>(Constants.cartResBox);
    await Hive.openBox<HiveMeal>(Constants.cartMealsBox);
    await Hive.openBox<HiveVolCus>(Constants.volCartBox);
  }

  /// GETS CART restaurant from cartResBox
  void getCartRes() {
    cartResBox = Hive.box<HiveRestaurant>(Constants.cartResBox);
    cartRes = cartResBox.get('cartRes',
        defaultValue: HiveRestaurant(id: -1, name: 'Default'));
    log.v('cartRes ${cartRes!.id}');
  }

  /// GETS all CART meals from cartMealsBox
  void getCartMeals() {
    cartMealsBox = Hive.box<HiveMeal>(Constants.cartMealsBox);
    _cartMeals.value = cartMealsBox.values.toList();
    if (_cartMeals.value.isNotEmpty)
      _bottomCartService.showBottomCart(); // SHOWS BottomCart.

    log.v('_cartMeals.value length: ${_cartMeals.value.length}');
  }

//---------------------------------------//
//------------------ RESTAURANT PART ---------------------//
//---------------------------------------//

  /// UPDATES a restaurant in CART
  Future<void> updateResInCart(Restaurant? restaurant) async {
    log.i('resId: ${restaurant!.id}');

    try {
      final HiveRestaurant _restaurant = HiveRestaurant(
        id: restaurant.id,
        image: restaurant.image,
        name: restaurant.name,
        description: restaurant.description,
        rated: restaurant.rated,
        rating: restaurant.rating,
        workingHours: restaurant.workingHours,
        prepareTime: restaurant.prepareTime,
        phoneNumber: restaurant.phoneNumber,
        address: restaurant.address,
        deliveryPrice: restaurant.deliveryPrice,
      );
      await cartResBox.put('cartRes', _restaurant);
      cartRes = cartResBox.get('cartRes',
          defaultValue: HiveRestaurant(id: -1, name: 'Default'));

      log.v('cartResId ${cartRes!.id}');
    } catch (e) {
      log.v('Couldn\'t UPDATE a restaurant in CART: $e');
    }
  }

//---------------------------------------//
//------------------ MEAL PART ---------------------//
//---------------------------------------//

  /// GETS total quantity of cartMeals for meal with mealId
  int? getMealQuantity(int? mealId) {
    var _quantity = 0;
    for (var _cartMeal in _cartMeals.value)
      if (_cartMeal.id == mealId) _quantity += _cartMeal.quantity!;

    log.v(' _quantity: $_quantity');
    return _quantity;
  }

  /// ADDS a meal to CART
  Future<void> addMealToCart(Meal? meal, {int? quantity = 1}) async {
    log.v('mealId: ${meal!.id}, quantity: $quantity');

    try {
      final HiveMeal _cartMeal = HiveMeal(
        id: meal.id,
        image: meal.image,
        name: meal.name,
        price: meal.price,
        discount: meal.discount!.toInt(),
        discountedPrice: meal.discountedPrice,
        quantity: quantity,
        customs: [],
        volumes: [],
      );
      await cartMealsBox.add(_cartMeal);
      _cartMeals.value.add(_cartMeal);
      log.v('_cartMeals.value length: ${_cartMeals.value.length}');
    } catch (e) {
      log.v('Couldn\'t ADD a meal to CART: $e');
    }
  }

  /// UPDATES a meal in CART
  Future<void> updateMealInCart({int? mealId, int? quantity}) async {
    log.v('mealId: $mealId, quantity: $quantity');

    /// CHECKS whether meal with this id exists and GETS pos if it exists. If NOT, returns -1
    int pos = _cartMeals.value.indexWhere((_meal) => _meal.id == mealId);
    if (pos == -1) return;

    if (quantity! >= 1) {
      _cartMeals.value[pos].quantity = quantity;
      cartMealsBox.putAt(pos, _cartMeals.value[pos]);
      log.v(
          '_cartMeals.value[pos].quantity: ${_cartMeals.value[pos].quantity}');
    } else {
      cartMealsBox.deleteAt(pos);
      _cartMeals.value.removeAt(pos);

      log.v('REMOVED _cartMeals.value.length: ${_cartMeals.value.length}');

      if (_cartMeals.value.isEmpty)
        _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    }
  }

  Future<void> clearCart() async {
    log.v('BEFORE CLEAR _cartMeals.value length: ${_cartMeals.value.length}');
    await cartMealsBox.clear();
    await cartResBox.clear();
    _cartMeals.value.clear();
    await cartResBox.put('cartRes', HiveRestaurant(id: -1, name: 'Default'));
    cartRes = cartResBox.get('cartRes',
        defaultValue: HiveRestaurant(id: -1, name: 'Default'));

    _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    log.v(
        'AFTER CLEAR _cartMeals.value length: ${_cartMeals.value.length} and cartResId: ${cartRes!.id}');
  }

  Future<void> setResDefault() async {
    await cartResBox.clear();
    await cartResBox.put('cartRes', HiveRestaurant(id: -1, name: 'Default'));
    cartRes = cartResBox.get('cartRes',
        defaultValue: HiveRestaurant(id: -1, name: 'Default'));
    log.v('cartResId: ${cartRes!.id}');
  }

//---------------------------------------//
//------------------ MEAL BOTTOM SHEET PART ---------------------//
//---------------------------------------//

  /// ADDS a meal to CART from BOTTOM SHEET
  Future<void> addUpdateMealInCartFromBottomSheet(
      Meal? meal, List<Volume> selectedVols, List<Customizable> selectedCustoms,
      {int? quantityDraft = 1}) async {
    log.v('mealId: ${meal!.id}, quantityDraft: $quantityDraft');

    bool isNew = true;

    List<HiveMeal>? similarMeals = [];
    HiveMeal? similarUpdateMeal;

    /// STEP 1. Filter only to similar meals from cartMeals
    for (HiveMeal cartMeal in _cartMeals.value)
      if (meal.id == cartMeal.id) similarMeals.add(cartMeal);

    /// STEP 2. MAKE isNew to TRUE if similarMeals isEmpty
    if (similarMeals.isEmpty) isNew = true;

    log.v(
        'BEFORE SIMILARS selectedVols and selectedCustoms: ${selectedVols.length} and ${selectedCustoms.length}');

    /// STEP 3. GO THROUGH each similarMeal for vols and customs iteration to decide whether ADD or UPDATE the meal
    for (HiveMeal similarMeal in similarMeals) {
      /// STEP 3.1. CREATE and DEFINE initial value for condition
      bool shouldAdd = false;

      List<Volume> _filteredSelectedVols = [];
      selectedVols.forEach(
        (vol) {
          if (vol.id != -1) _filteredSelectedVols.add(vol);
        },
      );
      log.v('filteredVols length: ${_filteredSelectedVols.length}');

      /// STEP 3.2. CHECK length. If not same then UPDATE shouldAdd to TRUE
      if (selectedVols.length != similarMeal.volumes!.length ||
          selectedCustoms.length != similarMeal.customs!.length) {
        shouldAdd = true;
        log.v('INSIDE NOT SAME LENGTH SIMILAR. That why shouldAdd: $shouldAdd');
      }

      log.i(
          'shouldAdd AFTER LENGTH Comparison ---------------------------- $shouldAdd');

      /// STEP 3.2. CHECK selectedVols and UPDATE isAdd var by condition ( ID COMPARISON )
      for (Volume vol in _filteredSelectedVols) {
        shouldAdd = !similarMeal.volumes!.any((_vol) => _vol.id == vol.id);
        if (shouldAdd) break;
      }

      log.i('shouldAdd AFTER VOLUME ---------------------------- $shouldAdd');

      /// STEP 3.3. CHECK selectedCustoms and UPDATE isUnique var by condition ( ID COMPARISON )
      /// The reason commenting contains func is that same data in hive doesn't equal to each other. That's why we shifted to id comparison WORKAROUND
      if (!shouldAdd)
        for (Customizable cus in selectedCustoms) {
          log.v('cus.id in each selectedCustoms: ${cus.id}');
          shouldAdd = !similarMeal.customs!.any((_cus) => _cus.id == cus.id);
          if (shouldAdd) break;
        }

      log.i(
          'shouldAdd AFTER CUSTOMIZES ---------------------------- $shouldAdd');

      /// STEP 3.4. if shouldAdd FALSE in the end then ASSIGN its value to isNew and UPDATE similarUpdateMeal
      if (!shouldAdd) {
        isNew = shouldAdd;
        similarUpdateMeal = similarMeal;
        log.v('INSIDE UPDATEEE SIMILARS shouldAdd at the END: $shouldAdd');
        break;
      }

      log.v('INSIDE SIMILARS shouldAdd at the END: $shouldAdd');
    }

    /// STEP 4. ADD or UPDATE a meal in CART
    /// ADD PART
    if (isNew) {
      log.v('ADDS with isNew: $isNew');
      List<HiveVolCus> _cartMealVolumes = [];
      List<HiveVolCus> _cartMealCustoms = [];

      /// STEP 4.1. ADD all selectedVols to _cartMeal.volumes
      for (Volume vol in selectedVols)
        _cartMealVolumes.add(HiveVolCus(
          id: vol.id,
          name: vol.volumeName,
          price: vol.price,
        ));

      /// STEP 4.2. ADD all selectedCustoms to _cartMeal.customs
      for (Customizable cus in selectedCustoms)
        _cartMealCustoms.add(HiveVolCus(
          id: cus.id,
          name: cus.customizableName,
          price: cus.price,
        ));

      log.v(
          '_cartMealVolumes LEN: ${_cartMealVolumes.length} and _cartMealCustoms LEN: ${_cartMealCustoms.length}');

      try {
        final HiveMeal _cartMeal = HiveMeal(
          id: meal.id,
          image: meal.image,
          name: meal.name,
          price: meal.price,
          discount: meal.discount!.toInt(),
          discountedPrice: meal.discountedPrice,
          quantity: quantityDraft,
          volumes: _cartMealVolumes,
          customs: _cartMealCustoms,
        );
        await cartMealsBox.add(_cartMeal);
        _cartMeals.value.add(_cartMeal);
        log.v('_cartMeals.value length: ${_cartMeals.value.length}');
      } catch (e) {
        log.v('Couldn\'t ADD a meal to CART from BOTTOM SHEET: $e');
      }
    }

    /// UPDATE PART
    else {
      log.v('UPDATES with isNew: $isNew');
      int pos = _cartMeals.value.indexOf(similarUpdateMeal!);
      log.v('pos of similarUpdateMeal: $pos');
      if (pos == -1) return;

      similarUpdateMeal.quantity = similarUpdateMeal.quantity! + quantityDraft!;
      cartMealsBox.putAt(pos, _cartMeals.value[pos]);
      log.v('similarUpdateMeal.quantity: ${similarUpdateMeal.quantity}');
    }
  }

//---------------------------------------//
//---------------------------------------//
//----------------------- CART VIEW PART --------------------------//
//---------------------------------------//
//---------------------------------------//

  /// GETS quantity of this hiveMeal from cartMeals
  int getCartMealQuantity(HiveMeal hiveMeal) {
    int pos = _cartMeals.value.indexOf(hiveMeal);
    if (pos == -1) return 0;
    log.v(
        '_cartMeals.value[pos].quantity!: ${_cartMeals.value[pos].quantity!}');

    return _cartMeals.value[pos].quantity!;
  }

  /// UPDATES cart meal in cartMeals
  Future<void> updateCartMealInCart({HiveMeal? hiveMeal, int? quantity}) async {
    log.i('hiveMeal.id: ${hiveMeal!.id}, quantity: $quantity');

    int pos = _cartMeals.value.indexOf(hiveMeal);
    if (pos == -1) return;

    if (quantity! >= 1) {
      _cartMeals.value[pos].quantity = quantity;
      cartMealsBox.putAt(pos, _cartMeals.value[pos]);
      log.v(
          '_cartMeals.value[pos].quantity: ${_cartMeals.value[pos].quantity}');
    } else {
      cartMealsBox.deleteAt(pos);
      _cartMeals.value.removeAt(pos);
      log.v('REMOVED _cartMeals.value.length: ${_cartMeals.value.length}');

      if (_cartMeals.value.isEmpty)
        _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    }
  }
}
