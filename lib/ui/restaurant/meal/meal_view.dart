import 'package:flutter/material.dart';
import 'package:yoda_res/models/models.dart';
import 'meal_item.dart';
import 'meal_view_model.dart';
import 'package:stacked/stacked.dart';

/// The reason to use this StatelessWidget instead of directly using FoodWidget structure is to create FoodViewModel first using ViewModelBuilder
class MealView extends StatelessWidget {
  final Meal meal;
  // final MealUI meal;
  const MealView({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MealViewModel>.nonReactive(
      builder: (context, model, child) => MealItem(meal: meal),
      viewModelBuilder: () => MealViewModel(),
    );
  }
}
