import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'cart_more_meal_hook.dart';
import 'cart_more_meal_view_model.dart';

class CartMoreMealView extends StatelessWidget {
  final Meal meal;
  const CartMoreMealView({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartMoreMealViewModel>.reactive(
      builder: (context, model, child) => CartMoreMealHook(meal: meal),
      viewModelBuilder: () => CartMoreMealViewModel(),
    );
  }
}
