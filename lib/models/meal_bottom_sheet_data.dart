import 'models.dart';
import '../ui/restaurant/meal/meal_view_model.dart';

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
