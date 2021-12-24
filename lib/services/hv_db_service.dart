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
    int pos = cartMeals.indexWhere((_meal) => _meal.id == mealId);
    if (pos == -1) return 0;

    log.i(' cartMeals[pos].id: ${cartMeals[pos].id}');
    return cartMeals[pos].quantity;
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
      );
      await cartMealsBox.add(_cartMeal);
      cartMeals.add(_cartMeal);
      log.i('cartMeals length: ${cartMeals.length}');
    } catch (e) {
      log.v('Couldn\'t ADD a meal to CART: $e');
    }
  }

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
}
