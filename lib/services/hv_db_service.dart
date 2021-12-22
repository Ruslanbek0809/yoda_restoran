import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
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
}
