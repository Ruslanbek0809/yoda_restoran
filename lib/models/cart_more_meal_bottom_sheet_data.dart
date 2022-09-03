import '../ui/cart/cart_res_food/cart_more_meal_view_model.dart';
import 'models.dart';

class CartMoreMealBottomSheetData {
  CartMoreMealBottomSheetData({
    this.meal,
    this.restaurant,
    required this.cartMoreMealViewModel,
  });
  final Meal? meal;
  final Restaurant? restaurant;
  final CartMoreMealViewModel cartMoreMealViewModel;
}
