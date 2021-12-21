import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/utils/utils.dart';

class HvDbService {
  Future initDB() async {
    await Hive.openBox<HiveMeal>(Constants.cartResBox);
    await Hive.openBox(Constants.cartMealsBox);
  }
}
