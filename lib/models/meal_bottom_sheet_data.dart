import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/restaurant/meal/meal_view_model.dart';

class MealBottomSheetData {
  MealBottomSheetData({
    this.meal,
    this.restaurant,
    required this.mealViewModel,
  });
  final Meal? meal;
  final Restaurant? restaurant;
  final MealViewModel mealViewModel;
}
