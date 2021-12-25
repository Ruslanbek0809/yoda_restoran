import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class HiveDbService {
  final log = getLogger('HiveDbService');

  final _bottomCartService = locator<BottomCartService>();

  static late Box<HiveRestaurant> cartResBox; // Change model type in
  static late Box<HiveMeal> cartMealsBox;
  static late Box<HiveVolCus> volCartBox;

  HiveRestaurant? cartRes;

  List<HiveMeal> cartMeals = [];
  // List<HiveMeal> get cartMeals => [..._cartMeals];

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
    log.i('cartRes ${cartRes!.id}');
  }

  /// GETS all CART meals from cartMealsBox
  void getCartMeals() {
    cartMealsBox = Hive.box<HiveMeal>(Constants.cartMealsBox);
    cartMeals = cartMealsBox.values.toList();
    if (cartMeals.isNotEmpty)
      _bottomCartService.showBottomCart(); // SHOWS BottomCart.

    log.i('${cartMeals.length}');
  }

  //------------------ RESTAURANT PART ---------------------//

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

      log.i('cartResId ${cartRes!.id}');
    } catch (e) {
      log.v('Couldn\'t UPDATE a restaurant in CART: $e');
    }
  }

  //------------------ MEAL PART ---------------------//

  /// GETS quantity of cartMeal for this meal
  int? getMealQuantity(int? mealId) {
    var _quantity = 0;
    for (var _cartMeal in cartMeals)
      if (_cartMeal.id == mealId) _quantity += _cartMeal.quantity!;

    //     int pos = cartMeals.indexWhere((_meal) => _meal.id == mealId);
    // if (pos == -1) return 0;
    // log.i(' cartMeals[pos].id: ${cartMeals[pos].id}');
    // return cartMeals[pos].quantity;

    log.i(' _quantity: $_quantity');
    return _quantity;
  }

  /// ADDS a meal to CART
  Future<void> addMealToCart(Meal? meal, {int? quantity = 1}) async {
    log.i('mealId: ${meal!.id}, quantity: $quantity');

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
      cartMeals.add(_cartMeal);
      log.i('cartMeals length: ${cartMeals.length}');
    } catch (e) {
      log.v('Couldn\'t ADD a meal to CART: $e');
    }
  }

  /// UPDATES a meal in CART
  Future<void> updateMealInCart({int? mealId, int? quantity}) async {
    log.i('mealId: $mealId, quantity: $quantity');

    /// CHECKS whether meal with this id exists and GETS pos if it exists. If NOT, returns -1
    int pos = cartMeals.indexWhere((_meal) => _meal.id == mealId);
    if (pos == -1) return;

    if (quantity! >= 1) {
      cartMeals[pos].quantity = quantity;
      cartMealsBox.putAt(pos, cartMeals[pos]);
      log.i('cartMeals[pos].quantity: ${cartMeals[pos].quantity}');
    } else {
      cartMealsBox.deleteAt(pos);
      cartMeals.removeAt(pos);

      if (cartMeals.isEmpty)
        _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    }
  }

  Future<void> clearCart() async {
    log.i('BEFORE CLEAR cartMeals length: ${cartMeals.length}');
    await cartMealsBox.clear();
    await cartResBox.clear();
    cartMeals.clear();
    await cartResBox.put('cartRes', HiveRestaurant(id: -1, name: 'Default'));
    cartRes = cartResBox.get('cartRes',
        defaultValue: HiveRestaurant(id: -1, name: 'Default'));

    _bottomCartService.hideBottomCart(); // HIDES BottomCart.
    log.i(
        'AFTER CLEAR cartMeals length: ${cartMeals.length} and cartResId: ${cartRes!.id}');
  }

  Future<void> setResDefault() async {
    await cartResBox.clear();
    await cartResBox.put('cartRes', HiveRestaurant(id: -1, name: 'Default'));
    cartRes = cartResBox.get('cartRes',
        defaultValue: HiveRestaurant(id: -1, name: 'Default'));
    log.i('cartResId: ${cartRes!.id}');
  }

  //------------------ MEAL BOTTOM SHEET PART ---------------------//

  /// ADDS a meal to CART from BOTTOM SHEET
  Future<void> addUpdateMealInCartFromBottomSheet(
      Meal? meal, List<Volume> selectedVols, List<Customizable> selectedCustoms,
      {int? quantityDraft = 1}) async {
    log.i('mealId: ${meal!.id}, quantityDraft: $quantityDraft');

    bool isUnique = false;

    List<HiveMeal>? similarMeals = [];
    HiveMeal? similarUpdateMeal;

    /// STEP 1. Filter only to similar meals from cartMeals
    for (HiveMeal cartMeal in cartMeals)
      if (meal.id == cartMeal.id) similarMeals.add(cartMeal);

    /// STEP 2. MAKE isUnique to TRUE if similarMeals isEmpty
    if (similarMeals.isEmpty) isUnique = true;

    log.v(
        'BEFORE STEP 3. length selectedVols and selectedCustoms: ${selectedVols.length} and ${selectedCustoms.length}');

    /// STEP 3. GO THROUGH each similarMeal for vols and customs iteration to decide whether ADD or UPDATE the meal
    for (HiveMeal similarMeal in similarMeals) {
      /// STEP 3.1. CHECK whether similarMeal.volumes and similarMeal.customs length EQUAL or NOT to selectedVols and selectedCustoms length. If NOT, MAKE isUnique to TRUE
      // if (selectedVols.length != similarMeal.volumes!.length ||
      //     selectedCustoms.length != similarMeal.customs!.length) {
      //   log.v('FOUND NOT SAME LENGTH PARAMS');
      //   isUnique = true;
      //   if (isUnique) break;
      // }

      /// STEP 3.2. CHECK selectedVols and UPDATE isUnique var by condition ( ID COMPARISON )
      for (Volume vol in selectedVols) {
        log.v('selectedVols Loop: ${vol.id}');
        isUnique = !similarMeal.volumes!
            .any((_vol) => _vol.id != -1 && _vol.id == vol.id);

        if (isUnique) break;
      }

      /// STEP 3.3. CHECK selectedCustoms and UPDATE isUnique var by condition ( ID COMPARISON )
      /// The reason commenting contains func is that same data in hive doesn't equal to each other. That's why we shifted to id comparison WORKAROUND
      for (Customizable cus in selectedCustoms) {
        log.v('selectedCustoms Loop: ${cus.id}');

        isUnique = !similarMeal.customs!.any((_cus) => _cus.id == cus.id);
        if (isUnique) break;
      }

      /// STEP 3.4. GETS value of similarMeal to similarUpdateMeal if there is similarMeal
      similarUpdateMeal = similarMeal;
      log.i('INSIDE SIMILARS isUnique at the END: $isUnique');
    }

    /// STEP 4. ADD or UPDATE a meal in CART
    /// ADD PART
    if (isUnique) {
      log.i('ADDS with isUnique: $isUnique');
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

      log.i(
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
        cartMeals.add(_cartMeal);
        log.i('cartMeals length: ${cartMeals.length}');
      } catch (e) {
        log.v('Couldn\'t ADD a meal to CART from BOTTOM SHEET: $e');
      }
    }

    /// UPDATE PART
    else {
      log.i('UPDATES with isUnique: $isUnique');
      int pos = cartMeals.indexOf(similarUpdateMeal!);
      log.i('pos of similarUpdateMeal: $pos');
      if (pos == -1) return;

      similarUpdateMeal.quantity = similarUpdateMeal.quantity! + quantityDraft!;
      cartMealsBox.putAt(pos, cartMeals[pos]);
      log.i('similarUpdateMeal.quantity: ${similarUpdateMeal.quantity}');
    }
  }
}
