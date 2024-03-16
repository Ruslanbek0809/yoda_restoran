import '../models/hive_models/hive_models.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

//*CartService is used only inside CartView and CartMealView
class CartService {
  final log = getLogger('CartService');

  final _api = locator<ApiService>();
  final _hiveDbService = locator<HiveDbService>();

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  List<Meal> _cartMealsUpdated = [];
  List<Meal> get cartMealsUpdated => _cartMealsUpdated;

  List<HiveMeal> get cartMeals => _hiveDbService.cartMeals;

  List<Meal> _moreMeals = [];
  List<Meal> get moreMeals => _moreMeals;

  //*GETS cart meals to CHECK for any changes and UPDATE according to it
  Future<void> getCartMeals(List<HiveMeal> cartMeals) async {
    _cartMealsUpdated = await _api.getCartMeals(cartMeals);
    await _hiveDbService.updateCartMeals(_cartMealsUpdated);
    log.v('getCartMeals() cartMeals => ${cartMeals.length}');
  }

  //*GETS More meals for this res
  Future<void> getMoreMeals(int resId, List<HiveMeal> cartMeals) async {
    _moreMeals = await _api.getMoreMeals(resId, cartMeals);
  }
}
