import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'res_details_main.dart';
import 'restaurant_details_view_model.dart';

class RestaurantDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantDetailsViewModel>.nonReactive(
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            ResDetailsMainWidget(),
            //------------------ BOTTOM CART ---------------------//
          ],
        ),
      ),
      viewModelBuilder: () => RestaurantDetailsViewModel(),
    );
  }
}
