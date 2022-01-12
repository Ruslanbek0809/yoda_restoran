import 'package:yoda_res/ui/cart/cart_view_model.dart';
import 'hive_models/hive_models.dart';

class CartMealDialogData {
  CartMealDialogData({
    this.cartViewModel,
    this.cartMeal,
  });
  final CartViewModel? cartViewModel;
  final HiveMeal? cartMeal;
}
