import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/restaurant/restaurant_details/res_details_bottom_cart.dart';
import 'res_details_main_hook.dart';
import 'res_details_main_busy.dart';
import 'restaurant_details_view_model.dart';

class RestaurantDetailsView extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantDetailsView({required this.restaurant, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantDetailsViewModel>.reactive(
      onModelReady: (model) => model.getResCatsWithMeals(restaurant.id!),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            //------------------ RESTAURANT MAIN PART ---------------------//
            model.isBusy
                ? ResDetailsMainBusy(restaurant: restaurant)
                : ResDetailsMainHook(restaurant: restaurant),
            // ResDetailsMainWidget(restaurant: restaurant),
            //------------------ BOTTOM CART ---------------------//
            ResDetailsBottomCart(),
          ],
        ),
      ),
      viewModelBuilder: () => RestaurantDetailsViewModel(),
    );
  }
}
