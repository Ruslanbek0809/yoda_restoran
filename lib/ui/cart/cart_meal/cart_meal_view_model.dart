import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/services/services.dart';

class CartMealViewModel extends BaseViewModel {
  final log = getLogger('CartMealViewModel');

  final _hiveDbService = locator<HiveDbService>();

  HiveMeal? cartMeal;
  int quantity = 0;

  /// GETS quantity of cartMeal for this mealId
  void getCartMealQuantity(HiveMeal hiveMeal) {
    quantity = _hiveDbService.getCartMealQuantity(hiveMeal);
    cartMeal = hiveMeal;
    notifyListeners();
  }

  /// CONCATENATES all cartMeal vols and customs into one string
  String get concatenateVolsCustoms {
    StringBuffer concatenatedString = StringBuffer();

    cartMeal!.volumes!.forEach((vol) {
      if (vol.id != -1) concatenatedString.write('${vol.name} ');
    });

    cartMeal!.customs!.forEach((cus) {
      concatenatedString.write('${cus.name} ');
    });

    return concatenatedString.toString();
  }
}
