import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';

class CartMealViewModel extends BaseViewModel {
  final log = getLogger('CartMealViewModel');

  final _hiveDbService = locator<HiveDbService>();

  int quantity = 0;

  /// GETS quantity of cartMeal for this mealId
  void getCartMealQuantity(int? mealId) {
    quantity = _hiveDbService.getCartMealQuantity(mealId)!;
    notifyListeners();
  }
}
