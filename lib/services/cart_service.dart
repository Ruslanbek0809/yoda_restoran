import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

/// CartService is used only inside CartView and CartMealView
class CartService {
  final log = getLogger('CartService');

  final _api = locator<ApiService>();

  List<Meal>? _moreMeals = [];
  List<Meal>? get moreMeals => _moreMeals;

  Future<void> getMoreMeals() async {
    _moreMeals = await _api.getMoreMeals();
  }
}
