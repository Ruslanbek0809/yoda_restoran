import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

class HiveDbService {
  final log = getLogger('HiveDbService');

  static late Box<HiveMeal> cartResBox; // Change model type in
  static late Box<HiveMeal> cartMealsBox;

  List<HiveMeal> _cartMeals = [];
  List<HiveMeal> get cartMeals => [..._cartMeals];

  /// INITIALIZE in StartUpViewModel
  Future initDB() async {
    await Hive.openBox<HiveMeal>(Constants.cartResBox);
    await Hive.openBox(Constants.cartMealsBox);
  }

  /// GETS all CART meals in onModelReady()
  void getCartMeals() {
    log.i('');
    
    cartMealsBox = Hive.box<HiveMeal>(Constants.cartMealsBox);
    _cartMeals = cartMealsBox.values.toList();
  }

  num? getMealQuantity({int? mealId}) {
    log.i('');

    int pos = _cartMeals.indexWhere((_meal) => _meal.id == mealId);
    if (pos == -1) return 0;
    log.i('_cartMeals[pos].id: ${_cartMeals[pos].id}');
    return _cartMeals[pos].quantity;
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
        discount: meal.discount,
        discountedPrice: meal.discountedPrice,
        quantity: quantity,
      );
      await cartMealsBox.add(_cartMeal);
      _cartMeals.add(_cartMeal);
      log.i('_cartMeals length: ${_cartMeals.length}');
    } catch (e) {
      log.v('Couldn\'t ADD a meal to CART: $e');
    }
  }

  Future<void> updateMealInCart({int? mealId, int? quantity}) async {
    log.i('mealId: $mealId, quantity: $quantity');

    /// CHECKS whether meal with this id exists and GETS pos if it exists. If NOT, returns -1
    int pos = _cartMeals.indexWhere((_meal) => _meal.id == mealId);
    if (pos == -1) return;

    if (quantity! >= 1) {
      cartMealsBox.deleteAt(pos);
      _cartMeals.removeAt(pos);
    } else {
      _cartMeals[pos].quantity = quantity;
      cartMealsBox.putAt(pos, _cartMeals[pos]);
    }
    log.i('_cartMeals[pos].quantity: ${_cartMeals[pos].quantity}');
  }

}
