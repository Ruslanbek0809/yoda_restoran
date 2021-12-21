import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoda_res/utils/utils.dart';

class HvDbService {
  Future initDB() async {
    await Hive.openBox(Constants.cartResBox);
    await Hive.openBox(Constants.cartMealsBox);
  }
}
