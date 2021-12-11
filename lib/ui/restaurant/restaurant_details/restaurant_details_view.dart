import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/restaurant/restaurant_details/res_details_bottom_cart.dart';
import 'res_details_main.dart';
import 'restaurant_details_view_model.dart';

class RestaurantDetailsView extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantDetailsView({required this.restaurant, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantDetailsViewModel>.nonReactive(
      // onModelReady: (model) => model.updateRestaurant(restaurant),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            //------------------ RESTAURANT MAIN PART ---------------------//
            ResDetailsMainWidget(restaurant: restaurant),
            //------------------ BOTTOM CART ---------------------//
            ResDetailsBottomCart(),
          ],
        ),
      ),
      viewModelBuilder: () => RestaurantDetailsViewModel(),
    );
  }
}
