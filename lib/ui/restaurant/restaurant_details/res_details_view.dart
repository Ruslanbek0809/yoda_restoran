import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../models/models.dart';
import 'res_details_bottom_cart.dart';
import 'res_details_main_hook.dart';
import 'res_details_main_busy.dart';
import 'res_details_view_model.dart';

class ResDetailsView extends StatelessWidget {
  final Restaurant restaurant;
  const ResDetailsView({required this.restaurant, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResDetailsViewModel>.reactive(
      // onModelReady: (model) => model.getResCatsWithMeals(restaurant.id!),
      viewModelBuilder: () => ResDetailsViewModel(restaurant),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            //------------------ RESTAURANT MAIN PART ---------------------//
            model.isBusy
                ? ResDetailsMainBusy(restaurant: restaurant)
                : ResDetailsMainHook(restaurant: restaurant),
            // ResDetailsMainWidget(restaurant: restaurant),
            //------------------ BOTTOM CART ---------------------//
            if (restaurant.id == model.cartRes!.id) ResDetailsBottomCart(),
          ],
        ),
      ),
    );
  }
}
