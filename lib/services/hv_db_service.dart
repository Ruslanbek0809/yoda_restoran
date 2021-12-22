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

  void getCartMeals() {
    log.i('');
    cartMealsBox = Hive.box<HiveMeal>(Constants.cartMealsBox);
    _cartMeals = cartMealsBox.values.toList();
  }

  Future<void> addMealToCart({Meal? meal, num? quantity = 1}) async {
    try {
      final HiveMeal _cartMeal = HiveMeal(
        id: meal!.id,
        image: meal.image,
        name: meal.name,
        price: meal.price,
        discount: meal.discount,
        discountedPrice: meal.discountedPrice,
        quantity: quantity,
      );
      await cartMealsBox.add(_cartMeal);
      _cartMeals.add(_cartMeal);
    } catch (e) {
      log.v('Could ADD a meal to cart: $e');
    }
  }
}
