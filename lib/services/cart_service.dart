import '../models/hive_models/hive_models.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

/// CartService is used only inside CartView and CartMealView
class CartService {
  final log = getLogger('CartService');

  final _api = locator<ApiService>();

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  List<Meal>? _moreMeals = [];
  List<Meal>? get moreMeals => _moreMeals;

  /// GETS More meals for this res
  Future<void> getMoreMeals(int resId, List<HiveMeal> cartMeals) async {
    _moreMeals = await _api.getMoreMeals(resId, cartMeals);
  }
}
