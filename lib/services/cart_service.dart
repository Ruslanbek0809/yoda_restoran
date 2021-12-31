import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

/// CartService is used only inside CartView and CartMealView
class CartService {
  final log = getLogger('CartService');

  final _api = locator<ApiService>();

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  List<Meal>? _moreMeals = [];
  List<Meal>? get moreMeals => _moreMeals;

  /// GETS More meals for this res
  Future<void> getMoreMeals() async {
    _moreMeals = await _api.getMoreMeals();
  }
}
