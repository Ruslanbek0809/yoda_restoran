import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../models/models.dart';
// import 'res_details_main_hook.dart';
import 'res_details_main_busy.dart';
import 'res_details_main_hook copy.dart';
// import 'res_details_main_busy copy.dart';
import 'res_details_view_model.dart';

class ResDetailsView extends StatelessWidget {
  final Restaurant restaurant;
  const ResDetailsView({required this.restaurant, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResDetailsViewModel>.reactive(
      viewModelBuilder: () => ResDetailsViewModel(restaurant),
      builder: (context, model, child) {
        if (model.isCustomError && restaurant.id == model.cartRes!.id)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            model.updateCustomError();
            await model.showCustomFlashBar(context: context);
          });
        else if (model.isCustomError)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            model.updateCustomError();
            await model.showCustomFlashBar(context: context);
          });

        return Scaffold(
          body:
              // Stack(
              //   children: [
              //*----------------- RESTAURANT MAIN PART ---------------------//
              model.isBusy ? ResDetailsMainBusy() : ResDetailsMainHook(),
          // //*----------------- BOTTOM CART ---------------------//
          // if (restaurant.id == model.cartRes!.id) ResDetailsBottomCart(),
          //   ],
          // ),
        );
        // return Scaffold(
        //   body: Stack(
        //     children: [
        //       //*----------------- RESTAURANT MAIN PART ---------------------//
        //       model.isBusy ? ResDetailsMainBusy() : ResDetailsMainHook(),
        //       //*----------------- BOTTOM CART ---------------------//
        //       if (restaurant.id == model.cartRes!.id) ResDetailsBottomCart(),
        //     ],
        //   ),
        // );
      },
    );
  }
}
