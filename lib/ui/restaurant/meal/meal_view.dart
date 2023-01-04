import 'package:flutter/material.dart';
import '../../../models/models.dart';
import 'meal_item_hook.dart';
import 'meal_view_model.dart';
import 'package:stacked/stacked.dart';

//*The reason to use this StatelessWidget instead of directly using FoodWidget structure is to create FoodViewModel first using ViewModelBuilder
class MealView extends StatelessWidget {
  final Meal meal;
  final Restaurant
      restaurant; // Needed for add meal with conditions only in CART
  const MealView({
    Key? key,
    required this.meal,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MealViewModel>.reactive(
      // onModelReady: (model) => model.getMealQuantity(meal.id), // This getMealQuantity is needed to update isButtonToggle part which UPDATES UI
      builder: (context, model, child) =>
          MealItemHook(meal: meal, restaurant: restaurant),
      viewModelBuilder: () => MealViewModel(mealId: meal.id),
    );
  }
}
