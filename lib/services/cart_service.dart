import 'package:collection/collection.dart';
import 'package:stacked/stacked.dart';

import '../models/hive_models/hive_models.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

//*CartService is used only inside CartView and CartMealView
// 1 For Reactive View
class CartService with ListenableServiceMixin {
  final log = getLogger('CartService');

  CartService() {
    // 3
    listenToReactiveValues([_showCartMealsDataUpdatedFlashbar]);
  }

  final _api = locator<ApiService>();
  final _hiveDbService = locator<HiveDbService>();

  Promocode? _promocode;
  Promocode? get promocode => _promocode;

  Restaurant? _singleRestaurant;
  Restaurant? get singleRestaurant => _singleRestaurant;

  List<Meal> _cartMealsUpdated = [];
  List<Meal> get cartMealsUpdated => _cartMealsUpdated;

  List<HiveMeal> get cartMeals => _hiveDbService.cartMeals;

  List<Meal> _moreMeals = [];
  List<Meal> get moreMeals => _moreMeals;

  // 2
  ReactiveValue<bool> _showCartMealsDataUpdatedFlashbar =
      ReactiveValue<bool>(false);

  bool get showCartMealsDataUpdatedFlashbar =>
      _showCartMealsDataUpdatedFlashbar.value;

  //*GETS cart meals to CHECK for any changes and UPDATE according to it
  Future<void> getSingleRestaurant(int resId) async {
    _singleRestaurant = await _api.getSingleRestaurant(resId);
    await _hiveDbService.updateResInCart(_singleRestaurant);
  }

  Future<void> getCartMeals(List<HiveMeal> cartMeals) async {
    _cartMealsUpdated = await _api.getCartMeals(cartMeals);

    //* Detect price changes
    bool priceChangeDetected = false;
    for (var updatedMeal in _cartMealsUpdated) {
      final existingMeal =
          cartMeals.firstWhereOrNull((meal) => meal.id == updatedMeal.id);
      if (existingMeal != null &&
          (existingMeal.price != updatedMeal.price ||
              existingMeal.discountedPrice != updatedMeal.discountedPrice)) {
        priceChangeDetected = true;
        break;
      }
    }
    _showCartMealsDataUpdatedFlashbar.value = priceChangeDetected;
    if (priceChangeDetected)
      await _hiveDbService.updateCartMeals(_cartMealsUpdated);
  }

  //*GETS More meals for this res
  Future<void> getMoreMeals(int resId, List<HiveMeal> cartMeals) async {
    _moreMeals = await _api.getMoreMeals(resId, cartMeals);
  }

  void resetCartMealsDataUpdatedFlashbar() {
    _showCartMealsDataUpdatedFlashbar.value = false;
  }
}
